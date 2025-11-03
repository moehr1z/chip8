with Ada.Strings.Bounded;
with Memory;  use Memory;
with Sprites; use Sprites;
with SDL.Video.Windows;
with SDL.Video.Renderers;
with Results; use Results;

-- TODO: user definable colors

package Display is
   pragma Assertion_Policy (Check);

   Width  : constant := 64;
   Height : constant := 32;

   type X_Coordinate is mod Width;
   type Y_Coordinate is mod Height;

   procedure Init (Scale : Positive := 1; Result : out Result_Type)
   with
     Pre  => not Was_Initialized,
     Post =>
       (Result.Success = True and then Was_Initialized)
       or else (Result.Success = False);
   function Was_Initialized return Boolean;

   procedure Update (Result : out Result_Type)
   with Pre => Was_Initialized;

   procedure Draw_Sprite
     (Location : Address;
      Size     : Sprite_Row_Number;
      X_Pos    : X_Coordinate;
      Y_Pos    : Y_Coordinate);

   procedure Clear;

private
   Display_Array : array (X_Coordinate'Range, Y_Coordinate'Range) of Boolean :=
     [others => [others => False]];

   Window   : SDL.Video.Windows.Window;
   Renderer : SDL.Video.Renderers.Renderer;

   Initialized   : Boolean := False;
   Display_Scale : Positive := 1;
end Display;
