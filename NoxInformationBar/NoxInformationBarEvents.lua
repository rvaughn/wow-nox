---------------------------------------------------------------------------
-- Nox Information Bar
---------------------------------------------------------------------------

---------------------------------------------------------------------------
-- OnLoad() Event Handler
---------------------------------------------------------------------------

function NoxInformationBar_OnLoad(frame)
   -- Register slash commands
   NoxInformationBar_RegisterSlashCommands(NoxInformationBarCommand);

   -- Register events
   local i, event;
   for event in pairs(NoxInformationBarEvents) do
      frame:RegisterEvent(event);
   end

   -- Reset rate calculator
   NoxInformationBarFrame.TimeSinceLastUpdate = 0;

   frame:SetBackdropColor(0, 0, 0, 0.75);

   -- Set up popup menu
   NoxInformationBarMenu:AddItem(NOX_IB.Menu.Reset, NoxInformationBar_ResetCounters);

   -- Hook time played method in chatframe so we can block it later
   NoxInformationBar_HookTimePlayed();
end

---------------------------------------------------------------------------
-- OnMouseDown() Event Handler
---------------------------------------------------------------------------

function NoxInformationBar_OnMouseDown(frame, button)
   if (button == "LeftButton" and not (Nox.Player.Locked)) then
      if (GameTooltip:IsOwned(NoxInformationBarFrame)) then
         GameTooltip:Hide();
      end
      NoxInformationBarFrame:StartMoving();
      NoxInformationBarFrame.isMoving = true;
   end
end

---------------------------------------------------------------------------
-- OnMouseUp() Event Handler
---------------------------------------------------------------------------

function NoxInformationBar_OnMouseUp(frame, button)
   if (button == "LeftButton" and NoxInformationBarFrame.isMoving) then
      NoxInformationBarFrame:StopMovingOrSizing();
      NoxInformationBarFrame.isMoving = false;
   elseif (button == "RightButton") then
      if (GameTooltip:IsOwned(NoxInformationBarFrame)) then
         GameTooltip:Hide();
      end
      PlaySound("igMainMenuOptionCheckBoxOn");
      NoxInformationBarMenu:Show();
   end
end

---------------------------------------------------------------------------
-- OnUpdate() Event Handler
---------------------------------------------------------------------------

function NoxInformationBar_OnUpdate(frame, elapsed)
   NoxInformationBar_RefreshDisplay(elapsed);
end

---------------------------------------------------------------------------
-- OnShow() Event Handler
---------------------------------------------------------------------------

function NoxInformationBar_OnShow(frame)
   -- do not delete
   -- this is here for the convenience of extensions
end

---------------------------------------------------------------------------
-- OnHide() Event Handler
---------------------------------------------------------------------------

function NoxInformationBar_OnHide(frame)
   -- do not delete
   -- this is here for the convenience of extensions
end

---------------------------------------------------------------------------
-- OnEnter()/OnLeave() Event Handlers
---------------------------------------------------------------------------

function NoxInformationBarText_OnEnter(frame)
   if (not NoxInformationBarMenu:IsVisible()) then
      NoxInformationBar_ShowTooltip();
   end
end

function NoxInformationBarText_OnLeave(frame)
   GameTooltip:Hide();
end

---------------------------------------------------------------------------
-- OnEvent() Event Handlers
---------------------------------------------------------------------------

NoxInformationBarEvents = {};

function NoxInformationBar_OnEvent(frame, event, ...)
   local func = NoxInformationBarEvents[event];
   if (func) then
      func(...);
   end
end

NoxInformationBarEvents["TIME_PLAYED_MSG"] = function(arg1, arg2)
   -- Update data
   Nox.Global.TotalTimePlayed               = arg1;
   Nox.Global.LevelTimePlayed               = arg2;
   --Nox.Global.ElapsedSinceLastPlayedMessage = 0;
    
   -- Sync up all of the times to the session time; this makes
   -- the tooltip look nicer as everything changes all at once
   local fraction = Nox.Global.SessionTimePlayed - floor(Nox.Global.SessionTimePlayed);
   Nox.Global.TotalTimePlayed = floor(Nox.Global.TotalTimePlayed) + fraction;
   Nox.Global.LevelTimePlayed = floor(Nox.Global.LevelTimePlayed) + fraction;
end

NoxInformationBarEvents["PLAYER_LEVEL_UP"] = function()
   if Nox.ready then
      -- Update data
      Nox.Global.LevelTimePlayed = Nox.Global.SessionTimePlayed - floor(Nox.Global.SessionTimePlayed);
      Nox.Global.RolloverXP = Nox.Global.SessionXP;
      Nox.Global.InitialXP = 0;
   
      Nox.Global.MaxLevel = (UnitLevel("player") == NoxInformationBarPlayerLevelMax);
        
      -- Update tooltip if it is up
      if (GameTooltip:IsOwned(NoxInformationBarFrame) and GameTooltip:IsVisible()) then 
         NoxInformationBar_SetTooltip(); 
      end
   end
end

NoxInformationBarEvents["PLAYER_ENTERING_WORLD"] = function()
   NoxInformationBar_InitPlayer();
   NoxInformationBar_UpdateConfig();

   if Nox.ready then
      -- start all counters from this event
      NoxInformationBar_ResetCounters();
      NoxInformationBar_RefreshFrame();
   end
end

NoxInformationBarEvents["UNIT_NAME_UPDATE"] = function()
   NoxInformationBar_InitPlayer();
   NoxInformationBar_UpdateConfig();

   if Nox.ready then
      NoxInformationBar_RefreshFrame();
   end
end

NoxInformationBarEvents["PLAYER_XP_UPDATE"] = function()
   if (Nox.Global.InitialXP) then
      -- Update data
      Nox.Global.SessionXP = UnitXP("player") - Nox.Global.InitialXP + Nox.Global.RolloverXP;
   end
end

NoxInformationBarEvents["VARIABLES_LOADED"] = function()
   NoxInformationBar_RegisterMyAddOns();
   NoxInformationBar_InitFormats();

   NoxInformationBar_InitVariables();
   NoxInformationBar_UpdateConfig();

   if Nox.ready then
      NoxInformationBar_ResetCounters();
      NoxInformationBar_RefreshFrame();
   end
end

NoxInformationBarEvents["ZONE_CHANGED"] = function()
   SetMapToCurrentZone();
end

NoxInformationBarEvents["UPDATE_FACTION"] = function()
   NoxInformationBar_UpdateFactions();
end

NoxInformationBarEvents["BAG_UPDATE"] = function()
   NoxInformationBar_UpdateInventory();
end

