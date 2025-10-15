package Memory is
   type Memory_Word is mod 2**8;
   type Address is range 0 .. 16#FFF#;
   subtype User_Address is
     Address range 16#200# .. 16#FFF#;  -- Program address space
   subtype Font_Address is
     Address range 16#050# .. 16#0A0#;  -- Built in font address space

   function Load (A : Address) return Memory_Word
   with Pre => A in User_Address'Range or else A in Font_Address'Range;

   procedure Store (A : User_Address; W : Memory_Word)
   with Post => Load (A) = W;

   procedure Load_Program (File_Name : String);
   procedure Load_Font;  -- Loads the default hex font to the Fonts_Space
private
   Data_Space : array (User_Address) of Memory_Word := [others => 0];
   Font_Space : array (Font_Address) of Memory_Word := [others => 0];
end Memory;
