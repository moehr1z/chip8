with Memory; use Memory;

package Stack is
   Capacity : constant := 16;

   procedure Push (I : User_Address)
   with Pre => not Full, Post => Size = Size'Old + 1 and I = Peek;

   procedure Pop (I : out User_Address)
   with Pre => not Empty, Post => Size = Size'Old - 1 and I = Peek'Old;

   function Empty return Boolean;
   function Full return Boolean;
   function Size return Integer;
   function Peek return User_Address
   with Pre => not Empty;
private
   Items : array (1 .. Capacity) of User_Address; -- the actual stack
   Top   : Integer range 0 .. Capacity := 0; -- 0 iff empty
end Stack;
