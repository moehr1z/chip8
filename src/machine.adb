package body Machine is
   procedure Step is
   begin

   end Step;

   procedure Fetch (O : out Opcode) is
   begin
      null;

   end Fetch;
   procedure Decode_And_Execute (O : Opcode) is
   begin
      null;

   end Decode_And_Execute;

   -- Instruction handlers
   --
   --
   procedure Handle_Cls is
   begin
      null;

   end Handle_Cls;
   procedure Handle_Ret is
   begin
      null;

   end Handle_Ret;

   procedure Handle_Sys_Addr (Addr : Address) is
   begin
      null;

   end Handle_Sys_Addr;
   procedure Handle_Jp_Addr (Addr : Address) is
   begin
      null;

   end Handle_Jp_Addr;
   procedure Handle_Call_Addr (Addr : Address) is
   begin
      null;

   end Handle_Call_Addr;
   procedure Handle_Jp_V0_Addr (Addr : Address) is
   begin
      null;

   end Handle_Jp_V0_Addr;
   procedure Handle_Ld_I_Addr (Addr : Address) is
   begin
      null;

   end Handle_Ld_I_Addr;

   procedure Handle_Se_Vx_Byte (Vx : Word; Byte : Word) is
   begin
      null;

   end Handle_Se_Vx_Byte;
   procedure Handle_Sne_Vx_Byte (Vx : Word; Byte : Word) is
   begin
      null;

   end Handle_Sne_Vx_Byte;
   procedure Handle_Ld_Vx_Byte (Vx : Word; Byte : Word) is
   begin
      null;

   end Handle_Ld_Vx_Byte;
   procedure Handle_Add_Vx_Byte (Vx : Word; Byte : Word) is
   begin
      null;

   end Handle_Add_Vx_Byte;
   procedure Handle_Rnd_Vx_Byte (Vx : Word; Byte : Word) is
   begin
      null;

   end Handle_Rnd_Vx_Byte;

   procedure Handle_Skp_Vx (Vx : Word) is
   begin
      null;

   end Handle_Skp_Vx;
   procedure Handle_Sknp_Vx (Vx : Word) is
   begin
      null;

   end Handle_Sknp_Vx;
   procedure Handle_Ld_Vx_Dt (Vx : Word) is
   begin
      null;

   end Handle_Ld_Vx_Dt;
   procedure Handle_Ld_Vx_K (Vx : Word) is
   begin
      null;

   end Handle_Ld_Vx_K;
   procedure Handle_Ld_Dt_Vx (Vx : Word) is
   begin
      null;

   end Handle_Ld_Dt_Vx;
   procedure Handle_Ld_St_Vx (Vx : Word) is
   begin
      null;

   end Handle_Ld_St_Vx;
   procedure Handle_Add_I_Vx (Vx : Word) is
   begin
      null;

   end Handle_Add_I_Vx;
   procedure Handle_Ld_F_Vx (Vx : Word) is
   begin
      null;

   end Handle_Ld_F_Vx;
   procedure Handle_Ld_B_Vx (Vx : Word) is
   begin
      null;

   end Handle_Ld_B_Vx;
   procedure Handle_Ld_I_Vx (Vx : Word) is
   begin
      null;

   end Handle_Ld_I_Vx;
   procedure Handle_Ld_Vx_I (Vx : Word) is
   begin
      null;

   end Handle_Ld_Vx_I;

   procedure Handle_Se_Vx_Vy (Vx : Word; Vy : Word) is
   begin
      null;

   end Handle_Se_Vx_Vy;
   procedure Handle_Ld_Vx_Vy (Vx : Word; Vy : Word) is
   begin
      null;

   end Handle_Ld_Vx_Vy;
   procedure Handle_Or_Vx_Vy (Vx : Word; Vy : Word) is
   begin
      null;

   end Handle_Or_Vx_Vy;
   procedure Handle_And_Vx_Vy (Vx : Word; Vy : Word) is
   begin
      null;

   end Handle_And_Vx_Vy;
   procedure Handle_Xor_Vx_Vy (Vx : Word; Vy : Word) is
   begin
      null;

   end Handle_Xor_Vx_Vy;
   procedure Handle_Add_Vx_Vy (Vx : Word; Vy : Word) is
   begin
      null;

   end Handle_Add_Vx_Vy;
   procedure Handle_Sub_Vx_Vy (Vx : Word; Vy : Word) is
   begin
      null;

   end Handle_Sub_Vx_Vy;
   procedure Handle_Shr_Vx_Vy (Vx : Word; Vy : Word) is
   begin
      null;

   end Handle_Shr_Vx_Vy;
   procedure Handle_Subn_Vx_Vy (Vx : Word; Vy : Word) is
   begin
      null;

   end Handle_Subn_Vx_Vy;
   procedure Handle_Shl_Vx_Vy (Vx : Word; Vy : Word) is
   begin
      null;

   end Handle_Shl_Vx_Vy;
   procedure Handle_Sne_Vx_Vy (Vx : Word; Vy : Word) is
   begin
      null;

   end Handle_Sne_Vx_Vy;
   procedure Handle_Drw_Vx_Vy_Nibble (Vx : Word; Vy : Word) is
   begin
      null;

   end Handle_Drw_Vx_Vy_Nibble;
end Machine;
