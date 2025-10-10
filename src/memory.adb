package body Memory is
   function Load_Memory (A : Address) return Word
   is (Data_Space (A));

   procedure Store_Memory (A : Address; W : Word) is
   begin
      Data_Space (A) := W;
   end Store_Memory;
end Memory;
