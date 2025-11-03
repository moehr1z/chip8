with SDL.Error;
with Ada.Strings;                       use Ada.Strings;
with Ada.Numerics;                      use Ada.Numerics;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
with Timers;                            use Timers;

package body Audio is
   procedure Init (Result : out Results.Result_Type) is
   begin
      if not SDL.Initialise (Flags => SDL.Enable_Audio) then
         Result :=
           (Success => False,
            Message => To_Bounded_String (SDL.Error.Get, Right));
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

      Initialized := True;
   end Init;

   function Was_Initialized return Boolean
   is (Initialized);

   procedure Handle_Audio is
   begin
      if Timers.Get_Sound_Timer /= 0 then
         Pause (Audio_Device, False);
      else
         Pause (Audio_Device, True);
      end if;
   end Handle_Audio;

   procedure Generate_Tone
     (User : in User_Data_Access; Data : out Sample_Buffer)
   is
      Gen       : constant access Tone_Data := Tone_Data (User.all)'Access;
      Step      : constant Float :=
        2.0 * Pi * Gen.Frequency * (1.0 / Gen.Sample_Rate);
      Amplitude : constant := 2.0**5; -- Scaling factor
   begin
      for I in Data'Range loop
         Data (I) := Sample (Sin (Gen.Phase) * Amplitude);
         Gen.Phase := Gen.Phase + Step;

         -- We don't  want it to grow indefinitely, otherwise we lose precision
         if Gen.Phase > 2.0 * Pi then
            Gen.Phase := Gen.Phase - 2.0 * Pi;
         end if;
      end loop;
   end Generate_Tone;
end Audio;
