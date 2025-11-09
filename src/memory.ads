with Results; use Results;

package Memory
  with SPARK_Mode => On
is
   type Memory_Word is mod 2**8;
   type Address is mod 2**12;
   subtype User_Address is
     Address
       range 16#200# .. 16#FFF#;  -- Program address space -> read and write
   subtype Interpreter_Address is
     Address range 16#000# .. 16#1FF#;  -- Interpreter space -> read only

   Memory_Words_Per_Instruction : constant := 2;

   function Load (A : Address) return Memory_Word;

   procedure Store (A : User_Address; W : Memory_Word)
   with Post => Load (A) = W;

   procedure Load_Program (File_Name : String; Result : out Result_Type);
   procedure Load_Font;  -- Loads the default hex font to the Fonts_Space
private
   Data_Space        : array (User_Address) of Memory_Word := [others => 0];
   Interpreter_Space : array (Interpreter_Address) of Memory_Word :=
     [others => 0];
end Memory;
