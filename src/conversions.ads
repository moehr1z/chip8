package Conversions is
   type BCD is array (Positive range <>) of Integer range 0 .. 9;

   function To_BCD (I : Integer) return BCD
   with
     Post =>
       (declare
          R renames To_BCD'Result;
        begin
          R (1) * 100 + R (2) * 10 + R (3) = I);
end Conversions;
