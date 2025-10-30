with SDL.Events.Events; use SDL.Events.Events;

package body Keypad is
   procedure Key_Is_Pressed (Key : Keypad_Key; Is_Pressed : out Boolean) is
      Current_Event : Events;
   begin
      Is_Pressed := False;
      while Poll (Current_Event) loop
         case Current_Event.Common.Event_Type is
            when Key_Down =>
               if Current_Event.Keyboard.Key_Sym.Scan_Code = Keymap (Key) then
                  Is_Pressed := True;
                  return;
               end if;

            when others =>
               null;
         end case;
      end loop;
   end Key_Is_Pressed;

   procedure Wait_For_Keypress (Output_Key : out Keypad_Key) is
      Current_Event : Events;
   begin
      -- loops until a valid key is pressed
      loop
         while Poll (Current_Event) loop
            case Current_Event.Common.Event_Type is
               when Key_Down =>
                  for Key in Keymap'Range loop
                     if Current_Event.Keyboard.Key_Sym.Scan_Code = Keymap (Key)
                     then
                        Output_Key := Key;
                        return;
                     end if;
                  end loop;

               when others =>
                  null;
            end case;
         end loop;
      end loop;
   end Wait_For_Keypress;
end Keypad;
