with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;

package body BCD is
   function To_BCD (I : Natural) return BCD_Array is
      Number_Digits : Natural :=
        (if (I = 0)
         then 0
         else Natural (Float'Floor (Log (Float (I), 10.0))) + 1);
      Tmp           : Integer := I;
      BCD_Result    : BCD_Array (1 .. Number_Digits);
   begin

      for I in reverse 1 .. Number_Digits loop
         BCD_Result (I) := Integer (Tmp rem 10);
         Tmp := Tmp / 10;
      end loop;

      return BCD_Result;
   end To_BCD;

   function From_BCD (B : BCD_Array) return Natural is
      Sum : Natural := 0;
      L   : constant Natural := B'Length;
   begin
      for J in B'Range loop
         Sum := Sum + B (J) * 10**(L - J);
      end loop;

      return Sum;
   end From_BCD;
end BCD;
