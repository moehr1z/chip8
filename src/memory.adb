with Ada.Sequential_IO;
with Sprites; use Sprites;

package body Memory is
   function Load (A : Address) return Memory_Word is
   begin
      if A in User_Address'Range then
         return Data_Space (A);
      else
         return Font_Space (A);
      end if;
   end Load;

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

   procedure Load_Font is
      Current_Address : Font_Address := Font_Space'First;
   begin
      for Index_Sprite in Hex_Sprites'Range loop
         declare
            Current_Sprite : constant Hex_Sprite := Hex_Sprites (Index_Sprite);
         begin
            for Index_Byte in Current_Sprite'Range loop
               Font_Space (Current_Address) :=
                 Memory_Word (Current_Sprite (Index_Byte));
               Current_Address := Current_Address + 1;
            end loop;
         end;
      end loop;
   end Load_Font;
end Memory;
