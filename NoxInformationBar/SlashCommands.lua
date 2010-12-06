---------------------------------------------------------------------------
-- Nox Information Bar
---------------------------------------------------------------------------

---------------------------------------------------------------------------
-- Readability Variables
---------------------------------------------------------------------------

local REQUIRED         = true;
local OPTIONAL         = false;
local STRICT           = true;
local NON_STRICT       = false;
local NO_DEFAULT       = nil;
local NO_TYPES         = nil;
local NO_BOUNDS        = nil;

local STATE_VALUES     = { "on", "off", "ON", "OFF", "On", "Off" };
local POSITIONS_VALUES = 
{ 
   "left", "topleft", "top", "topright", "right", "bottomright", "bottom", "bottomleft",
   "Left", "TopLeft", "Top", "TopRight", "Right", "BottomRight", "Bottom", "BottomLeft",
   "LEFT", "TOPLEFT", "TOP", "TOPRIGHT", "RIGHT", "BOTTOMRIGHT", "BOTTOM", "BOTTOMLEFT"
};

---------------------------------------------------------------------------
-- Slash Command Registration
---------------------------------------------------------------------------

function NoxInformationBar_RegisterSlashCommands(CommandParser)

   ----------------------------------------------------------------
   -- Visibility
   ----------------------------------------------------------------
   
   CommandParser:RegisterCommand(NOX_IB.Commands.Toggle,  
                                 NoxInformationBar_ToggleCommand,  
                                 "main", 
                                 NOX_IB.SlashCommand .. " " .. NOX_IB.Commands.Toggle  .. " " .. NOX_IB.Usage.Toggle);
   CommandParser:AddParameter(NOX_IB.Commands.Toggle,  
                              NOX_IB.Parameters.Slot, 
                              OPTIONAL, 
                              STRICT, 
                              { "number", "table" }, 
                              { lowerbound = 0, upperbound = NoxInformationBar_MaxSlots }, 
                              0);
   
   CommandParser:RegisterCommand(NOX_IB.Commands.Show,
                                 NoxInformationBar_ShowCommand,
                                 "main",
                                 NOX_IB.SlashCommand .. " " .. NOX_IB.Commands.Show    .. " " .. NOX_IB.Usage.Show);
   CommandParser:AddParameter(NOX_IB.Commands.Show,
                              NOX_IB.Parameters.Slot,
                              OPTIONAL,
                              STRICT,
                              { "number", "table" },
                              { lowerbound = 0, upperbound = NoxInformationBar_MaxSlots },
                              0);
   
   CommandParser:RegisterCommand(NOX_IB.Commands.Hide,
                                 NoxInformationBar_HideCommand,
                                 "main",
                                 NOX_IB.SlashCommand .. " " .. NOX_IB.Commands.Hide    .. " " .. NOX_IB.Usage.Hide);
   CommandParser:AddParameter(NOX_IB.Commands.Hide,
                              NOX_IB.Parameters.Slot,
                              OPTIONAL,
                              STRICT,
                              { "number", "table" },
                              { lowerbound = 0, upperbound = NoxInformationBar_MaxSlots },
                              0);
   
   ----------------------------------------------------------------
   -- Locking
   ----------------------------------------------------------------
   
   CommandParser:RegisterCommand(NOX_IB.Commands.Lock,
                                 NoxInformationBar_LockCommand,
                                 "main",
                                 NOX_IB.SlashCommand .. " " .. NOX_IB.Commands.Lock    .. " " .. NOX_IB.Usage.Lock);
   CommandParser:RegisterCommand(NOX_IB.Commands.Unlock,
                                 NoxInformationBar_UnlockCommand,
                                 "main",
                                 NOX_IB.SlashCommand .. " " .. NOX_IB.Commands.Unlock  .. " " .. NOX_IB.Usage.Unlock);
   
   ----------------------------------------------------------------
   -- Slots
   ----------------------------------------------------------------
   
   CommandParser:RegisterCommand(NOX_IB.Commands.Resize,
                                 NoxInformationBar_ResizeCommand,
                                 "main",
                                 NOX_IB.SlashCommand .. " " .. NOX_IB.Commands.Resize  .. " " .. NOX_IB.Usage.Resize);
   CommandParser:AddParameter(NOX_IB.Commands.Resize,
                              NOX_IB.Parameters.Slot,
                              REQUIRED,
                              STRICT,
                              { "number", "table" },
                              { lowerbound = 1, upperbound = NoxInformationBar_MaxSlots },
                              NO_DEFAULT);
   CommandParser:AddParameter(NOX_IB.Commands.Resize,
                              NOX_IB.Parameters.Width,
                              REQUIRED,
                              STRICT,
                              { "number" },
                              { lowerbound = 0, upperbound = 1000 },
                              75);
   
   CommandParser:RegisterCommand(NOX_IB.Commands.Remap,
                                 NoxInformationBar_RemapCommand,
                                 "main",
                                 NOX_IB.SlashCommand .. " " .. NOX_IB.Commands.Remap   .. " " .. NOX_IB.Usage.Remap);
   CommandParser:AddParameter(NOX_IB.Commands.Remap,
                              NOX_IB.Parameters.Slot,
                              REQUIRED,
                              STRICT,
                              { "number", "table" },
                              { lowerbound = 1, upperbound = NoxInformationBar_MaxSlots },
                              NO_DEFAULT);
   CommandParser:AddParameter(NOX_IB.Commands.Remap,
                              NOX_IB.Parameters.Display,
                              REQUIRED,
                              STRICT,
                              { "string" },
                              NO_BOUNDS,
                              NO_DEFAULT);
   
   ----------------------------------------------------------------
   -- Tooltip
   ----------------------------------------------------------------
   
   CommandParser:RegisterCommand(NOX_IB.Commands.Tooltip,
                                 NoxInformationBar_TooltipCommand,
                                 "main",
                                 NOX_IB.SlashCommand .. " " .. NOX_IB.Commands.Tooltip .. " " .. NOX_IB.Usage.Tooltip);
   CommandParser:AddParameter(NOX_IB.Commands.Tooltip,
                              NOX_IB.Parameters.State,
                              OPTIONAL,
                              STRICT,
                              { "string" },
                              STATE_VALUES,
                              "on");
   CommandParser:AddParameter(NOX_IB.Commands.Tooltip,
                              NOX_IB.Parameters.Position,
                              OPTIONAL,
                              STRICT,
                              { "string" },
                              POSITIONS_VALUES,
                              "top");
   CommandParser:AddParameter(NOX_IB.Commands.Tooltip,
                              NOX_IB.Parameters.X,
                              OPTIONAL,
                              STRICT,
                              { "number" },
                              NO_BOUNDS,
                              0);
   CommandParser:AddParameter(NOX_IB.Commands.Tooltip,
                              NOX_IB.Parameters.Y,
                              OPTIONAL,
                              STRICT,
                              { "number" },
                              NO_BOUNDS,
                              -32);
   
   ----------------------------------------------------------------
   -- Clock
   ----------------------------------------------------------------
   
   CommandParser:RegisterCommand(NOX_IB.Commands.Clock,
                                 NoxInformationBar_ClockCommand,
                                 "main",
                                 NOX_IB.SlashCommand .. " " .. NOX_IB.Commands.Clock   .. " " .. NOX_IB.Usage.Clock);
   CommandParser:AddParameter(NOX_IB.Commands.Clock,
                              NOX_IB.Parameters.OffsetHour,
                              OPTIONAL,
                              STRICT,
                              { "number" },
                              { lowerbound = -25, upperbound = 25 },
                              1);
   CommandParser:AddParameter(NOX_IB.Commands.Clock,
                              NOX_IB.Parameters.OffsetMinute,
                              OPTIONAL,
                              STRICT,
                              { "number" },
                              { lowerbound = -59, upperbound = 59 },
                              0);
   
   ----------------------------------------------------------------
   -- Help
   ----------------------------------------------------------------
   
   CommandParser:RegisterCommand(NOX_IB.Commands.Reset,
                                 NoxInformationBar_ResetCommand,
                                 "main",
                                 NOX_IB.SlashCommand .. " " .. NOX_IB.Commands.Reset   .. " " .. NOX_IB.Usage.Reset);
   CommandParser:RegisterCommand(NOX_IB.Commands.Help,
                                 NoxInformationBar_HelpCommand,
                                 "main",
                                 NOX_IB.SlashCommand .. " " .. NOX_IB.Commands.Help    .. " " .. NOX_IB.Usage.Help);
   
end

---------------------------------------------------------------------------
-- Slash Command Handlers - Visibility
---------------------------------------------------------------------------

function NoxInformationBar_ToggleCommand(msg)
    local args = NoxInformationBarCommand:GetParameters(msg);
    
    if NoxInformationBarCommand:ValidateParameters(NOX_IB.Commands.Toggle, args) then
        local slots = NoxInformationBarCommand:GetValueList(args[string.lower(NOX_IB.Parameters.Slot)]);
        
        local index;
        for index = 1, slots.n do
        
            -- Toggle information bar
            if (slots[index] == 0) then
            
                if (Nox.Player.Visible) then
                    Nox.Player.Visible = false;
                    NoxInformationBarFrame:Hide();
                else
                    Nox.Player.Visible = true;
                    NoxInformationBarFrame:Show();
                end
                
            -- Toggle slot
            else
            
                if (Nox.Player.Slot[slots[index]].Visible) then
                    NoxInformationBar_HideSlot(slots[index]);
                else
                    NoxInformationBar_ShowSlot(slots[index]);
                end
                
                NoxInformationBar_RefreshFrame();

            end
        end
    end
end

function NoxInformationBar_ShowCommand(msg)
    local args = NoxInformationBarCommand:GetParameters(msg);
    
    if NoxInformationBarCommand:ValidateParameters(NOX_IB.Commands.Show, args) then
        local slots = NoxInformationBarCommand:GetValueList(args[string.lower(NOX_IB.Parameters.Slot)]);
        
        local index;
        for index = 1, slots.n do
        
            -- Toggle information bar
            if (slots[index] == 0) then
            
                Nox.Player.Visible = true;
                NoxInformationBarFrame:Show();
                
            -- Toggle slot
            else

                --NoxInformationBar_ShowSlot(slots[index]);
                Nox.Player.Slot[ slots[index] ].Visible = true;
                NoxInformationBar_RefreshFrame();
                
            end
            
        end
    end
end

function NoxInformationBar_HideCommand(msg)
    local args = NoxInformationBarCommand:GetParameters(msg);
    
    if NoxInformationBarCommand:ValidateParameters(NOX_IB.Commands.Hide, args) then
        local slots = NoxInformationBarCommand:GetValueList(args[string.lower(NOX_IB.Parameters.Slot)]);
        
        local index;
        for index = 1, slots.n do
        
            -- Toggle information bar
            if (slots[index] == 0) then
            
                Nox.Player.Visible = false;
                NoxInformationBarFrame:Hide();
                
            -- Toggle slot
            else
            
                --NoxInformationBar_HideSlot(slots[index]);
                Nox.Player.Slot[slots[index]].Visible = false;
                NoxInformationBar_RefreshFrame();
                
            end
            
        end
    end
end

---------------------------------------------------------------------------
-- Slash Command Handlers - Locking / Unlocking
---------------------------------------------------------------------------

function NoxInformationBar_LockCommand(msg)
    Nox.Player.Locked = true;
end

function NoxInformationBar_UnlockCommand(msg)
    Nox.Player.Locked = false;
end

----------------------------------------------------------------
-- Slash Command Handlers - Slots
----------------------------------------------------------------
    
function NoxInformationBar_ResizeCommand(msg)
    local args = NoxInformationBarCommand:GetParameters(msg);
    
    if NoxInformationBarCommand:ValidateParameters(NOX_IB.Commands.Resize, args) then
        local slots = NoxInformationBarCommand:GetValueList(args[string.lower(NOX_IB.Parameters.Slot)]);
        local width = args[string.lower(NOX_IB.Parameters.Width)];
        
        local index;
        for index = 1, slots.n do
            Nox.Player.Slot[slots[index]].Width = width;
        end
        
        NoxInformationBar_RefreshFrame();
    end
end

function NoxInformationBar_RemapCommand(msg)
    local args = NoxInformationBarCommand:GetParameters(msg);
    
    if NoxInformationBarCommand:ValidateParameters(NOX_IB.Commands.Remap, args) then
        local slots   = NoxInformationBarCommand:GetValueList(args[string.lower(NOX_IB.Parameters.Slot)]);
        local display = args[string.lower(NOX_IB.Parameters.Display)];
        
        local index;
        for index = 1, slots.n do
            NoxInformationBar_ClearSlot(slots[index]);
            Nox.Player.Slot[slots[index]].Display = display;
        end
        
        NoxInformationBar_RefreshFrame();
    end
end

----------------------------------------------------------------
-- Slash Command Handlers - Miscellaneous
----------------------------------------------------------------
    
function NoxInformationBar_TooltipCommand(msg)
    local args = NoxInformationBarCommand:GetParameters(msg);
    
    if NoxInformationBarCommand:ValidateParameters(NOX_IB.Commands.Tooltip, args) then
        local state  = args[string.lower(NOX_IB.Parameters.State)];
        local anchor = args[string.lower(NOX_IB.Parameters.Position)];
        local x      = args[string.lower(NOX_IB.Parameters.X)];
        local y      = args[string.lower(NOX_IB.Parameters.Y)];
        
        if (string.lower(state) == "on") then 
            Nox.Player.Tooltip.State = true;
        else
            Nox.Player.Tooltip.State = false;
        end
        Nox.Player.Tooltip.Anchor = anchor;
        Nox.Player.Tooltip.X      = x;
        Nox.Player.Tooltip.Y      = y;
    end
end

function NoxInformationBar_ClockCommand(msg)
    local args = NoxInformationBarCommand:GetParameters(msg);
    
    if NoxInformationBarCommand:ValidateParameters(NOX_IB.Commands.Clock, args) then
        local hours   = args[string.lower(NOX_IB.Parameters.OffsetHour)];
        local minutes = args[string.lower(NOX_IB.Parameters.OffsetMinute)];
        
        Nox.Player.Clock.OffsetHour   = hours;
        Nox.Player.Clock.OffsetMinute = minutes;
    end
end

----------------------------------------------------------------
-- Slash Command Handlers - Help
----------------------------------------------------------------

function NoxInformationBar_HelpCommand(msg)
   NoxInformationBarCommand:DisplayUsage();
end

function NoxInformationBar_ResetCommand(msg)
   NoxInformationBar_ResetCounters();
end

----------------------------------------------------------------
-- Slash Command Handlers - Help
----------------------------------------------------------------

function NoxInformationBarCommand:DisplayUsage(group)
   DEFAULT_CHAT_FRAME:AddMessage(NOX_IB.Messages.GroupHeader);
   SlashCommandParser.DisplayUsage(self, group);
   DEFAULT_CHAT_FRAME:AddMessage(NOX_IB.Messages.GroupFooter);
end
