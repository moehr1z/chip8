with Interfaces;
with Results; use Results;
with SDL.Audio.Devices;
with SDL.Audio.Sample_Formats;

package Audio is
   procedure Init (Result : out Result_Type);

   procedure Handle_Audio;
private
   subtype Sample is Interfaces.Integer_8;
   type Sample_Index is range 0 .. 4095;
   type Sample_Buffer is array (Sample_Index range <>) of Sample;

   package SDL_Audio_Device is new
     SDL.Audio.Devices
       (Frame_Type   => Sample,
        Buffer_Index => Sample_Index,
        Buffer_Type  => Sample_Buffer);
   use SDL_Audio_Device;

   Audio_Device : SDL_Audio_Device.Device;

   procedure Generate_Tone
     (User : in User_Data_Access; Data : out Sample_Buffer);

   type Tone_Data is new User_Data with record
      Phase       : Float := 0.0;
      Frequency   : Float := 500.0; -- in HZ
      Sample_Rate : Float := 44_100.0;
   end record;

   Desired_Spec_Value  : Desired_Spec :=
     (Mode      => Desired,
      Frequency => 44_100,
      Format    => SDL.Audio.Sample_Formats.Sample_Format_S8,
      Channels  => 1,
      Samples   => Sample_Index'Size);
   Obtained_Spec_Value : Obtained_Spec;

   Data : aliased Tone_Data;

   Callback_Procedure : constant Audio_Callback := Generate_Tone'Access;
end Audio;
