package Timers is
   Rate : constant Positive := 60;

   type Timer is range 0 .. 2**8 - 1;

   procedure Update_Timers;

   procedure Set_Delay_Timer (Value : Timer)
   with Post => Get_Delay_Timer = Value;

   procedure Set_Sound_Timer (Value : Timer)
   with Post => Get_Sound_Timer = Value;

   function Get_Delay_Timer return Timer;
   function Get_Sound_Timer return Timer;
private
   Delay_Timer_Value : Timer := Timer'Last;
   Sound_Timer_Value : Timer := Timer'Last;

   procedure Update_Delay_Timer
   with
     Post =>
       (if Delay_Timer_Value'Old = 0
        then
          Delay_Timer_Value = Delay_Timer_Value'Old
          or else Delay_Timer_Value < Delay_Timer_Value'Old);

   procedure Update_Sound_Timer
   with
     Post =>
       (if Sound_Timer_Value'Old = 0
        then
          Sound_Timer_Value = Sound_Timer_Value'Old
          or else Sound_Timer_Value < Sound_Timer_Value'Old);
end Timers;
