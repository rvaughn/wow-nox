---------------------------------------------------------------------------
-- Nox Information Bar
--
-- This is a reusable popup menu that can be used independently of the
-- Nox Information Bar.
---------------------------------------------------------------------------

---------------------------------------------------------------------------
-- Global Variables
---------------------------------------------------------------------------

NoxPopupMenu = {
   anchorFrame   = "MOUSE"; -- "MOUSE" or name of frame
   anchorPoint   = "TOPRIGHT";
   relativePoint = nil;
   anchorOffsetX = 0;
   anchorOffsetY = 0;
   style         = "MENU";  -- "MENU" or "DIALOG"
};

---------------------------------------------------------------------------
-- Local Variables
---------------------------------------------------------------------------

local MAX_BUTTONS    = 32;

local BORDER_WIDTH   = 30;
local BORDER_HEIGHT  = 30;
local BUTTON_HEIGHT  = 16;
local MIN_WIDTH      = 128;

local MENU_SHOW_TIME = 2;

---------------------------------------------------------------------------
-- Event Handlers
---------------------------------------------------------------------------

function NoxPopupMenuFrame_OnLoad(frame)
   NoxPopupMenuFrame_PlaceButtons();
   table.insert(UIMenus, "NoxPopupMenuFrame");
end

function NoxPopupMenuFrame_OnShow(frame)
end

function NoxPopupMenuFrame_OnHide(frame)
   frame.owner = nil;
   frame.showTimer = nil;
   frame.isCounting = nil;
end

function NoxPopupMenuButton_OnClick(button)
   local menu = button:GetParent();
   local id = button:GetID();
   local func = menu.owner.items[id].func;
   local object = menu.owner.items[id].object;
   menu:Hide();
   if (func) then
      func(object);
   end
end

function NoxPopupMenuFrame_OnUpdate(frame, elapsed)
   if (frame:IsVisible()) then
      if (not frame.showTimer or not frame.isCounting) then
         return;
      elseif (frame.showTimer < 0) then
         frame:Hide();
      else
         frame.showTimer = frame.showTimer - elapsed;
      end
   end
end

function NoxPopupMenuFrame_StartCounting(frame)
   frame.showTimer = MENU_SHOW_TIME;
   frame.isCounting = true;
end

function NoxPopupMenuFrame_StopCounting(frame)
   frame.isCounting = nil;
end

---------------------------------------------------------------------------
-- Utility functions and setup
---------------------------------------------------------------------------

function NoxPopupMenuFrame_PlaceButtons()
   _G["NoxPopupMenuButton1"]:SetPoint("TOPLEFT", "NoxPopupMenuFrame", "TOPLEFT", BORDER_WIDTH / 2, -BORDER_HEIGHT / 2);
   for i = 2, MAX_BUTTONS do
      _G["NoxPopupMenuButton" .. i]:SetPoint("TOP", "NoxPopupMenuButton" .. (i-1), "BOTTOM", 0, 0);
   end
end

function NoxPopupMenu:BuildMenu()
   self:SetStyle();
   self:PopulateButtons();
   self:SizeMenu();
end

function NoxPopupMenu:SetStyle()
   if (self.style == "MENU") then
      NoxPopupMenuFrameDialogBackdrop:Hide();
      NoxPopupMenuFrameMenuBackdrop:Show();
   else
      NoxPopupMenuFrameDialogBackdrop:Show();
      NoxPopupMenuFrameMenuBackdrop:Hide();
   end
end

function NoxPopupMenu:PopulateButtons()
   for i = 1, self.numItems do
      local button = _G["NoxPopupMenuButton" .. i];
      button:SetText(self.items[i].name);
      button:Show();
   end
   for i = self.numItems + 1, MAX_BUTTONS do
      local button = _G["NoxPopupMenuButton" .. i];
      button:Hide();
   end
end

function NoxPopupMenu:SizeMenu()
   local width = self:GetMaxItemWidth();
   NoxPopupMenuFrame:SetHeight((self.numItems * BUTTON_HEIGHT) + BORDER_HEIGHT);
   NoxPopupMenuFrame:SetWidth(width + BORDER_WIDTH);
   for i = 1, self.numItems do
      button = _G["NoxPopupMenuButton" .. i]
      button:SetWidth(width);
   end
end

function NoxPopupMenu:GetMaxItemWidth()
   local width = MIN_WIDTH;
   for i = 1, self.numItems do
      button = _G["NoxPopupMenuButton" .. i];
      width = max(width, button:GetTextWidth() + BORDER_WIDTH);
   end
   return width;
end

---------------------------------------------------------------------------
-- Client-callable functions
---------------------------------------------------------------------------
--
-- Call "new" like this to override any of the defaults, or to add new fields:
--   NoxPopupMenu:new{field=value [, field=value]...}
-- where "field" is any of the predefined fields (see the top of this file)
-- or a new field name.
-- use a standard call to create a default object like this:
--   NoxPopupMenu:new()
--
function NoxPopupMenu:new(o)
   o = o or {};

   o.items = {};

   setmetatable(o, self);
   self.__index = self;
   return o;
end

function NoxPopupMenu:AddSeparator()
   return self:AddButton{ ["name"]="" };
end
   
function NoxPopupMenu:AddItem(name, func, object, pos)
   return self:AddButton{ ["name"]=name, ["func"]=func, ["object"]=object, ["pos"]=pos };
end

function NoxPopupMenu:AddButton(button)
   if (table.getn(self.items) >= MAX_BUTTONS) then
      DEFAULT_CHAT_FRAME:AddMessage(NOX_ERROR_TOO_MANY_BUTTONS);
      return nil;
   end
   local pos = button.pos or table.getn(self.items) + 1;
   table.insert(self.items, pos, button)
   self.numItems = table.getn(self.items);
   return button;
end

local ShiftUp = 
{
   TOPLEFT     = "BOTTOMLEFT",
   TOP         = "BOTTOM",
   TOPRIGHT    = "BOTTOMRIGHT",
   LEFT        = "BOTTOMLEFT",
   CENTER      = "BOTTOM",
   RIGHT       = "BOTTOMRIGHT",
   BOTTOMLEFT  = "BOTTOMLEFT",
   BOTTOM      = "BOTTOM",
   BOTTOMRIGHT = "BOTTOMRIGHT"
};

local ShiftDown = 
{
   TOPLEFT     = "TOPLEFT",
   TOP         = "TOP",
   TOPRIGHT    = "TOPRIGHT",
   LEFT        = "TOPLEFT",
   CENTER      = "TOP",
   RIGHT       = "TOPRIGHT",
   BOTTOMLEFT  = "TOPLEFT",
   BOTTOM      = "TOP",
   BOTTOMRIGHT = "TOPRIGHT"
};

local ShiftLeft =
{
   TOPLEFT      = "TOPRIGHT",
   TOP          = "TOPRIGHT",
   TOPRIGHT     = "TOPRIGHT",
   LEFT         = "RIGHT",
   CENTER       = "RIGHT",
   RIGHT        = "RIGHT",
   BOTTOMLEFT   = "BOTTOMRIGHT",
   BOTTOM       = "BOTTOMRIGHT",
   BOTTOMRIGHT  = "BOTTOMTIGHT"
}

local ShiftRight =
{
   TOPLEFT      = "TOPLEFT",
   TOP          = "TOPLEFT",
   TOPRIGHT     = "TOPLEFT",
   LEFT         = "LEFT",
   CENTER       = "LEFT",
   RIGHT        = "LEFT",
   BOTTOMLEFT   = "BOTTOMLEFT",
   BOTTOM       = "BOTTOMLEFT",
   BOTTOMRIGHT  = "BOTTOMRIGHT"
}

function NoxPopupMenu:Show()
   if (NoxPopupMenuFrame:IsVisible() and NoxPopupMenuFrame.owner ~= self) then
      NoxPopupMenuFrame:Hide();
   end
   
   NoxPopupMenuFrame.owner = self;
   self:BuildMenu();

   local anchorPoint;
   local anchorFrame;
   local relativePoint;
   local offsetX;
   local offsetY;

   if (self.anchorFrame == "MOUSE") then
      local mouseX, mouseY = GetCursorPosition(UIParent);
      anchorPoint = string.upper(self.anchorPoint);
      anchorFrame = "UIParent";
      relativePoint = "BOTTOMLEFT";
      offsetX = mouseX + self.anchorOffsetX;
      offsetY = mouseY + self.anchorOffsetY;
   else
      anchorPoint = string.upper(self.anchorPoint);
      anchorFrame = self.anchorFrame;
      relativePoint = self.relativePoint;
      offsetX = self.anchorOffsetX;
      offsetY = self.anchorOffsetY;
   end

   offsetX = offsetX / UIParent:GetScale();
   offsetY = offsetY / UIParent:GetScale();

   NoxPopupMenuFrame:ClearAllPoints();
   NoxPopupMenuFrame:SetPoint(anchorPoint, anchorFrame, relativePoint, offsetX, offsetY);

   local offscreen = false;
   if (NoxPopupMenuFrame:GetBottom() < UIParent:GetBottom()) then
      offscreen = true;
      anchorPoint = ShiftUp[anchorPoint];
   elseif (NoxPopupMenuFrame:GetTop() > UIParent:GetTop()) then
      offscreen = true;
      anchorPoint = ShiftDown[anchorPoint];
   end
   if (NoxPopupMenuFrame:GetLeft() < UIParent:GetLeft()) then
      offscreen = true;
      anchorPoint = ShiftRight[anchorPoint];
   elseif (NoxPopupMenuFrame:GetRight() > UIParent:GetRight()) then
      offscreen = true;
      anchorPoint = ShiftLeft[anchorPoint];
   end

   if (offscreen) then
      NoxPopupMenuFrame:ClearAllPoints();
      NoxPopupMenuFrame:SetPoint(anchorPoint, anchorFrame, relativePoint, offsetX, offsetY);
   end

   NoxPopupMenuFrame:Show();
end

function NoxPopupMenu:Hide()
   if (NoxPopupMenuFrame.owner == self) then
      NoxPopupMenuFrame:Hide();
   end
end

function NoxPopupMenu:IsVisible()
   return NoxPopupMenuFrame:IsVisible() and NoxPopupMenuFrame.owner == self;
end
