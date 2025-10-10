package body Stack is
   procedure Push (I : Address) is
   begin
      Top := Top + 1;
      Items (Top) := I;
   end Push;

   procedure Pop (I : out Address) is
   begin
      I := Items (Top);
      Top := Top - 1;
   end Pop;

   function Size return Integer is
   begin
      return Top;
   end Size;

   function Empty return Boolean
   is (Top = 0);
   function Full return Boolean
   is (Top = Capacity);
end Stack;
