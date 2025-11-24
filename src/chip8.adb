with Audio;
with Display;
with Instructions;
with Memory;
with Random_Numbers;
with Results;
with Timers;
with Keypad;
with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Real_Time;          use Ada.Real_Time;
with Ada.Strings.Unbounded;  use Ada.Strings.Unbounded;
with GNAT.Command_Line;      use GNAT.Command_Line;
with SDL.Events.Events;      use SDL.Events.Events;
with SDL.Events.Keyboards;   use SDL.Events.Keyboards;
with GNAT.OS_Lib;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

with Registers;

procedure Chip8 is
   Rom        : Unbounded_String := To_Unbounded_String ("Default.ch8");
   Batch_Size : Integer := 10;
   Scaling    : Integer := 20;

   procedure Dump_State is
   begin
      Put_Line ("Program Counter: " & Registers.Get_Program_Counter'Image);
      Put_Line ("Registers: ");
      for I in Registers.General_Register_Number'Range loop
         Put_Line (I'Image & ": " & Registers.Get_General_Register (I)'Image);
      end loop;
      Put_Line ("Address Register: " & Registers.Get_Address_Register'Image);
   end Dump_State;

   procedure Read_In_Args is
      Max_Scaling : constant := 40;
   begin
      loop
         begin
            case Getopt ("r: b: s: h") is
               when 'h' =>
                  Put_Line ("=== Options ===");
                  Put_Line ("-r [f]" & HT & HT & "Run the given program file");
                  Put_Line
                    ("-b [n]" & HT & HT & "Execute n instructions per frame");
                  Put_Line
                    ("-s [n]"
                     & HT
                     & HT
                     & "Scale the output by factor n (1 .."
                     & Max_Scaling'Image
                     & ")");
                  GNAT.OS_Lib.OS_Exit (0);

               when 'r' =>
                  Rom := To_Unbounded_String (Parameter);

               when 'b' =>
                  Batch_Size := Integer'Value (Parameter);

               when 's' =>
                  Scaling := Integer'Value (Parameter);
                  if Scaling < 1 or Scaling > Max_Scaling then
                     Put_Line
                       ("Scaling factor has to be between 1 and"
                        & Max_Scaling'Image);
                     GNAT.OS_Lib.OS_Exit (1);
                  end if;

               when ASCII.NUL =>
                  exit;

               when others =>
                  Put_Line
                    ("Unknown command line argument (" & Parameter & ")!");
                  GNAT.OS_Lib.OS_Exit (1);
            end case;
         exception
            when others =>
               Put_Line ("Could not parse command line arguments!");
               GNAT.OS_Lib.OS_Exit (1);
         end;

      end loop;
   end Read_In_Args;

   procedure Initialise is
      Load_Result         : Results.Result_Type;
      Audio_Init_Result   : Results.Result_Type;
      Display_Init_Result : Results.Result_Type;
   begin
      Random_Numbers.Init;

      Display.Init (Scale => Scaling, Result => Display_Init_Result);
      if not Display_Init_Result.Success then
         Put_Line
           ("Could not initialize display ("
            & String (Display_Init_Result.Message)
            & ")");
         Dump_State;
         GNAT.OS_Lib.OS_Exit (1);
      end if;

      Audio.Init (Audio_Init_Result);
      if not Audio_Init_Result.Success then
         Put_Line
           ("Could not initialize audio ("
            & String (Audio_Init_Result.Message)
            & ")");
         Dump_State;
         GNAT.OS_Lib.OS_Exit (1);
      end if;

      Memory.Load_Font;
      Memory.Load_Program (To_String (Rom), Load_Result);
      if not Load_Result.Success then
         Put_Line
           ("Could not load program (" & String (Load_Result.Message) & ")");
         Dump_State;
         GNAT.OS_Lib.OS_Exit (1);
      end if;
   end Initialise;

   procedure Main_Loop is
      Step_Result           : Results.Result_Type;
      Display_Update_Result : Results.Result_Type;
      Paused                : Boolean := False;

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
                     Scan_Code : constant Scan_Codes :=
                       Current_Event.Keyboard.Key_Sym.Scan_Code;
                     Key       : constant Keypad.Key_Option :=
                       Keypad.Scan_Code_To_Key (Scan_Code);
                  begin
                     if Scan_Code = Scan_Code_P then
                        Paused := not Paused;
                     elsif Key.Is_Some then
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
                  GNAT.OS_Lib.OS_Exit (0);

               when others =>
                  null;
            end case;
         end loop;

         for I in 1 .. Batch_Size loop
            if Paused then
               exit;
            end if;

            -- We don't execute anything if we are waiting for input, but still want the timers to continue running
            if Keypad.Waiting_For_Input then
               exit;
            end if;

            Instructions.Step (Step_Result);

            if Step_Result.Success = False then
               Put_Line
                 ("Could not execute instruction ("
                  & String (Step_Result.Message)
                  & ")");
               Dump_State;
               GNAT.OS_Lib.OS_Exit (1);
            end if;

         end loop;

         Display.Update (Result => Display_Update_Result);
         if not Display_Update_Result.Success then
            Put_Line
              ("Could not update display ("
               & String (Display_Update_Result.Message)
               & ")");
            Dump_State;
            GNAT.OS_Lib.OS_Exit (1);
         end if;

         Audio.Handle_Audio;
         Timers.Update_Timers;

         if Clock >= Next_Cycle then
            Next_Cycle := Clock;
         end if;

         delay until Next_Cycle;
      end loop;
   end Main_Loop;
begin
   Read_In_Args;
   Initialise;
   Main_Loop;
end Chip8;
