package body Results is
   function To_Result_String (S : String) return Result_String is
      Output_String : Results.Result_String := [others => ' '];
      Last          : constant Integer :=
        (if S'Length >= Result_String'Length
         then Result_String'Length
         else S'Length);
   begin
      for I in Result_String'First .. Last loop
         Output_String (I) := S (I);
      end loop;

      return Output_String;
   end To_Result_String;
end Results;
