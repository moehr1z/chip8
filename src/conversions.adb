with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;

package body Conversions is
   function To_BCD (I : Integer) return BCD is
      Number_Digits : constant Integer :=
        Integer (Float'Floor (Log (Float (I), 10.0))) + 1;
      Tmp           : Integer := I;
      BCD_Result    : BCD (1 .. Number_Digits);
   begin
      for I in 1 .. Number_Digits loop
         BCD_Result (I) := Integer (Tmp rem 10);
         Tmp := Tmp / 10;
      end loop;

      return BCD_Result;
   end To_BCD;
end Conversions;
