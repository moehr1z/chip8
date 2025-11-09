package body Random_Numbers is
   procedure Init is
   begin
      Rand_Byte.Reset (Random_Generator);
   end Init;

   function Get_Random_Number return Random_Number is
   begin
      return Random (Random_Generator);
   end Get_Random_Number;
end Random_Numbers;
