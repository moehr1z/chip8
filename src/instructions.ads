with Ada.Strings.Bounded;
with Registers; use Registers;
with Memory;    use Memory;

-- instruction names and semantics are as described here:
-- http://devernay.free.fr/hacks/chip8/C8TECH10.HTM#3.1

package Instructions is
   pragma Assertion_Policy (Check);

   Instruction_Length : constant Integer :=
     2; -- 2 Memory_Words per Instruction
   type Opcode is mod 2**(Instruction_Length * 8);

   package Instruction_Bounded_String is new
     Ada.Strings.Bounded.Generic_Bounded_Length (Max => 100);
   use Instruction_Bounded_String;

   type Instruction_Error is (Opcode_Error, Execution_Error);

   type Instruction_Result (Success : Boolean := True) is record
      case Success is
         when True =>
            null;

         when False =>
            Error   : Instruction_Error;
            Message : Bounded_String;
            Code    : Opcode;
      end case;
   end record;

   procedure Step
     (Result : out Instruction_Result);  --  does fetch, decode & execute

private
   Current_Opcode : Opcode := Opcode'First;

   type NNN is mod 2**12;
   type N is mod 2**4;
   subtype Nibble is N;
   type X is mod 2**4;
   type Y is mod 2**4;
   type KK is mod 2**8;
   subtype Byte is KK;

   type Instruction is record
      N_Value   : N;
      NNN_Value : NNN;
      X_Value   : X;
      Y_Value   : Y;
      KK_Value  : KK;
   end record;
   function To_Instruction (O : Opcode) return Instruction;

   function Fetch return Opcode;
   procedure Execute
     (O      : Opcode;
      Result :
        out Instruction_Result);   -- Conceptionally decode and execute are two different steps, but there is no real advantage of implementing it that way imo

   -- helper function to generate an error when you can't increment the program counter (can happen at many places)
   function Generate_Program_Counter_Error return Instruction_Result;

   -- same but when an address is not in user or font address space
   function Generate_Address_Bounds_Error return Instruction_Result;

   function Generate_Unknown_Opcode_Error return Instruction_Result;

   -- Instruction handlers
   procedure Handle_Cls;
   procedure Handle_Ret (Result : out Instruction_Result);

   procedure Handle_Sys_Addr (Target_Address : Address);
   procedure Handle_Jp_Addr
     (Target_Address : Address; Result : out Instruction_Result);
   procedure Handle_Call_Addr
     (Target_Address : Address; Result : out Instruction_Result);
   procedure Handle_Jp_V0_Addr
     (Target_Address : Address; Result : out Instruction_Result);
   procedure Handle_Ld_I_Addr
     (Target_Address : Address; Result : out Instruction_Result);

   procedure Handle_Se_Vx_Byte
     (Register_1 : General_Register_Number;
      B          : Byte;
      Result     : out Instruction_Result);
   procedure Handle_Sne_Vx_Byte
     (Register_1 : General_Register_Number;
      B          : Byte;
      Result     : out Instruction_Result);
   procedure Handle_Ld_Vx_Byte
     (Register_1 : General_Register_Number; B : Byte);
   procedure Handle_Add_Vx_Byte
     (Register_1 : General_Register_Number; B : Byte);
   procedure Handle_Rnd_Vx_Byte
     (Register_1 : General_Register_Number; B : Byte);

   procedure Handle_Ld_I_Vx
     (Register_1 : General_Register_Number; Result : out Instruction_Result);
   procedure Handle_Ld_Vx_I
     (Register_1 : General_Register_Number; Result : out Instruction_Result);
   procedure Handle_Skp_Vx
     (Register_1 : General_Register_Number; Result : out Instruction_Result);
   procedure Handle_Sknp_Vx
     (Register_1 : General_Register_Number; Result : out Instruction_Result);
   procedure Handle_Ld_Vx_Dt (Register_1 : General_Register_Number);
   procedure Handle_Ld_Vx_K (Register_1 : General_Register_Number);
   procedure Handle_Ld_Dt_Vx (Register_1 : General_Register_Number);
   procedure Handle_Ld_St_Vx (Register_1 : General_Register_Number);
   procedure Handle_Add_I_Vx
     (Register_1 : General_Register_Number; Result : out Instruction_Result);
   procedure Handle_Ld_F_Vx
     (Register_1 : General_Register_Number; Result : out Instruction_Result);
   procedure Handle_Ld_B_Vx (Register_1 : General_Register_Number);
   procedure Handle_Shr_Vx (Register_1 : General_Register_Number);
   procedure Handle_Shl_Vx (Register_1 : General_Register_Number);

   procedure Handle_Se_Vx_Vy
     (Register_1 : General_Register_Number;
      Register_2 : General_Register_Number;
      Result     : out Instruction_Result);
   procedure Handle_Ld_Vx_Vy
     (Register_1 : General_Register_Number;
      Register_2 : General_Register_Number);
   procedure Handle_Or_Vx_Vy
     (Register_1 : General_Register_Number;
      Register_2 : General_Register_Number);
   procedure Handle_And_Vx_Vy
     (Register_1 : General_Register_Number;
      Register_2 : General_Register_Number);
   procedure Handle_Xor_Vx_Vy
     (Register_1 : General_Register_Number;
      Register_2 : General_Register_Number);
   procedure Handle_Add_Vx_Vy
     (Register_1 : General_Register_Number;
      Register_2 : General_Register_Number);
   procedure Handle_Sub_Vx_Vy
     (Register_1 : General_Register_Number;
      Register_2 : General_Register_Number);
   procedure Handle_Subn_Vx_Vy
     (Register_1 : General_Register_Number;
      Register_2 : General_Register_Number);
   procedure Handle_Sne_Vx_Vy
     (Register_1 : General_Register_Number;
      Register_2 : General_Register_Number;
      Result     : out Instruction_Result);

   procedure Handle_Drw_Vx_Vy_Nibble
     (Register_1  : General_Register_Number;
      Register_2  : General_Register_Number;
      Sprite_Size : Nibble;
      Result      : out Instruction_Result);
end Instructions;
