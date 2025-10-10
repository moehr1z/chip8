with Machine; use Machine;

package Stack is
   Capacity : constant := 64;

   procedure Push (I : Address)
   with Pre => not Full, Post => Size = Size'Old + 1;

   procedure Pop (I : out Address)
   with Pre => not Empty, Post => Size = Size'Old - 1;

   function Empty return Boolean;
   function Full return Boolean;
   function Size return Integer;
private
   Items : array (1 .. Capacity) of Address; -- the actual stack
   Top   : Integer range 0 .. Capacity := 0; -- 0 iff empty
end Stack;
