with Instructions;

package body Registers is
   procedure Set_General_Register
     (Number : General_Register_Number; Value : Register_Word) is
   begin
      General_Registers (Number) := Value;
   end Set_General_Register;

   procedure Add_General_Register
     (Number_1 : General_Register_Number; Number_2 : General_Register_Number)
   is
      Pre_Value   : constant Register_Word := Get_General_Register (Number_1);
      After_Value : constant Register_Word :=
        Pre_Value + Get_General_Register (Number_2);
   begin
      Set_General_Register (Number_1, After_Value);

      -- Overflow
      Set_VF (After_Value < Pre_Value);
   end Add_General_Register;

   procedure Sub_General_Register
     (Number_1 : General_Register_Number; Number_2 : General_Register_Number)
   is
      Pre_Value   : constant Register_Word := Get_General_Register (Number_1);
      After_Value : constant Register_Word :=
        Pre_Value - Get_General_Register (Number_2);
   begin
      Set_General_Register (Number_1, After_Value);

      -- Underflow
      Set_VF (After_Value > Pre_Value);
   end Sub_General_Register;

   procedure SubN_General_Register
     (Target : General_Register_Number; Other : General_Register_Number)
   is
      Pre_Value   : constant Register_Word := Get_General_Register (Other);
      After_Value : constant Register_Word :=
        Pre_Value - Get_General_Register (Target);
   begin
      Set_General_Register (Target, After_Value);

      -- Underflow
      Set_VF (After_Value > Pre_Value);
   end SubN_General_Register;

   procedure Shift_Left_General_Register (Number : General_Register_Number) is
      Value : constant Register_Word := Get_General_Register (Number);
   begin
      Set_VF ((Value and Register_Word (Register_Word'Modulus / 2)) = 1);

      Set_General_Register (Number, Value * 2);
   end Shift_Left_General_Register;

   procedure Shift_Right_General_Register (Number : General_Register_Number) is
      Value : constant Register_Word := Get_General_Register (Number);
   begin
      Set_VF ((Value and 1) = 1);

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
      Program_Counter :=
        User_Address
          (Integer (Program_Counter) + Instructions.Instruction_Length);
   end Increment_Program_Counter;

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

   function Get_VF return Register_Word
   is (Get_General_Register (16#F#));
end Registers;
