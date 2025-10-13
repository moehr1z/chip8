with Memory; use Memory;

package Registers is
   type Register_Word is mod 2**8;
   type General_Register_Number is range 0 .. 16#F#;

   VF : constant General_Register_Number := 16#F#;

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

   -- TODO: conditions
   procedure Add_General_Register
     (Number : General_Register_Number; Value : Register_Word);

   -- TODO: conditions
   procedure Sub_General_Register
     (Number : General_Register_Number; Value : Register_Word);

   -- TODO: conditions
   procedure Shift_Left_General_Register (Number : General_Register_Number);

   -- TODO: conditions
   procedure Shift_Right_General_Register (Number : General_Register_Number);

   function Get_General_Register
     (Number : General_Register_Number) return Register_Word;

   procedure Set_Address_Register (Value : Address)
   with
     Pre  => Value in User_Address'Range or else Value in Font_Address'Range,
     Post => Get_Address_Register = Value;

   function Get_Address_Register return Address;

   procedure Set_Program_Counter (Value : User_Address)
   with Post => Get_Program_Counter = Value;

   procedure Increment_Program_Counter
   with
     Pre  => Get_Program_Counter < User_Address'Last,
     Post => Get_Program_Counter = Get_Program_Counter'Old + 1;

   procedure Skip_Next_Instruction
   with
     Pre  => Get_Program_Counter + 1 < User_Address'Last,
     Post => Get_Program_Counter = Get_Program_Counter'Old + 2;

   function Get_Program_Counter return User_Address;

   procedure Set_VF (B : Boolean)
   with Post => Get_General_Register (VF) = (if B then 1 else 0);

private
   General_Registers : array (General_Register_Number) of Register_Word :=
     (others => 0);
   Address_Register  : Address := Address'First;
   Program_Counter   : User_Address := User_Address'First;

end Registers;
