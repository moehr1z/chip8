with Registers; use Registers;
with Memory;    use Memory;
with Results;   use Results;

-- instruction names and semantics are as described here:
-- http://devernay.free.fr/hacks/chip8/C8TECH10.HTM#3.1

package Instructions
  with Spark_Mode => On
is
   type Opcode is mod 2**(Memory.Memory_Words_Per_Instruction * 8);

   --  does fetch, decode & execute
   procedure Step (Result : out Result_Type)
   with Pre => not Result'Constrained;
private
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

   -- Conceptionally decode and execute are two different steps, but there is no real advantage of implementing it that way imo
   procedure Execute (O : Opcode; Result : out Result_Type)
   with Pre => not Result'Constrained;

   -- helper function to generate an error when you can't increment the program counter (can happen at many places)
   function Generate_Program_Counter_Error return Result_Type;

   -- same but when an address is not in user or font address space
   function Generate_Address_Bounds_Error return Result_Type;

   function Generate_Unknown_Opcode_Error (O : Opcode) return Result_Type;

   -- Instruction handlers
   procedure Handle_Cls;
   procedure Handle_Ret (Result : out Result_Type)
   with Pre => not Result'Constrained;

   procedure Handle_Jp_Addr
     (Target_Address : Address; Result : out Result_Type)
   with Pre => not Result'Constrained;
   procedure Handle_Call_Addr
     (Target_Address : Address; Result : out Result_Type)
   with Pre => not Result'Constrained;
   procedure Handle_Jp_Vx_Addr
     (Register       : General_Register_Number;
      Target_Address : Address;
      Result         : out Result_Type)
   with Pre => not Result'Constrained;
   procedure Handle_Ld_I_Addr (Target_Address : Address);

   procedure Handle_Se_Vx_Byte
     (Register_1 : General_Register_Number; B : Byte; Result : out Result_Type)
   with Pre => not Result'Constrained;
   procedure Handle_Sne_Vx_Byte
     (Register_1 : General_Register_Number; B : Byte; Result : out Result_Type)
   with Pre => not Result'Constrained;
   procedure Handle_Ld_Vx_Byte
     (Register_1 : General_Register_Number; B : Byte);
   procedure Handle_Add_Vx_Byte
     (Register_1 : General_Register_Number; B : Byte);
   procedure Handle_Rnd_Vx_Byte
     (Register_1 : General_Register_Number; B : Byte);

   procedure Handle_Ld_I_Vx
     (Register_1 : General_Register_Number; Result : out Result_Type)
   with Pre => not Result'Constrained;
   procedure Handle_Ld_Vx_I (Register_1 : General_Register_Number);
   procedure Handle_Skp_Vx
     (Register_1 : General_Register_Number; Result : out Result_Type)
   with Pre => not Result'Constrained;
   procedure Handle_Sknp_Vx
     (Register_1 : General_Register_Number; Result : out Result_Type)
   with Pre => not Result'Constrained;
   procedure Handle_Ld_Vx_Dt (Register_1 : General_Register_Number);
   procedure Handle_Ld_Vx_K (Register_1 : General_Register_Number);
   procedure Handle_Ld_Dt_Vx (Register_1 : General_Register_Number);
   procedure Handle_Ld_St_Vx (Register_1 : General_Register_Number);
   procedure Handle_Add_I_Vx
     (Register_1 : General_Register_Number; Result : out Result_Type)
   with Pre => not Result'Constrained;
   procedure Handle_Ld_F_Vx (Register_1 : General_Register_Number);
   procedure Handle_Ld_B_Vx
     (Register_1 : General_Register_Number; Result : out Result_Type)
   with Pre => not Result'Constrained;
   procedure Handle_Shr_Vx (Register_1 : General_Register_Number);
   procedure Handle_Shl_Vx (Register_1 : General_Register_Number);

   procedure Handle_Se_Vx_Vy
     (Register_1 : General_Register_Number;
      Register_2 : General_Register_Number;
      Result     : out Result_Type)
   with Pre => not Result'Constrained;
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
      Result     : out Result_Type)
   with Pre => not Result'Constrained;

   procedure Handle_Drw_Vx_Vy_Nibble
     (Register_1  : General_Register_Number;
      Register_2  : General_Register_Number;
      Sprite_Size : Nibble);
end Instructions;
