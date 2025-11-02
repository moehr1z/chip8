package Conversions is
   pragma Assertion_Policy (Check);

   type BCD is array (Positive range <>) of Integer range 0 .. 9;

   function From_BCD (B : BCD) return Natural;

   function To_BCD (I : Natural) return BCD
   with Post => From_BCD (To_BCD'Result) = I;

end Conversions;
