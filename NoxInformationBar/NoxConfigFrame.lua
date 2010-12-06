---------------------------------------------------------------------------
-- Nox Information Bar
--
-- NoxConfigFrame is totally self-contained (except for the localized
-- strings), so if you want to run without it, you can simply remove
-- the NoxConfigFrame.xml line from the NoxInformationBar.toc file.
---------------------------------------------------------------------------

-- create a series of global variables called "NOXCONFIG_NoxConfigFrameSlot<n>" for GUI localization
-- this has to happen immediately, before the XML load, so it must be outside of a function
for i = 1, NoxInformationBar_MaxSlots do
   setglobal("NOXCONFIG_NoxConfigFrameSlot" .. i, NOXCONFIG_NoxConfigFrameSlot .. i);
end

function NoxConfigFrame_OnLoad(frame)
    -- register slash command
    NoxInformationBarCommand:RegisterCommand(NOX_IB.Commands.Config, NoxConfigFrame_ConfigCommand, "main", NOX_IB.SlashCommand .. " " .. NOX_IB.Commands.Config .. " " .. NOX_IB.Usage.Config);

   -- register events
   frame:RegisterEvent("VARIABLES_LOADED");

   -- add self to UI panels list
   UIPanelWindows["NoxConfigFrame"] = {area = "center", pushable = 0};

   -- add self to popup menu
   NoxInformationBarMenu:AddItem(NOX_IB.Menu.Config, NoxConfigFrame_Open);

   -- set up tabs
   PanelTemplates_SetNumTabs(frame, 4);
   PanelTemplates_SetTab(frame, 1);
end

function NoxConfigFrame_OnShow(frame)
   NoxConfigFrame_Update();
end

function NoxConfigFrame_OnHide(frame)
   if (ColorPickerFrame:IsShown()) then
      ColorPickerCancelButton:Click();
   end

   if (MYADDONS_ACTIVE_OPTIONSFRAME == frame) then
      ShowUIPanel(myAddOnsFrame);
   end
end

function NoxConfigFrame_OnEvent(frame, event, ...)
   if (event == "VARIABLES_LOADED") then
      NoxConfigFrame_OnVariablesLoaded();
   end
end

function NoxConfigFrame_OnVariablesLoaded()
   -- hook into myAddOns, if available
   -- the bar will already have added itself, just add the config frame here
   Nox.RegistrationInfo.optionsframe = "NoxConfigFrame";
   -- Add NoxInformationBar to myAddOns addons list
   if (myAddOnsFrame) then
      myAddOnsFrame_Register(Nox.RegistrationInfo);
   end
end

----------------------------------------------------------------
-- Slash Command Handlers
----------------------------------------------------------------
    
function NoxConfigFrame_ConfigCommand(msg)
   NoxConfigFrame_Open();
end

----------------------------------------------------------------
-- Utility functions
----------------------------------------------------------------
    
function NoxConfigFrame_Open()
   ShowUIPanel(NoxConfigFrame);
end

function NoxConfigFrame_Close()
   HideUIPanel(NoxConfigFrame);
end

function NoxConfigFrame_Update()
   NoxConfigFrame_Load(Nox.Player, Nox.Player, Nox.Player.Tooltip.Content, NoxMoverConfig);
end

function NoxConfigFrame_SetDefaults()
   NoxConfigFrame_Load(NoxInformationBarDefaults, NoxInformationBarPlayerDefaults, NoxTooltipDefaults, NoxMoverDefaults);
end

function NoxConfigFrame_Load(config, player, tooltip, movers)
   local slotEnabled, slotWidth, slotDisplay;

   NoxConfigFrameBarVisible:SetChecked(config.Visible);
   NoxConfigFrameBarMovable:SetChecked(not config.Locked);
   NoxConfigFrameShowBorder:SetChecked(config.Border);
   NoxConfigFrameExpBarsEnabled:SetChecked(config.ShowXPBar);
   NoxConfigFrameExpBarColor:SetColor(config.XPBarColor.r, config.XPBarColor.g, config.XPBarColor.b, config.XPBarColor.a);
   NoxConfigFrameRestedBarColor:SetColor(config.RestBarColor.r, config.RestBarColor.g, config.RestBarColor.b, config.RestBarColor.a);
   NoxConfigFrame_SetExpBarButtons();

   NoxConfigFrameTooltipEnabled:SetChecked(config.Tooltip.State);
   NoxConfigFrameTooltipAnchor:SetValue(config.Tooltip.Anchor);
   NoxConfigFrameTooltipX:SetNumber(config.Tooltip.X);
   NoxConfigFrameTooltipY:SetNumber(config.Tooltip.Y);

   NoxConfigFrameClockOffsetHours:SetValue(config.Clock.OffsetHour);
   NoxConfigFrameClockOffsetMins:SetValue(config.Clock.OffsetMinute);

   NoxConfigFrameFontSizeBar:SetValue(config.FontSize);
   NoxConfigFrameFontSizeTooltip:SetValue(config.Tooltip.FontSize);

   for index = 1, NoxInformationBar_MaxSlots do
      slotEnabled = _G["NoxConfigFrameSlot" .. index .. "Enabled"];
      slotWidth   = _G["NoxConfigFrameSlot" .. index .. "Width"];
      slotDisplay = _G["NoxConfigFrameSlot" .. index .. "Display"];

      slotEnabled:SetChecked(config.Slot[index].Visible);
      slotWidth:SetNumber(config.Slot[index].Width);
      slotDisplay:SetText(config.Slot[index].Display);
   end

   local left, right;
   for index = 1, NoxInformationBar_MaxTooltipLines do
      left = _G["NoxConfigTooltip" .. index .. "LeftText"];
      right = _G["NoxConfigTooltip" .. index .. "RightText"];
      if (tooltip[index] and tooltip[index].left) then
         left:SetText(tooltip[index].left);
      else
         left:SetText("");
      end
      if (tooltip[index] and tooltip[index].right) then
         right:SetText(tooltip[index].right);
      else
         right:SetText("");
      end
   end

   NoxConfigFrameOverrideGeneral:SetChecked(rawget(player, "Override") ~= nil);
   NoxConfigFrameOverrideClock:SetChecked(rawget(player, "Clock") ~= nil);
   NoxConfigFrameOverrideSlots:SetChecked(rawget(player, "Slot") ~= nil);
   NoxConfigFrameOverrideTooltip:SetChecked(rawget(player, "Tooltip") ~= nil);

   if (movers) then
      NoxConfigFrameMoveBuffsEnabled:SetChecked(movers.buffs.on);
      NoxConfigFrameMoveBuffsOffsetX:SetNumber(movers.buffs.x);
      NoxConfigFrameMoveBuffsOffsetY:SetNumber(movers.buffs.y);

      NoxConfigFrameMoveBGFlagEnabled:SetChecked(movers.bgflag.on);
      NoxConfigFrameMoveBGFlagOffsetX:SetNumber(movers.bgflag.x);
      NoxConfigFrameMoveBGFlagOffsetY:SetNumber(movers.bgflag.y);

      NoxConfigFrameMovePlayerEnabled:SetChecked(movers.player.on);
      NoxConfigFrameMovePlayerOffsetX:SetNumber(movers.player.x);
      NoxConfigFrameMovePlayerOffsetY:SetNumber(movers.player.y);

      NoxConfigFrameMoveTargetEnabled:SetChecked(movers.target.on);
      NoxConfigFrameMoveTargetOffsetX:SetNumber(movers.target.x);
      NoxConfigFrameMoveTargetOffsetY:SetNumber(movers.target.y);

      NoxConfigFrameMoveMinimapEnabled:SetChecked(movers.minimap.on);
      NoxConfigFrameMoveMinimapOffsetX:SetNumber(movers.minimap.x);
      NoxConfigFrameMoveMinimapOffsetY:SetNumber(movers.minimap.y);
   end
end

function NoxConfigFrame_Save()
   local overrideGeneral = NoxConfigFrameOverrideGeneral:GetChecked();
   local overrideClock   = NoxConfigFrameOverrideClock:GetChecked();
   local overrideSlots   = NoxConfigFrameOverrideSlots:GetChecked();
   local overrideTooltip = NoxConfigFrameOverrideTooltip:GetChecked();

   if (overrideGeneral) then                          
      -- we're overriding
      Nox.Player.Override = 1;
      NoxConfigFrame_SaveGeneral(Nox.Player);
   elseif (rawget(Nox.Player, "Override")) then 
      -- turned off override
      Nox.Player.Override = nil;
      Nox.Player.Visible = nil;
      Nox.Player.Locked = nil;
      Nox.Player.Border = nil;
      Nox.Player.ShowXPBar = nil;
      Nox.Player.XPBarColor = nil;
      Nox.Player.RestBarColor = nil;
      Nox.Player.FontSize = nil;
   else                                               
      -- no override
      NoxConfigFrame_SaveGeneral(Nox.Config);
   end
  
   if (overrideClock) then 
      -- we're overriding
      NoxConfigFrame_SaveClock(Nox.Player);
   elseif (rawget(Nox.Player, "Clock")) then 
      -- turned off override
      Nox.Player.Clock = nil;
   else 
      -- no override
      NoxConfigFrame_SaveClock(Nox.Config);
   end
  
   if (overrideSlots) then 
      -- we're overriding
      NoxConfigFrame_SaveSlots(Nox.Player);
   elseif (rawget(Nox.Player, "Slot")) then    
      -- turned off override
      Nox.Player.Slot = nil;
   else 
      -- no override
      NoxConfigFrame_SaveSlots(Nox.Config);
   end
  
   if (overrideTooltip) then                   
      -- we're overriding
      NoxConfigFrame_SaveTooltip(Nox.Player);
   elseif (rawget(Nox.Player, "Tooltip")) then 
      -- turned off override
      Nox.Player.Tooltip = nil;
   else
      -- no override
      NoxConfigFrame_SaveTooltip(Nox.Config);
   end
  
   NoxConfigFrame_SaveMovers();
end

function NoxConfigFrame_SaveGeneral(config)
   config.Visible   = NoxConfigFrameBarVisible:GetChecked() == 1;
   config.Locked    = NoxConfigFrameBarMovable:GetChecked() ~= 1;
   config.Border    = NoxConfigFrameShowBorder:GetChecked() == 1;
   config.ShowXPBar = NoxConfigFrameExpBarsEnabled:GetChecked() == 1;

   local r, g, b, a;
   r, g, b, a = NoxConfigFrameExpBarColor:GetColor();
   if (not config.XPBarColor) then
      config.XPBarColor = {};
   end
   config.XPBarColor.r = r;
   config.XPBarColor.g = g; 
   config.XPBarColor.b = b; 
   config.XPBarColor.a = a;
   r, g, b, a = NoxConfigFrameRestedBarColor:GetColor();
   if (not config.RestBarColor) then
      config.RestBarColor = {};
   end
   config.RestBarColor.r = r;
   config.RestBarColor.g = g;
   config.RestBarColor.b = b;
   config.RestBarColor.a = a;

   config.FontSize = NoxConfigFrameFontSizeBar:GetValue();
end

function NoxConfigFrame_SaveClock(config)
   if (rawget(config, "Clock") == nil) then
      config.Clock = {};
   end

   config.Clock.OffsetHour   = NoxConfigFrameClockOffsetHours:GetValue();
   config.Clock.OffsetMinute = NoxConfigFrameClockOffsetMins:GetValue();
end

function NoxConfigFrame_SaveSlots(config)
   local slotEnabled, slotWidth, slotDisplay;

   if (rawget(config, "Slot") == nil) then
      config.Slot = {};
   end

   for index = 1, NoxInformationBar_MaxSlots do
      slotEnabled = _G["NoxConfigFrameSlot" .. index .. "Enabled"];
      slotWidth   = _G["NoxConfigFrameSlot" .. index .. "Width"];
      slotDisplay = _G["NoxConfigFrameSlot" .. index .. "Display"];

      if (not config.Slot[index]) then
         config.Slot[index] = {};
      end

      if (config.Slot[index].Display ~= slotDisplay:GetText()) then
         NoxInformationBar_ClearSlot(index);
      end

      config.Slot[index].Visible = slotEnabled:GetChecked() == 1;
      config.Slot[index].Width   = slotWidth:GetNumber();
      config.Slot[index].Display = slotDisplay:GetText();
   end   
end

function NoxConfigFrame_SaveTooltip(config)
   if (rawget(config, "Tooltip") == nil) then
      config.Tooltip = {};
   end
   if (not config.Tooltip.Content) then
      config.Tooltip.Content = {};
   end

   config.Tooltip.State  = NoxConfigFrameTooltipEnabled:GetChecked() == 1;
   config.Tooltip.Anchor = NoxConfigFrameTooltipAnchor:GetValue();
   config.Tooltip.X      = NoxConfigFrameTooltipX:GetNumber();
   config.Tooltip.Y      = NoxConfigFrameTooltipY:GetNumber();
   config.Tooltip.Parent = "UIParent"; -- invariant for now
   config.Tooltip.FontSize = NoxConfigFrameFontSizeTooltip:GetValue();

   local tooltip = config.Tooltip.Content;

   -- store tooltip lines, deleting any with both segments empty
   local left, right, leftText, rightText, line;
   line = 1;
   for index = 1, NoxInformationBar_MaxTooltipLines do
      left = _G["NoxConfigTooltip" .. index .. "LeftText"];
      right = _G["NoxConfigTooltip" .. index .. "RightText"];
      leftText = left:GetText();
      rightText = right:GetText();
      if (leftText ~= "" or rightText ~= "") then
         if (not tooltip[line]) then
            tooltip[line] = {};
         end
         
         tooltip[line].left = leftText;
         tooltip[line].right = rightText;
         
         line = line + 1;
      end
   end

   -- wipe any remaining tooltip lines configured
   for index = line, NoxInformationBar_MaxTooltipLines do
      tooltip[index] = nil;
   end
end

function NoxConfigFrame_SaveMovers()
   if (NoxMoverConfig) then
      NoxMoverConfig.buffs.on   = NoxConfigFrameMoveBuffsEnabled:GetChecked() == 1;
      NoxMoverConfig.buffs.x    = NoxConfigFrameMoveBuffsOffsetX:GetNumber();
      NoxMoverConfig.buffs.y    = NoxConfigFrameMoveBuffsOffsetY:GetNumber();

      NoxMoverConfig.bgflag.on  = NoxConfigFrameMoveBGFlagEnabled:GetChecked() == 1;
      NoxMoverConfig.bgflag.x   = NoxConfigFrameMoveBGFlagOffsetX:GetNumber();
      NoxMoverConfig.bgflag.y   = NoxConfigFrameMoveBGFlagOffsetY:GetNumber();

      NoxMoverConfig.player.on  = NoxConfigFrameMovePlayerEnabled:GetChecked() == 1;
      NoxMoverConfig.player.x   = NoxConfigFrameMovePlayerOffsetX:GetNumber();
      NoxMoverConfig.player.y   = NoxConfigFrameMovePlayerOffsetY:GetNumber();

      NoxMoverConfig.target.on  = NoxConfigFrameMoveTargetEnabled:GetChecked() == 1;
      NoxMoverConfig.target.x   = NoxConfigFrameMoveTargetOffsetX:GetNumber();
      NoxMoverConfig.target.y   = NoxConfigFrameMoveTargetOffsetY:GetNumber();

      NoxMoverConfig.minimap.on = NoxConfigFrameMoveMinimapEnabled:GetChecked() == 1;
      NoxMoverConfig.minimap.x  = NoxConfigFrameMoveMinimapOffsetX:GetNumber();
      NoxMoverConfig.minimap.y  = NoxConfigFrameMoveMinimapOffsetY:GetNumber();
   end
end

-- these are supported, but disabling doesn't match the rest of the GUI
function NoxConfigFrame_SetExpBarButtons()
   if (NoxConfigFrameExpBarsEnabled:GetChecked()) then
      --NoxConfigFrameExpBarColor:Enable();
      --NoxConfigFrameRestedBarColor:Enable();
   else
      --NoxConfigFrameExpBarColor:Disable();
      --NoxConfigFrameRestedBarColor:Disable();
   end
end

-- none of these enables/disables are supported
function NoxConfigFrame_SetTooltipControls()
   if (NoxConfigFrameTooltipEnabled:GetChecked()) then
      --NoxConfigFrameTooltipAnchor:Enable();
      --NoxConfigFrameTooltipOffset:Enable();
      --NoxConfigFrameTooltipX:Enable();
      --NoxConfigFrameTooltipY:Enable();
   else
      --NoxConfigFrameTooltipAnchor:Disable();
      --NoxConfigFrameTooltipOffset:Disable();
      --NoxConfigFrameTooltipX:Disable();
      --NoxConfigFrameTooltipY:Disable();
   end
end

----------------------------------------------------------------
-- Color button functions
----------------------------------------------------------------   

function NoxConfigFrameColorButton_OnLoad(button)
   button.swatchFunc      = NoxConfigFrameColorButton_OnSelectColor;
   button.cancelFunc      = NoxConfigFrameColorButton_OnCancelColor;
   button.opacityFunc     = NoxConfigFrameColorButton_OnSelectOpacity;

   button.SetColor        = NoxConfigFrameColorButton_SetColor;
   button.GetColor        = NoxConfigFrameColorButton_GetColor;
   button.OpenColorPicker = NoxConfigFrameColorButton_OpenColorPicker;
   button.SetBorderColor  = NoxConfigFrameColorButton_SetBorderColor;

   button.OriginalEnable  = button.Enable;
   button.Enable          = NoxConfigFrameColorButton_Enable;
   button.OriginalDisable = button.Disable;
   button.Disable         = NoxConfigFrameColorButton_Disable;

   button:SetColor(1.0, 1.0, 1.0, 1.0);
   button.hasOpacity = true;
end

function NoxConfigFrameColorButton_OnSelectColor()
   local button = ColorPickerFrame.button;
   local red, green, blue = ColorPickerFrame:GetColorRGB();
   local alpha = 1.0 - OpacitySliderFrame:GetValue(); -- the slider is backwards for some reason
   button:SetColor(red, green, blue, alpha);
end

function NoxConfigFrameColorButton_OnCancelColor(previous)
   local button = ColorPickerFrame.button;
   button:SetColor(previous.r, previous.g, previous.b, previous.alpha);
end

function NoxConfigFrameColorButton_OnSelectOpacity()
   local button = ColorPickerFrame.button;
	 local swatch = _G[button:GetName() .. "NormalTexture"];

   button.alpha = 1.0 - OpacitySliderFrame:GetValue(); -- the slider is backwards for some reason
   swatch:SetAlpha(button.alpha);
end

function NoxConfigFrameColorButton_OpenColorPicker(button)
   -- only allow one at a time
   if (ColorPickerFrame:IsVisible()) then
      return;
   end

   ColorPickerFrame.button         = button;
   ColorPickerFrame.func           = button.swatchFunc;
   ColorPickerFrame.cancelFunc     = button.cancelFunc;
   ColorPickerFrame.opacityFunc    = button.opacityFunc;
   ColorPickerFrame.hasOpacity     = button.hasOpacity;
   ColorPickerFrame.opacity        = 1.0 - button.alpha; -- the slider is backwards for some reason
   ColorPickerFrame.previousValues = {r = button.r, g = button.g, b = button.b, alpha = button.alpha};
   ColorPickerFrame:SetColorRGB(button.r, button.g, button.b);

   -- do NOT use ShowUIPanel for this.  ColorPickerFrame is not a full panel and so ShowUIPanel will only
   -- call frame:Show() anyway, but, since we've registered as a center panel, ShowUIPanel blocks 
   -- (probably because of an oversight) ColorPickerFrame from showing up at all.
   --ShowUIPanel(ColorPickerFrame);
   ColorPickerFrame:Show();
end

function NoxConfigFrameColorButton_SetColor(button, red, green, blue, alpha)
	 local swatch = _G[button:GetName() .. "NormalTexture"];

   if (alpha == nil) then
      alpha = 1.0;
   end
	
   swatch:SetVertexColor(red, green, blue);
   swatch:SetAlpha(alpha);
   
   button.r = red;
   button.g = green;
   button.b = blue;
   button.alpha = alpha;
end

function NoxConfigFrameColorButton_GetColor(button)
   return button.r, button.g, button.b, button.alpha;
end

function NoxConfigFrameColorButton_SetBorderColor(button, red, green, blue)
	 local border = _G[button:GetName() .. "SwatchBg"];
	
   border:SetVertexColor(red, green, blue);
end

function NoxConfigFrameColorButton_Enable(button)
	 local swatch = _G[button:GetName() .. "NormalTexture"];

   swatch:SetVertexColor(button.r, button.g, button.b);
   swatch:SetAlpha(button.alpha);

   button:SetBorderColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);

   button:OriginalEnable();
end

function NoxConfigFrameColorButton_Disable(button)
	 local swatch = _G[button:GetName() .. "NormalTexture"];

   swatch:SetVertexColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
   swatch:SetAlpha(1.0);

   button:SetBorderColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
   button:OriginalDisable();
end

----------------------------------------------------------------
-- Check button functions
----------------------------------------------------------------   

function NoxConfigFrameCheckButton_OnClick(button)
   if (button == NoxConfigFrameExpBarsEnabled) then
      NoxConfigFrame_SetExpBarButtons();
   elseif (button == NoxConfigFrameTooltipEnabled) then
      NoxConfigFrame_SetTooltipControls();
   end
end

----------------------------------------------------------------
-- Tooltip editbox functions
----------------------------------------------------------------   

function NoxConfigFrameTooltipEditBox_Next(frame)
   local i, side;
   _, _, i, side = string.find(frame:GetName(), "NoxConfigTooltip(%d+)(%a+)Text");
   i = tonumber(i);
   if (side == "Left") then
      side = "Right";
   else
      side = "Left";
      i = i + 1;
   end
   if (i > NoxInformationBar_MaxTooltipLines) then
      i = 1;
   end

   _G["NoxConfigTooltip" .. i .. side .. "Text"]:SetFocus();
end

function NoxConfigFrameTooltipEditBox_Prev(frame)
   local i, side;
   _, _, i, side = string.find(frame:GetName(), "NoxConfigTooltip(%d+)(%a+)Text");
   i = tonumber(i);
   if (side == "Left") then
      side = "Right";
      i = i - 1;
   else
      side = "Left";
   end
   if (i < 1) then
      i = NoxInformationBar_MaxTooltipLines;
   end

   _G["NoxConfigTooltip" .. i .. side .. "Text"]:SetFocus();
end

function NoxConfigFrame_InsertTooltipLine(frame)
   local found, line;
   local srcleft, srcright, dstleft, dstright;
   if (NoxConfigFrame.tooltipLine) then
      found, _, line = string.find(NoxConfigFrame.tooltipLine:GetName(), "NoxConfigTooltip(%d+)");
      if (found) then
         srcleft = NoxConfigTooltip36LeftText;
         srcright = NoxConfigTooltip36RightText;
         for i = 35, line, -1 do
            dstleft = srcleft;
            dstright = srcright;
            srcleft = _G["NoxConfigTooltip" .. i .. "LeftText"];
            srcright = _G["NoxConfigTooltip" .. i .. "RightText"];
            dstleft:SetText(srcleft:GetText());
            dstright:SetText(srcright:GetText());
         end
         srcleft:SetText("");
         srcright:SetText("");
      end
   end
end

function NoxConfigFrame_DeleteTooltipLine(frame)
   local found, line;
   local srcleft, srcright, dstleft, dstright;
   if (NoxConfigFrame.tooltipLine) then
      found, _, line = string.find(NoxConfigFrame.tooltipLine:GetName(), "NoxConfigTooltip(%d+)");
      if (found) then
         dstleft = _G["NoxConfigTooltip" .. line .. "LeftText"];
         dstright = _G["NoxConfigTooltip" .. line .. "RightText"];
         for i = line+1, 36 do
            srcleft = _G["NoxConfigTooltip" .. i .. "LeftText"];
            srcright = _G["NoxConfigTooltip" .. i .. "RightText"];
            dstleft:SetText(srcleft:GetText());
            dstright:SetText(srcright:GetText());
            dstleft = srcleft;
            dstright = srcright;
         end
         srcleft:SetText("");
         srcright:SetText("");
      end
   end
end

----------------------------------------------------------------
-- Drop-down menu functions
----------------------------------------------------------------   

local ANCHOR_VALUES = { "left", "topleft",  "top", "topright",  "right", "bottomright",  "bottom", "bottomleft",  "center" };
local ANCHOR_TEXT   = { "Left", "Top Left", "Top", "Top Right", "Right", "Bottom Right", "Bottom", "Bottom Left", "Center" };

function NoxConfigFrameTooltipAnchor_OnLoad(frame)
   frame.SetValue = NoxConfigFrameTooltipAnchor_SetValue;
   frame.GetValue = NoxConfigFrameTooltipAnchor_GetValue;
end

function NoxConfigFrameTooltipAnchor_SetValue(frame, text)
   -- initialize the list now.  this will ensure that it's filled, and so can set
   -- the right text in the drop down box.
   UIDropDownMenu_Initialize(frame, NoxConfigFrameTooltipAnchor_Init);
   UIDropDownMenu_SetSelectedValue(frame, text);
end

function NoxConfigFrameTooltipAnchor_GetValue(frame)
   return UIDropDownMenu_GetSelectedValue(frame);
end

function NoxConfigFrameTooltipAnchor_Init(frame)
   local index, value;
   local info = {};
   
   for index, value in ipairs(ANCHOR_TEXT) do
      info.text = value;
      info.value = ANCHOR_VALUES[index];
      info.checked = nil;
      info.func = NoxConfigFrameTooltipAnchor_OnClick;
      UIDropDownMenu_AddButton(info);
   end
end

function NoxConfigFrameTooltipAnchor_OnClick(frame)
   UIDropDownMenu_SetSelectedValue(NoxConfigFrameTooltipAnchor, frame.value);
end

