package body Audio is
   procedure Init (Result : out Results.Result_Type) is
   begin
      Initialized := True;
   end Init;

   function Was_Initialized return Boolean
   is (Initialized);

   procedure Play_Audio is
   begin
      null;
   end Play_Audio;
end Audio;
