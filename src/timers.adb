package body Timers
  with SPARK_Mode => On
is
   procedure Update_Timers is
   begin
      Update_Delay_Timer;
      Update_Sound_Timer;
   end Update_Timers;

   procedure Update_Delay_Timer is
   begin
      if Get_Delay_Timer > 0 then
         Delay_Timer_Value := Delay_Timer_Value - 1;
      end if;
   end Update_Delay_Timer;

   procedure Update_Sound_Timer is
   begin
      if Get_Sound_Timer > 0 then
         Sound_Timer_Value := Sound_Timer_Value - 1;
      end if;
   end Update_Sound_Timer;

   procedure Set_Delay_Timer (Value : Timer) is
   begin
      Delay_Timer_Value := Value;
   end Set_Delay_Timer;

   procedure Set_Sound_Timer (Value : Timer) is
   begin
      Sound_Timer_Value := Value;
   end Set_Sound_Timer;

   function Get_Delay_Timer return Timer
   is (Delay_Timer_Value);
   function Get_Sound_Timer return Timer
   is (Sound_Timer_Value);
end Timers;
