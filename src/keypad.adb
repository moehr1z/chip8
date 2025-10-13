with Ada.Text_IO;

package body Keypad is
   function Key_Is_Pressed (Key : Keypad_Key) return Boolean is
      Input     : Character;
      Available : Boolean;
   begin
      Ada.Text_IO.Get_Immediate (Input, Available);
      if Available and then Input = Keymap (Key) then
         return True;
      else
         return False;
      end if;
   end Key_Is_Pressed;

   function Wait_For_Keypress return Keypad_Key is
      Input : Character;
   begin
      -- loops until a valid key is pressed
      loop
         Ada.Text_IO.Get_Immediate (Input);
         for Key in Keymap'Range loop
            if Input = Keymap (Key) then
               return Key;
            end if;
         end loop;
      end loop;
   end Wait_For_Keypress;
end Keypad;
