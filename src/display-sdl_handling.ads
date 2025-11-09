with SDL.Video.Windows;
with SDL.Video.Renderers;

package Display.SDL_Handling is
   procedure Init
     (Scale  : Positive;
      Width  : Integer;
      Height : Integer;
      Result : out Result_Type);

   procedure Render
     (Display_Array : Display_Array_Type; Result : out Result_Type);

private
   Window   : SDL.Video.Windows.Window;
   Renderer : SDL.Video.Renderers.Renderer;

   Display_Scale : Positive := 1;
end Display.SDL_Handling;
