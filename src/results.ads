with Ada.Strings.Bounded;

package Results is
   package Result_Bounded_String is new
     Ada.Strings.Bounded.Generic_Bounded_Length (Max => 100);
   use Result_Bounded_String;

   type Result_Type (Success : Boolean := True) is record
      case Success is
         when True =>
            null;

         when False =>
            Error : Bounded_String;
      end case;
   end record;
end Results;
