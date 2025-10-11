package body Registers is

   procedure Set_General_Register
     (Number : General_Register_Number; Value : Register_Word) is
   begin
      General_Registers (Number) := Value;
   end Set_General_Register;

   function Get_General_Register
     (Number : General_Register_Number) return Register_Word
   is (General_Registers (Number));

   procedure Set_Address_Register (Value : Address) is
   begin
      Address_Register := Value;
   end Set_Address_Register;

   function Get_Address_Register return Address
   is (Address_Register);

   function Carry_Is_Set return Boolean
   is (Get_General_Register (VF) /= 0);

   procedure Set_Carry (State : Boolean) is
   begin
      Set_VF_From_Boolean (State);
   end Set_Carry;

   function No_Borrow_Is_Set return Boolean
   is (Get_General_Register (VF) /= 0);
   procedure Set_No_Borrow (State : Boolean) is
   begin
      Set_VF_From_Boolean (State);
   end Set_No_Borrow;

   function Collision_Is_Set return Boolean
   is (Get_General_Register (VF) /= 0);
   procedure Set_Collision (State : Boolean) is
   begin
      Set_VF_From_Boolean (State);
   end Set_Collision;

   procedure Set_VF_From_Boolean (B : Boolean) is
      Value : Register_Word := 0;
   begin
      if B then
         Value := 1;
      end if;
      Set_General_Register (VF, Value);
   end Set_VF_From_Boolean;
end Registers;
