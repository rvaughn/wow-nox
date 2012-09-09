---------------------------------------------------------------------------
-- Nox Information Bar
---------------------------------------------------------------------------

---------------------------------------------------------------------------
-- Localization Container
---------------------------------------------------------------------------

NOX_IB = { };

---------------------------------------------------------------------------
-- Global
---------------------------------------------------------------------------

NOX_IB.Name                            = "Nox Information Bar";
NOX_IB.Version                         = "5.0.0";
NOX_IB.SlashCommand                    = "/noxib";
NOX_IB.UI                              = "Nox";
NOX_IB.Description                     = "A configurable information bar.";

---------------------------------------------------------------------------
-- English
---------------------------------------------------------------------------

-- Default to English.  If another supported locale is used, it will
-- override these settings.  This also prevents problems with values
-- introduced in English, but mistakenly uncopied to other locales.
--if ( GetLocale ( ) == "enUS" ) then

    ----------------------------------------------------------------
    -- Bindings
    ----------------------------------------------------------------
    
    NOX_IB.Bindings                    = { };
    NOX_IB.Bindings.Toggle             = "Toggle " .. NOX_IB.Name;

    ----------------------------------------------------------------
    -- Tooltip
    ----------------------------------------------------------------
    
    NOX_IB.TooltipHeader               = "Experience for {name} (Level {level} {class})";
    NOX_IB.TooltipPlayTime             = "Total play time:";
    NOX_IB.TooltipPlayTimeValue        = "||cffcccccc{totaltime}";
    NOX_IB.TooltipSessionStatsMaxed    = "Current session play time:";
                                 
    NOX_IB.TooltipXPHeader             = "Experience:";
    NOX_IB.TooltipXPNextLevel          = "    Required for next level:";
    NOX_IB.TooltipXPNextLevelValue     = "||cff93008c{maxxp} xp";
    NOX_IB.TooltipXPEarned             = "    Earned this level:";
    NOX_IB.TooltipXPEarnedValue        = "||cff93008c{xp} xp";
    NOX_IB.TooltipXPToGo               = "    To go this level:";
    NOX_IB.TooltipXPToGoValue          = "||cff93008c{xptolevel} xp";
    NOX_IB.TooltipXPRested             = "    Rested bonus until:";
    NOX_IB.TooltipXPRestedValue        = "||cff0063ff{restlimit} xp";
    NOX_IB.TooltipXPRestedToGo         = "    Rested bonus remaining:";
    NOX_IB.TooltipXPRestedToGoValue    = "||cff0063ff{restbonus} xp";
    
    NOX_IB.TooltipLevelStats           = "Current level's statistics:";
    NOX_IB.TooltipLevelTime            = "    Play time:";
    NOX_IB.TooltipLevelTimeValue       = "||cffcccccc{leveltime}";
    NOX_IB.TooltipLevelETL             = "    Estimated time to level:";
    NOX_IB.TooltipLevelETLValue        = "||cffcccccc{levelttl}";
    NOX_IB.TooltipLevelRate            = "    Leveling speed:";
    NOX_IB.TooltipLevelRateValue       = "||cffcccccc{levelxprate} xp/hr";

    NOX_IB.TooltipSessionStats         = "Current session's statistics:";
    NOX_IB.TooltipSessionTime          = "    Play time:";
    NOX_IB.TooltipSessionTimeValue     = "||cffcccccc{sessiontime}";
    NOX_IB.TooltipSessionETL           = "    Estimated time to level:";
    NOX_IB.TooltipSessionETLValue      = "||cffcccccc{sessionttl}";
    NOX_IB.TooltipSessionRate          = "    Leveling speed:";
    NOX_IB.TooltipSessionRateValue     = "||cffcccccc{sessionxprate} xp/hr";

    NOX_IB.TooltipFooter               = "||cffccccccRight-click bar for menu";

    NOX_IB.TooltipXPSuffix             = "xp";
    NOX_IB.TooltipRateSuffix           = "xp/hr";

    ----------------------------------------------------------------
    -- Clock
    ----------------------------------------------------------------
    
    NOX_IB.Clock                       = { };
    NOX_IB.Clock.Day                   = "%d day";
    NOX_IB.Clock.Days                  = "%d days";
    NOX_IB.Clock.Hour                  = "%d hr";
    NOX_IB.Clock.Hours                 = "%d hrs";
    NOX_IB.Clock.Minute                = "%d min";
    NOX_IB.Clock.Minutes               = "%d mins";
    NOX_IB.Clock.Second                = "%d sec";
    NOX_IB.Clock.Seconds               = "%d secs";
    NOX_IB.Clock.Infinite              = "infinite";

    NOX_IB.Clock.Short                 = { };
    NOX_IB.Clock.Short.Day             = "d";
    NOX_IB.Clock.Short.Hour            = "h";
    NOX_IB.Clock.Short.Minute          = "m";
    NOX_IB.Clock.Short.Second          = "s";

    NOX_IB.Clock.TimeSeparator         = ":";
    NOX_IB.Clock.DaySeparator          = ".";

    ----------------------------------------------------------------
    -- Money
    ----------------------------------------------------------------
    
    NOX_IB.Money                       = { };
    NOX_IB.Money.Long                  = { };
    NOX_IB.Money.Long.Gold             = " gold ";
    NOX_IB.Money.Long.Silver           = " silver ";
    NOX_IB.Money.Long.Copper           = " copper";
    NOX_IB.Money.Short                 = { };
    NOX_IB.Money.Short.Gold            = "g ";
    NOX_IB.Money.Short.Silver          = "s ";
    NOX_IB.Money.Short.Copper          = "c";
    
    ----------------------------------------------------------------
    -- Ammo bag names
    ----------------------------------------------------------------
    
    NOX_IB.AmmoTypes = { "Quiver", "Ammo", "Bandolier" };

    ----------------------------------------------------------------
    -- Commands
    ----------------------------------------------------------------
    
    NOX_IB.Commands                    = { };
    NOX_IB.Commands.Toggle             = "Toggle";
    NOX_IB.Commands.Show               = "Show";
    NOX_IB.Commands.Hide               = "Hide";
    NOX_IB.Commands.Lock               = "Lock";
    NOX_IB.Commands.Unlock             = "Unlock";
    NOX_IB.Commands.Resize             = "Resize";
    NOX_IB.Commands.Remap              = "Remap";
    NOX_IB.Commands.Tooltip            = "Tooltip";
    NOX_IB.Commands.Clock              = "Clock";
    NOX_IB.Commands.Reset              = "Reset";
    NOX_IB.Commands.Help               = "Help";
    NOX_IB.Commands.Config             = "Config";
    
    ----------------------------------------------------------------
    -- Usage
    ----------------------------------------------------------------
    
    NOX_IB.Usage                    = { };
    NOX_IB.Usage.Toggle             = "[slot=<table>]";
    NOX_IB.Usage.Show               = "[slot=<table>]";
    NOX_IB.Usage.Hide               = "[slot=<table>]";
    NOX_IB.Usage.Lock               = "";
    NOX_IB.Usage.Unlock             = "";
    NOX_IB.Usage.Resize             = "slot=<table> width=number";
    NOX_IB.Usage.Remap              = "slot=<table> display='string'";
    NOX_IB.Usage.Tooltip            = "[state=<'on' | 'off'>] [position=<anchor>] [x=number] [y=number]";
    NOX_IB.Usage.Clock              = "[offsethour=number] [offsetminute=number]";
    NOX_IB.Usage.Reset              = "";
    NOX_IB.Usage.Help               = "";
    NOX_IB.Usage.Config             = "";
    
    ----------------------------------------------------------------
    -- Parameters
    ----------------------------------------------------------------
    
    NOX_IB.Parameters                  = { };
    NOX_IB.Parameters.Slot             = "Slot";
    NOX_IB.Parameters.Width            = "Width";
    NOX_IB.Parameters.X                = "X";
    NOX_IB.Parameters.Y                = "Y";
    NOX_IB.Parameters.Display          = "Display";
    NOX_IB.Parameters.State            = "State";
    NOX_IB.Parameters.Position         = "Position";
    NOX_IB.Parameters.OffsetHour       = "OffsetHour";
    NOX_IB.Parameters.OffsetMinute     = "OffsetMinute";
        
    ----------------------------------------------------------------
    -- Format constants
    ----------------------------------------------------------------

    NOX_IB.Format                      = { };

    -- time formats
    NOX_IB.Format.Short                = "short";  -- 1.2:03:04
    NOX_IB.Format.Medium               = "medium"; -- 1d 2h 3m 4s
    NOX_IB.Format.Long                 = "long";   -- 1 day, 2 hours, 3 minutes, 4 seconds

    -- memory formats
    NOX_IB.Format.KB                   = "kb";
    NOX_IB.Format.MB                   = "mb";

    -- number formats
    NOX_IB.Format.Decimal              = "dec";
    NOX_IB.Format.Integer              = "int";
    
    -- money formats
    NOX_IB.Format.Copper               = "copper";     -- 3
    NOX_IB.Format.Silver               = "silver";     -- 2
    NOX_IB.Format.Gold                 = "gold";       -- 1
    NOX_IB.Format.AsCopper             = "as copper";  -- 10203
    NOX_IB.Format.AsSilver             = "as silver";  -- 102.03
    NOX_IB.Format.AsGold               = "as gold";    -- 1.02
    NOX_IB.Format.LongMoney            = "long";       -- 1 gold 2 silver 3 copper
    NOX_IB.Format.ShortMoney           = "short";      -- 1g 2s 3c
    NOX_IB.Format.NumericMoney         = "numeric";    -- 1 2 3
    NOX_IB.Format.CompactMoney         = "compact";    -- 1.2.3
    NOX_IB.Format.MoneySeparator       = ".";
    NOX_IB.Format.GoldColor            = "|cffffd100";
    NOX_IB.Format.SilverColor          = "|cffe6e6e6";
    NOX_IB.Format.CopperColor          = "|cffc8602c";
    NOX_IB.Format.True                 = "true";
    NOX_IB.Format.False                = "false";

    ----------------------------------------------------------------
    -- Messages
    ----------------------------------------------------------------
    
    NOX_IB.Messages                    = { };
    
    ----------------------------------------------------------------
    -- Usage
    ----------------------------------------------------------------
    
    -- Header is prepended to every line in the usage summary
    -- this takes up unnecessary space in the usage summary, making
    -- it harder to read
    --NOX_IB.Messages.Header             = "|cff8080ff<" .. NOX_IB.Name .. ">|r ";
    NOX_IB.Messages.Header             = "";
    
    -- these are new strings that appear before and after the whole
    -- usage summary, respectively.
    NOX_IB.Messages.GroupHeader        = "|cff8080ff<" .. NOX_IB.Name .. ">|r ";
    NOX_IB.Messages.GroupFooter        = "<table> can be a number (eg. 1), range (eg. 1-6), or table (eg. [1 3 4 5])" .. "\n" ..
                                         "<anchor> can be 'left', 'topleft', 'top', 'topright', 'right', 'bottomright', 'bottom', or 'bottomleft'";
	
    ----------------------------------------------------------------
    -- Values
    ----------------------------------------------------------------
    
    NOX_IB.Messages.NotAvailable       = "n/a";
    NOX_IB.Messages.Empty              = "empty";
    NOX_IB.Messages.None               = "none";
    NOX_IB.Messages.Error              = "|cffff0000error|r";

    ----------------------------------------------------------------
    -- Popup Menu
    ----------------------------------------------------------------

    NOX_IB.Menu                       = {};
    NOX_IB.Menu.Reset                 = "Reset session stats";
    NOX_IB.Menu.Config                = "Options";

    ----------------------------------------------------------------
    -- Errors
    ----------------------------------------------------------------

    NOX_ERROR_TOO_MANY_BUTTONS        = "|cffff0000NoxIB: error: attempting to add too many buttons to popup menu|r";

    ----------------------------------------------------------------
    -- Config Dialog
    ----------------------------------------------------------------

    NOXCONFIG_TITLE                              = "Nox Information Bar";

    NOXCONFIG_ENABLED                            = "Visible";
    NOXCONFIG_WIDTH                              = "Width";
    NOXCONFIG_DISPLAY                            = "Display";

    NOXCONFIG_NoxConfigFrameGeneralGroup         = "General";
    NOXCONFIG_NoxConfigFrameBarVisible           = "Enable Nox Information Bar";
    NOXCONFIG_NoxConfigFrameBarMovable           = "Allow bar to be moved";
    NOXCONFIG_NoxConfigFrameShowBorder           = "Show border and background";
    NOXCONFIG_NoxConfigFrameExpBarsEnabled       = "Show experience bars";
    NOXCONFIG_NoxConfigFrameExpBarColor          = "Experience bar color";
    NOXCONFIG_NoxConfigFrameRestedBarColor       = "Rested bar color";

    NOXCONFIG_NoxConfigFrameTooltipGroup         = "Tooltip";
    NOXCONFIG_NoxConfigFrameTooltipEnabled       = "Enable tooltip";
    NOXCONFIG_NoxConfigFrameTooltipAnchor        = "Anchor:";

    NOXCONFIG_NoxConfigFrameClockGroup           = "Clock";
    NOXCONFIG_NoxConfigFrameClockOffsetHours     = "Clock hour offset";
    NOXCONFIG_NoxConfigFrameClockOffsetHours_MIN = "-25";
    NOXCONFIG_NoxConfigFrameClockOffsetHours_MAX = "+25";
    NOXCONFIG_NoxConfigFrameClockOffsetMins      = "Clock minute offset";
    NOXCONFIG_NoxConfigFrameClockOffsetMins_MIN  = "-60";
    NOXCONFIG_NoxConfigFrameClockOffsetMins_MAX  = "+60";

    NOXCONFIG_NoxConfigFrameFontGroup            = "Font Size";
    NOXCONFIG_NoxConfigFrameFontSizeBar          = "Main Bar";
    NOXCONFIG_NoxConfigFrameFontSizeBar_MIN      = "8";
    NOXCONFIG_NoxConfigFrameFontSizeBar_MAX      = "32";
    NOXCONFIG_NoxConfigFrameFontSizeTooltip      = "Tooltip";
    NOXCONFIG_NoxConfigFrameFontSizeTooltip_MIN  = "8";
    NOXCONFIG_NoxConfigFrameFontSizeTooltip_MAX  = "32";

    NOXCONFIG_NoxConfigFramePersonalGroup        = "Character-specific Options";
    NOXCONFIG_NoxConfigFrameOverrideGeneral      = "Customize general options";
    NOXCONFIG_NoxConfigFrameOverrideClock        = "Customize clock";
    NOXCONFIG_NoxConfigFrameOverrideSlots        = "Customize slots";
    NOXCONFIG_NoxConfigFrameOverrideTooltip      = "Customize tooltip"; 

    NOXCONFIG_NoxConfigFrameSlotGroup            = "Slots";
    NOXCONFIG_NoxConfigFrameSlot                 = "Slot ";

    NOXCONFIG_NoxConfigFrameTooltipContentGroup  = "Tooltip Content";
    NOXCONFIG_NoxConfigFrameMoverGroup           = "Movable UI Frames";

    NOXCONFIG_OFFSET_LABEL                       = "Offset";
    NOXCONFIG_OFFSET_X                           = "x:";
    NOXCONFIG_OFFSET_Y                           = "y:";

    NOXCONFIG_NoxConfigFrameMoveBuffsEnabled     = "Move Buffs";
    NOXCONFIG_NoxConfigFrameMoveBGFlagEnabled    = "Move Battlegrounds Flag";
    NOXCONFIG_NoxConfigFrameMovePlayerEnabled    = "Move Player Portrait";
    NOXCONFIG_NoxConfigFrameMoveTargetEnabled    = "Move Target Portrait";
    NOXCONFIG_NoxConfigFrameMoveMinimapEnabled   = "Move Minimap";

    NOXCONFIG_APPLY_BUTTON                       = "Apply";
    NOXCONFIG_RESET_BUTTON                       = "Defaults";
    NOXCONFIG_CLOSE_BUTTON                       = "Okay";
    NOXCONFIG_CANCEL_BUTTON                      = "Cancel";
    NOXCONFIG_GENERAL_BUTTON                     = "General";
    NOXCONFIG_SLOTS_BUTTON                       = "Slots";
    NOXCONFIG_TOOLTIP_BUTTON                     = "Tooltip";
    NOXCONFIG_DELETE_BUTTON                      = "Delete";
    NOXCONFIG_INSERT_BUTTON                      = "Insert";
    NOXCONFIG_MOVERS_BUTTON                      = "Movers";
    
---------------------------------------------------------------------------
-- Variable names
---------------------------------------------------------------------------

    NOX_IB.Param                 = { };
    NOX_IB.Param.latency         = "latency";
    NOX_IB.Param.framerate       = "framerate";
    NOX_IB.Param.hours24         = "24hours";
    NOX_IB.Param.hours           = "hours";
    NOX_IB.Param.minutes         = "minutes";
    NOX_IB.Param.ampm            = "ampm";
    NOX_IB.Param.x               = "x";
    NOX_IB.Param.y               = "y";
    NOX_IB.Param.money           = "money";
    NOX_IB.Param.hpregen         = "hpregen";
    NOX_IB.Param.manaregen       = "manaregen";
    NOX_IB.Param.hp              = "hp";
    NOX_IB.Param.hploss          = "hploss";
    NOX_IB.Param.hppct           = "hp%";
    NOX_IB.Param.maxhp           = "maxhp";
    NOX_IB.Param.mana            = "mana";
    NOX_IB.Param.manaloss        = "manaloss";
    NOX_IB.Param.manapct         = "mana%";
    NOX_IB.Param.maxmana         = "maxmana";
    NOX_IB.Param.xp              = "xp";
    NOX_IB.Param.xptolevel       = "xptolevel";
    NOX_IB.Param.xppct           = "xp%";
    NOX_IB.Param.xptolevelpct    = "xptolevel%";
    NOX_IB.Param.maxxp           = "maxxp";
    NOX_IB.Param.rest            = "rest";
    NOX_IB.Param.level           = "level";
    NOX_IB.Param.ubs             = "ubs";
    NOX_IB.Param.abs             = "abs";
    NOX_IB.Param.tbs             = "tbs";
    NOX_IB.Param.mem             = "mem";
    NOX_IB.Param.restbonus       = "restbonus";
    NOX_IB.Param.restlimit       = "restlimit";
    NOX_IB.Param.sessionttl      = "sessionttl";
    NOX_IB.Param.levelttl        = "levelttl";
    NOX_IB.Param.bestttl         = "bestttl";
    NOX_IB.Param.totaltime       = "totaltime";
    NOX_IB.Param.sessiontime     = "sessiontime";
    NOX_IB.Param.leveltime       = "leveltime";
    NOX_IB.Param.sessionxprate   = "sessionxprate";
    NOX_IB.Param.levelxprate     = "levelxprate";
    NOX_IB.Param.income          = "income";
    NOX_IB.Param.expense         = "expense";
    NOX_IB.Param.netincome       = "netincome";
    NOX_IB.Param.incomerate      = "incomerate";
    NOX_IB.Param.expenserate     = "expenserate";
    NOX_IB.Param.netincomerate   = "netincomerate";
    NOX_IB.Param.factionstanding = "factionstanding";
    NOX_IB.Param.factionrep      = "reputation";
    NOX_IB.Param.factionrepmax   = "reputationmax";
    NOX_IB.Param.factionreppct   = "reputation%";
    NOX_IB.Param.factionatwar    = "factionatwar";
    NOX_IB.Param.factionname     = "factionname";
    NOX_IB.Param.itemcount       = "itemcount";

    -- deprecated vars
    NOX_IB.Param.sessionttlshort = "sessionttlshort";
    NOX_IB.Param.levelttlshort   = "levelttlshort";
    NOX_IB.Param.bestttlshort    = "bestttlshort";
    NOX_IB.Param.memmb           = "memmb";
    NOX_IB.Param.memkb           = "memkb";
    NOX_IB.Param.memlimitmb      = "memlimitmb";
    NOX_IB.Param.memlimitkb      = "memlimitkb";
    NOX_IB.Param.allmoney        = "allmoney";
    NOX_IB.Param.gold            = "gold";
    NOX_IB.Param.silver          = "silver";
    NOX_IB.Param.copper          = "copper";

-- end

---------------------------------------------------------------------------
-- Deutsch
---------------------------------------------------------------------------

if ( GetLocale ( ) == "deDE" ) then

    -- don't recreate tables in other languages - just override values

    ----------------------------------------------------------------
    -- Bindings
    ----------------------------------------------------------------
    
    NOX_IB.Bindings.Toggle             = "Umschalten " .. NOX_IB.Name;

    ----------------------------------------------------------------
    -- Tooltip
    ----------------------------------------------------------------
    
    NOX_IB.TooltipPlayTime             = "Insgesamt gespielt:";
    NOX_IB.TooltipLevelStats           = "Level Statistik:";
    NOX_IB.TooltipLevelTime            = "    Zeit gespielt:";
    NOX_IB.TooltipLevelETL             = "    Gesch\195\164tzte Zeit bis zum Level-Up:";
    NOX_IB.TooltipLevelRate            = "    Erfahrung pro Stunde:";
    NOX_IB.TooltipSessionStats         = "Sitzungs Statistik:";
    NOX_IB.TooltipSessionTime          = "    Zeit gespielt:";
    NOX_IB.TooltipSessionETL           = "    Gesch\195\164tzte Zeit bis zum Level-Up:";
    NOX_IB.TooltipSessionRate          = "    Erfahrung pro Stunde:";
    NOX_IB.TooltipSessionStatsMaxed    = "Sitzungs gespielt:";
                                 
    NOX_IB.TooltipRateFormat           = "|cffcccccc%0.2f XP/Std|r";

    NOX_IB.TooltipXPFormat             = "|cff93008c%s XP|r";
    NOX_IB.TooltipRestedXPFormat       = "|cff0063ff%s XP|r";

    ----------------------------------------------------------------
    -- Clock
    ----------------------------------------------------------------
    
    NOX_IB.Clock.Day                   = "%d Tag";
    NOX_IB.Clock.Days                  = "%d Tage";
    NOX_IB.Clock.Hour                  = "%d Stunde";
    NOX_IB.Clock.Hours                 = "%d Stunden";
    NOX_IB.Clock.Minute                = "%d Minute";
    NOX_IB.Clock.Minutes               = "%d Minuten";
    NOX_IB.Clock.Second                = "%d Sekunde";
    NOX_IB.Clock.Seconds               = "%d Sekunden";
    NOX_IB.Clock.Infinite              = "Unendlich";

end

---------------------------------------------------------------------------
-- Bindings
---------------------------------------------------------------------------

BINDING_HEADER_NOX_UI      = NOX_IB.UI;
BINDING_NAME_NOX_IB_TOGGLE = NOX_IB.Bindings.Toggle;
