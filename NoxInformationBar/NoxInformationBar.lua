--------------------------------------------------------------------------
-- Nox Information Bar
---------------------------------------------------------------------------

---------------------------------------------------------------------------
-- Variables
---------------------------------------------------------------------------

local Original_DisplayTimePlayed;
local ChatSuppressed = false;

---------------------------------------------------------------------------
-- Time Played Handling
---------------------------------------------------------------------------

function NoxInformationBar_RequestTimePlayed()
   -- if we're requesting the time played, prevent it from showing up in
   -- chat until we receive it
   ChatSuppressed = true;
   RequestTimePlayed();
end

function NoxInformationBar_DisplayTimePlayed(...)
   if (not ChatSuppressed) then
      Original_DisplayTimePlayed(...);
   else
      ChatSuppressed = false;
   end
end

function NoxInformationBar_HookTimePlayed()
   Original_DisplayTimePlayed = ChatFrame_DisplayTimePlayed;
   ChatFrame_DisplayTimePlayed = NoxInformationBar_DisplayTimePlayed;
end

---------------------------------------------------------------------------
-- Refresh Frame
---------------------------------------------------------------------------

function NoxInformationBar_RefreshFrame()
   -- Show / Hide bar
   if (Nox.Player.Visible) then 
      NoxInformationBarFrame:Show();
      NoxInformationBarFrame:SetHeight(Nox.Player.FontSize + 13);
   else                                             
      NoxInformationBarFrame:Hide();
      return;
   end

   -- show / hide border
   if (Nox.Player.Border) then
      NoxInformationBarFrameBackdrop:Show();
   else
      NoxInformationBarFrameBackdrop:Hide();
   end

   -- Set xp bar colors
   if (Nox.Player.ShowXPBar) then
      NoxInformationBarPlayerXPBar:SetStatusBarColor(Nox.Player.XPBarColor.r, Nox.Player.XPBarColor.g, Nox.Player.XPBarColor.b, Nox.Player.XPBarColor.a);
      NoxInformationBarPlayerRestXPBar:SetStatusBarColor(Nox.Player.RestBarColor.r, Nox.Player.RestBarColor.g, Nox.Player.RestBarColor.b, Nox.Player.RestBarColor.a);
      NoxInformationBarPlayerXPBar:SetHeight(Nox.Player.FontSize + 4);
      NoxInformationBarPlayerRestXPBar:SetHeight(Nox.Player.FontSize + 4);
   end
   
   -- Refresh slots
   local slotsWidth = 0;
   
   local index;
   for index = 1, NoxInformationBar_MaxSlots do
      local width = NoxInformationBar_GetSlotWidth(index) * Nox.Player.FontSize / 10;
      if (Nox.Player.Slot[index].Visible and width and width > 0) then
         NoxInformationBar_InitSlot(index, slotsWidth + 5, width);
         if (not Nox.Slots) then
            DEFAULT_CHAT_FRAME:AddMessage("no slots!");
            return
         end
         if (not Nox.Slots[index]) then
            DEFAULT_CHAT_FRAME:AddMessage("no slot " .. index);
            return
         end
         if (not Nox.Slots[index].SetWidth) then
            DEFAULT_CHAT_FRAME:AddMessage("no SetWidth!");
            return
         end
         Nox.Slots[index]:SetWidth(width);
         slotsWidth = slotsWidth + width;

         local name, height, flags = Nox.Slots[index]:GetFont();
         Nox.Slots[index]:SetFont(name, Nox.Player.FontSize, flags);

         NoxInformationBar_ShowSlot(index);
      else
         NoxInformationBar_HideSlot(index);
         NoxInformationBar_ClearSlot(index);
         Nox.Slots[index]:SetWidth(0);
      end
   end
   
   -- Resize bar
   NoxInformationBarFrame:SetWidth(slotsWidth + 10);
   NoxInformationBarTextButton:SetWidth(slotsWidth);
   NoxInformationBarPlayerXPBar:SetWidth(slotsWidth);
   NoxInformationBarPlayerRestXPBar:SetWidth(slotsWidth);
   --NoxInformationBarPlayerXPBarBackground:SetWidth(slotsWidth);

   -- Refresh XP bars
   NoxInformationBarPlayerXPBar_Update();
end

---------------------------------------------------------------------------
-- Refresh Display
---------------------------------------------------------------------------

function NoxInformationBar_RefreshDisplay(arg1)
   -- Make sure player is initialized
   -- NoxInformationBarPlayer_Update();

   if Nox.ready then
      NoxInformationBar_CalculateRegeneration(arg1);
      NoxInformationBar_UpdateTimers(arg1);

      if (NoxInformationBarFrame.TimeSinceLastUpdate > NOX_IB_UPDATE_RATE) then
         NoxInformationBarFrame.TimeSinceLastUpdate = 0;

         NoxInformationBar_UpdateSlots();
      
         if (GameTooltip:IsOwned(NoxInformationBarFrame)) then 
            NoxInformationBar_SetTooltip(); 
         end
      end
   end
end

function NoxInformationBar_UpdateSlots()
   local index;
   for index = 1, NoxInformationBar_MaxSlots do
      if (Nox.Player.Slot[index].Visible and Nox.Player.Slot[index].Width and Nox.Player.Slot[index].Width > 1) then
         NoxInformationBar_FormatSlot(index);
      end
   end
end

function NoxInformationBar_FormatSlot(index)
   local display = Nox.Player.Slot[index].Display;
   
   display = NoxInformationBar_FormatText(display);

   -- Set slot text
   Nox.Slots[index]:SetText(display);
end

function NoxInformationBar_FormatText(display)
   -- Allow user to type color and restore codes in edit boxes
   if (string.find(display, "||c")) then 
      display = string.gsub(display, "||c", "|c"); 
   end
   if (string.find(display, "||r")) then 
      display = string.gsub(display, "||r", "|r"); 
   end

   return (string.gsub(display, "(%b{})", NoxInformationBar_InterpretParam));
end

local args = {};

function NoxInformationBar_InterpretParam(param)
   local name = string.sub(param, 2, -2);
   local code, args = NoxInformationBar_ParseParam(name);
   if (string.find(code, "%s")) then
      code = string.gsub(code, "%s", "");
   end
   if (string.find(code, "%u")) then
      code = string.lower(code);
   end
   local format = NoxInformationBar_GetFormat(code);
   if (format) then
      if (format.func) then
         if (args) then
            return format.func(unpack(args));
         else
            return format.func();
         end
      else
         return NOX_IB.Messages.Error;
      end
   elseif string.find(name, "{") then -- did we find nested braces?
      return "{" .. (string.gsub(name, "(%b{})", NoxInformationBar_InterpretParam)) .. "}";
   else -- if not found, return the original match unchanged
      return param;
   end
end

function NoxInformationBar_ParseParam(param)
   local colon = string.find(param, ":");
   if (colon) then
      local arg = string.sub(param, colon + 1);
      local code = string.sub(param, 1, colon - 1);

      -- parse arguments
      -- we reuse a single table each time to avoid table construction costs
      local i, start, comma;

      i = 1;
      start = 1;
      repeat
         comma = string.find(arg, ",", start);
         if (comma) then
            args[i] = string.sub(arg, start, comma - 1);
            start = comma + 1;
         else
            args[i] = string.sub(arg, start);
         end
         i = i + 1;
      until (not comma);

      -- kill any args leftover from last call
      while (args[i]) do
         args[i] = nil;
         i = i + 1;
      end

      return code, args;
   else
      return param;
   end
end

---------------------------------------------------------------------------
-- Slot functions
---------------------------------------------------------------------------

function NoxInformationBar_ShowSlot(index)
   Nox.Slots[index]:Show();
end

function NoxInformationBar_HideSlot(index)
   Nox.Slots[index]:Hide();
end

function NoxInformationBar_InitSlot(index, left, width)
end

function NoxInformationBar_ClearSlot(index)
   Nox.Slots[index]:SetText("");
end

function NoxInformationBar_GetSlotWidth(index)
   return Nox.Player.Slot[index].Width;
end

---------------------------------------------------------------------------
-- Periodic counter functions
---------------------------------------------------------------------------

function NoxInformationBar_ResetCounters()
   -- Time played
   Nox.Global.TotalTimePlayed               = 0;
   Nox.Global.LevelTimePlayed               = 0;
   Nox.Global.SessionTimePlayed             = 0;

   -- XP
   Nox.Global.InitialXP  = UnitXP("player");
   Nox.Global.SessionXP  = 0;
   Nox.Global.RolloverXP = 0;
   Nox.Global.LevelMax = (UnitLevel("player") == NoxInformationBarPlayerLevelMax);

   -- Money
   Nox.Global.InitialMoney = GetMoney();
   Nox.Global.LastMoney    = Nox.Global.InitialMoney;
   Nox.Global.Income       = 0;
   Nox.Global.Expense      = 0;

   -- Regeneration
   Nox.Global.LastHealth  = -1;
   Nox.Global.HealthRegen = -1;
   Nox.Global.LastMana    = -1;
   Nox.Global.ManaRegen   = -1;

   -- get time played
   NoxInformationBar_RequestTimePlayed();
end

function NoxInformationBar_UpdateTimers(arg1)
   Nox.Global.SessionTimePlayed = Nox.Global.SessionTimePlayed + arg1;
   Nox.Global.LevelTimePlayed   = Nox.Global.LevelTimePlayed + arg1;
   Nox.Global.TotalTimePlayed   = Nox.Global.TotalTimePlayed + arg1;
   --Nox.Global.ElapsedSinceLastPlayedMessage = Nox.Global.ElapsedSinceLastPlayedMessage + arg1;

   local money = GetMoney();
   if (money > Nox.Global.LastMoney) then
      Nox.Global.Income = Nox.Global.Income + (money - Nox.Global.LastMoney);
   elseif (money < Nox.Global.LastMoney) then
      Nox.Global.Expense = Nox.Global.Expense + (Nox.Global.LastMoney - money);
   end
   Nox.Global.LastMoney = money;

   --SetMapToCurrentZone();
   Nox.Global.Position.x, Nox.Global.Position.y = GetPlayerMapPosition("player");

   NoxInformationBarFrame.TimeSinceLastUpdate = NoxInformationBarFrame.TimeSinceLastUpdate + arg1;
end

function NoxInformationBar_CalculateRegeneration(arg1)
   local CurrentHealth = UnitHealth("player");
   local CurrentMana   = UnitMana("player");

   if (Nox.Global.LastHealth > 0 and 
       (not(Nox.Global.LastHealth == CurrentHealth) or CurrentHealth == UnitHealthMax("player"))) then 
      Nox.Global.HealthRegen = CurrentHealth - Nox.Global.LastHealth; 
   end
   if (Nox.Global.LastMana > 0 and 
       (not(Nox.Global.LastMana == CurrentMana) or CurrentMana == UnitManaMax("player"))) then 
      Nox.Global.ManaRegen = CurrentMana - Nox.Global.LastMana;
   end
        
   Nox.Global.LastHealth = CurrentHealth;
   Nox.Global.LastMana   = CurrentMana;
end

