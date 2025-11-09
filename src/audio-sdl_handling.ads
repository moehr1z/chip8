with SDL.Audio.Devices;
with SDL.Audio.Sample_Formats;

package Audio.SDL_Handling is
   procedure Init (Result : out Result_Type);

   procedure Pause_Sound (B : Boolean);
private
   package SDL_Audio_Device is new
     SDL.Audio.Devices
       (Frame_Type   => Sample,
        Buffer_Index => Sample_Index,
        Buffer_Type  => Sample_Buffer);
   use SDL_Audio_Device;

   Audio_Device : SDL_Audio_Device.Device;

   procedure Generate_Tone
     (User : in User_Data_Access; Data : out Sample_Buffer);

   Data : aliased User_Data;

   Desired_Spec_Value  : Desired_Spec :=
     (Mode      => Desired,
      Frequency => 44_100,
      Format    => SDL.Audio.Sample_Formats.Sample_Format_S8,
      Channels  => 1,
      Samples   => Sample_Index'Size);
   Obtained_Spec_Value : Obtained_Spec;

   Callback_Procedure : constant Audio_Callback := Generate_Tone'Access;
end Audio.SDL_Handling;
