with Ada.Numerics.Discrete_Random;

package Random_Numbers is
   type Random_Number is mod 2**8;
   procedure Init;
   function Get_Random_Number return Random_Number;

private
   package Rand_Byte is new Ada.Numerics.Discrete_Random (Random_Number);
   use Rand_Byte;
   Random_Generator : Generator;
end Random_Numbers;
