with Audio;
with Display;
with Instructions;
with Memory;
with Random_Numbers;
with Results;
with Timers;
with Keypad;
with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Real_Time;         use Ada.Real_Time;
with Ada.Command_Line;      use Ada.Command_Line;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with GNAT.Command_Line;     use GNAT.Command_Line;
with SDL.Events.Events;     use SDL.Events.Events;
with SDL.Events.Keyboards;  use SDL.Events.Keyboards;

with Registers;

procedure Chip8 is
   Rom        : Unbounded_String := To_Unbounded_String ("Default.ch8");
   Batch_Size : Integer := 10;
   Scaling    : Integer := 20;

   Audio_Init_Result     : Results.Result_Type;
   Display_Init_Result   : Results.Result_Type;
   Display_Update_Result : Results.Result_Type;
   Step_Result           : Results.Result_Type;

   procedure Dump_State is
   begin
      Put_Line ("Program Counter: " & Registers.Get_Program_Counter'Image);
      Put_Line ("Registers: ");
      for I in Registers.General_Register_Number'Range loop
         Put_Line (I'Image & ": " & Registers.Get_General_Register (I)'Image);
      end loop;
      Put_Line ("Address Register: " & Registers.Get_Address_Register'Image);
      Put_Line ("Current Opcode: " & Instructions.Current_Opcode'Image);
   end Dump_State;
begin
   -- parse command line options
   loop
      begin
         case Getopt ("r: b: s:") is
            when 'r' =>
               Rom := To_Unbounded_String (Parameter);

            when 'b' =>
               Batch_Size := Integer'Value (Parameter);

            when 's' =>
               Scaling := Integer'Value (Parameter);

            when ASCII.NUL =>
               exit;

            when others =>
               Put_Line ("Unknown command line argument (" & Parameter & ")!");
               Set_Exit_Status (1);
               return;
         end case;
      exception
         when others =>
            Put_Line ("Could not parse command line arguments!");
            Set_Exit_Status (1);
            return;
      end;

   end loop;

   -- init everything
   Random_Numbers.Init;

   Display.Init (Scale => Scaling, Result => Display_Init_Result);
   if not Display_Init_Result.Success then
      Put_Line
        ("Could not initialize display ("
         & Display_Init_Result.Message'Image
         & ")");
      Dump_State;
      Set_Exit_Status (1);
      return;
   end if;

   Audio.Init (Audio_Init_Result);

   Memory.Load_Font;
   Memory.Load_Program (To_String (Rom));

   -- main loop
   declare
      Micro         : constant Float := 10.0**6;
      Period        : constant Time_Span :=
        Microseconds (Integer (Micro / Float (Timers.Rate_In_Hertz)));
      Next_Cycle    : Time := Clock;
      Current_Event : Events;
   begin
      loop
         Next_Cycle := Next_Cycle + Period;

         -- Handle SDL inputs
         while Poll (Current_Event) loop
            case Current_Event.Common.Event_Type is
               when Key_Down =>
                  declare
                     Key : constant Keypad.Key_Option :=
                       Keypad.Scan_Code_To_Key
                         (Current_Event.Keyboard.Key_Sym.Scan_Code);
                  begin
                     if Key.Is_Some then
                        Keypad.Pressed_Keys (Key.Key) := True;
                     end if;
                  end;

               when Key_Up =>
                  declare
                     Key : constant Keypad.Key_Option :=
                       Keypad.Scan_Code_To_Key
                         (Current_Event.Keyboard.Key_Sym.Scan_Code);
                  begin
                     if Keypad.Waiting_For_Input then
                        Registers.Set_General_Register
                          (Keypad.Waiting_For_Input_Register,
                           Registers.Register_Word (Key.Key));
                        Keypad.Waiting_For_Input := False;
                     end if;

                     if Key.Is_Some then
                        Keypad.Pressed_Keys (Key.Key) := False;
                     end if;
                  end;

               when SDL.Events.Quit =>
                  return;

               when others =>
                  null;
            end case;
         end loop;

         for I in 1 .. Batch_Size loop
            -- We don't execute anything if we are waiting for input, but still want the timers to continue running
            if Keypad.Waiting_For_Input then
               exit;
            end if;

            Instructions.Step (Step_Result);

            if Step_Result.Success = False then
               Put_Line
                 ("Could not execute instruction ("
                  & Step_Result.Message'Image
                  & ")");
               Dump_State;
               Set_Exit_Status (1);
               return;
            end if;

         end loop;

         Display.Update (Result => Display_Update_Result);
         if not Display_Update_Result.Success then
            Put_Line
              ("Could not update display ("
               & Display_Update_Result.Message'Image
               & ")");
            Dump_State;
            Set_Exit_Status (1);
            return;
         end if;

         Audio.Handle_Audio;
         Timers.Update_Timers;

         if Clock >= Next_Cycle then
            Next_Cycle := Clock;
         end if;

         delay until Next_Cycle;
      end loop;
   end;
end Chip8;
