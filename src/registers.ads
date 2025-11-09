with Memory; use Memory;

package Registers
  with SPARK_Mode => On
is
   type Register_Word is mod 2**8;
   type General_Register_Number is range 0 .. 16#F#;

   VF : constant General_Register_Number := 16#F#;

   procedure Set_General_Register
     (Number : General_Register_Number; Value : Register_Word)
   with Post => Get_General_Register (Number) = Value;

   procedure Add_General_Register
     (Number_1 : General_Register_Number; Number_2 : General_Register_Number)
   with
     Contract_Cases =>
       (Integer (Get_General_Register (Number_1))
        + Integer (Get_General_Register (Number_2))
        > Integer (Register_Word'Last) => Get_VF = 1,
        others                         => Get_VF = 0);

   procedure Sub_General_Register
     (Number_1 : General_Register_Number; Number_2 : General_Register_Number)
   with
     Contract_Cases =>
       (Get_General_Register (Number_1) >= Get_General_Register (Number_2) =>
          Get_VF = 1,
        others                                                             =>
          Get_Vf = 0);

   -- Target = Other - Target
   procedure SubN_General_Register
     (Target : General_Register_Number; Other : General_Register_Number)
   with
     Contract_Cases =>
       (Get_General_Register (Other) >= Get_General_Register (Target) =>
          Get_VF = 1,
        others                                                        =>
          Get_VF = 0);

   procedure Shift_Left_General_Register (Number : General_Register_Number)
   with
     Contract_Cases =>
       ((Get_General_Register (Number)
         and Register_Word (Register_Word'Modulus / 2))
        /= 0   => Get_VF = 1,
        others => Get_VF = 0);

   procedure Shift_Right_General_Register (Number : General_Register_Number)
   with
     Contract_Cases =>
       ((Get_General_Register (Number) and 1) = 1 => Get_VF = 1,
        others                                    => Get_VF = 0);

   function Get_General_Register
     (Number : General_Register_Number) return Register_Word;

   procedure Set_Address_Register (Value : Address)
   with Post => Get_Address_Register = Value;

   function Get_Address_Register return Address;

   procedure Set_Program_Counter (Value : User_Address)
   with Post => Get_Program_Counter = Value;

   procedure Increment_Program_Counter
   with
     Pre  =>
       Get_Program_Counter
       <= User_Address'Last - Memory.Memory_Words_Per_Instruction,
     Post =>
       Get_Program_Counter
       = Get_Program_Counter'Old + Memory.Memory_Words_Per_Instruction;

   function Get_Program_Counter return User_Address;

   function Can_Increment_Program_Counter return Boolean;

   procedure Set_VF (B : Boolean)
   with Post => Get_VF = (if B then 1 else 0);

   function Get_VF return Register_Word;

private
   General_Registers : array (General_Register_Number) of Register_Word :=
     [others => 0];
   Address_Register  : Address := Address'First;
   Program_Counter   : User_Address := User_Address'First;

end Registers;
