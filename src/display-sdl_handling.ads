with SDL.Video.Windows;
with SDL.Video.Renderers;

package Display.SDL_Handling is
   procedure Init
     (Scale  : Positive;
      Width  : Integer;
      Height : Integer;
      Result : out Result_Type)
   with
     Pre  => not Was_Initialized,
     Post =>
       (Result.Success = True and then Was_Initialized)
       or else (Result.Success = False);
   function Was_Initialized return Boolean;

   procedure Render
     (Display_Array : Display_Array_Type; Result : out Result_Type)
   with Pre => Was_Initialized;

private
   Window   : SDL.Video.Windows.Window;
   Renderer : SDL.Video.Renderers.Renderer;

   Initialized   : Boolean := False;
   Display_Scale : Positive := 1;
end Display.SDL_Handling;
