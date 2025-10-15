with Ada.Text_IO;

package body Keypad is
   procedure Key_Is_Pressed (Key : Keypad_Key; Is_Pressed : out Boolean) is
      Input     : Character;
      Available : Boolean;
   begin
      Ada.Text_IO.Get_Immediate (Input, Available);
      if Available and then Input = Keymap (Key) then
         Is_Pressed := True;
      else
         Is_Pressed := False;
      end if;
   end Key_Is_Pressed;

   procedure Wait_For_Keypress (Output_Key : out Keypad_Key) is
      Input : Character;
   begin
      -- loops until a valid key is pressed
      loop
         Ada.Text_IO.Get_Immediate (Input);
         for Key in Keymap'Range loop
            if Input = Keymap (Key) then
               Output_Key := Key;
               return;
            end if;
         end loop;
      end loop;
   end Wait_For_Keypress;
end Keypad;
