with Sprite; use Sprite;
with Memory; use Memory;

package Display is
   Width  : constant Integer := 64;
   Height : constant Integer := 32;

   type X_Coordinate is mod Width;
   type Y_Coordinate is mod Height;

   procedure Init;
   procedure Update;
   procedure Draw_Sprite
     (Location : Address;
      Size     : Positive;
      X_Pos    : X_Coordinate;
      Y_Pos    : Y_Coordinate)
   with Pre => Size <= Max_Sprite_Height * Integer (Sprite_Row_Value'Last);
   procedure Clear;

private

end Display;
