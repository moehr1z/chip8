package body Timers is
   procedure Update_Timers is
   begin
      Delay_Timer_Value := Delay_Timer_Value - 1;
      Sound_Timer_Value := Sound_Timer_Value - 1;
   end Update_Timers;

   function Get_Delay_Timer return Delay_Timer
   is (Delay_Timer_Value);
   function Get_Sound_Timer return Sound_Timer
   is (Sound_Timer_Value);
end Timers;
