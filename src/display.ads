with Ada.Strings.Bounded;
with Memory;  use Memory;
with Sprites; use Sprites;
with SDL.Video.Windows;
with SDL.Video.Renderers;

-- TODO: user definable colors

package Display is
   pragma Assertion_Policy (Check);

   package Display_Bounded_String is new
     Ada.Strings.Bounded.Generic_Bounded_Length (Max => 100);
   use Display_Bounded_String;

   type Display_Error is (SDL_Error);

   type Display_Result (Success : Boolean := True) is record
      case Success is
         when True =>
            null;

         when False =>
            Error   : Display_Error;
            Message : Bounded_String;
      end case;
   end record;

   Width  : constant := 64;
   Height : constant := 32;

   type X_Coordinate is mod Width;
   type Y_Coordinate is mod Height;

   procedure Init (Scale : Positive := 1; Result : out Display_Result)
   with
     Pre  => not Was_Initialized,
     Post =>
       (Result.Success = True and then Was_Initialized)
       or else (Result.Success = False);
   function Was_Initialized return Boolean;

   procedure Update (Result : out Display_Result)
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
