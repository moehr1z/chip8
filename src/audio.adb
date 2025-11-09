with Audio.SDL_Handling;
with Timers; use Timers;

package body Audio
  with SPARK_Mode => On
is
   procedure Init (Result : out Results.Result_Type) is
   begin
      Audio.SDL_Handling.Init (Result);
   end Init;

   procedure Handle_Audio is
      Paused : Boolean := Timers.Get_Sound_Timer = 0;
   begin
      Audio.SDL_Handling.Pause_Sound (Paused);
      -- gnatprove complains that Handle_Audio has no effect,
      -- so I update some ghost variable. Probably not the
      -- right way to do it...
      Audio_Is_Paused := Paused;
   end Handle_Audio;

   procedure Fill_Sample_Buffer (Data : out Sample_Buffer) is
      Period_Samples      : constant Natural := Sample_Rate / Frequency;
      Half_Period_Samples : constant Natural := Period_Samples / 2;
   begin
      -- This doesn't actually do anything, but Spark needs to have some info
      -- about phase, such that it can prove the loop invariant for the first
      -- iteration
      Phase := Phase mod Period_Samples;

      for I in Data'Range loop
         pragma Loop_Invariant (Phase < Period_Samples);

         if Phase < Half_Period_Samples then
            Data (I) := Sample'Last;
         else
            Data (I) := Sample'First;
         end if;

         Phase := (Phase + 1) mod Period_Samples;
      end loop;
   end Fill_Sample_Buffer;
end Audio;
