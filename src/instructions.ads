with Registers; use Registers;
with Memory;    use Memory;

-- instruction names and semantics are as described here:
-- http://devernay.free.fr/hacks/chip8/C8TECH10.HTM#3.1

package Instructions is
   Instruction_Length : constant Integer :=
     2; -- 2 Memory_Words per Instruction
   procedure Step;  --  does fetch, decode & execute
private
   type Opcode is mod 2**(Instruction_Length * 8);

   subtype NNN is User_Address;
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
     (O :
        Opcode);   -- Conceptionally decode and execute are two different steps, but there is no real advantage of implementing it that way imo

   -- Instruction handlers
   procedure Handle_Cls;
   procedure Handle_Ret;

   procedure Handle_Sys_Addr (Target_Address : User_Address);
   procedure Handle_Jp_Addr (Target_Address : User_Address);
   procedure Handle_Call_Addr (Target_Address : User_Address);
   procedure Handle_Jp_V0_Addr (Target_Address : User_Address);
   procedure Handle_Ld_I_Addr (Target_Address : Address);

   procedure Handle_Se_Vx_Byte
     (Register_1 : General_Register_Number; B : Byte);
   procedure Handle_Sne_Vx_Byte
     (Register_1 : General_Register_Number; B : Byte);
   procedure Handle_Ld_Vx_Byte
     (Register_1 : General_Register_Number; B : Byte);
   procedure Handle_Add_Vx_Byte
     (Register_1 : General_Register_Number; B : Byte);
   procedure Handle_Rnd_Vx_Byte
     (Register_1 : General_Register_Number; B : Byte);

   procedure Handle_Ld_I_Vx (Register_1 : General_Register_Number);
   procedure Handle_Ld_Vx_I (Register_1 : General_Register_Number);
   procedure Handle_Skp_Vx (Register_1 : General_Register_Number);
   procedure Handle_Sknp_Vx (Register_1 : General_Register_Number);
   procedure Handle_Ld_Vx_Dt (Register_1 : General_Register_Number);
   procedure Handle_Ld_Vx_K (Register_1 : General_Register_Number);
   procedure Handle_Ld_Dt_Vx (Register_1 : General_Register_Number);
   procedure Handle_Ld_St_Vx (Register_1 : General_Register_Number);
   procedure Handle_Add_I_Vx (Register_1 : General_Register_Number);
   procedure Handle_Ld_F_Vx (Register_1 : General_Register_Number);
   procedure Handle_Ld_B_Vx (Register_1 : General_Register_Number);
   procedure Handle_Shr_Vx (Register_1 : General_Register_Number);
   procedure Handle_Shl_Vx (Register_1 : General_Register_Number);

   procedure Handle_Se_Vx_Vy
     (Register_1 : General_Register_Number;
      Register_2 : General_Register_Number);
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
      Register_2 : General_Register_Number);

   procedure Handle_Drw_Vx_Vy_Nibble
     (Register_1  : General_Register_Number;
      Register_2  : General_Register_Number;
      Sprite_Size : Nibble);
end Instructions;
