with Registers; use Registers;
with Memory;    use Memory;

package Instructions is
   procedure Step;  --  does fetch, decode & execute
private
   Opcode_Length : constant Integer := 2**16;
   type Opcode is mod Opcode_Length;

   subtype NNN is Address;
   type N is mod 2**4;
   type X is mod 2**4;
   type Y is mod 2**4;
   type KK is mod 2**8;
   subtype Byte is KK;

   procedure Fetch (O : out Opcode);
   procedure Decode_And_Execute
     (O :
        Opcode);   -- Conceptionally decode and execute are two different steps, but there is no real advantage of implementing it that way imo

   -- Instruction handlers
   procedure Handle_Cls;
   procedure Handle_Ret;

   procedure Handle_Sys_Addr (Addr : Address);
   procedure Handle_Jp_Addr (Addr : Address);
   procedure Handle_Call_Addr (Addr : Address);
   procedure Handle_Jp_V0_Addr (Addr : Address);
   procedure Handle_Ld_I_Addr (Addr : Address);

   procedure Handle_Se_Vx_Byte (Vx : Register_Word; B : Byte);
   procedure Handle_Sne_Vx_Byte (Vx : Register_Word; B : Byte);
   procedure Handle_Ld_Vx_Byte (Vx : Register_Word; B : Byte);
   procedure Handle_Add_Vx_Byte (Vx : Register_Word; B : Byte);
   procedure Handle_Rnd_Vx_Byte (Vx : Register_Word; B : Byte);

   procedure Handle_Skp_Vx (Vx : Register_Word);
   procedure Handle_Sknp_Vx (Vx : Register_Word);
   procedure Handle_Ld_Vx_Dt (Vx : Register_Word);
   procedure Handle_Ld_Vx_K (Vx : Register_Word);
   procedure Handle_Ld_Dt_Vx (Vx : Register_Word);
   procedure Handle_Ld_St_Vx (Vx : Register_Word);
   procedure Handle_Add_I_Vx (Vx : Register_Word);
   procedure Handle_Ld_F_Vx (Vx : Register_Word);
   procedure Handle_Ld_B_Vx (Vx : Register_Word);
   procedure Handle_Ld_I_Vx (Vx : Register_Word);
   procedure Handle_Ld_Vx_I (Vx : Register_Word);

   procedure Handle_Se_Vx_Vy (Vx : Register_Word; Vy : Register_Word);
   procedure Handle_Ld_Vx_Vy (Vx : Register_Word; Vy : Register_Word);
   procedure Handle_Or_Vx_Vy (Vx : Register_Word; Vy : Register_Word);
   procedure Handle_And_Vx_Vy (Vx : Register_Word; Vy : Register_Word);
   procedure Handle_Xor_Vx_Vy (Vx : Register_Word; Vy : Register_Word);
   procedure Handle_Add_Vx_Vy (Vx : Register_Word; Vy : Register_Word);
   procedure Handle_Sub_Vx_Vy (Vx : Register_Word; Vy : Register_Word);
   procedure Handle_Shr_Vx_Vy (Vx : Register_Word; Vy : Register_Word);
   procedure Handle_Subn_Vx_Vy (Vx : Register_Word; Vy : Register_Word);
   procedure Handle_Shl_Vx_Vy (Vx : Register_Word; Vy : Register_Word);
   procedure Handle_Sne_Vx_Vy (Vx : Register_Word; Vy : Register_Word);
   procedure Handle_Drw_Vx_Vy_Nibble (Vx : Register_Word; Vy : Register_Word);
end Instructions;
