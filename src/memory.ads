package Memory is
   type Memory_Word is mod 2**8;
   type Address is mod 2**12;
   subtype User_Address is
     Address
       range 16#200# .. 16#FFF#;  -- Program address space -> read and write
   subtype Interpreter_Address is
     Address range 16#000# .. 16#1FF#;  -- Interpreter space -> read only

   function Load (A : Address) return Memory_Word;

   procedure Store (A : User_Address; W : Memory_Word)
   with Post => Load (A) = W;

   procedure Load_Program (File_Name : String);
   procedure Load_Font;  -- Loads the default hex font to the Fonts_Space

   function Is_User_Address (Value : Integer) return Boolean;
private
   Data_Space        : array (User_Address) of Memory_Word := [others => 0];
   Interpreter_Space : array (Interpreter_Address) of Memory_Word :=
     [others => 0];
end Memory;
