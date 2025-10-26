package Sprites is
   Max_Sprite_Height : constant Integer := 15;

   type Sprite_Row_Value is mod 2**8;
   type Sprite_Row_Number is range 1 .. Max_Sprite_Height;
   type Sprite is array (Sprite_Row_Number range <>) of Sprite_Row_Value;

   -- Predefined font for hexadecimal values
   subtype Font_Range is Integer range 0 .. 16#F#;
   subtype Hex_Sprite is Sprite (1 .. 5);
   Hex_Sprites : constant array (Font_Range) of Hex_Sprite :=
     [0     => [16#F0#, 16#90#, 16#90#, 16#90#, 16#F0#],
      1     => [16#20#, 16#60#, 16#20#, 16#20#, 16#70#],
      2     => [16#F0#, 16#10#, 16#F0#, 16#80#, 16#F0#],
      3     => [16#F0#, 16#10#, 16#F0#, 16#10#, 16#F0#],
      4     => [16#90#, 16#90#, 16#F0#, 16#10#, 16#10#],
      5     => [16#F0#, 16#80#, 16#F0#, 16#10#, 16#F0#],
      6     => [16#F0#, 16#80#, 16#F0#, 16#90#, 16#F0#],
      7     => [16#F0#, 16#10#, 16#20#, 16#40#, 16#40#],
      8     => [16#F0#, 16#90#, 16#F0#, 16#90#, 16#F0#],
      9     => [16#F0#, 16#90#, 16#F0#, 16#10#, 16#F0#],
      16#A# => [16#F0#, 16#90#, 16#F0#, 16#90#, 16#90#],
      16#B# => [16#E0#, 16#90#, 16#E0#, 16#90#, 16#E0#],
      16#C# => [16#F0#, 16#80#, 16#80#, 16#80#, 16#F0#],
      16#D# => [16#E0#, 16#90#, 16#90#, 16#90#, 16#E0#],
      16#E# => [16#F0#, 16#80#, 16#F0#, 16#80#, 16#F0#],
      16#F# => [16#F0#, 16#80#, 16#F0#, 16#80#, 16#80#]];
end Sprites;
