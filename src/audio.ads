with Timers;  use Timers;
with Results; use Results;
use Results.Result_Bounded_String;

package Audio is
   pragma Assertion_Policy (Check);

   procedure Init (Result : out Result_Type);
   function Was_Initialized return Boolean;

   procedure Play_Audio
   with Pre => Was_Initialized;
private
   Initialized : Boolean := False;
end Audio;
