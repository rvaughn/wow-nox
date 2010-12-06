---------------------------------------------------------------------------
-- Nox Money Extension
--
-- Adds a coin display to the Nox Information Bar, and also serves as
-- an example of how to add complex extensions to the Nox Bar.
--
-- @author Gruma
---------------------------------------------------------------------------

---------------------------------------------------------------------------
-- Variables
---------------------------------------------------------------------------

local MoneyCode    = NOX_ME_PARAM;
local MinimumWidth = 128;

local Original_NoxInformationBar_GetSlotWidth;
local Original_NoxInformationBar_FormatSlot;
local Original_NoxInformationBar_ShowSlot;
local Original_NoxInformationBar_HideSlot;
local Original_NoxInformationBar_InitSlot;
local Original_NoxInformationBar_ClearSlot;

---------------------------------------------------------------------------
-- Extra Money Types for the MoneyFrame
---------------------------------------------------------------------------

MoneyTypeInfo["NOX_STATIC"] = {
   OnloadFunc = function(self)
   end,

   UpdateFunc = function(self)
      return nil;
   end,

   collapse = 1,
};

MoneyTypeInfo["NOX_PLAYER"] = {
   OnloadFunc = function(self)
      self:RegisterEvent("PLAYER_MONEY");
      self:RegisterEvent("PLAYER_TRADE_MONEY");
      self:RegisterEvent("TRADE_MONEY_CHANGED");
      self:RegisterEvent("SEND_MAIL_MONEY_CHANGED");
      self:RegisterEvent("SEND_MAIL_COD_CHANGED");
   end,

   UnloadFunc = function(self)
      self:UnregisterEvent("PLAYER_MONEY");
      self:UnregisterEvent("PLAYER_TRADE_MONEY");
      self:UnregisterEvent("TRADE_MONEY_CHANGED");
      self:UnregisterEvent("SEND_MAIL_MONEY_CHANGED");
      self:UnregisterEvent("SEND_MAIL_COD_CHANGED");
   end,

   UpdateFunc = function(self)
      return (GetMoney() - GetCursorMoney() - GetPlayerTradeMoney());
   end,

   PickupFunc = function(self, amount)
      PickupPlayerMoney(amount);
   end,

   DropFunc = function(self)
      DropCursorMoney();
   end,

   collapse = 1,
   canPickup = 1,
   showSmallerCoins = "Backpack"
};

---------------------------------------------------------------------------
-- Event Handlers
---------------------------------------------------------------------------

function NoxMoneyExtension_OnLoad(frame)
   -- hook all of the functions we need
   Original_NoxInformationBar_GetSlotWidth = NoxInformationBar_GetSlotWidth;
   NoxInformationBar_GetSlotWidth = NoxMoneyExtension_GetSlotWidth;

   Original_NoxInformationBar_FormatSlot = NoxInformationBar_FormatSlot;
   NoxInformationBar_FormatSlot = NoxMoneyExtension_FormatSlot;

   Original_NoxInformationBar_ShowSlot = NoxInformationBar_ShowSlot;
   NoxInformationBar_ShowSlot = NoxMoneyExtension_ShowSlot;

   Original_NoxInformationBar_HideSlot = NoxInformationBar_HideSlot;
   NoxInformationBar_HideSlot = NoxMoneyExtension_HideSlot;

   Original_NoxInformationBar_InitSlot = NoxInformationBar_InitSlot;
   NoxInformationBar_InitSlot = NoxMoneyExtension_InitSlot;

   Original_NoxInformationBar_ClearSlot = NoxInformationBar_ClearSlot;
   NoxInformationBar_ClearSlot = NoxMoneyExtension_ClearSlot;
end

function NoxMoneyFrame_OnEvent(self, event, ...)
   if (self.info and self:IsVisible()) then
      self:Update();
   end
end

function NoxMoneyFrame_OnShow(self)
   MoneyFrame_UpdateMoney(self);
end

function NoxMoneyFrame_OnHide(self)
   if (self.hasPickup == 1) then
      CoinPickupFrame:Hide();
      self.hasPickup = 0;
   end
end

function NoxMoneyFrameButton_OnClick(self, type)
   local parent = self:GetParent();
   OpenCoinPickupFrame(type, parent.info.UpdateFunc(parent), parent);
   NoxMoneyExtension_AlignCoinPickupFrame(parent);
   parent.hasPickup = 1;
end

---------------------------------------------------------------------------
-- Slot rendering functions
---------------------------------------------------------------------------

function NoxMoneyExtension_GetSlotWidth(index)
   local info = Nox.Player.Slot[index];
   local slot = Nox.Slots[index];

   -- we could enforce minimum width like this.
   -- for now, we won't
   --[[
   if (slot.has_money) then
      info.Width = max(MinimumWidth, info.Width);
   end
   ]]

   return Original_NoxInformationBar_GetSlotWidth(index);
end

function NoxMoneyExtension_FormatSlot(index)
   local info = Nox.Player.Slot[index];
   local slot = Nox.Slots[index];

   if (slot.has_money) then
      -- we need to suppress the default display, which is the slot code
      slot:SetText("");
   else
      Original_NoxInformationBar_FormatSlot(index);
   end
end

function NoxMoneyExtension_ShowSlot(index)
   local info = Nox.Player.Slot[index];
   local slot = Nox.Slots[index];

   if (slot.has_money) then
      slot.money_frame:Show();
   end

   Original_NoxInformationBar_ShowSlot(index);
end

function NoxMoneyExtension_HideSlot(index)
   local info = Nox.Player.Slot[index];
   local slot = Nox.Slots[index];

   if (slot.has_money) then
      slot.money_frame:Hide();
   end

   Original_NoxInformationBar_HideSlot(index);
end

function NoxMoneyExtension_InitSlot(index, left, width)
   Original_NoxInformationBar_InitSlot(index, left, width);

   local info = Nox.Player.Slot[index];
   local slot = Nox.Slots[index];

   local code, args = NoxInformationBar_ParseParam(info.Display);
   if (code == MoneyCode) then
      if (not slot.has_money) then
         -- if the slot doesn't have an active money frame, we
         -- need to give it one.  don't reinit if there's one active.
         if (not slot.money_frame) then
            -- create new frame
            slot.money_frame = CreateFrame("Frame", "NoxMoneyFrame"..index, NoxInformationBarTextButton, "NoxMoneyFrameTemplate");
            slot.money_frame.Update = MoneyFrame_UpdateMoney;
         end
         -- call OnLoad explicitly with the real type
         SmallMoneyFrame_OnLoad(slot.money_frame, "NOX_PLAYER");
         slot.money_frame.Unload = slot.money_frame.info.UnloadFunc;

         slot:SetText("");
         slot.has_money = 1;
         MoneyFrame_UpdateMoney(slot.money_frame);
      end
      
      -- always reset font and position
      local font, height, flags = slot:GetFont();
      getglobal("NoxMoneyFrame"..index.."CopperButtonText"):SetFont(font, Nox.Player.FontSize, flags);
      getglobal("NoxMoneyFrame"..index.."SilverButtonText"):SetFont(font, Nox.Player.FontSize, flags);
      getglobal("NoxMoneyFrame"..index.."GoldButtonText"):SetFont(font, Nox.Player.FontSize, flags);

      slot.money_frame:ClearAllPoints();
      slot.money_frame:SetWidth(width);
      slot.money_frame:SetPoint("CENTER", "NoxInformationBarSlot"..index, "CENTER", 0, -1);
   end
end

function NoxMoneyExtension_ClearSlot(index)
   local info = Nox.Player.Slot[index];
   local slot = Nox.Slots[index];

   if (slot.has_money) then
      slot.money_frame:Unload(slot);
      slot.has_money = nil;
   end

   Original_NoxInformationBar_ClearSlot(index);
end

function NoxMoneyExtension_AlignCoinPickupFrame(parent)
   -- if the bar is at the top of the screen, move the coin pickup frame
   -- to show below the bar
   if (CoinPickupFrame:GetTop() > GetScreenHeight()) then
      CoinPickupFrame:SetPoint("BOTTOMRIGHT", parent:GetName(), "TOPRIGHT", 0, -16 - CoinPickupFrame:GetHeight());
   end
end
