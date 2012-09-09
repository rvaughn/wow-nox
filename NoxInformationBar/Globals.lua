---------------------------------------------------------------------------
-- Nox Information Bar
---------------------------------------------------------------------------

---------------------------------------------------------------------------
-- Constants
---------------------------------------------------------------------------

NoxInformationBarPlayerLevelMax                    = 85;
NoxInformationBar_MaxSlots                         = 16;
NoxInformationBar_MaxTooltipLines                  = 30;

---------------------------------------------------------------------------
-- Default Settings
---------------------------------------------------------------------------

NoxInformationBarDefaults                          = { };
NoxInformationBarDefaults.ShowXPBar                = true;
NoxInformationBarDefaults.Visible                  = true;
NoxInformationBarDefaults.Locked                   = false;
NoxInformationBarDefaults.Border                   = true;
NoxInformationBarDefaults.FontSize                 = 10;

NoxInformationBarDefaults.Clock                    = { };
NoxInformationBarDefaults.Clock.OffsetHour         = 0;
NoxInformationBarDefaults.Clock.OffsetMinute       = 0;

NoxInformationBarDefaults.Tooltip                  = { };
NoxInformationBarDefaults.Tooltip.State            = true;
NoxInformationBarDefaults.Tooltip.Anchor           = "top";
NoxInformationBarDefaults.Tooltip.X                = 0;
NoxInformationBarDefaults.Tooltip.Y                = -32;
NoxInformationBarDefaults.Tooltip.Parent           = "UIParent";
NoxInformationBarDefaults.Tooltip.FontSize         = 10;

NoxInformationBarDefaults.XPBarColor               = { };
NoxInformationBarDefaults.XPBarColor.r             = 0.58;
NoxInformationBarDefaults.XPBarColor.g             = 0.0;
NoxInformationBarDefaults.XPBarColor.b             = 0.55;
NoxInformationBarDefaults.XPBarColor.a             = 1.0;
NoxInformationBarDefaults.RestBarColor             = { };
NoxInformationBarDefaults.RestBarColor.r           = 0.0;
NoxInformationBarDefaults.RestBarColor.g           = 0.39;
NoxInformationBarDefaults.RestBarColor.b           = 1.0;
NoxInformationBarDefaults.RestBarColor.a           = 1.0;

NoxInformationBarDefaults.Players                  = { };

NoxInformationBarDefaults.Slot                     = { };

NoxInformationBarDefaults.Slot[1]                  = { };
NoxInformationBarDefaults.Slot[1].Visible          = true;
NoxInformationBarDefaults.Slot[1].Width            = 75;
NoxInformationBarDefaults.Slot[1].Display          = "{latency} ms";

NoxInformationBarDefaults.Slot[2]                  = { };
NoxInformationBarDefaults.Slot[2].Visible          = true;
NoxInformationBarDefaults.Slot[2].Width            = 75;
NoxInformationBarDefaults.Slot[2].Display          = "{framerate} fps";

NoxInformationBarDefaults.Slot[3]                  = { };
NoxInformationBarDefaults.Slot[3].Visible          = true;
NoxInformationBarDefaults.Slot[3].Width            = 75;
NoxInformationBarDefaults.Slot[3].Display          = "{24hours}:{minutes}";

NoxInformationBarDefaults.Slot[4]                  = { };
NoxInformationBarDefaults.Slot[4].Visible          = true;
NoxInformationBarDefaults.Slot[4].Width            = 75;
NoxInformationBarDefaults.Slot[4].Display          = "({x}, {y})";

NoxInformationBarPlayerDefaults                    = { };

NoxInformationBarSlotDefaults                      = { };
NoxInformationBarSlotDefaults.Visible              = false;
NoxInformationBarSlotDefaults.Width                = 75;
NoxInformationBarSlotDefaults.Display              = "empty";

NoxTooltipDefaults = {
   { left=NOX_IB.TooltipHeader,       right=""                              },
   { left=" ",                        right=""                              },
   { left=NOX_IB.TooltipPlayTime,     right=NOX_IB.TooltipPlayTimeValue     },
   { left=" ",                        right=""                              },
   { left=NOX_IB.TooltipXPHeader,     right=""                              },
   { left=NOX_IB.TooltipXPNextLevel,  right=NOX_IB.TooltipXPNextLevelValue  },
   { left=NOX_IB.TooltipXPEarned,     right=NOX_IB.TooltipXPEarnedValue     },
   { left=NOX_IB.TooltipXPToGo,       right=NOX_IB.TooltipXPToGoValue       },
   { left=NOX_IB.TooltipXPRested,     right=NOX_IB.TooltipXPRestedValue     },
   { left=NOX_IB.TooltipXPRestedToGo, right=NOX_IB.TooltipXPRestedToGoValue },
   { left=" ",                        right=""                              },
   { left=NOX_IB.TooltipLevelStats,   right=""                              },
   { left=NOX_IB.TooltipLevelTime,    right=NOX_IB.TooltipLevelTimeValue    },
   { left=NOX_IB.TooltipLevelETL,     right=NOX_IB.TooltipLevelETLValue     },
   { left=NOX_IB.TooltipLevelRate,    right=NOX_IB.TooltipLevelRateValue    },
   { left=" ",                        right=""                              },
   { left=NOX_IB.TooltipSessionStats, right=""                              },
   { left=NOX_IB.TooltipSessionTime,  right=NOX_IB.TooltipSessionTimeValue  },
   { left=NOX_IB.TooltipSessionETL,   right=NOX_IB.TooltipSessionETLValue   },
   { left=NOX_IB.TooltipSessionRate,  right=NOX_IB.TooltipSessionRateValue  },
   { left=" ",                        right=""                              },
   { left=NOX_IB.TooltipFooter,       right=""                              },
};

-- do this manually
--NoxInformationBarDefaults.Tooltip.Content = NoxTooltipDefaults;

---------------------------------------------------------------------------
-- Runtime Configuration
---------------------------------------------------------------------------

Nox = {
   Config  = nil;
   Player  = nil;
   Formats = {};
   Slots   = {};
   Global  = {};
   ready = false;
};

-- this is the actual saved variable
NoxInformationBarConfig = nil;

Nox.Global = {
   TotalTimePlayed   = 0;
   LevelTimePlayed   = 0;
   SessionTimePlayed = 0;

   InitialXP         = 0;
   SessionXP         = 0;
   RolloverXP        = 0;
   LevelMax          = false;

   InitialMoney      = 0;
   LastMoney         = 0;
   Income            = 0;
   Expense           = 0;

   LastHealth        = -1;
   HealthRegen       = -1;
   LastMana          = -1;
   ManaRegen         = -1;

   Position          = { x = 0, y = 0 };
   
   Factions          = {};
   Inventory         = {};
};

-- info for myAddOns
Nox.RegistrationInfo = {
   name = NOX_IB.Name,
   description = NOX_IB.Description,
   version = NOX_IB.Version,
   category = MYADDONS_CATEGORY_BARS,
   frame = "NoxInformationBarFrame"
};

---------------------------------------------------------------------------
-- Locals
---------------------------------------------------------------------------

local playerInitialized = false;
local gotPlayer = false;
local gotVariables = false;
local playermeta = {};

---------------------------------------------------------------------------
-- Format-code functions
---------------------------------------------------------------------------

function NoxInformationBar_GetFormats()
   return Nox.Formats;
end

function NoxInformationBar_InitFormats()
   NoxInformationBar_AddFormats(
      -- general replacements
      { code = NOX_IB.Param.latency,           func = NoxInformationBar_GetLatency                   },
      { code = NOX_IB.Param.framerate,         func = NoxInformationBar_GetFramerate                 },
      { code = NOX_IB.Param.hours24,           func = NoxInformationBar_Get24Hours                   },
      { code = NOX_IB.Param.hours,             func = NoxInformationBar_GetHours                     },
      { code = NOX_IB.Param.minutes,           func = NoxInformationBar_GetMinutes                   },
      { code = NOX_IB.Param.ampm,              func = NoxInformationBar_GetAMPM                      },
      { code = NOX_IB.Param.x,                 func = NoxInformationBar_GetLocationX                 },
      { code = NOX_IB.Param.y,                 func = NoxInformationBar_GetLocationY                 },
      { code = NOX_IB.Param.money,             func = NoxInformationBar_GetMoney                     },
      { code = NOX_IB.Param.hpregen,           func = NoxInformationBar_GetHealthRegen               },
      { code = NOX_IB.Param.manaregen,         func = NoxInformationBar_GetManaRegen                 },
      { code = NOX_IB.Param.hp,                func = NoxInformationBar_GetHealth                    },
      { code = NOX_IB.Param.hploss,            func = NoxInformationBar_GetHealthLoss                },
      { code = NOX_IB.Param.hppct,             func = NoxInformationBar_GetHealthPercentage          },
      { code = NOX_IB.Param.maxhp,             func = NoxInformationBar_GetMaxHealth                 },
      { code = NOX_IB.Param.mana,              func = NoxInformationBar_GetMana                      },
      { code = NOX_IB.Param.manaloss,          func = NoxInformationBar_GetManaLoss                  },
      { code = NOX_IB.Param.manapct,           func = NoxInformationBar_GetManaPercentage            },
      { code = NOX_IB.Param.maxmana,           func = NoxInformationBar_GetMaxMana                   },
      { code = NOX_IB.Param.xp,                func = NoxInformationBar_GetXP                        },
      { code = NOX_IB.Param.xptolevel,         func = NoxInformationBar_GetXPToLevel                 },
      { code = NOX_IB.Param.xppct,             func = NoxInformationBar_GetXPPercentage              },
      { code = NOX_IB.Param.xptolevelpct,      func = NoxInformationBar_GetXPToLevelPercentage       },
      { code = NOX_IB.Param.maxxp,             func = NoxInformationBar_GetMaxXP                     },
      { code = NOX_IB.Param.rest,              func = NoxInformationBar_GetRestXP                    },
      { code = NOX_IB.Param.level,             func = NoxInformationBar_GetLevel                     },
      { code = NOX_IB.Param.ubs,               func = NoxInformationBar_GetUsedBagSlots              },
      { code = NOX_IB.Param.abs,               func = NoxInformationBar_GetAvailableBagSlots         },
      { code = NOX_IB.Param.tbs,               func = NoxInformationBar_GetTotalBagSlots             },
      { code = NOX_IB.Param.mem,               func = NoxInformationBar_GetUIMemory,                 },
      { code = NOX_IB.Param.restbonus,         func = NoxInformationBar_GetRestedBonus               },
      { code = NOX_IB.Param.restlimit,         func = NoxInformationBar_GetRestedLimit               },
      { code = NOX_IB.Param.sessionttl,        func = NoxInformationBar_GetSessionTimeToLevel        },
      { code = NOX_IB.Param.levelttl,          func = NoxInformationBar_GetLevelTimeToLevel          },
      { code = NOX_IB.Param.bestttl,           func = NoxInformationBar_GetBestTimeToLevel           },
      { code = NOX_IB.Param.totaltime,         func = NoxInformationBar_GetTotalTimePlayed           },
      { code = NOX_IB.Param.sessiontime,       func = NoxInformationBar_GetSessionTimePlayed         },
      { code = NOX_IB.Param.leveltime,         func = NoxInformationBar_GetLevelTimePlayed           },
      { code = NOX_IB.Param.sessionxprate,     func = NoxInformationBar_GetSessionXPRate             },
      { code = NOX_IB.Param.levelxprate,       func = NoxInformationBar_GetLevelXPRate               },
      { code = NOX_IB.Param.income,            func = NoxInformationBar_GetMoneyEarned               },
      { code = NOX_IB.Param.expense,           func = NoxInformationBar_GetMoneySpent                },
      { code = NOX_IB.Param.netincome,         func = NoxInformationBar_GetNetIncome                 },
      { code = NOX_IB.Param.incomerate,        func = NoxInformationBar_GetIncomeRate                },
      { code = NOX_IB.Param.expenserate,       func = NoxInformationBar_GetExpenseRate               },
      { code = NOX_IB.Param.netincomerate,     func = NoxInformationBar_GetNetIncomeRate             },
      { code = NOX_IB.Param.factionstanding,   func = NoxInformationBar_GetFactionStanding           },
      { code = NOX_IB.Param.factionrep,        func = NoxInformationBar_GetFactionReputation         },
      { code = NOX_IB.Param.factionrepmax,     func = NoxInformationBar_GetFactionReputationMax      },
      { code = NOX_IB.Param.factionreppct,     func = NoxInformationBar_GetFactionReputationPct      },
      { code = NOX_IB.Param.factionatwar,      func = NoxInformationBar_GetFactionAtWar              },
      { code = NOX_IB.Param.factionname,       func = NoxInformationBar_GetFactionName               },
      { code = NOX_IB.Param.itemcount,         func = NoxInformationBar_GetItemCount                 }
   );
   -- deprecated formats
   NoxInformationBar_AddFormats(
      { code = NOX_IB.Param.sessionttlshort,   func = function() return NoxInformationBar_GetSessionTimeToLevel(NOX_IB.Format.Short); end },
      { code = NOX_IB.Param.levelttlshort,     func = function() return NoxInformationBar_GetLevelTimeToLevel(NOX_IB.Format.Short);   end },
      { code = NOX_IB.Param.bestttlshort,      func = function() return NoxInformationBar_GetBestTimeToLevel(NOX_IB.Format.Short);    end },
      { code = NOX_IB.Param.memmb,             func = function() return NoxInformationBar_GetUIMemory(NOX_IB.Format.MB);              end },
      { code = NOX_IB.Param.memkb,             func = function() return NoxInformationBar_GetUIMemory(NOX_IB.Format.KB);              end },
      { code = NOX_IB.Param.memlimitmb,        func = function() return NoxInformationBar_GetUIMemoryLimit(NOX_IB.Format.MB);         end },
      { code = NOX_IB.Param.memlimitkb,        func = function() return NoxInformationBar_GetUIMemoryLimit(NOX_IB.Format.KB);         end },
      { code = NOX_IB.Param.allmoney,          func = function() return NoxInformationBar_GetMoney(NOX_IB.Format.Short);              end },
      { code = NOX_IB.Param.gold,              func = function() return NoxInformationBar_GetMoney(NOX_IB.Format.Gold);               end },
      { code = NOX_IB.Param.silver,            func = function() return NoxInformationBar_GetMoney(NOX_IB.Format.Silver);             end },
      { code = NOX_IB.Param.copper,            func = function() return NoxInformationBar_GetMoney(NOX_IB.Format.Copper);             end }
   );
end

function NoxInformationBar_AddFormats(...)
   for i, v in ipairs{...} do
      Nox.Formats[v.code] = v;
   end
end

function NoxInformationBar_GetIndexedFormat(name)
   local index,format;
   for index, format in pairs(NoxInformationBar_GetFormats()) do
      if (name == format.code) then
         return format;
      end
   end
end

function NoxInformationBar_GetFormat(name)
   return Nox.Formats[name];
end

function NoxInformationBar_InitPlayer()
   if not gotPlayer then
      -- Do nothing if player name is not available
      local playerName = UnitName("player");
      if (playerName == nil or playerName == UNKNOWNOBJECT or playerName == UKNOWNBEING) then
         return;
      end
      gotPlayer = true;
   end
end

function NoxInformationBar_InitVariables()
   if not gotVariables then
      -- fill in any missing fields and init for new users
      NoxInformationBarConfig = NoxInformationBar_DuplicateTable(NoxInformationBarDefaults, NoxInformationBarConfig);
      
      if (not NoxInformationBarConfig.Tooltip.Content) then
         NoxInformationBarConfig.Tooltip.Content = NoxInformationBar_DuplicateTable(NoxTooltipDefaults);
      end

      -- make sure we're referring to the saved table
      Nox.Config = NoxInformationBarConfig;

      -- delete old unused fields
      Nox.Config.HideMainXPBar = nil;
    
      -- alias GUI slots for easy access
      for i = 1, NoxInformationBar_MaxSlots do
         Nox.Slots[i] = _G["NoxInformationBarSlot" .. i];
      end

      gotVariables = true;
   end
end

function NoxInformationBar_UpdateConfig()
   if (gotVariables and gotPlayer and not Nox.ready) then
      -- Do nothing if player name is not available
      local playerName = UnitName("player");
      local realm = GetCVar("realmName");
	
      -- create realm/player if missing, and move from old player location if that one is present
      if (not Nox.Config.Players[realm]) then
         Nox.Config.Players[realm] = { };
      end
      if (not Nox.Config.Players[realm][playerName]) then
         if (Nox.Config.Players[playerName]) then
            Nox.Config.Players[realm][playerName] = Nox.Config.Players[playerName];
            Nox.Config.Players[playerName] = nil;
         else
            Nox.Config.Players[realm][playerName] = { };
         end
      end

      -- save a shortcut so we don't have to keep mucking about with the player's name
      Nox.Player = Nox.Config.Players[realm][playerName];

      -- fill in any missing defaults
      NoxInformationBar_DuplicateTable(NoxInformationBarPlayerDefaults, Nox.Player);

      -- fill in any missing fields in any of the overrides
      if (Nox.Player.Tooltip) then
         NoxInformationBar_DuplicateTable(NoxInformationBarDefaults.Tooltip, Nox.Player.Tooltip);
      end
      if (Nox.Player.Slot) then
         NoxInformationBar_DuplicateTable(NoxInformationBarDefaults.Slot, Nox.Player.Slot);
      end
      if (Nox.Player.Clock) then
         NoxInformationBar_DuplicateTable(NoxInformationBarDefaults.Clock, Nox.Player.Clock);
      end

      -- now set main config as defaults for the player, so we can use the
      -- player as the main config source.  this way, if the player has
      -- private settings, they override the main config.
      playermeta.__index = Nox.Config;
      setmetatable(Nox.Player, playermeta);

      NoxInformationBar_UpdateInventory();
      NoxInformationBar_UpdateFactions();

      Nox.ready = true;

      -- now fire an event to notify any interested extensions
      NoxInformationBar_OnPlayerInitialized();
   end
end

function NoxInformationBar_OnPlayerInitialized()
end

function NoxInformationBar_ResetConfig()
   Nox.Config  = NoxInformationBar_DuplicateTable(NoxInformationBarDefaults);
   Nox.Player  = NoxInformationBar_DuplicateTable(NoxInformationBarPlayerDefaults);
   Nox.Config.Tooltip.Content = NoxInformationBar_DuplicateTable(NoxTooltipDefaults);
end

function NoxInformationBar_DuplicateTable(src, dst, overwrite)
   -- warning: this function assumes that dst has tables
   -- in the same keys as src.  If dst has a scalar value
   -- at the same key src has a table value, an error will occur
   
   dst = dst or {};

   for k,v in pairs(src) do
      if (type(v) == "table") then
         dst[k] = NoxInformationBar_DuplicateTable(v, dst[k], overwrite);
      elseif (dst[k] == nil or overwrite) then
         dst[k] = v;
      end
   end

   return dst;
end

---------------------------------------------------------------------------
-- Slash Command Parser
---------------------------------------------------------------------------

NoxInformationBarCommand = SlashCommandParser:New("NoxInformationBar", NOX_IB.Messages.Header);
SLASH_NoxInformationBar1 = NOX_IB.SlashCommand;

---------------------------------------------------------------------------
-- Right-click Menu
---------------------------------------------------------------------------

NoxInformationBarMenu = NoxPopupMenu:new();

---------------------------------------------------------------------------
-- Constants
---------------------------------------------------------------------------

NOX_IB_UPDATE_RATE = 1;
NOX_IB_RUN_SPEED   = 7;

---------------------------------------------------------------------------
-- Initialize to defaults
---------------------------------------------------------------------------

-- fill out default config
for i = 1, NoxInformationBar_MaxSlots do
   if (not NoxInformationBarDefaults.Slot[i]) then
      NoxInformationBarDefaults.Slot[i] = NoxInformationBar_DuplicateTable(NoxInformationBarSlotDefaults);
   end
end

-- set configuration to defaults
NoxInformationBar_ResetConfig();
