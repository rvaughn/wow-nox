---------------------------------------------------------------------------
-- Nox Information Bar
---------------------------------------------------------------------------

---------------------------------------------------------------------------
-- Local helper functions
---------------------------------------------------------------------------

local function SessionTimeToLevel()
   return (UnitXPMax("player") - UnitXP("player")) * Nox.Global.SessionTimePlayed / Nox.Global.SessionXP;
end

local function LevelTimeToLevel()
   return (UnitXPMax("player") - UnitXP("player")) * Nox.Global.LevelTimePlayed / UnitXP("player");
end

local function LevelTimeToLevelIsValid()
   return UnitXP("player") > 0;
end

local function SessionTimeToLevelIsValid()
   return Nox.Global.SessionXP > 0;
end

---------------------------------------------------------------------------
-- Slot value functions
---------------------------------------------------------------------------

function NoxInformationBar_GetLatency(format)
    local input, output, latency = GetNetStats();
    
    if (latency > 600) then 
       return "|cffff0000" .. latency;
    elseif (latency > 300) then 
       return "|cffffff00" .. latency;
    else
       return "|cff00ff00" .. latency;
    end
end

function NoxInformationBar_GetFramerate(format)
    local fps = GetFramerate();
    
    if (fps > 24) then 
       return "|cff00ff00" .. NoxInformationBar_FormatNumber(fps, format, NOX_IB.Format.Decimal);
    elseif (fps > 12) then 
       return "|cffffff00" .. NoxInformationBar_FormatNumber(fps, format, NOX_IB.Format.Decimal);
    else
       return "|cffff0000" .. NoxInformationBar_FormatNumber(fps, format, NOX_IB.Format.Decimal);
    end
end

function NoxInformationBar_Get24Hours(format)
    local hour, minute = GetGameTime();
    hour   = hour   + (Nox.Player.Clock.OffsetHour   or 0);
    minute = minute + (Nox.Player.Clock.OffsetMinute or 0);
    
    -- Wrap minutes
    if (minute > 59) then 
       minute = minute - 60; 
       hour = hour + 1;
    elseif (minute < 0) then 
       minute = 60 + minute; 
       hour = hour - 1;
    end
    
    -- Wrap hours
    if (hour > 23) then 
       hour = hour - 24;
    elseif (hour < 0) then 
       hour = 24 + hour;
    end
    
    return hour;
end

function NoxInformationBar_GetHours(format)
    local hour, minute = GetGameTime();
    hour   = hour   + (Nox.Player.Clock.OffsetHour   or 0);
    minute = minute + (Nox.Player.Clock.OffsetMinute or 0);
    
    -- Wrap minutes
    if (minute > 59) then 
       minute = minute - 60; 
       hour = hour + 1;
    elseif (minute < 0) then 
       minute = 60 + minute; 
       hour = hour - 1;
    end
    
    -- Wrap hours
    if (hour > 23) then 
       hour = hour - 24;
    elseif (hour < 0) then 
       hour = 24 + hour;
    end
    
    -- the "+11 mod 12 +1" dodge changes the range from 0-11 to 1-12
    return math.fmod(hour + 11, 12) + 1;
end

function NoxInformationBar_GetMinutes(format)
    local hour, minute = GetGameTime();
    minute = minute + (Nox.Player.Clock.OffsetMinute or 0);
    
    -- Wrap minutes
    if (minute > 59) then 
       minute = minute - 60;
    elseif (minute < 0) then 
       minute = 60 + minute;
    end
    
    return string.format("%02d", minute);
end

function NoxInformationBar_GetAMPM(format)
    local hour, minute = GetGameTime();
    hour   = hour   + (Nox.Player.Clock.OffsetHour   or 0);
    minute = minute + (Nox.Player.Clock.OffsetMinute or 0);
    
    -- Wrap minutes
    if (minute > 59) then 
       minute = minute - 60; 
       hour = hour + 1;
    elseif (minute < 0) then 
       minute = 60 + minute; 
       hour = hour - 1;
    end
    
    -- Wrap hours
    if (hour > 23) then 
       hour = hour - 24;
    elseif (hour < 0) then 
       hour = 24 + hour;
    end
    
    if (hour > 11) then 
       return "PM";
    else
       return "AM";
    end
end

function NoxInformationBar_GetLocationX(format)
   return NoxInformationBar_FormatNumber(Nox.Global.Position.x * 100, format, NOX_IB.Format.Integer);
end

function NoxInformationBar_GetLocationY(format)
   return NoxInformationBar_FormatNumber(Nox.Global.Position.y * 100, format, NOX_IB.Format.Integer);
end

function NoxInformationBar_GetHealthRegen(format)
   return NoxInformationBar_FormatNumber(Nox.Global.HealthRegen, format, NOX_IB.Format.Decimal); 
end

function NoxInformationBar_GetManaRegen(format)
   return NoxInformationBar_FormatNumber(Nox.Global.ManaRegen, format, NOX_IB.Format.Decimal); 
end

function NoxInformationBar_GetHealth(format)
    return UnitHealth("player");
end

function NoxInformationBar_GetHealthLoss(format)
    return UnitHealthMax("player") - UnitHealth("player");
end

function NoxInformationBar_GetHealthPercentage(format)
    if (not(UnitHealthMax("player") > 0)) then 
       return NOX_IB.Messages.NotAvailable; 
    end
    
    return NoxInformationBar_FormatNumber(UnitHealth("player") / UnitHealthMax("player") * 100, format, NOX_IB.Format.Decimal);
end

function NoxInformationBar_GetMaxHealth(format)
    return UnitHealthMax("player");
end

function NoxInformationBar_GetMana(format)
    return UnitMana("player");
end

function NoxInformationBar_GetManaLoss(format)
    return UnitManaMax("player") - UnitMana("player");
end

function NoxInformationBar_GetManaPercentage(format)
    if (not(UnitManaMax("player") > 0)) then 
       return NOX_IB.Messages.NotAvailable; 
    end
    
    return NoxInformationBar_FormatNumber(UnitMana("player") / UnitManaMax("player") * 100, format, NOX_IB.Format.Decimal);
end

function NoxInformationBar_GetMaxMana(format)
    return UnitManaMax("player");
end

function NoxInformationBar_GetXP(format)
    return UnitXP("player");
end

function NoxInformationBar_GetXPToLevel(format)
    return UnitXPMax("player") - UnitXP("player");
end

function NoxInformationBar_GetXPPercentage(format)
    if (not(UnitXPMax("player") > 0)) then 
       return NOX_IB.Messages.NotAvailable; 
    end
    
    return NoxInformationBar_FormatNumber(UnitXP("player") / UnitXPMax("player") * 100, format, NOX_IB.Format.Decimal);
end

function NoxInformationBar_GetMaxXP(format)
    return UnitXPMax("player");
end

function NoxInformationBar_GetRestXP(format)
    return (GetXPExhaustion() or 0) / 2;
end

function NoxInformationBar_GetLevel(format)
    return UnitLevel("player");
end

function NoxInformationBar_GetUIMemory(range, format)
    local uimem = gcinfo();
    local result;
    if (range == NOX_IB.Format.MB) then
       result = NoxInformationBar_FormatNumber(uimem / 1024, format, NOX_IB.Format.Decimal);
    else
       result = NoxInformationBar_FormatNumber(uimem, format, NOX_IB.Format.Integer);
    end
    
    --if (uimem > 30720) then 
    --   return "|cffff0000" .. result;
    --elseif (uimem > 24576) then 
    --   return "|cffffff00" .. result;
    --else
    --   return "|cff00ff00" .. result;
    --end

    return result;
end

function NoxInformationBar_GetUsedBagSlots(format)
    local used = 0;
    local bag = 0;
    for bag = 0, 4 do
       local slots = GetContainerNumSlots(bag);
        
       local slot = 0;
       for slot = 1, slots do
          if (GetContainerItemInfo(bag, slot)) then
             used = used + 1;
          end
       end
    end      
    return used;
end

function NoxInformationBar_GetAvailableBagSlots(format)
   local notused = 0;
   local bag = 0;
   for bag = 0, 4 do
      local slots = GetContainerNumSlots(bag);
      local slot = 0;
      for slot = 1, slots do
         if (not GetContainerItemInfo(bag, slot)) then
            notused = notused + 1;
         end
      end
   end
   return notused;
end

function NoxInformationBar_GetTotalBagSlots(format)
   local total = 0;
   local bag = 0;
   for bag = 0, 4 do
      total = total + GetContainerNumSlots(bag);
   end
   return total;
end

function NoxInformationBar_GetXPToLevelPercentage(format)
    if (not(UnitXPMax("player") > 0)) then 
       return NOX_IB.Messages.NotAvailable; 
    end
    
    return NoxInformationBar_FormatNumber((UnitXPMax("player") - UnitXP("player")) * 100 / UnitXPMax("player"), format, NOX_IB.Format.Decimal);
end

function NoxInformationBar_GetRestedBonus(format)
   return (GetXPExhaustion() or 0);
end

function NoxInformationBar_GetRestedLimit(format)
    local rest = GetXPExhaustion() or 0;
    if (rest > 0) then
       return rest + UnitXP("player");
    else
       return 0;
    end
end

function NoxInformationBar_GetItemCount(format)
   if (Nox.Global.Inventory[format]) then
      return Nox.Global.Inventory[format];
   else
      Nox.Global.Inventory[format] = 0;
      return 0;
   end
end

function NoxInformationBar_UpdateInventory()
   for k,v in pairs(Nox.Global.Inventory) do
      Nox.Global.Inventory[k] = 0;
   end
   for bag = 0, 4 do
      for slot = 1, GetContainerNumSlots(bag) do
         if (GetContainerItemInfo(bag, slot)) then
            local link = GetContainerItemLink(bag, slot);
            local name = GetItemInfo(link);
            if (name and not Nox.Global.Inventory[name]) then
               Nox.Global.Inventory[name] = 0;
            end
            local _, count = GetContainerItemInfo(bag, slot);
            if (count and name and Nox.Global.Inventory[name]) then
               Nox.Global.Inventory[name] = Nox.Global.Inventory[name] + count;
            end
         end
      end
   end
end

function NoxInformationBar_GetTotalTimePlayed(format)
   return NoxInformationBar_FormatTime(Nox.Global.TotalTimePlayed, format);
end

function NoxInformationBar_GetLevelTimePlayed(format)
   return NoxInformationBar_FormatTime(Nox.Global.LevelTimePlayed, format);
end

function NoxInformationBar_GetSessionTimePlayed(format)
   return NoxInformationBar_FormatTime(Nox.Global.SessionTimePlayed, format);
end

function NoxInformationBar_GetSessionTimeToLevel(format)
   if (Nox.Global.LevelMax) then
      return NOX_IB.Messages.NotAvailable;
   elseif (SessionTimeToLevelIsValid()) then
      return NoxInformationBar_FormatTime(SessionTimeToLevel(), format);
   else
      return NOX_IB.Clock.Infinite;
   end
end

function NoxInformationBar_GetLevelTimeToLevel(format)
   if (Nox.Global.LevelMax) then
      return NOX_IB.Messages.NotAvailable;
   elseif (LevelTimeToLevelIsValid()) then
      return NoxInformationBar_FormatTime(LevelTimeToLevel(), format);
   else
      return NOX_IB.Clock.Infinite;
   end
end

function NoxInformationBar_GetBestTimeToLevel(format)
   if (Nox.Global.LevelMax) then
      return NOX_IB.Messages.NotAvailable;
   elseif (LevelTimeToLevelIsValid() and SessionTimeToLevelIsValid()) then
      return NoxInformationBar_FormatTime(min(LevelTimeToLevel(), SessionTimeToLevel()), format);
   elseif (SessionTimeToLevelIsValid()) then
      return NoxInformationBar_FormatTime(SessionTimeToLevel(), format);
   elseif (LevelTimeToLevelIsValid()) then
      return NoxInformationBar_FormatTime(LevelTimeToLevel(), format);
   else
      return NOX_IB.Clock.Infinite;
   end
end

function NoxInformationBar_GetSessionXPRate(format)
   if (Nox.Global.LevelMax) then
      return 0;
   elseif (Nox.Global.SessionTimePlayed > 0) then
      return NoxInformationBar_FormatNumber(Nox.Global.SessionXP / Nox.Global.SessionTimePlayed * 3600, format, NOX_IB.Format.Decimal);
   else
      return NOX_IB.Messages.NotAvailable;
   end
end

function NoxInformationBar_GetLevelXPRate(format)
   if (Nox.Global.LevelMax) then
      return 0;
   elseif (Nox.Global.LevelTimePlayed > 0) then
      return NoxInformationBar_FormatNumber(UnitXP("player") / Nox.Global.LevelTimePlayed * 3600, format, NOX_IB.Format.Decimal);
   else
      return NOX_IB.Messages.NotAvailable;
   end
end

function NoxInformationBar_GetMoney(format, arg1, arg2)
   return NoxInformationBar_FormatMoney(GetMoney(), format, arg1, arg2);
end

function NoxInformationBar_GetMoneyEarned(format, arg1, arg2)
   return NoxInformationBar_FormatMoney(Nox.Global.Income, format, arg1, arg2);
end

function NoxInformationBar_GetMoneySpent(format, arg1, arg2)
   return NoxInformationBar_FormatMoney(Nox.Global.Expense, format, arg1, arg2);
end

function NoxInformationBar_GetNetIncome(format, arg1, arg2)
   return NoxInformationBar_FormatMoney(Nox.Global.Income - Nox.Global.Expense, format, arg1, arg2);
end

function NoxInformationBar_GetIncomeRate(format, arg1, arg2)
   if (Nox.Global.SessionTimePlayed > 0) then
      return NoxInformationBar_FormatMoney(Nox.Global.Income / Nox.Global.SessionTimePlayed * 3600, format, arg1, arg2);
   else
      return NOX_IB.Messages.NotAvailable;
   end
end

function NoxInformationBar_GetExpenseRate(format, arg1, arg2)
   if (Nox.Global.SessionTimePlayed > 0) then
      return NoxInformationBar_FormatMoney(Nox.Global.Expense / Nox.Global.SessionTimePlayed * 3600, format, arg1, arg2);
   else
      return NOX_IB.Messages.NotAvailable;
   end
end

function NoxInformationBar_GetNetIncomeRate(format, arg1, arg2)
   if (Nox.Global.SessionTimePlayed > 0) then
      return NoxInformationBar_FormatMoney((Nox.Global.Income - Nox.Global.Expense) / Nox.Global.SessionTimePlayed * 3600, format, arg1, arg2);
   else
      return NOX_IB.Messages.NotAvailable;
   end
end

function NoxInformationBar_GetFactionReputation(name)
   if (Nox.Global.Factions[name]) then
      return Nox.Global.Factions[name].rep;
   else
      return NOX_IB.Messages.NotAvailable;
   end
end

function NoxInformationBar_GetFactionStanding(name)
   if (Nox.Global.Factions[name]) then
      return Nox.Global.Factions[name].standing;
   else
      return NOX_IB.Messages.NotAvailable;
   end
end

function NoxInformationBar_GetFactionReputationPct(name, format)
   if (Nox.Global.Factions[name]) then
      return NoxInformationBar_FormatNumber(Nox.Global.Factions[name].rep / Nox.Global.Factions[name].max * 100, format, NOX_IB.Format.Integer);
   else
      return NOX_IB.Messages.NotAvailable;
   end
end

function NoxInformationBar_GetFactionReputationMax(name)
   if (Nox.Global.Factions[name]) then
      return Nox.Global.Factions[name].max;
   else
      return NOX_IB.Messages.NotAvailable;
   end
end

function NoxInformationBar_GetFactionName(name)
   if (Nox.Global.Factions[name]) then
      return Nox.Global.Factions[name].name;
   else
      return NOX_IB.Messages.NotAvailable;
   end
end

function NoxInformationBar_GetFactionAtWar(name, arg1, arg2)
   if (Nox.Global.Factions[name]) then
      return NoxInformationBar_FormatBoolean(Nox.Global.Factions[name].atWar, arg1, arg2);
   else
      return NOX_IB.Messages.NotAvailable;
   end
end

function NoxInformationBar_UpdateFactions()
   for index = 1, GetNumFactions(), 1 do
      local name, desc, standingId, bottomValue, topValue, earnedValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, isWatched = GetFactionInfo(index);
      if (not isHeader) then
         local faction = Nox.Global.Factions[name];
         if (not faction) then
            faction = {};
            Nox.Global.Factions[name] = faction;
         end
         faction.name = name;
         faction.min = 0;
         faction.max = topValue - bottomValue;
         faction.rep = earnedValue - bottomValue;
         faction.atWar = atWarWith;
         faction.standing = GetText("FACTION_STANDING_LABEL"..standingId, UnitSex("player"));
      end
   end
end
