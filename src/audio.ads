with Interfaces; use Interfaces;
with Results;    use Results;

package Audio
  with SPARK_Mode => On
is
   procedure Init (Result : out Result_Type);

   procedure Handle_Audio;

   Amplitude : constant := 2**5;

   subtype Sample is Interfaces.Integer_8;
   type Sample_Index is range 0 .. 4095;
   type Sample_Buffer is array (Sample_Index range <>) of Sample;

   procedure Fill_Sample_Buffer (Data : out Sample_Buffer);
private
   Frequency   : constant := 500; -- in HZ
   Sample_Rate : constant := 44_100;
   Phase       : Natural := 0;

   Audio_Is_Paused : Boolean := True
   with Ghost;
end Audio;
