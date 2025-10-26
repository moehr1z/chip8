with Display;
use Display.Display_Bounded_String;
with Instructions;
with Memory;
with Random_Numbers;
with Timers;
with Ada.Text_IO;      use Ada.Text_IO;
with Ada.Real_Time;    use Ada.Real_Time;
with Ada.Command_Line; use Ada.Command_Line;

-- TODO: arguments (e.g. rom, batch size, scaling etc)

procedure Chip8 is
   Display_Init_Result   : Display.Display_Result;
   Display_Update_Result : Display.Display_Result;
begin
   Random_Numbers.Init;

   Display.Init (Result => Display_Init_Result);
   if not Display_Init_Result.Success then
      Put_Line
        ("Could not initialize display ("
         & Display_Init_Result.Error'Image
         & ")");
      Put_Line ("Error Message: " & To_String (Display_Init_Result.Message));
      Set_Exit_Status (1);
      return;
   end if;

   Memory.Load_Font;
   Memory.Load_Program ("TODO");

   declare
      Micro                  : constant Float := 10.0**6;
      Period                 : constant Time_Span :=
        Microseconds (Integer (Micro / Float (Timers.Rate_In_Hertz)));
      Next_Cycle             : Time := Clock;
      Instruction_Batch_Size : constant Integer := 600;
   begin
      loop
         Next_Cycle := Next_Cycle + Period;

         for I in 1 .. Instruction_Batch_Size loop
            Instructions.Step;
         end loop;

         Display.Update (Result => Display_Update_Result);
         if not Display_Update_Result.Success then
            Put_Line
              ("Could not update display ("
               & Display_Init_Result.Error'Image
               & ")");
            Put_Line
              ("Error Message: " & To_String (Display_Init_Result.Message));
            Set_Exit_Status (1);
            return;
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
