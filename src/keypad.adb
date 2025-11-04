package body Keypad is
   function Scan_Code_To_Key (Code : Scan_Codes) return Key_Option is
   begin
      for K in Keymap'Range loop
         if Code = Keymap (K) then
            return (Is_Some => True, Key => K);
         end if;
      end loop;

      return (Is_Some => False);
   end;
end Keypad;
