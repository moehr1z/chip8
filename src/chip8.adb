with Display;
with Instructions;
with Memory;
with Random_Numbers;
with Timers;
with Ada.Text_IO;   use Ada.Text_IO;
with Ada.Real_Time; use Ada.Real_Time;

procedure Chip8 is
begin
   Random_Numbers.Init;
   Display.Init;
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

         Display.Update;
         Timers.Update_Timers;

         if Clock >= Next_Cycle then
            Put_Line ("Deadline miss!");
            Next_Cycle := Clock;
         end if;

         delay until Next_Cycle;
      end loop;
   end;
end Chip8;
