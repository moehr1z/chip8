package Timers is

   Rate : constant Positive := 60;
   type Delay_Timer is mod Rate;
   type Sound_Timer is mod Rate;

   procedure Update_Timers
   with
     Post =>
       Get_Delay_Timer /= Get_Delay_Timer'Old
       and Get_Sound_Timer /= Get_Sound_Timer'Old;

   function Get_Delay_Timer return Delay_Timer;
   function Get_Sound_Timer return Sound_Timer;
private
   Delay_Timer_Value : Delay_Timer := Delay_Timer'Last;
   Sound_Timer_Value : Sound_Timer := Sound_Timer'Last;
end Timers;
