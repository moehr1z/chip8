package body BCD
  with SPARK_Mode => On
is
   function Get_Number_Digits (I : Natural) return Natural is
      Tmp           : Natural := I;
      Number_Digits : Natural := 0;
   begin
      if I = 0 then
         Number_Digits := 1;
      else
         while Tmp /= 0 loop
            -- Tmp decreases faster than Number_Digits increases.
            -- Because we exit when Tmp = 0 that also means that Number_Digits
            -- can never be greater than Tmps initial value (I), which is within Natural bounds,
            -- so we can't get an out of bounds exception.
            pragma
              Loop_Invariant
                (Tmp'Loop_Entry - Tmp
                   >= Number_Digits - Number_Digits'Loop_Entry);

            Tmp := Tmp / 10;
            Number_Digits := Number_Digits + 1;
         end loop;
      end if;

      return Number_Digits;
   end Get_Number_Digits;

   function To_BCD (I : Natural) return BCD_Array is
      Number_Digits : constant Natural := Get_Number_Digits (I);
      Tmp           : Natural := I;
      BCD_Result    : BCD_Array (1 .. Number_Digits);
   begin

      for I in reverse 1 .. Number_Digits loop
         BCD_Result (I) := Digit (Tmp rem 10);
         Tmp := Tmp / 10;
      end loop;

      return BCD_Result;
   end To_BCD;
end BCD;
