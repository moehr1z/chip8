with Memory; use Memory;

package Registers is
   pragma Assertion_Policy (Check);

   type Register_Word is mod 2**8;
   type General_Register_Number is range 0 .. 16#F#;

   VF : constant General_Register_Number := 16#F#;

   procedure Set_General_Register
     (Number : General_Register_Number; Value : Register_Word)
   with Post => Get_General_Register (Number) = Value;

   procedure Add_General_Register
     (Number_1 : General_Register_Number; Number_2 : General_Register_Number)
   with
     Post =>
       ((Integer (Get_General_Register (Number_1)'Old)
         + Integer (Get_General_Register (Number_2)'Old)
         > Integer (Register_Word'Last))
        and then Get_VF = 1)
       or else Get_VF = 0;

   procedure Sub_General_Register
     (Number_1 : General_Register_Number; Number_2 : General_Register_Number)
   with
     Post =>
       (Get_General_Register (Number_1)'Old
        >= Get_General_Register (Number_2)'Old
        and then Get_VF = 1)
       or else Get_VF = 0;

   -- Target = Other - Target
   procedure SubN_General_Register
     (Target : General_Register_Number; Other : General_Register_Number)
   with
     Post =>
       (Get_General_Register (Other)'Old >= Get_General_Register (Target)'Old
        and then Get_VF = 1)
       or else Get_VF = 0;

   procedure Shift_Left_General_Register (Number : General_Register_Number)
   with
     Post =>
       ((Get_General_Register (Number)'Old
         and Register_Word (Register_Word'Modulus / 2))
        /= 0
        and then Get_VF = 1)
       or else Get_VF = 0;

   procedure Shift_Right_General_Register (Number : General_Register_Number)
   with
     Post =>
       ((Get_General_Register (Number)'Old and 1) = 1 and then Get_VF = 1)
       or else Get_VF = 0;

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
     Post => Get_Program_Counter = Get_Program_Counter'Old + 2;

   function Get_Program_Counter return User_Address;

   procedure Set_VF (B : Boolean)
   with Post => Get_VF = (if B then 1 else 0);

   function Get_VF return Register_Word;

private
   General_Registers : array (General_Register_Number) of Register_Word :=
     [others => 0];
   Address_Register  : Address := Address'First;
   Program_Counter   : User_Address := User_Address'First;

end Registers;
