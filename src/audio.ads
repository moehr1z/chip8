with Interfaces;
with Results; use Results;

package Audio is
   procedure Init (Result : out Result_Type);

   procedure Handle_Audio;

   subtype Sample is Interfaces.Integer_8;
   type Sample_Index is range 0 .. 4095;
   type Sample_Buffer is array (Sample_Index range <>) of Sample;

   procedure Fill_Sample_Buffer (Data : out Sample_Buffer);
private
   Phase       : Float := 0.0;
   Frequency   : constant Float := 500.0; -- in HZ
   Sample_Rate : constant Float := 44_100.0;
end Audio;
