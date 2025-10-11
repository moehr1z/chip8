with Memory; use Memory;

package Registers is
   type Register_Word is mod 2**8;
   type General_Register_Number is range 0 .. 16#F#;

   procedure Set_General_Register
     (Number : General_Register_Number; Value : Register_Word)
     -- Postcondition: The specified register is really set to Value and no other is modified
   with Post => Get_General_Register (Number) = Value;
   --  TODO: how to properly express this?
   --  and then (for all I in General_Register_Number =>
   --              I = Number
   --              or else (Get_General_Register (I)
   --                       = Get_General_Register (I)'Old
   --                       and Get_Address_Register
   --                           = Get_Address_Register'Old));

   function Get_General_Register
     (Number : General_Register_Number) return Register_Word;

   procedure Set_Address_Register (Value : Address)
   with Post => Get_Address_Register = Value;

   function Get_Address_Register return Address;

   function Carry_Is_Set return Boolean;

   procedure Set_Carry (State : Boolean)
   with Post => Carry_Is_Set = State;

   function No_Borrow_Is_Set return Boolean;

   procedure Set_No_Borrow (State : Boolean)
   with Post => No_Borrow_Is_Set = State;

   function Collision_Is_Set return Boolean;

   procedure Set_Collision (State : Boolean)
   with Post => Collision_Is_Set = State;

private
   General_Registers : array (General_Register_Number) of Register_Word :=
     (others => 0);
   Address_Register  : Address := 0;

   VF : constant General_Register_Number := 16#F#;

   procedure Set_VF_From_Boolean (B : Boolean)
   with Post => Get_General_Register (VF) = (if B then 1 else 0);
end Registers;
