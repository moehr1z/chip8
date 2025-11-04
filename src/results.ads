package Results
  with SPARK_Mode => On
is
   Max_String_Length : constant := 30;
   type Result_String is new String (1 .. Max_String_Length);

   type Result_Type (Success : Boolean := True) is record
      case Success is
         when True =>
            null;

         when False =>
            Message : Result_String;
      end case;
   end record;

   function To_Result_String (S : String) return Result_String;
end Results;
