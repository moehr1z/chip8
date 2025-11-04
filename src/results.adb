package body Results
  with SPARK_Mode => On
is
   function To_Result_String (S : String) return Result_String is
      Output_String : Results.Result_String := [others => ' '];
      Length        : constant Integer :=
        Integer'Min (S'Length, Output_String'Length);
   begin
      for I in 0 .. Length - 1 loop
         Output_String (Output_String'First + I) := S (S'First + I);
      end loop;

      return Output_String;
   end To_Result_String;
end Results;
