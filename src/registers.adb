package body Registers is

   procedure Set_General_Register
     (Number : General_Register_Number; Value : Register_Word) is
   begin
      General_Registers (Number) := Value;
   end Set_General_Register;

   procedure Add_General_Register
     (Number : General_Register_Number; Value : Register_Word)
   is
      Pre_Value   : constant Register_Word := Get_General_Register (Number);
      After_Value : Register_Word;
   begin
      Set_General_Register (Number, Pre_Value + Value);
      After_Value := Get_General_Register (Number);

      -- Overflow
      if After_Value < Pre_Value then
         Set_VF (True);
      else
         Set_VF (False);
      end if;
   end Add_General_Register;

   procedure Sub_General_Register
     (Number : General_Register_Number; Value : Register_Word)
   is
      Pre_Value   : constant Register_Word := Get_General_Register (Number);
      After_Value : Register_Word;
   begin
      Set_General_Register (Number, Pre_Value - Value);
      After_Value := Get_General_Register (Number);

      -- Underflow
      if After_Value > Pre_Value then
         Set_VF (False);
      else
         Set_VF (True);
      end if;
   end Sub_General_Register;

   procedure Shift_Left_General_Register (Number : General_Register_Number) is
      Value : constant Register_Word := Get_General_Register (Number);
   begin
      if (Value and 1) = 1 then
         -- LSB
         Set_VF (True);
      end if;

      Set_General_Register (Number, Value * 2);
   end Shift_Left_General_Register;

   procedure Shift_Right_General_Register (Number : General_Register_Number) is
      Value : constant Register_Word := Get_General_Register (Number);
   begin
      if (Value and Register_Word (Register_Word'Modulus / 2)) = 1 then
         -- MSB
         Set_VF (True);
      end if;

      Set_General_Register (Number, Value / 2);
   end Shift_Right_General_Register;

   function Get_General_Register
     (Number : General_Register_Number) return Register_Word
   is (General_Registers (Number));

   procedure Set_Address_Register (Value : Address) is
   begin
      Address_Register := Value;
   end Set_Address_Register;

   function Get_Address_Register return Address
   is (Address_Register);

   procedure Set_Program_Counter (Value : User_Address) is
   begin
      Program_Counter := Value;
   end Set_Program_Counter;

   procedure Increment_Program_Counter is
   begin
      Program_Counter := Program_Counter + 1;
   end Increment_Program_Counter;

   procedure Skip_Next_Instruction is
   begin
      Program_Counter := Program_Counter + 2;
   end Skip_Next_Instruction;

   function Get_Program_Counter return User_Address
   is (Program_Counter);

   procedure Set_VF (B : Boolean) is
      Value : Register_Word := 0;
   begin
      if B then
         Value := 1;
      end if;
      Set_General_Register (VF, Value);
   end Set_VF;
end Registers;
