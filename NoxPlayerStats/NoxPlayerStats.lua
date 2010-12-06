---------------------------------------------------------------------------
-- Nox Player Stats
--
-- Makes player information available to the Nox Information Bar.
--
-- @author   Gruma
---------------------------------------------------------------------------

---------------------------------------------------------------------------
-- Variables
---------------------------------------------------------------------------

local Original_NoxInformationBar_InitFormats;

---------------------------------------------------------------------------
-- Initialization
---------------------------------------------------------------------------

function NoxPlayerStats_OnLoad(self)
   Original_NoxInformationBar_InitFormats = NoxInformationBar_InitFormats;
   NoxInformationBar_InitFormats = NoxPlayerStats_InitFormats;
end

function NoxPlayerStats_InitFormats()
   -- set up the base table first
   Original_NoxInformationBar_InitFormats();

   -- add new codes
   NoxInformationBar_AddFormats(
      { code = NOX_PS_PARAM.class,        func = NoxPlayerStats_GetPlayerClass },
      { code = NOX_PS_PARAM.name,         func = NoxPlayerStats_GetPlayerName },
      { code = NOX_PS_PARAM.subzone,      func = NoxPlayerStats_GetCurrentSubZone   },
      { code = NOX_PS_PARAM.shortzone,    func = NoxPlayerStats_GetCurrentZoneShort },
      { code = NOX_PS_PARAM.realm,        func = NoxPlayerStats_GetPlayerRealm },
      { code = NOX_PS_PARAM.zone,         func = NoxPlayerStats_GetCurrentZone },
      { code = NOX_PS_PARAM.sex,          func = NoxPlayerStats_GetPlayerSex },
      { code = NOX_PS_PARAM.race,         func = NoxPlayerStats_GetPlayerRace },
      { code = NOX_PS_PARAM.faction,      func = NoxPlayerStats_GetPlayerFaction },
      { code = NOX_PS_PARAM.strength,     func = NoxPlayerStats_GetPlayerStrength },
      { code = NOX_PS_PARAM.agility,      func = NoxPlayerStats_GetPlayerAgility },
      { code = NOX_PS_PARAM.stamina,      func = NoxPlayerStats_GetPlayerStamina },
      { code = NOX_PS_PARAM.intellect,    func = NoxPlayerStats_GetPlayerIntellect },
      { code = NOX_PS_PARAM.spirit,       func = NoxPlayerStats_GetPlayerSpirit },
      { code = NOX_PS_PARAM.armor,        func = NoxPlayerStats_GetPlayerArmor },
      { code = NOX_PS_PARAM.resistholy,   func = NoxPlayerStats_GetHolyResistance },
      { code = NOX_PS_PARAM.resistarcane, func = NoxPlayerStats_GetArcaneResistance },
      { code = NOX_PS_PARAM.resistfire,   func = NoxPlayerStats_GetFireResistance },
      { code = NOX_PS_PARAM.resistnature, func = NoxPlayerStats_GetNatureResistance },
      { code = NOX_PS_PARAM.resistfrost,  func = NoxPlayerStats_GetFrostResistance },
      { code = NOX_PS_PARAM.resistshadow, func = NoxPlayerStats_GetShadowResistance },
      { code = NOX_PS_PARAM.realzone,     func = NoxPlayerStats_GetRealZoneName },
      { code = NOX_PS_PARAM.skillmain,    func = NoxPlayerStats_GetWeaponSkillMainHand },
      { code = NOX_PS_PARAM.skilloff,     func = NoxPlayerStats_GetWeaponSkillOffHand },
      { code = NOX_PS_PARAM.skillranged,  func = NoxPlayerStats_GetWeaponSkillRanged }
   );
end

---------------------------------------------------------------------------
-- Data functions
---------------------------------------------------------------------------

function NoxPlayerStats_GetPlayerClass()
   return (UnitClass("player"));
end

function NoxPlayerStats_GetPlayerName()
   return UnitName("player");
end

function NoxPlayerStats_GetPlayerRealm()
   return GetCVar("realmName");
end

function NoxPlayerStats_GetCurrentZone()
   return NoxPlayerStats_ZoneColor(GetZoneText());
end

function NoxPlayerStats_GetCurrentSubZone()
   return NoxPlayerStats_ZoneColor(GetSubZoneText());
end

function NoxPlayerStats_GetCurrentZoneShort()
   return NoxPlayerStats_ZoneColor(GetMinimapZoneText());
end

function NoxPlayerStats_GetRealZoneName()
   return NoxPlayerStats_ZoneColor(GetRealZoneText());
end

function NoxPlayerStats_GetPlayerSex()
   local id = UnitSex("player");
   if (id == 2) then
      return MALE;
   elseif (id == 3) then
      return FEMALE;
   else
      return UNKNOWN;
   end
end

function NoxPlayerStats_GetPlayerRace()
   return UnitRace("player");
end

function NoxPlayerStats_GetPlayerFaction()
   return UnitFactionGroup("player");
end

function NoxPlayerStats_GetPlayerStrength()
   return NoxPlayerStats_GetPlayerStat(1);
end

function NoxPlayerStats_GetPlayerAgility()
   return NoxPlayerStats_GetPlayerStat(2);
end

function NoxPlayerStats_GetPlayerStamina()
   return NoxPlayerStats_GetPlayerStat(3);
end

function NoxPlayerStats_GetPlayerIntellect()
   return NoxPlayerStats_GetPlayerStat(4);
end

function NoxPlayerStats_GetPlayerSpirit()
   return NoxPlayerStats_GetPlayerStat(5);
end

function NoxPlayerStats_GetPlayerStat(id)
   if (id >= 1 and id <= 5) then
      local base, stat, buff, debuff = UnitStat("player", id);
			
      if (debuff < 0) then
         return RED_FONT_COLOR_CODE .. stat .. FONT_COLOR_CODE_CLOSE;
			elseif (buff > 0) then
         return GREEN_FONT_COLOR_CODE .. stat .. FONT_COLOR_CODE_CLOSE;
      else
         return HIGHLIGHT_FONT_COLOR_CODE .. stat .. FONT_COLOR_CODE_CLOSE;
      end
  else
     return NOX_IB.Messages.NotAvailable;
  end
end

function NoxPlayerStats_GetPlayerArmor()
   local base, armor, armor2, buff, debuff = UnitArmor("player");
			
   if (debuff < 0) then
      return RED_FONT_COLOR_CODE .. armor .. FONT_COLOR_CODE_CLOSE;
   elseif (buff > 0) then
      return GREEN_FONT_COLOR_CODE .. armor .. FONT_COLOR_CODE_CLOSE;
   else
      return HIGHLIGHT_FONT_COLOR_CODE .. armor .. FONT_COLOR_CODE_CLOSE;
   end
end

function NoxPlayerStats_GetHolyResistance()
   return NoxPlayerStats_GetPlayerResistance(1);
end

function NoxPlayerStats_GetArcaneResistance()
   return NoxPlayerStats_GetPlayerResistance(6);
end

function NoxPlayerStats_GetFireResistance()
   return NoxPlayerStats_GetPlayerResistance(2);
end

function NoxPlayerStats_GetNatureResistance()
   return NoxPlayerStats_GetPlayerResistance(3);
end

function NoxPlayerStats_GetFrostResistance()
   return NoxPlayerStats_GetPlayerResistance(4);
end

function NoxPlayerStats_GetShadowResistance()
   return NoxPlayerStats_GetPlayerResistance(5);
end

function NoxPlayerStats_GetPlayerResistance(id)
   if (id >= 1 and id <= 6) then
      local base, stat, buff, debuff = UnitResistance("player", id);
			
      if (debuff < 0) then
         return RED_FONT_COLOR_CODE .. stat .. FONT_COLOR_CODE_CLOSE;
			elseif (buff > 0) then
         return GREEN_FONT_COLOR_CODE .. stat .. FONT_COLOR_CODE_CLOSE;
      else
         return HIGHLIGHT_FONT_COLOR_CODE .. stat .. FONT_COLOR_CODE_CLOSE;
      end
  else
     return NOX_IB.Messages.NotAvailable;
  end
end

function NoxPlayerStats_ZoneColor(text)
   local color;
   local pvpType, factionName, isArena = GetZonePVPInfo();
   if (isArena) then
      color = "|cffff2020";
   elseif ( pvpType == "friendly" ) then
      color = "|cff20ff20";
   elseif ( pvpType == "hostile" ) then
      color = "|cffff2020";
   elseif ( pvpType == "contested" ) then
      color = "|cffffb400";
   else
      color = "|cffffd200";
   end
   return color .. text .. "|r";
end

function NoxPlayerStats_GetWeaponSkillMainHand()
   local mainbase, mainmod, offbase, offmod = UnitAttackBothHands("player");
   return mainbase + mainmod;
end

function NoxPlayerStats_GetWeaponSkillOffHand()
   local mainbase, mainmod, offbase, offmod = UnitAttackBothHands("player");
   return offbase + offmod;
end

function NoxPlayerStats_GetWeaponSkillRanged()
   local rangedbase, rangedmod = UnitRangedAttack("player");
   return rangedbase + rangedmod;
end
