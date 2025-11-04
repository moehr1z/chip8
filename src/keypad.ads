with SDL.Events.Keyboards; use SDL.Events.Keyboards;
with Display;
with Registers;

-- TODO: error handling

package Keypad is
   Waiting_For_Input          : Boolean := False;
   Waiting_For_Input_Register : Registers.General_Register_Number := 0;

   type Keypad_Key is range 0 .. 16#F#;

   type Key_Option (Is_Some : Boolean := False) is record
      case Is_Some is
         when True =>
            Key : Keypad_Key;

         when False =>
            null;
      end case;
   end record;

   Pressed_Keys : array (Keypad_Key) of Boolean := [others => False];

   function Scan_Code_To_Key (Code : Scan_Codes) return Key_Option;
private

   --  mapping to a regular keyboard
   Keymap : array (Keypad_Key) of Scan_Codes :=
     [-- First row
      1     => Scan_Code_1,
      2     => Scan_Code_2,
      3     => Scan_Code_3,
      16#C# => Scan_Code_4,
      -- Second row
      4     => Scan_Code_Q,
      5     => Scan_Code_W,
      6     => Scan_Code_E,
      16#D# => Scan_Code_R,
      -- Third row
      7     => Scan_Code_A,
      8     => Scan_Code_S,
      9     => Scan_Code_D,
      16#E# => Scan_Code_F,
      -- Fourth Row
      16#A# => Scan_Code_Z,
      0     => Scan_Code_X,
      16#B# => Scan_Code_C,
      16#F# => Scan_Code_V];

end Keypad;
