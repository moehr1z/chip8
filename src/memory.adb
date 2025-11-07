with Ada.Sequential_IO;
with Sprites; use Sprites;

package body Memory
  with SPARK_Mode => On
is
   function Load (A : Address) return Memory_Word
   is (if A in User_Address'Range
       then Data_Space (A)
       else Interpreter_Space (A));

   procedure Store (A : User_Address; W : Memory_Word) is
   begin
      Data_Space (A) := W;
   end Store;

   -- TODO: Spark
   procedure Load_Program (File_Name : String) with SPARK_Mode => Off is
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
      Start_Address : constant := Interpreter_Space'First;
   begin
      for Index_Sprite in Hex_Sprites'Range loop
         declare
            Current_Sprite : constant Hex_Sprite := Hex_Sprites (Index_Sprite);
         begin
            for Index_Byte in Current_Sprite'Range loop
               declare
                  Sprite_Offset : constant Natural :=
                    Natural (Index_Sprite * Hex_Sprites'Length);
                  Byte_Offset   : constant Natural := Natural (Index_Byte - 1);
               begin

                  Interpreter_Space
                    (Interpreter_Address
                       (Start_Address + Sprite_Offset + Byte_Offset)) :=
                    Memory_Word (Current_Sprite (Index_Byte));

               end;
            end loop;
         end;
      end loop;
   end Load_Font;

   function Is_User_Address (Value : Integer) return Boolean
   is (Value in Integer (User_Address'First) .. Integer (User_Address'Last));
end Memory;
