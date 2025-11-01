with Display;
use Display.Display_Bounded_String;
with Instructions;
use Instructions.Instruction_Bounded_String;
with Memory;
with Random_Numbers;
with Timers;
with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Real_Time;         use Ada.Real_Time;
with Ada.Command_Line;      use Ada.Command_Line;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with GNAT.Command_Line;     use GNAT.Command_Line;

procedure Chip8 is
   type Failure_Modes is (Shutdown, Ignore, Halt);

   Rom          : Unbounded_String := To_Unbounded_String ("Default.ch8");
   Batch_Size   : Integer := 600;
   Scaling      : Integer := 1;
   Failure_Mode : Failure_Modes := Shutdown;

   Display_Init_Result   : Display.Display_Result;
   Display_Update_Result : Display.Display_Result;
   Step_Result           : Instructions.Instruction_Result;
begin
   -- parse command line options
   loop
      begin
         case Getopt ("r: -rom: b: -batch: s: -scaling: f: -fail-mode:") is
            when 'r' =>
               Rom := To_Unbounded_String (Parameter);

            when 'b' =>
               Batch_Size := Integer'Value (Parameter);

            when 's' =>
               Scaling := Integer'Value (Parameter);

            when 'f' =>
               Failure_Mode := Failure_Modes'Value (Parameter);

            when '-' =>
               if Full_Switch = "--rom" then
                  Rom := To_Unbounded_String (Parameter);
               elsif Full_Switch = "--batch" then
                  Batch_Size := Integer'Value (Parameter);
               elsif Full_Switch = "--scaling" then
                  Scaling := Integer'Value (Parameter);
               elsif Full_Switch = "--fail-mode" then
                  Failure_Mode := Failure_Modes'Value (Parameter);
               end if;

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
         & Display_Init_Result.Error'Image
         & ")");
      Put_Line ("Error Message: " & To_String (Display_Init_Result.Message));

      case Failure_Mode is
         when Shutdown =>
            Set_Exit_Status (1);
            return;

         when Ignore =>
            null;

         when Halt =>
            delay Duration (Integer'Last);
            return;
      end case;
   end if;

   Memory.Load_Font;
   Memory.Load_Program (To_String (Rom));

   -- main loop
   declare
      Micro      : constant Float := 10.0**6;
      Period     : constant Time_Span :=
        Microseconds (Integer (Micro / Float (Timers.Rate_In_Hertz)));
      Next_Cycle : Time := Clock;
   begin
      loop
         Next_Cycle := Next_Cycle + Period;

         for I in 1 .. Batch_Size loop
            Instructions.Step (Step_Result);

            if Step_Result.Success = False then
               Put_Line
                 ("Could not execute instruction ("
                  & Step_Result.Error'Image
                  & ")");
               Put_Line ("Error Message: " & To_String (Step_Result.Message));
               Put_Line ("Opcode: " & Step_Result.Code'Image);

               case Failure_Mode is
                  when Shutdown =>
                     Set_Exit_Status (1);
                     return;

                  when Ignore =>
                     null;

                  when Halt =>
                     delay Duration (Integer'Last);
                     return;
               end case;
            end if;
         end loop;

         Display.Update (Result => Display_Update_Result);
         if not Display_Update_Result.Success then
            Put_Line
              ("Could not update display ("
               & Display_Update_Result.Error'Image
               & ")");
            Put_Line
              ("Error Message: " & To_String (Display_Update_Result.Message));

            case Failure_Mode is
               when Shutdown =>
                  Set_Exit_Status (1);
                  return;

               when Ignore =>
                  null;

               when Halt =>
                  delay Duration (Integer'Last);
                  return;
            end case;

         end if;

         Timers.Update_Timers;

         if Clock >= Next_Cycle then
            Put_Line ("Deadline miss!");
            Next_Cycle := Clock;
         end if;

         delay until Next_Cycle;
      end loop;
   end;
end Chip8;
