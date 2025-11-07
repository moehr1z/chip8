package body Registers
  with SPARK_Mode => On
is
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

      Set_VF (After_Value < Pre_Value);
   end Add_General_Register;

   procedure Sub_General_Register
     (Number_1 : General_Register_Number; Number_2 : General_Register_Number)
   is
      Value_1 : constant Register_Word := Get_General_Register (Number_1);
      Value_2 : constant Register_Word := Get_General_Register (Number_2);
   begin
      Set_General_Register (Number_1, Value_1 - Value_2);

      Set_VF (Value_1 >= Value_2);
   end Sub_General_Register;

   procedure SubN_General_Register
     (Target : General_Register_Number; Other : General_Register_Number)
   is
      Value_1 : constant Register_Word := Get_General_Register (Target);
      Value_2 : constant Register_Word := Get_General_Register (Other);
   begin
      Set_General_Register (Target, Value_2 - Value_1);

      Set_VF (Value_2 >= Value_1);
   end SubN_General_Register;

   procedure Shift_Left_General_Register (Number : General_Register_Number) is
      Value : constant Register_Word := Get_General_Register (Number);
   begin
      Set_General_Register (Number, Value * 2);

      Set_VF ((Value and Register_Word (Register_Word'Modulus / 2)) /= 0);
   end Shift_Left_General_Register;

   procedure Shift_Right_General_Register (Number : General_Register_Number) is
      Value : constant Register_Word := Get_General_Register (Number);
   begin
      Set_General_Register (Number, Value / 2);

      Set_VF ((Value and 1) = 1);
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
          (Integer (Program_Counter) + Memory.Memory_Words_Per_Instruction);
   end Increment_Program_Counter;

   function Get_Program_Counter return User_Address
   is (Program_Counter);

   procedure Set_VF (B : Boolean) is
   begin
      Set_General_Register (VF, (if B then 1 else 0));
   end Set_VF;

   function Get_VF return Register_Word
   is (Get_General_Register (16#F#));
end Registers;
