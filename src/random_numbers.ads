with Ada.Numerics.Discrete_Random;

package Random_Numbers is
   pragma Assertion_Policy (Check);

   type Random_Number is mod 2**8;
   procedure Init
   with Post => Was_Initialized;
   function Was_Initialized return Boolean;

   function Get_Random_Number return Random_Number
   with Pre => Was_Initialized;

private
   package Rand_Byte is new Ada.Numerics.Discrete_Random (Random_Number);
   use Rand_Byte;
   Random_Generator : Generator;

   Is_Initialized : Boolean := False;
end Random_Numbers;
