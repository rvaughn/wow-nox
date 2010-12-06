---------------------------------------------------------------------------
-- Nox Information Bar
---------------------------------------------------------------------------

---------------------------------------------------------------------------
-- External support
---------------------------------------------------------------------------

function NoxInformationBar_RegisterMyAddOns()
   -- Add NoxInformationBar to myAddOns addons list
   if (myAddOnsFrame) then
      myAddOnsFrame_Register(Nox.RegistrationInfo);
   end
end
