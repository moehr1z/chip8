package body Stack is
   pragma SPARK_Mode;

   procedure Push (I : User_Address) is
   begin
      Top := Top + 1;
      Items (Top) := I;
   end Push;

   procedure Pop (I : out User_Address) is
   begin
      I := Items (Top);
      Top := Top - 1;
   end Pop;

   function Size return Integer is
   begin
      return Top;
   end Size;

   function Peek return User_Address is
   begin
      return Items (Top);
   end Peek;

   function Empty return Boolean
   is (Top = 0);
   function Full return Boolean
   is (Top = Capacity);
end Stack;
