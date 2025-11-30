with SDL.Error;

package body Audio.SDL_Handling is
   procedure Init (Result : out Results.Result_Type) is
   begin
      if not SDL.Initialise (Flags => SDL.Enable_Audio) then
         Result :=
           (Success => False, Message => To_Result_String (SDL.Error.Get));
         return;
      end if;

      Open
        (Self            => Audio_Device,
         Desired         => Desired_Spec_Value,
         Obtained        => Obtained_Spec_Value,
         Callback        => Callback_Procedure,
         User_Data       => Data'Access,
         Allowed_Changes => None);

      Pause (Audio_Device, True);
   end Init;

   procedure Pause_Sound (B : Boolean) is
   begin
      Pause (Audio_Device, B);
   end Pause_Sound;

   procedure Generate_Tone
     (User : in User_Data_Access; Data : out Sample_Buffer) is
   begin
      -- The Audio_Callback type requires us to have this signature,
      -- but we don't actually need User
      pragma Unreferenced (User);

      Audio.Fill_Sample_Buffer (Data);
   end Generate_Tone;
end Audio.SDL_Handling;
