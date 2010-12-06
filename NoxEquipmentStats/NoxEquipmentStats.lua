---------------------------------------------------------------------------
-- Nox Equipment Stats
--
-- Makes equipment stats available to the Nox Information Bar
--
-- @author Gruma
---------------------------------------------------------------------------

---------------------------------------------------------------------------
-- Variables
---------------------------------------------------------------------------

local Original_NoxInformationBar_InitFormats;

local DURABILITY_PATTERN = "(%d+) / (%d+)";

NoxEquipmentStats = {
-- slots with durability
   [NOX_ES_SLOT.head]      = { slot="HeadSlot",          name=HEADSLOT },
   [NOX_ES_SLOT.shoulders] = { slot="ShoulderSlot",      name=SHOULDERSLOT },
   [NOX_ES_SLOT.chest]     = { slot="ChestSlot",         name=CHESTSLOT },
   [NOX_ES_SLOT.wrists]    = { slot="WristSlot",         name=WRISTSLOT },
   [NOX_ES_SLOT.hands]     = { slot="HandsSlot",         name=HANDSSLOT },
   [NOX_ES_SLOT.waist]     = { slot="WaistSlot",         name=WAISTSLOT },
   [NOX_ES_SLOT.legs]      = { slot="LegsSlot",          name=LEGSSLOT },
   [NOX_ES_SLOT.feet]      = { slot="FeetSlot",          name=FEETSLOT },
   [NOX_ES_SLOT.mainhand]  = { slot="MainHandSlot",      name=MAINHANDSLOT },
   [NOX_ES_SLOT.offhand]   = { slot="SecondaryHandSlot", name=SECONDARYHANDSLOT },
   [NOX_ES_SLOT.ranged]    = { slot="RangedSlot",        name=RANGEDSLOT },
-- others
   [NOX_ES_SLOT.finger1]   = { slot="Finger0Slot",       name=FINGER0SLOT },
   [NOX_ES_SLOT.finger2]   = { slot="Finger1Slot",       name=FINGER1SLOT },
   [NOX_ES_SLOT.trinket1]  = { slot="Trinket0Slot",      name=TRINKET0SLOT },
   [NOX_ES_SLOT.trinket2]  = { slot="Trinket1Slot",      name=TRINKET1SLOT },
   [NOX_ES_SLOT.neck]      = { slot="NeckSlot",          name=NECKSLOT },
   [NOX_ES_SLOT.back]      = { slot="BackSlot",          name=BACKSLOT },
   [NOX_ES_SLOT.shirt]     = { slot="ShirtSlot",         name=SHIRTSLOT },
   [NOX_ES_SLOT.tabard]    = { slot="TabardSlot",        name=TABARDSLOT },
-- ammo slot is gone?
--   [NOX_ES_SLOT.ammo]      = { slot="AmmoSlot",          name=AMMOSLOT },
};

-- aliases
NoxEquipmentAliases = {
   [NOX_ES_SLOT.shield]      = NoxEquipmentStats.offhand;
   [NOX_ES_SLOT.cloak]       = NoxEquipmentStats.back;
   [NOX_ES_SLOT.ring1]       = NoxEquipmentStats.finger1;
   [NOX_ES_SLOT.ring2]       = NoxEquipmentStats.finger2;
   [NOX_ES_SLOT.necklace]    = NoxEquipmentStats.neck;
   [NOX_ES_SLOT.bracers]     = NoxEquipmentStats.wrists;
   [NOX_ES_SLOT.helm]        = NoxEquipmentStats.head;
   [NOX_ES_SLOT.gloves]      = NoxEquipmentStats.hands;
   [NOX_ES_SLOT.pants]       = NoxEquipmentStats.legs;
   [NOX_ES_SLOT.boots]       = NoxEquipmentStats.feet;
   [NOX_ES_SLOT.pauldrons]   = NoxEquipmentStats.shoulders;
   [NOX_ES_SLOT.weapon]      = NoxEquipmentStats.mainhand;
   [NOX_ES_SLOT.gun]         = NoxEquipmentStats.ranged;
   [NOX_ES_SLOT.bow]         = NoxEquipmentStats.ranged;
   [NOX_ES_SLOT.torso]       = NoxEquipmentStats.chest;
   [NOX_ES_SLOT.pendant]     = NoxEquipmentStats.neck;
   [NOX_ES_SLOT.robe]        = NoxEquipmentStats.chest;
   [NOX_ES_SLOT.skirt]       = NoxEquipmentStats.legs;
   [NOX_ES_SLOT.kilt]        = NoxEquipmentStats.legs;
   [NOX_ES_SLOT.leggings]    = NoxEquipmentStats.legs;
   [NOX_ES_SLOT.belt]        = NoxEquipmentStats.waist;
   [NOX_ES_SLOT.tunic]       = NoxEquipmentStats.chest;
   [NOX_ES_SLOT.hat]         = NoxEquipmentStats.head;
   [NOX_ES_SLOT.goggles]     = NoxEquipmentStats.head;
   [NOX_ES_SLOT.gauntlets]   = NoxEquipmentStats.hands;
   [NOX_ES_SLOT.shoes]       = NoxEquipmentStats.feet;
   [NOX_ES_SLOT.vest]        = NoxEquipmentStats.chest;
   [NOX_ES_SLOT.breastplate] = NoxEquipmentStats.chest;
};

setmetatable(NoxEquipmentAliases, { __index = NoxEquipmentStats });

NoxEquipmentStats_TotalRepairCost = 0;
NoxEquipmentStats_TotalCurrDurability = 0;
NoxEquipmentStats_TotalMaxDurability = 0;

---------------------------------------------------------------------------
-- Initialization
---------------------------------------------------------------------------

function NoxEquipmentStats_OnLoad(self)
   -- hook needed functions
   Original_NoxInformationBar_InitFormats = NoxInformationBar_InitFormats;
   NoxInformationBar_InitFormats = NoxEquipmentStats_InitFormats;

   -- register events we need
   self:RegisterEvent("PLAYER_ENTERING_WORLD");
   self:RegisterEvent("UNIT_INVENTORY_CHANGED");
   self:RegisterEvent("UPDATE_INVENTORY_ALERTS");
   self:RegisterEvent("PLAYER_REGEN_ENABLED");
   self:RegisterEvent("MERCHANT_CLOSED");
   self:RegisterEvent("PLAYER_MONEY");
   -- for later, perhaps
   --self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
end

function NoxEquipmentStats_InitFormats()
   -- set up the base table first
   Original_NoxInformationBar_InitFormats();

   -- add new codes
   NoxInformationBar_AddFormats(
      { code = NOX_ES_PARAM.equipslot,           func = NoxEquipmentStats_GetSlotName },
      { code = NOX_ES_PARAM.equipname,           func = NoxEquipmentStats_GetItemName },
      { code = NOX_ES_PARAM.currdurability,      func = NoxEquipmentStats_GetCurrentDurability },
      { code = NOX_ES_PARAM.maxdurability,       func = NoxEquipmentStats_GetMaxDurability },
      { code = NOX_ES_PARAM.durabilitypct,       func = NoxEquipmentStats_GetDurabilityPercent },
      { code = NOX_ES_PARAM.repaircost,          func = NoxEquipmentStats_GetRepairCost },
      { code = NOX_ES_PARAM.totalrepaircost,     func = NoxEquipmentStats_GetTotalRepairCost },
      { code = NOX_ES_PARAM.totalcurrdurability, func = NoxEquipmentStats_GetTotalCurrentDurability },
      { code = NOX_ES_PARAM.totalmaxdurability,  func = NoxEquipmentStats_GetTotalMaxDurability },
      { code = NOX_ES_PARAM.totaldurabilitypct,  func = NoxEquipmentStats_GetTotalDurabilityPercent }
   );
end

---------------------------------------------------------------------------
-- Event Handlers
---------------------------------------------------------------------------

function NoxEquipmentStats_OnEvent(self, event, arg1, arg2)
   if (event == "UNIT_INVENTORY_CHANGED" and arg1 == "player") then
      NoxEquipmentStats_Update();
   elseif (event == "UPDATE_INVENTORY_ALERTS") then
      NoxEquipmentStats_Update();
   elseif (event == "PLAYER_ENTERING_WORLD") then
      NoxEquipmentStats_Update();
   elseif (event == "PLAYER_REGEN_ENABLED") then
      NoxEquipmentStats_Update();
   elseif (event == "MERCHANT_CLOSED") then
      NoxEquipmentStats_Update();
   elseif (event == "PLAYER_MONEY" and CanMerchantRepair()) then
      NoxEquipmentStats_Update();
   elseif (event == "COMBAT_LOG_EVENT_UNFILTERED") then
      -- DURABILITY_DAMAGE doesn't seem to fire right now, so we leave it out
      if ((string.sub(arg2, -17) == "DURABILITY_DAMAGE" or string.sub(arg2, -21) == "DURABILITY_DAMAGE_ALL")) then
         NoxEquipmentStats_Update();
      end
   end
end

-- technique adapted from TitanDurability
function NoxEquipmentStats_Update()
   local slotKey, slot, hasItem, hasCooldown, repairCost;
   NoxEquipmentStats_TotalRepairCost = 0;
   NoxEquipmentStats_TotalCurrDurability = 0;
   NoxEquipmentStats_TotalMaxDurability = 0;

   for slotKey, slot in pairs(NoxEquipmentStats) do
      if (not slot.id) then
         slot.id = GetInventorySlotInfo(slot.slot);
      end

      if (slot.id) then
         hasItem, hasCooldown, repairCost = NoxEquipmentTooltip:SetInventoryItem("player", slot.id);

         -- wipe previous values before updating
         slot.currentDurability = nil;
         slot.maxDurability     = nil;
         slot.percentDurability = nil;
         slot.repairCost        = nil;
         slot.hasDurability     = nil;

         if (hasItem) then
         local i, text, durability, durabilityMax;
            
            slot.item = NoxEquipmentTooltipTextLeft1:GetText();
            
            for i = 2, NoxEquipmentTooltip:NumLines() do
               text = getglobal("NoxEquipmentTooltipTextLeft" .. i):GetText();
               _, _, durability, durabilityMax = string.find(text, DURABILITY_PATTERN);
               if (durability) then
                  slot.currentDurability = durability;
                  slot.maxDurability     = durabilityMax;
                  slot.percentDurability = (durability / durabilityMax) * 100;
                  slot.repairCost        = repairCost or 0;
                  slot.hasDurability     = 1;
                  
                  NoxEquipmentStats_TotalRepairCost = NoxEquipmentStats_TotalRepairCost + (repairCost or 0);
                  NoxEquipmentStats_TotalCurrDurability = NoxEquipmentStats_TotalCurrDurability + durability;
                  NoxEquipmentStats_TotalMaxDurability = NoxEquipmentStats_TotalMaxDurability + durabilityMax;
               end
            end
         else
            slot.item              = NOX_IB.Messages.Empty
         end
      end
   end
end

---------------------------------------------------------------------------
-- Data functions
---------------------------------------------------------------------------

function NoxEquipmentStats_GetSlotName(slot)
   local item = NoxEquipmentAliases[slot];
   if (item) then
      return item.name;
   else
      return NOX_IB.Messages.NotAvailable;
   end
end

function NoxEquipmentStats_GetItemName(slot)
   local item = NoxEquipmentAliases[slot];
   if (item) then
      return item.item;
   else
      return NOX_IB.Messages.NotAvailable;
   end
end

function NoxEquipmentStats_GetCurrentDurability(slot)
   local item = NoxEquipmentAliases[slot];
   if (item and item.hasDurability) then
      return item.currentDurability;
   else
      return NOX_IB.Messages.NotAvailable;
   end
end

function NoxEquipmentStats_GetMaxDurability(slot)
   local item = NoxEquipmentAliases[slot];
   if (item and item.hasDurability) then
      return item.maxDurability;
   else
      return NOX_IB.Messages.NotAvailable;
   end
end

function NoxEquipmentStats_GetDurabilityPercent(slot, format)
   local item = NoxEquipmentAliases[slot];
   if (item and item.hasDurability) then
      return NoxInformationBar_FormatNumber(item.percentDurability, format, NOX_IB.Format.Decimal);
   else
      return NOX_IB.Messages.NotAvailable;
   end
end

function NoxEquipmentStats_GetRepairCost(slot, format, arg1, arg2)
   local item = NoxEquipmentAliases[slot];
   if (item and item.hasDurability) then
      return NoxInformationBar_FormatMoney(item.repairCost, format, arg1, arg2);
   else
      return NOX_IB.Messages.NotAvailable;
   end
end

function NoxEquipmentStats_GetTotalRepairCost(format, arg1, arg2)
   return NoxInformationBar_FormatMoney(NoxEquipmentStats_TotalRepairCost, format, arg1, arg2);
end

function NoxEquipmentStats_GetTotalCurrentDurability(format, arg1, arg2)
   return NoxEquipmentStats_TotalCurrDurability;
end

function NoxEquipmentStats_GetTotalMaxDurability(format, arg1, arg2)
   return NoxEquipmentStats_TotalMaxDurability;
end

function NoxEquipmentStats_GetTotalDurabilityPercent(format, arg1, arg2)
   if (NoxEquipmentStats_TotalMaxDurability > 0) then
      return NoxInformationBar_FormatNumber(((NoxEquipmentStats_TotalCurrDurability / NoxEquipmentStats_TotalMaxDurability) * 100), format, NOX_IB.Format.Decimal);
   else
      return NOX_IB.Messages.NotAvailable;
   end
end

