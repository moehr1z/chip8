with Registers;
with SDL.Video.Windows.Makers;
with SDL.Video.Renderers.Makers;
with SDL.Error;
with Ada.Strings; use Ada.Strings;

package body Display is

   procedure Init (Scale : Positive := 1; Result : out Result_Type) is
   begin
      Display_Scale := Scale;

      if not SDL.Initialise (Flags => SDL.Enable_Screen) then
         Result :=
           (Success => False,
            Message => To_Bounded_String (SDL.Error.Get, Right));
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
              (Success => False,
               Message => To_Bounded_String (SDL.Error.Get, Right));
            return;
      end;

   end Init;

   function Was_Initialized return Boolean
   is (Initialized);

   -- TODO: bounds check + more fine granular exception handling
   procedure Update (Result : out Result_Type) is
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
              (Success => False,
               Message => To_Bounded_String (SDL.Error.Get, Right));
            return;
      end;
   end Update;

   procedure Draw_Sprite
     (Location : Address;
      Size     : Sprite_Row_Number;
      X_Pos    : X_Coordinate;
      Y_Pos    : Y_Coordinate)
   is
      function Load_Sprite return Sprite is
         Current_Location : Address := Location;
         Out_Sprite       : Sprite (1 .. Size);
      begin
         for Row_Index in 1 .. Size loop
            Out_Sprite (Row_Index) :=
              Sprite_Row_Value (Load (Current_Location));
            Current_Location := Current_Location + 1;
         end loop;

         return Out_Sprite;
      end Load_Sprite;

      Target_Sprite : constant Sprite := Load_Sprite;
      Current_X     : X_Coordinate := X_Pos;
      Current_Y     : Y_Coordinate := Y_Pos;
      Collision     : Boolean := False;
   begin

      Process_Each_Row :
      for Row_Index in Target_Sprite'Range loop
         declare
            Byte         : constant Sprite_Row_Value :=
              Target_Sprite (Row_Index);
            Sprite_Value : Boolean := False;
         begin
            Process_Each_Bit :
            for Bit_Index in 0 .. 7 loop
               Sprite_Value := (Byte and (2#10000000# / 2**Bit_Index)) /= 0;

               if Sprite_Value then
                  if Display_Array (Current_X, Current_Y) then
                     Collision := True;
                  end if;

                  Display_Array (Current_X, Current_Y) :=
                    not Display_Array (Current_X, Current_Y);
               end if;

               -- Sprites that go over right side of screen get clipped (quirk)
               if Current_X = X_Coordinate'Last then
                  exit Process_Each_Bit;
               end if;

               Current_X := Current_X + 1;
            end loop Process_Each_Bit;
         end;
         -- Sprites that go over bottom side of screen get clipped (quirk)
         if Current_Y = Y_Coordinate'Last then
            exit Process_Each_Row;
         end if;

         Current_Y := Current_Y + 1;
         Current_X := X_Pos;
      end loop Process_Each_Row;

      Registers.Set_VF (Collision);
   end Draw_Sprite;

   procedure Clear is
   begin
      for X in Display_Array'Range (1) loop
         for Y in Display_Array'Range (2) loop
            Display_Array (X, Y) := False;
         end loop;
      end loop;
   end Clear;

end Display;
