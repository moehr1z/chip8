with Ada.Sequential_IO;
with Sprites;        use Sprites;
with Ada.Exceptions; use Ada.Exceptions;

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

   procedure Load_Program (File_Name : String; Result : out Result_Type)
   with SPARK_Mode => Off
   is
      Loader_Index : User_Address := Data_Space'First;
      package Word_IO is new Ada.Sequential_IO (Memory_Word);
      use Word_IO;
      F            : Word_IO.File_Type;
      Current_Word : Memory_Word := 0;
   begin
      Open (F, In_File, File_Name);
      while not End_Of_File (F) loop
         Read (F, Current_Word);
         Store (Loader_Index, Current_Word);

         if Loader_Index = User_Address'Last then
            Result :=
              (Success => False,
               Message =>
                 To_Result_String
                   ("Program File is too big (" & File_Name & ")"));
            Close (F);
            return;
         end if;
         Loader_Index := Loader_Index + 1;
      end loop;
      Close (F);

   exception
      when E : others =>
         Result :=
           (Success => False,
            Message =>
              To_Result_String
                ("Could not load program ("
                 & File_Name
                 & ") (Error:"
                 & Exception_Message (E)
                 & ")"));
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
end Memory;
