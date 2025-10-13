package Memory is
   type Memory_Word is mod 2**8;
   type User_Address is
     range 16#200# .. 16#FFF#; -- there's actually 12 bits for addresses,
   --  but from 0x000 to 0x1FF there was the location of the original interpreter.
   --  So programs should only use the range given above.

   function Load (A : User_Address) return Memory_Word;
   procedure Store (A : User_Address; W : Memory_Word);
   procedure Load_Program (File_Name : String);
private
   Data_Space : array (User_Address) of Memory_Word := (others => 0);
end Memory;
