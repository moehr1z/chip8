with SDL.Video.Windows.Makers;
with SDL.Video.Renderers.Makers;
with SDL.Error;

package body Display.SDL_Handling is
   procedure Init
     (Scale  : Positive;
      Width  : Integer;
      Height : Integer;
      Result : out Result_Type) is
   begin
      Display_Scale := Scale;

      if not SDL.Initialise (Flags => SDL.Enable_Screen) then
         Result :=
           (Success => False, Message => To_Result_String (SDL.Error.Get));
         return;
      end if;

      begin
         SDL.Video.Windows.Makers.Create
           (Win      => Window,
            Title    => "Chip 8",
            Position => SDL.Natural_Coordinates'(X => 10, Y => 10),
            Size     =>
              SDL.Positive_Sizes'
                (SDL.Dimension (Display_Scale * Width),
                 SDL.Dimension (Display_Scale * Height)),
            Flags    => 0);
         SDL.Video.Renderers.Makers.Create (Renderer, Window);

         Renderer.Set_Draw_Colour ((0, 0, 0, 255));
         Renderer.Clear;
         Renderer.Present;

         Initialized := True;
      exception
         when others =>
            Result :=
              (Success => False, Message => To_Result_String (SDL.Error.Get));
            return;
      end;
   end Init;

   function Was_Initialized return Boolean
   is (Initialized);

   -- TODO: bounds check + more fine granular exception handling
   procedure Render
     (Display_Array : Display_Array_Type; Result : out Result_Type) is
   begin
      begin
         for X in Display_Array'Range (1) loop
            for Y in Display_Array'Range (2) loop
               if Display_Array (X, Y) = True then
                  Renderer.Set_Draw_Colour ((0, 255, 0, 255));
               else
                  Renderer.Set_Draw_Colour ((0, 0, 0, 255));
               end if;

               Renderer.Fill
                 (Rectangle =>
                    (SDL.Coordinate (Integer (X) * Integer (Display_Scale)),
                     SDL.Coordinate (Integer (Y) * Integer (Display_Scale)),
                     SDL.Natural_Dimension (Display_Scale),
                     SDL.Natural_Dimension (Display_Scale)));

            end loop;
         end loop;

         Renderer.Present;
      exception
         when others =>
            Result :=
              (Success => False, Message => To_Result_String (SDL.Error.Get));
            return;
      end;
   end Render;
end Display.SDL_Handling;
