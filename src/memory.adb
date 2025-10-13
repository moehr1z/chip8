with Ada.Sequential_IO;

package body Memory is
   function Load (A : User_Address) return Memory_Word
   is (Data_Space (A));

   procedure Store (A : User_Address; W : Memory_Word) is
   begin
      Data_Space (A) := W;
   end Store;

   procedure Load_Program (File_Name : String) is
      Loader_Index : User_Address := Data_Space'First;
      package Word_IO is new Ada.Sequential_IO (Memory_Word);
      use Word_IO;
      F            : Word_IO.File_Type;
      Current_Word : Memory_Word := 0;
   begin
      -- TODO: error handling (exceptions, file bigger than memory etc)

      Open (F, In_File, File_Name);
      while not End_Of_File (F) loop
         Read (F, Current_Word);
         Store (Loader_Index, Current_Word);
         Loader_Index := Loader_Index + 1;
      end loop;
      Close (F);
   end Load_Program;
end Memory;
