with Memory;  use Memory;
with Sprites; use Sprites;
with Results; use Results;

package Display
  with SPARK_Mode => On
is
   Width  : constant := 64;
   Height : constant := 32;

   type X_Coordinate is mod Width;
   type Y_Coordinate is mod Height;

   type Display_Array_Type is
     array (X_Coordinate'Range, Y_Coordinate'Range) of Boolean;

   procedure Init (Scale : Positive; Result : out Result_Type);

   procedure Update (Result : out Result_Type);

   procedure Draw_Sprite
     (Location : Address;
      Size     : Sprite_Row_Number;
      X_Pos    : X_Coordinate;
      Y_Pos    : Y_Coordinate);

   procedure Clear;

private
   Display_Array : Display_Array_Type := [others => [others => False]];

   Display_Scale : Positive := 20;
end Display;
