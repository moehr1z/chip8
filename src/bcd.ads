package BCD
  with SPARK_Mode => On
is
   type Digit is range 0 .. 9;
   -- For this purpose a constrained array with 3 elements would suffice, but I wanted to make
   -- it unconstrained as an exercise (and maybe reusability in the future)
   -- TODO: add functional postcondition
   type BCD_Array is array (Positive range <>) of Digit;

   function To_BCD (I : Natural) return BCD_Array;

private
   function Get_Number_Digits (I : Natural) return Natural;
end BCD;
