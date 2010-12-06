---------------------------------------------------------------------------
-- Nox Information Bar
---------------------------------------------------------------------------

---------------------------------------------------------------------------
-- XP Bar Functions
---------------------------------------------------------------------------

local Original_NoxInformationBar_OnPlayerInitialized;

function NoxInformationBarPlayerXPBar_OnLoad(frame)
    -- Experience bar registrations
    frame:RegisterEvent("PLAYER_XP_UPDATE");
    frame:RegisterEvent("PLAYER_LEVEL_UP");
    frame:RegisterEvent("PLAYER_ENTERING_WORLD");
    Original_NoxInformationBar_OnPlayerInitialized = NoxInformationBar_OnPlayerInitialized;
    NoxInformationBar_OnPlayerInitialized = NoxInformationBarPlayerXPBar_OnPlayerInitialized;
end

function NoxInformationBarPlayerXPBar_OnPlayerInitialized()
   Original_NoxInformationBar_OnPlayerInitialized();
   NoxInformationBarPlayerXPBar_Update();
end

function NoxInformationBarPlayerXPBar_OnEvent(frame, event, ...)
   -- Setup our experience bar when the player logs in, when experience changes, or when the player levels up
   if (event == "PLAYER_XP_UPDATE" or event == "PLAYER_LEVEL_UP" or event == "PLAYER_ENTERING_WORLD") then
      NoxInformationBarPlayerXPBar_Update();
   end
end

function NoxInformationBarPlayerXPBar_Update()
   local currentXP = UnitXP("player");
   local nextXP    = UnitXPMax("player");
   local restXP    = (GetXPExhaustion() or 0);

   NoxInformationBarPlayerXPBar:SetMinMaxValues(0, nextXP);
   NoxInformationBarPlayerXPBar:SetValue(currentXP);

   NoxInformationBarPlayerRestXPBar:SetMinMaxValues(0, nextXP);
   NoxInformationBarPlayerRestXPBar:SetValue(min(nextXP, currentXP + restXP));

   -- Hide bars if player maxed
   if (Nox.Player.ShowXPBar and UnitLevel("player") < NoxInformationBarPlayerLevelMax) then
      NoxInformationBarPlayerXPBar:Show();
      NoxInformationBarPlayerRestXPBar:Show();
   else
      NoxInformationBarPlayerXPBar:Hide();
      NoxInformationBarPlayerRestXPBar:Hide();
   end
end
