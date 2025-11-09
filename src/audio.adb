with Audio.SDL_Handling;
with Timers; use Timers;

package body Audio is
   procedure Init (Result : out Results.Result_Type) is
   begin
      Audio.SDL_Handling.Init (Result);
   end Init;

   procedure Handle_Audio is
   begin
      Audio.SDL_Handling.Pause_Sound (Timers.Get_Sound_Timer = 0);
   end Handle_Audio;

   procedure Fill_Sample_Buffer (Data : out Sample_Buffer) is
      Period_Samples      : constant Natural := Sample_Rate / Frequency;
      Half_Period_Samples : constant Natural := Period_Samples / 2;
   begin
      for I in Data'Range loop
         if Phase < Half_Period_Samples then
            Data (I) := Sample'Last;
         else
            Data (I) := Sample'First;
         end if;

         Phase := (Phase + 1) mod Period_Samples;
      end loop;
   end Fill_Sample_Buffer;
end Audio;
