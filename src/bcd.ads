package BCD is
   pragma Assertion_Policy (Check);

   type BCD_Array is array (Positive range <>) of Integer range 0 .. 9;

   function From_BCD (B : BCD_Array) return Natural;

   function To_BCD (I : Natural) return BCD_Array
   with Post => From_BCD (To_BCD'Result) = I;

end BCD;
