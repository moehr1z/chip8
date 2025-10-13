with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

package Keypad is
   type Keypad_Key is range 0 .. 16#F#;
   function Key_Is_Pressed (Key : Keypad_Key) return Boolean;
   function Wait_For_Keypress
      return Keypad_Key;    -- halts until a key is pressed, then returns it
private
   Latin1_Numerics_Start : Positive := 48; -- Element '0' in Latin1
   -- mapping to a regular keyboard
   Keymap                : array (Keypad_Key) of Character :=
     (-- First row
      1     => Character'Val (Latin1_Numerics_Start + 1),
      2     => Character'Val (Latin1_Numerics_Start + 2),
      3     => Character'Val (Latin1_Numerics_Start + 3),
      16#C# => Character'Val (Latin1_Numerics_Start + 4),
      -- Second row
      4     => LC_Q,
      5     => LC_W,
      6     => LC_E,
      16#D# => LC_R,
      -- Third row
      7     => LC_A,
      8     => LC_S,
      9     => LC_D,
      16#E# => LC_F,
      -- Fourth Row
      16#A# => LC_A,
      0     => LC_S,
      16#B# => LC_D,
      16#F# => LC_F);
end Keypad;
