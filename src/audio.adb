with Audio.SDL_Handling;
with Ada.Numerics;                      use Ada.Numerics;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
with Timers;                            use Timers;

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
      Step      : constant Float := 2.0 * Pi * Frequency * (1.0 / Sample_Rate);
      Amplitude : constant := 2.0**5; -- Scaling factor
   begin
      for I in Data'Range loop
         Data (I) := Sample (Sin (Phase) * Amplitude);
         Phase := Phase + Step;

         -- We don't  want it to grow indefinitely, otherwise we lose precision
         if Phase > 2.0 * Pi then
            Phase := Phase - 2.0 * Pi;
         end if;
      end loop;
   end Fill_Sample_Buffer;
end Audio;
