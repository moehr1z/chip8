with BCD;
with Display;
with Sprites;
with Stack;
with Timers;
with Keypad;
with Random_Numbers;

package body Instructions is
   procedure Step (Result : out Result_Type) is
      O : constant Opcode := Fetch;
   begin
      if not Can_Increment_Program_Counter then
         Result := Generate_Program_Counter_Error;
         return;
      end if;

      Increment_Program_Counter;
      Execute (O, Result);
   end Step;

   function Fetch return Opcode is
      First_Byte  : constant Memory_Word := Load (Get_Program_Counter);
      Second_Byte : constant Memory_Word := Load (Get_Program_Counter + 1);
      Code        : constant Opcode :=
        Opcode
          ((Integer (First_Byte) * (Integer (Memory_Word'Last) + 1))
           + Integer (Second_Byte));
   begin
      return Code;
   end Fetch;

   procedure Execute (O : Opcode; Result : out Result_Type) is
      I : constant Instruction := To_Instruction (O);
   begin
      case O and 16#F000# is
         when 16#0000# =>
            case O is
               when 16#00E0# =>
                  Handle_Cls;

               when 16#00EE# =>
                  Handle_Ret (Result);

               when others =>
                  Handle_Sys_Addr;
            end case;

         when 16#1000# =>
            Handle_Jp_Addr (Address (I.NNN_Value), Result);

         when 16#2000# =>
            Handle_Call_Addr (Address (I.NNN_Value), Result);

         when 16#3000# =>
            Handle_Se_Vx_Byte
              (General_Register_Number (I.X_Value), Byte (I.KK_Value), Result);

         when 16#4000# =>
            Handle_Sne_Vx_Byte
              (General_Register_Number (I.X_Value), Byte (I.KK_Value), Result);

         when 16#5000# =>
            if (O and 16#000F#) = 0 then
               Handle_Se_Vx_Vy
                 (General_Register_Number (I.X_Value),
                  General_Register_Number (I.Y_Value),
                  Result);
            else
               Result := Generate_Unknown_Opcode_Error;
            end if;

         when 16#6000# =>
            Handle_Ld_Vx_Byte
              (General_Register_Number (I.X_Value), Byte (I.KK_Value));

         when 16#7000# =>
            Handle_Add_Vx_Byte
              (General_Register_Number (I.X_Value), Byte (I.KK_Value));

         when 16#8000# =>
            case O and 16#000F# is
               when 16#0000# =>
                  Handle_Ld_Vx_Vy
                    (General_Register_Number (I.X_Value),
                     General_Register_Number (I.Y_Value));

               when 16#0001# =>
                  Handle_Or_Vx_Vy
                    (General_Register_Number (I.X_Value),
                     General_Register_Number (I.Y_Value));

               when 16#0002# =>
                  Handle_And_Vx_Vy
                    (General_Register_Number (I.X_Value),
                     General_Register_Number (I.Y_Value));

               when 16#0003# =>
                  Handle_Xor_Vx_Vy
                    (General_Register_Number (I.X_Value),
                     General_Register_Number (I.Y_Value));

               when 16#0004# =>
                  Handle_Add_Vx_Vy
                    (General_Register_Number (I.X_Value),
                     General_Register_Number (I.Y_Value));

               when 16#0005# =>
                  Handle_Sub_Vx_Vy
                    (General_Register_Number (I.X_Value),
                     General_Register_Number (I.Y_Value));

               when 16#0006# =>
                  Handle_Shr_Vx (General_Register_Number (I.X_Value));

               when 16#0007# =>
                  Handle_Subn_Vx_Vy
                    (General_Register_Number (I.X_Value),
                     General_Register_Number (I.Y_Value));

               when 16#000E# =>
                  Handle_Shl_Vx (General_Register_Number (I.X_Value));

               when others =>
                  Result := Generate_Unknown_Opcode_Error;
            end case;

         when 16#9000# =>
            Handle_Sne_Vx_Vy
              (General_Register_Number (I.X_Value),
               General_Register_Number (I.Y_Value),
               Result);

         when 16#A000# =>
            Handle_Ld_I_Addr (Address (I.NNN_Value));

         when 16#B000# =>
            Handle_Jp_Vx_Addr
              (General_Register_Number (I.X_Value),
               User_Address (I.NNN_Value),
               Result);

         when 16#C000# =>
            Handle_Rnd_Vx_Byte
              (General_Register_Number (I.X_Value), Byte (I.KK_Value));

         when 16#D000# =>
            Handle_Drw_Vx_Vy_Nibble
              (General_Register_Number (I.X_Value),
               General_Register_Number (I.Y_Value),
               Nibble (I.N_Value));

         when 16#E000# =>
            case O and 16#00FF# is
               when 16#009E# =>
                  Handle_Skp_Vx (General_Register_Number (I.X_Value), Result);

               when 16#00A1# =>
                  Handle_Sknp_Vx (General_Register_Number (I.X_Value), Result);

               when others =>
                  Result := Generate_Unknown_Opcode_Error;
            end case;

         when 16#F000# =>
            case O and 16#00FF# is
               when 16#0007# =>
                  Handle_Ld_Vx_Dt (General_Register_Number (I.X_Value));

               when 16#000A# =>
                  Handle_Ld_Vx_K (General_Register_Number (I.X_Value));

               when 16#0015# =>
                  Handle_Ld_Dt_Vx (General_Register_Number (I.X_Value));

               when 16#0018# =>
                  Handle_Ld_St_Vx (General_Register_Number (I.X_Value));

               when 16#001E# =>
                  Handle_Add_I_Vx (General_Register_Number (I.X_Value));

               when 16#0029# =>
                  Handle_Ld_F_Vx (General_Register_Number (I.X_Value));

               when 16#0033# =>
                  Handle_Ld_B_Vx (General_Register_Number (I.X_Value));

               when 16#0055# =>
                  Handle_Ld_I_Vx (General_Register_Number (I.X_Value));

               when 16#0065# =>
                  Handle_Ld_Vx_I (General_Register_Number (I.X_Value));

               when others =>
                  Result := Generate_Unknown_Opcode_Error;
            end case;

         when others =>
            Result := Generate_Unknown_Opcode_Error;
      end case;
   end Execute;

   function To_Instruction (O : Opcode) return Instruction is
      N_Value   : constant N := N ((O and 16#000F#));
      NNN_Value : constant NNN := NNN ((O and 16#0FFF#));
      X_Value   : constant X := X ((O and 16#0F00#) / 2**8);
      Y_Value   : constant Y := Y ((O and 16#00F0#) / 2**4);
      KK_Value  : constant KK := KK ((O and 16#00FF#));
   begin
      return (N_Value, NNN_Value, X_Value, Y_Value, KK_Value);
   end To_Instruction;

   function Generate_Program_Counter_Error return Result_Type is
   begin
      return
        (Success => False,
         Message =>
           To_Result_String
             ("Cannot increase program counter because it already points to the last user address"));
   end Generate_Program_Counter_Error;

   function Generate_Address_Bounds_Error return Result_Type is
   begin
      return
        (Success => False,
         Message =>
           To_Result_String ("Address out of user or font space bounds"));
   end Generate_Address_Bounds_Error;

   function Generate_Unknown_Opcode_Error return Result_Type is
   begin
      return
        (Success => False, Message => To_Result_String ("Unknown opcode"));
   end Generate_Unknown_Opcode_Error;

   -- Instruction handlers
   --
   --
   procedure Handle_Cls is
   begin
      Display.Clear;
   end Handle_Cls;

   procedure Handle_Ret (Result : out Result_Type) is
      Return_Address : User_Address;
   begin
      if Stack.Empty then
         Result :=
           (Success => False, Message => To_Result_String ("Stack Empty"));
         return;
      end if;

      Stack.Pop (Return_Address);
      Set_Program_Counter (Return_Address);
   end Handle_Ret;

   procedure Handle_Sys_Addr is
   begin
      -- The SYS  instruction is only used on the old computers
      -- on which Chip-8 was originally implemented. We ignore it.
      return;
   end Handle_Sys_Addr;

   procedure Handle_Jp_Addr
     (Target_Address : Address; Result : out Result_Type) is
   begin
      if not Memory.Is_User_Address (Integer (Target_Address)) then
         Result := Generate_Address_Bounds_Error;
         return;
      end if;

      Set_Program_Counter (Target_Address);
   end Handle_Jp_Addr;

   procedure Handle_Call_Addr
     (Target_Address : Address; Result : out Result_Type) is
   begin
      if not Memory.Is_User_Address (Integer (Target_Address)) then
         Result := Generate_Address_Bounds_Error;
         return;
      end if;

      if Stack.Full then
         Result :=
           (Success => False, Message => To_Result_String ("Stack Full"));
         return;
      end if;

      Stack.Push (Get_Program_Counter);
      Set_Program_Counter (Target_Address);
   end Handle_Call_Addr;

   procedure Handle_Jp_Vx_Addr
     (Register       : General_Register_Number;
      Target_Address : Address;
      Result         : out Result_Type)
   is
      Value         : constant Register_Word :=
        Get_General_Register (Register);
      Final_Address : constant Integer :=
        Integer (Target_Address) + Integer (Value);
   begin
      if not Memory.Is_User_Address (Final_Address) then
         Result := Generate_Address_Bounds_Error;
         return;
      end if;

      Set_Program_Counter (User_Address (Final_Address));
   end Handle_Jp_Vx_Addr;

   procedure Handle_Ld_I_Addr (Target_Address : Address) is
   begin
      Set_Address_Register (Target_Address);
   end Handle_Ld_I_Addr;

   procedure Handle_Se_Vx_Byte
     (Register_1 : General_Register_Number; B : Byte; Result : out Result_Type)
   is
      Value : constant Register_Word := Get_General_Register (Register_1);
   begin
      if Byte (Value) = B then
         if not Can_Increment_Program_Counter then
            Result := Generate_Program_Counter_Error;
            return;
         end if;

         Increment_Program_Counter;
      end if;

   end Handle_Se_Vx_Byte;

   procedure Handle_Sne_Vx_Byte
     (Register_1 : General_Register_Number; B : Byte; Result : out Result_Type)
   is
      Value : constant Register_Word := Get_General_Register (Register_1);
   begin
      if Byte (Value) /= B then
         if not Can_Increment_Program_Counter then
            Result := Generate_Program_Counter_Error;
            return;
         end if;

         Increment_Program_Counter;
      end if;

   end Handle_Sne_Vx_Byte;

   procedure Handle_Ld_Vx_Byte (Register_1 : General_Register_Number; B : Byte)
   is
   begin
      Set_General_Register (Register_1, Register_Word (B));
   end Handle_Ld_Vx_Byte;

   procedure Handle_Add_Vx_Byte
     (Register_1 : General_Register_Number; B : Byte) is
   begin
      Set_General_Register
        (Register_1, Get_General_Register (Register_1) + Register_Word (B));
   end Handle_Add_Vx_Byte;

   procedure Handle_Rnd_Vx_Byte
     (Register_1 : General_Register_Number; B : Byte) is
   begin
      Set_General_Register
        (Register_1,
         Register_Word (Random_Numbers.Get_Random_Number)
         and Register_Word (B));
   end Handle_Rnd_Vx_Byte;

   procedure Handle_Skp_Vx
     (Register_1 : General_Register_Number; Result : out Result_Type)
   is
      Key : constant Register_Word := Get_General_Register (Register_1);
   begin
      if Keypad.Pressed_Keys (Keypad.Keypad_Key (Key)) then
         if not Can_Increment_Program_Counter then
            Result := Generate_Program_Counter_Error;
            return;
         end if;

         Increment_Program_Counter;
      end if;
   end Handle_Skp_Vx;

   procedure Handle_Sknp_Vx
     (Register_1 : General_Register_Number; Result : out Result_Type)
   is
      Key : constant Register_Word := Get_General_Register (Register_1);
   begin
      if not Keypad.Pressed_Keys (Keypad.Keypad_Key (Key)) then
         if not Can_Increment_Program_Counter then
            Result := Generate_Program_Counter_Error;
            return;
         end if;

         Increment_Program_Counter;
      end if;

   end Handle_Sknp_Vx;

   procedure Handle_Ld_Vx_Dt (Register_1 : General_Register_Number) is
      Value_Delay_Timer : constant Timers.Timer := Timers.Get_Delay_Timer;
   begin
      Set_General_Register (Register_1, Register_Word (Value_Delay_Timer));
   end Handle_Ld_Vx_Dt;

   procedure Handle_Ld_Vx_K (Register_1 : General_Register_Number) is
   begin
      Keypad.Waiting_For_Input := True;
      Keypad.Waiting_For_Input_Register := Register_1;
   -- The actual handling is done in the main procedure. Not so nice, but that's were the sdl input handling is...
   end Handle_Ld_Vx_K;

   procedure Handle_Ld_Dt_Vx (Register_1 : General_Register_Number) is
      Value : constant Register_Word := Get_General_Register (Register_1);
   begin
      Timers.Set_Delay_Timer (Timers.Timer (Value));
   end Handle_Ld_Dt_Vx;

   procedure Handle_Ld_St_Vx (Register_1 : General_Register_Number) is
      Value : constant Register_Word := Get_General_Register (Register_1);
   begin
      Timers.Set_Sound_Timer (Timers.Timer (Value));
   end Handle_Ld_St_Vx;

   procedure Handle_Add_I_Vx (Register_1 : General_Register_Number) is
      Value_R1               : constant Register_Word :=
        Get_General_Register (Register_1);
      Value_Address_Register : constant Address := Get_Address_Register;
      Final_Address          : constant Integer :=
        Integer (Value_Address_Register) + Integer (Value_R1);
   begin
      Set_Address_Register (Address (Final_Address));
   end Handle_Add_I_Vx;

   procedure Handle_Ld_F_Vx (Register_1 : General_Register_Number) is
      Value          : constant Register_Word :=
        Get_General_Register (Register_1);
      Sprite_Address : constant Integer :=
        Integer (Memory.Interpreter_Address'First)
        + Integer ((Value * Sprites.Hex_Sprite'Length));
   begin
      Set_Address_Register (Address (Sprite_Address));
   end Handle_Ld_F_Vx;

   -- TODO: range check
   procedure Handle_Ld_B_Vx (Register_1 : General_Register_Number) is
      BCD_Value       : constant BCD.BCD_Array :=
        BCD.To_BCD (Integer (Get_General_Register (Register_1)));
      Current_Address : Address := Get_Address_Register;
   begin
      for I in 0 .. 2 - BCD_Value'Length loop
         Memory.Store (Current_Address, 0);
         Current_Address := Current_Address + 1;
      end loop;

      for I in BCD_Value'Range loop
         Memory.Store (Current_Address, Memory_Word (BCD_Value (I)));
         Current_Address := Current_Address + 1;
      end loop;
   end Handle_Ld_B_Vx;

   procedure Handle_Ld_I_Vx (Register_1 : General_Register_Number) is
      Current_Address : Address := Get_Address_Register;
   begin
      for Register in General_Register_Number'First .. Register_1 loop
         Memory.Store
           (Current_Address, Memory_Word (Get_General_Register (Register)));
         Current_Address := Current_Address + 1;
      end loop;
   end Handle_Ld_I_Vx;

   procedure Handle_Ld_Vx_I (Register_1 : General_Register_Number) is
      Current_Address : Address := Get_Address_Register;
   begin
      for Register in General_Register_Number'First .. Register_1 loop
         Set_General_Register
           (Register, Register_Word (Memory.Load (Current_Address)));
         Current_Address := Current_Address + 1;
      end loop;
   end Handle_Ld_Vx_I;

   procedure Handle_Se_Vx_Vy
     (Register_1 : General_Register_Number;
      Register_2 : General_Register_Number;
      Result     : out Result_Type) is
   begin
      if Get_General_Register (Register_1) = Get_General_Register (Register_2)
      then
         if not Can_Increment_Program_Counter then
            Result := Generate_Program_Counter_Error;
            return;
         end if;

         Increment_Program_Counter;
      end if;
   end Handle_Se_Vx_Vy;

   procedure Handle_Ld_Vx_Vy
     (Register_1 : General_Register_Number;
      Register_2 : General_Register_Number) is
   begin
      Set_General_Register (Register_1, Get_General_Register (Register_2));
   end Handle_Ld_Vx_Vy;

   procedure Handle_Or_Vx_Vy
     (Register_1 : General_Register_Number;
      Register_2 : General_Register_Number) is
   begin
      Set_General_Register
        (Register_1,
         Get_General_Register (Register_1)
         or Get_General_Register (Register_2));
   end Handle_Or_Vx_Vy;

   procedure Handle_And_Vx_Vy
     (Register_1 : General_Register_Number;
      Register_2 : General_Register_Number) is
   begin
      Set_General_Register
        (Register_1,
         Get_General_Register (Register_1)
         and Get_General_Register (Register_2));
   end Handle_And_Vx_Vy;

   procedure Handle_Xor_Vx_Vy
     (Register_1 : General_Register_Number;
      Register_2 : General_Register_Number) is
   begin
      Set_General_Register
        (Register_1,
         Get_General_Register (Register_1)
         xor Get_General_Register (Register_2));
   end Handle_Xor_Vx_Vy;

   procedure Handle_Add_Vx_Vy
     (Register_1 : General_Register_Number;
      Register_2 : General_Register_Number) is
   begin
      Add_General_Register (Register_1, Register_2);
   end Handle_Add_Vx_Vy;

   procedure Handle_Sub_Vx_Vy
     (Register_1 : General_Register_Number;
      Register_2 : General_Register_Number) is
   begin
      Sub_General_Register (Register_1, Register_2);
   end Handle_Sub_Vx_Vy;

   procedure Handle_Shr_Vx (Register_1 : General_Register_Number) is
   begin
      Shift_Right_General_Register (Register_1);
   end Handle_Shr_Vx;

   procedure Handle_Subn_Vx_Vy
     (Register_1 : General_Register_Number;
      Register_2 : General_Register_Number) is
   begin
      SubN_General_Register (Register_1, Register_2);
   end Handle_Subn_Vx_Vy;

   procedure Handle_Shl_Vx (Register_1 : General_Register_Number) is
   begin
      Shift_Left_General_Register (Register_1);
   end Handle_Shl_Vx;

   procedure Handle_Sne_Vx_Vy
     (Register_1 : General_Register_Number;
      Register_2 : General_Register_Number;
      Result     : out Result_Type) is
   begin
      if Get_General_Register (Register_1) /= Get_General_Register (Register_2)
      then
         if not Can_Increment_Program_Counter then
            Result := Generate_Program_Counter_Error;
            return;
         end if;

         Increment_Program_Counter;
      end if;
   end Handle_Sne_Vx_Vy;

   procedure Handle_Drw_Vx_Vy_Nibble
     (Register_1  : General_Register_Number;
      Register_2  : General_Register_Number;
      Sprite_Size : Nibble)
   is
      X_Pos : Display.X_Coordinate;
      Y_Pos : Display.Y_Coordinate;
   begin
      X_Pos :=
        Display.X_Coordinate
          (Get_General_Register (Register_1) mod Display.Width);
      Y_Pos :=
        Display.Y_Coordinate
          (Get_General_Register (Register_2) mod Display.Height);

      Display.Draw_Sprite
        (Location => Get_Address_Register,
         Size     => Sprites.Sprite_Row_Number (Sprite_Size),
         X_Pos    => X_Pos,
         Y_Pos    => Y_Pos);
   end Handle_Drw_Vx_Vy_Nibble;
end Instructions;
