with SDL.Events.Keyboards; use SDL.Events.Keyboards;

package Keypad is
   type Keypad_Key is range 0 .. 16#F#;
   procedure Key_Is_Pressed (Key : Keypad_Key; Is_Pressed : out Boolean);
   procedure Wait_For_Keypress
     (Output_Key :
        out Keypad_Key); -- halts until a key is pressed, then returns it
private
   Latin1_Numerics_Start : Positive := 48; -- Element '0' in Latin1
   -- mapping to a regular keyboard
   Keymap                : array (Keypad_Key) of Scan_Codes :=
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
      16#A# => Scan_Code_A,
      0     => Scan_Code_S,
      16#B# => Scan_Code_D,
      16#F# => Scan_Code_F];
end Keypad;
