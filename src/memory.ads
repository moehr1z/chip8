with Machine; use Machine;

package Memory is
   type Address is
     range 16#200#
           .. 16#FFF#; -- there's actually 12 bits for addresses, but from 0x000 to 0x1FF there was the location of the original interpreter. So programs should only use the range given above.

   function Load_Memory (A : Address) return Word;
   procedure Store_Memory (A : Address; W : Word);
private
   Data_Space : array (Address) of Word := (others => 0);
end Memory;
