---------------------------------------------------------------------------
-- Nox Combat Stats
--
-- Makes combat information available to the Nox Information Bar.
--
-- @author   Gruma
---------------------------------------------------------------------------

---------------------------------------------------------------------------
-- Variables
---------------------------------------------------------------------------

local Original_NoxInformationBar_InitFormats;

NoxCombatStats = { };
NoxCombatStats.InCombat       = nil;
NoxCombatStats.CombatStart    = 0;
NoxCombatStats.CombatEnd      = 0;

NoxCombatStats.Kills          = 0;
NoxCombatStats.XP             = 0;
NoxCombatStats.XPPerKill      = 0;
NoxCombatStats.XP1            = 0;
NoxCombatStats.XP2            = 0;
NoxCombatStats.XP3            = 0;
NoxCombatStats.XP4            = 0;

NoxCombatStats.combat = {};
NoxCombatStats.combat.MeleeDamage    = 0;
NoxCombatStats.combat.NonMeleeDamage = 0;
NoxCombatStats.combat.PetDamage      = 0;
NoxCombatStats.combat.Healed         = 0;
NoxCombatStats.combat.MeleeHits      = 0;
NoxCombatStats.combat.NonMeleeHits   = 0;
NoxCombatStats.combat.HealHits       = 0;
NoxCombatStats.combat.MeleeCrits     = 0;
NoxCombatStats.combat.NonMeleeCrits  = 0;
NoxCombatStats.combat.HealCrits      = 0;
NoxCombatStats.combat.MeleeMisses    = 0;
NoxCombatStats.combat.NonMeleeMisses = 0;
NoxCombatStats.combat.HealMisses     = 0;

NoxCombatStats.session = {};
NoxCombatStats.session.MeleeDamage    = 0;
NoxCombatStats.session.NonMeleeDamage = 0;
NoxCombatStats.session.PetDamage      = 0;
NoxCombatStats.session.Healed         = 0;
NoxCombatStats.session.MeleeHits      = 0;
NoxCombatStats.session.NonMeleeHits   = 0;
NoxCombatStats.session.HealHits       = 0;
NoxCombatStats.session.MeleeCrits     = 0;
NoxCombatStats.session.NonMeleeCrits  = 0;
NoxCombatStats.session.HealCrits      = 0;
NoxCombatStats.session.MeleeMisses    = 0;
NoxCombatStats.session.NonMeleeMisses = 0;
NoxCombatStats.session.HealMisses     = 0;
NoxCombatStats.session.CombatTime     = 0;

NoxCombatStats.pets = {};

local gStats = NoxCombatStats;
local cStats = NoxCombatStats.combat;
local sStats = NoxCombatStats.session;
local pets   = NoxCombatStats.pets;

---------------------------------------------------------------------------
-- Initialization
---------------------------------------------------------------------------

function NoxCombatStats_OnLoad(self)
   -- hook base functions
   Original_NoxInformationBar_InitFormats = NoxInformationBar_InitFormats;
   NoxInformationBar_InitFormats = NoxCombatStats_InitFormats;

   -- Register events
   for event in pairs(NoxCombatStats_Events) do
      self:RegisterEvent(event);
   end

   -- add menu option
   NoxInformationBarMenu:AddItem(NOX_CS_MENU_ITEM, NoxCombatStats_ResetSession, nil, 2);
end

function NoxCombatStats_InitFormats()
   -- set up the base table first
   Original_NoxInformationBar_InitFormats();

   -- add new codes
   NoxInformationBar_AddFormats(
      { code = NOX_CS_PARAM.curr_dps,               func =  NoxCombatStats_GetDPS                         },
      { code = NOX_CS_PARAM.curr_hps,               func =  NoxCombatStats_GetHPS                         },
      { code = NOX_CS_PARAM.curr_petdps,            func =  NoxCombatStats_GetPetDPS                      },
      { code = NOX_CS_PARAM.curr_totaldamage,       func =  NoxCombatStats_GetTotalDamage                 },
      { code = NOX_CS_PARAM.curr_totalheal,         func =  NoxCombatStats_GetTotalHeal                   },
      { code = NOX_CS_PARAM.curr_combatduration,    func =  NoxCombatStats_GetCombatDuration              },
      { code = NOX_CS_PARAM.curr_meleehits,         func =  NoxCombatStats_GetMeleeHits                   },
      { code = NOX_CS_PARAM.curr_meleemisses,       func =  NoxCombatStats_GetMeleeMisses                 },
      { code = NOX_CS_PARAM.curr_meleecrits,        func =  NoxCombatStats_GetMeleeCriticals              },
      { code = NOX_CS_PARAM.curr_meleehitspct,      func =  NoxCombatStats_GetMeleeHitsPercentage         },
      { code = NOX_CS_PARAM.curr_meleemissespct,    func =  NoxCombatStats_GetMeleeMissesPercentage       },
      { code = NOX_CS_PARAM.curr_meleecritspct,     func =  NoxCombatStats_GetMeleeCriticalsPercentage    },
      { code = NOX_CS_PARAM.curr_nonmeleehits,      func =  NoxCombatStats_GetNonMeleeHits                },
      { code = NOX_CS_PARAM.curr_nonmeleemisses,    func =  NoxCombatStats_GetNonMeleeMisses              },
      { code = NOX_CS_PARAM.curr_nonmeleecrits,     func =  NoxCombatStats_GetNonMeleeCriticals           },
      { code = NOX_CS_PARAM.curr_nonmeleehitspct,   func =  NoxCombatStats_GetNonMeleeHitsPercentage      },
      { code = NOX_CS_PARAM.curr_nonmeleemissespct, func =  NoxCombatStats_GetNonMeleeMissesPercentage    },
      { code = NOX_CS_PARAM.curr_nonmeleecritspct,  func =  NoxCombatStats_GetNonMeleeCriticalsPercentage },
      { code = NOX_CS_PARAM.curr_healhits,          func =  NoxCombatStats_GetHealHits                    },
      { code = NOX_CS_PARAM.curr_healmisses,        func =  NoxCombatStats_GetHealMisses                  },
      { code = NOX_CS_PARAM.curr_healcrits,         func =  NoxCombatStats_GetHealCriticals               },
      { code = NOX_CS_PARAM.curr_healhitspct,       func =  NoxCombatStats_GetHealHitsPercentage          },
      { code = NOX_CS_PARAM.curr_healmissespct,     func =  NoxCombatStats_GetHealMissesPercentage        },
      { code = NOX_CS_PARAM.curr_healcritspct,      func =  NoxCombatStats_GetHealCriticalsPercentage     },

      { code = NOX_CS_PARAM.sess_dps,               func =  NoxCombatStats_GetSessionDPS                         },
      { code = NOX_CS_PARAM.sess_hps,               func =  NoxCombatStats_GetSessionHPS                         },
      { code = NOX_CS_PARAM.sess_petdps,            func =  NoxCombatStats_GetSessionPetDPS                      },
      { code = NOX_CS_PARAM.sess_totaldamage,       func =  NoxCombatStats_GetSessionTotalDamage                 },
      { code = NOX_CS_PARAM.sess_totalheal,         func =  NoxCombatStats_GetSessionTotalHeal                   },
      { code = NOX_CS_PARAM.sess_combatduration,    func =  NoxCombatStats_GetSessionCombatDuration              },
      { code = NOX_CS_PARAM.sess_meleehits,         func =  NoxCombatStats_GetSessionMeleeHits                   },
      { code = NOX_CS_PARAM.sess_meleemisses,       func =  NoxCombatStats_GetSessionMeleeMisses                 },
      { code = NOX_CS_PARAM.sess_meleecrits,        func =  NoxCombatStats_GetSessionMeleeCriticals              },
      { code = NOX_CS_PARAM.sess_meleehitspct,      func =  NoxCombatStats_GetSessionMeleeHitsPercentage         },
      { code = NOX_CS_PARAM.sess_meleemissespct,    func =  NoxCombatStats_GetSessionMeleeMissesPercentage       },
      { code = NOX_CS_PARAM.sess_meleecritspct,     func =  NoxCombatStats_GetSessionMeleeCriticalsPercentage    },
      { code = NOX_CS_PARAM.sess_nonmeleehits,      func =  NoxCombatStats_GetSessionNonMeleeHits                },
      { code = NOX_CS_PARAM.sess_nonmeleemisses,    func =  NoxCombatStats_GetSessionNonMeleeMisses              },
      { code = NOX_CS_PARAM.sess_nonmeleecrits,     func =  NoxCombatStats_GetSessionNonMeleeCriticals           },
      { code = NOX_CS_PARAM.sess_nonmeleehitspct,   func =  NoxCombatStats_GetSessionNonMeleeHitsPercentage      },
      { code = NOX_CS_PARAM.sess_nonmeleemissespct, func =  NoxCombatStats_GetSessionNonMeleeMissesPercentage    },
      { code = NOX_CS_PARAM.sess_nonmeleecritspct,  func =  NoxCombatStats_GetSessionNonMeleeCriticalsPercentage },
      { code = NOX_CS_PARAM.sess_healhits,          func =  NoxCombatStats_GetSessionHealHits                    },
      { code = NOX_CS_PARAM.sess_healmisses,        func =  NoxCombatStats_GetSessionHealMisses                  },
      { code = NOX_CS_PARAM.sess_healcrits,         func =  NoxCombatStats_GetSessionHealCriticals               },
      { code = NOX_CS_PARAM.sess_healhitspct,       func =  NoxCombatStats_GetSessionHealHitsPercentage          },
      { code = NOX_CS_PARAM.sess_healmissespct,     func =  NoxCombatStats_GetSessionHealMissesPercentage        },
      { code = NOX_CS_PARAM.sess_healcritspct,      func =  NoxCombatStats_GetSessionHealCriticalsPercentage     },

      { code = NOX_CS_PARAM.kills,                  func = NoxCombatStats_GetNumKills                            },
      { code = NOX_CS_PARAM.xpperkill,              func = NoxCombatStats_GetXPPerKill                           },
      { code = NOX_CS_PARAM.killstolevel,           func = NoxCombatStats_GetKillsToLevel                        }
   );
end

---------------------------------------------------------------------------
-- NoxCombatStats - OnEvent() Event
---------------------------------------------------------------------------

NoxCombatStats_Events = {}
function NoxCombatStats_OnEvent(frame, event, ...)
   local func = NoxCombatStats_Events[event];
   if (func) then
      func(...);
   end
end

---------------------------------------------------------------------------
-- VARIABLES_LOADED Event
---------------------------------------------------------------------------

NoxCombatStats_Events["VARIABLES_LOADED"] = 
function()
   gStats.InCombat = nil;
end

---------------------------------------------------------------------------
-- PLAYER_REGEN_DISABLED Event
---------------------------------------------------------------------------

NoxCombatStats_Events["PLAYER_REGEN_DISABLED"] = 
function()
   NoxCombatStats_EnterCombat();
end

---------------------------------------------------------------------------
-- PLAYER_REGEN_ENABLED Event
---------------------------------------------------------------------------

NoxCombatStats_Events["PLAYER_REGEN_ENABLED"] = 
function()
   NoxCombatStats_LeaveCombat();
end

---------------------------------------------------------------------------
-- CHAT_MSG_COMBAT_XP_GAIN Event
---------------------------------------------------------------------------

NoxCombatStats_Events["CHAT_MSG_COMBAT_XP_GAIN"] = 
function(arg1)
   firsti, lasti, xp = string.find(arg1, NOX_CS_STR_KILL);
   if (xp) then
      -- we'll register kills in PARTY_KILLS, just record XP here
      gStats.XP = gStats.XP + xp;

      gStats.XP4 = gStats.XP3;
      gStats.XP3 = gStats.XP2;
      gStats.XP2 = gStats.XP1;
      gStats.XP1 = xp;
      gStats.XPPerKill = (gStats.XP1 + gStats.XP2 + gStats.XP3 + gStats.XP4) / math.min(gStats.Kills, 4);
   end
end

---------------------------------------------------------------------------
-- COMBAT_LOG_EVENT_UNFILTERED Event
---------------------------------------------------------------------------

NoxCombatStats_CombatEvents = {}
NoxCombatStats_Events["COMBAT_LOG_EVENT_UNFILTERED"] = 
function(timestamp, event, ...)
   local func = NoxCombatStats_CombatEvents[event];
   if (func) then
      func(...);
   end
end

-- this only fires for mobs that grant XP
NoxCombatStats_CombatEvents["PARTY_KILL"] = 
function(...)
   gStats.Kills = gStats.Kills + 1;
end

NoxCombatStats_CombatEvents["SPELL_CREATE"] =
function(...)
   local sourceID, sourceName, sourceFlags = select(1, ...);
   local destID, destName, destFlags = select(4, ...);

   if (sourceID == UnitGUID("PLAYER")) then
      pets[destID] = 1;
   else
      -- this handles "sub-pets", such as elementals created by
      -- elemental totems
      for id in pairs(pets) do
         if (sourceID == id) then
            pets[destID] = 1;
         end
      end
   end
end
NoxCombatStats_CombatEvents["SPELL_SUMMON"] = NoxCombatStats_CombatEvents["SPELL_CREATE"];

NoxCombatStats_CombatEvents["UNIT_DIED"] = 
function(...)
   local destID, destName, destFlags = select(4, ...);
   pets[destID] = nil;
end
NoxCombatStats_CombatEvents["UNIT_DESTROYED"] = NoxCombatStats_CombatEvents["UNIT_DIED"];

NoxCombatStats_CombatEvents["SWING_DAMAGE"] = 
function(...)
   local sourceID, sourceName, sourceFlags = select(1, ...);
   local destID, destName, destFlags = select(4, ...);
   local amount, overkill, school = select(7, ...);
   local resisted, blocked, absorbed = select(10, ...);
   local critical, glancing, crushing = select(13, ...);

   if (sourceID == UnitGUID("PLAYER")) then
      cStats.MeleeDamage  = cStats.MeleeDamage + amount;
      cStats.MeleeHits    = cStats.MeleeHits   + 1;
      sStats.MeleeDamage = sStats.MeleeDamage + amount;
      sStats.MeleeHits   = sStats.MeleeHits   + 1;
      
      if (critical) then
         cStats.MeleeCrits  = cStats.MeleeCrits + 1;
         sStats.MeleeCrits = sStats.MeleeCrits + 1;
      end
   elseif (sourceID == UnitGUID("PET") or pets[sourceID]) then
      cStats.PetDamage = cStats.PetDamage + amount;
      sStats.PetDamage = sStats.PetDamage + amount;
   end
end

NoxCombatStats_CombatEvents["SWING_MISSED"] = 
function(...)
   local sourceID, sourceName, sourceFlags = select(1, ...);

   if (sourceID == UnitGUID("PLAYER")) then
      cStats.MeleeMisses = cStats.MeleeMisses + 1;
      sStats.MeleeMisses = sStats.MeleeMisses + 1;
   end
end

-- ranged counts as melee (it's not "spells")
NoxCombatStats_CombatEvents["RANGE_DAMAGE"] = 
function(...)
   local sourceID, sourceName, sourceFlags = select(1, ...);
   local destID, destName, destFlags = select(4, ...);
   local spellID, spellName, spellSchool = select(7, ...);
   local amount, overkill, school = select(10, ...);

   if (sourceID == UnitGUID("PLAYER")) then
      local resisted, blocked, absorbed = select(13, ...);
      local critical, glancing, crushing = select(16, ...);

      cStats.MeleeDamage  = cStats.MeleeDamage + amount;
      cStats.MeleeHits    = cStats.MeleeHits   + 1;
      sStats.MeleeDamage = sStats.MeleeDamage + amount;
      sStats.MeleeHits   = sStats.MeleeHits   + 1;

      if (critical) then
         cStats.MeleeCrits  = cStats.MeleeCrits + 1;
         sStats.MeleeCrits = sStats.MeleeCrits + 1;
      end
   elseif (sourceID == UnitGUID("PET") or pets[sourceID]) then
      cStats.PetDamage = cStats.PetDamage + amount;
      sStats.PetDamage = sStats.PetDamage + amount;
   end
end

NoxCombatStats_CombatEvents["RANGE_MISSED"] = 
function(...)
   local sourceID, sourceName, sourceFlags = select(1, ...);

   if (sourceID == UnitGUID("PLAYER")) then
      cStats.MeleeMisses = cStats.MeleeMisses + 1;
      sStats.MeleeMisses = sStats.MeleeMisses + 1;
   end
end

NoxCombatStats_CombatEvents["SPELL_DAMAGE"] =
function(...)
   local sourceID, sourceName, sourceFlags = select(1, ...);
   local destID, destName, destFlags = select(4, ...);
   local spellID, spellName, spellSchool = select(7, ...);
   local amount, overkill, school = select(10, ...);

   if (sourceID == UnitGUID("PLAYER")) then
      local resisted, blocked, absorbed = select(13, ...);
      local critical, glancing, crushing = select(16, ...);

      cStats.NonMeleeDamage = cStats.NonMeleeDamage + amount;
      cStats.NonMeleeHits   = cStats.NonMeleeHits   + 1;
      sStats.NonMeleeDamage = sStats.NonMeleeDamage + amount;
      sStats.NonMeleeHits   = sStats.NonMeleeHits   + 1;

      if (critical) then
         cStats.NonMeleeCrits = cStats.NonMeleeCrits + 1;
         sStats.NonMeleeCrits = sStats.NonMeleeCrits + 1;
      end
   elseif (sourceID == UnitGUID("PET") or pets[sourceID]) then
      cStats.PetDamage = cStats.PetDamage + amount;
      sStats.PetDamage = sStats.PetDamage + amount;
   end
end

NoxCombatStats_CombatEvents["SPELL_MISSED"] =
function(...)
   local sourceID, sourceName, sourceFlags = select(1, ...);

   if (sourceID == UnitGUID("PLAYER")) then
      cStats.NonMeleeMisses = cStats.NonMeleeMisses + 1;
      sStats.NonMeleeMisses = sStats.NonMeleeMisses + 1;
   end
end

-- I don't know if this will miss the initial "hit" from the cast
NoxCombatStats_CombatEvents["SPELL_PERIODIC_DAMAGE"] =
function(...)
   local sourceID, sourceName, sourceFlags = select(1, ...);
   local destID, destName, destFlags = select(4, ...);
   local spellID, spellName, spellSchool = select(7, ...);
   local amount, overkill, school = select(10, ...);

   if (sourceID == UnitGUID("PLAYER")) then
      local resisted, blocked, absorbed = select(13, ...);
      local critical, glancing, crushing = select(16, ...);

      cStats.NonMeleeDamage = cStats.NonMeleeDamage + amount;
      --cStats.NonMeleeHits   = cStats.NonMeleeHits   + 1;
      sStats.NonMeleeDamage = sStats.NonMeleeDamage + amount;
      --sStats.NonMeleeHits   = sStats.NonMeleeHits   + 1;

      if (critical) then
         cStats.NonMeleeCrits = cStats.NonMeleeCrits + 1;
         sStats.NonMeleeCrits = sStats.NonMeleeCrits + 1;
      end
   elseif (sourceID == UnitGUID("PET") or pets[sourceID]) then
      cStats.PetDamage = cStats.PetDamage + amount;
      sStats.PetDamage = sStats.PetDamage + amount;
   end
end

NoxCombatStats_CombatEvents["SPELL_PERIODIC_MISSED"] =
function(...)
   local sourceID, sourceName, sourceFlags = select(1, ...);

   if (sourceID == UnitGUID("PLAYER")) then
      --cStats.NonMeleeMisses = cStats.NonMeleeMisses + 1;
      --sStats.NonMeleeMisses = sStats.NonMeleeMisses + 1;
   end
end

NoxCombatStats_CombatEvents["SPELL_HEAL"] =
function(...)
   if (gStats.InCombat) then
      local sourceID, sourceName, sourceFlags = select(1, ...);
      local destID, destName, destFlags = select(4, ...);
      local spellID, spellName, spellSchool = select(7, ...);
      local amount, overheal, critical = select(10, ...);

      if (sourceID == UnitGUID("PLAYER")) then
         cStats.Healed   = cStats.Healed   + amount;
         cStats.HealHits = cStats.HealHits + 1;
         sStats.Healed   = sStats.Healed   + amount;
         sStats.HealHits = sStats.HealHits + 1;

         if (critical) then
            cStats.HealCrits = cStats.HealCrits + 1;
            sStats.HealCrits = sStats.HealCrits + 1;
         end
      end
   end
end

NoxCombatStats_CombatEvents["SPELL_PERIODIC_HEAL"] =
function(...)
   if (gStats.InCombat) then
      local sourceID, sourceName, sourceFlags = select(1, ...);
      local destID, destName, destFlags = select(4, ...);
      local spellID, spellName, spellSchool = select(7, ...);
      local amount, overheal, critical = select(10, ...);

      if (sourceID == UnitGUID("PLAYER")) then
         cStats.Healed   = cStats.Healed   + amount;
         sStats.Healed   = sStats.Healed   + amount;
      end
   end
end

---------------------------------------------------------------------------
-- NoxCombatStats - Enter / Leave Combat
---------------------------------------------------------------------------

function NoxCombatStats_EnterCombat()
   if (not gStats.InCombat) then
      gStats.InCombat       = 1;
      cStats.MeleeDamage    = 0;
      cStats.NonMeleeDamage = 0;
      cStats.Healed         = 0;
      cStats.PetDamage      = 0;
      cStats.MeleeHits      = 0;
      cStats.NonMeleeHits   = 0;
      cStats.HealHits       = 0;
      cStats.MeleeCrits     = 0;
      cStats.NonMeleeCrits  = 0;
      cStats.HealCrits      = 0;
      cStats.MeleeMisses    = 0;
      cStats.NonMeleeMisses = 0;
      cStats.HealMisses     = 0;
      -- copy previous time to session
      sStats.CombatTime = sStats.CombatTime + gStats.CombatEnd - gStats.CombatStart;
      gStats.CombatStart    = GetTime();
      gStats.CombatEnd      = 0;
   end
end

function NoxCombatStats_LeaveCombat()
   if (gStats.InCombat) then
      gStats.CombatEnd = GetTime();
      gStats.InCombat  = nil;
   end
end

function NoxCombatStats_ResetSession()
   gStats.InCombat        = nil;
   gStats.CombatStart     = 0;
   gStats.CombatEnd       = 0;

   gStats.Kills           = 0;
   gStats.XP              = 0;
   gStats.XPPerKill       = 0;
   gStats.XP1             = 0;
   gStats.XP2             = 0;
   gStats.XP3             = 0;
   gStats.XP4             = 0;

   cStats.MeleeDamage     = 0;
   cStats.NonMeleeDamage  = 0;
   cStats.Healed          = 0;
   cStats.PetDamage       = 0;
   cStats.MeleeHits       = 0;
   cStats.NonMeleeHits    = 0;
   cStats.HealHits        = 0;
   cStats.MeleeCrits      = 0;
   cStats.NonMeleeCrits   = 0;
   cStats.HealCrits       = 0;
   cStats.MeleeMisses     = 0;
   cStats.NonMeleeMisses  = 0;
   cStats.HealMisses      = 0;

   sStats.MeleeDamage     = 0;
   sStats.NonMeleeDamage  = 0;
   sStats.PetDamage       = 0;
   sStats.Healed          = 0;
   sStats.MeleeHits       = 0;
   sStats.NonMeleeHits    = 0;
   sStats.HealHits        = 0;
   sStats.MeleeCrits      = 0;
   sStats.NonMeleeCrits   = 0;
   sStats.HealCrits       = 0;
   sStats.MeleeMisses     = 0;
   sStats.NonMeleeMisses  = 0;
   sStats.HealMisses      = 0;
   sStats.CombatTime      = 0;
end

---------------------------------------------------------------------------
-- NoxCombatStats - Report Functions - Current combat
---------------------------------------------------------------------------

function NoxCombatStats_GetDPS(format)
   local CombatEnd = gStats.CombatEnd;
   if (CombatEnd == 0 and gStats.CombatStart > 0) then
      CombatEnd = GetTime();
   end

   if (not (CombatEnd > gStats.CombatStart)) then
      return NOX_IB.Messages.NotAvailable;
   end

   return NoxInformationBar_FormatNumber((cStats.MeleeDamage + cStats.NonMeleeDamage + cStats.PetDamage) / (CombatEnd - gStats.CombatStart), format, NOX_IB.Format.Decimal);
end

function NoxCombatStats_GetHPS(format)
   local CombatEnd = gStats.CombatEnd;
   if (CombatEnd == 0 and gStats.CombatStart > 0) then
      CombatEnd = GetTime();
   end

   if (not (CombatEnd > gStats.CombatStart)) then
      return NOX_IB.Messages.NotAvailable;
   end

   return NoxInformationBar_FormatNumber(cStats.Healed / (CombatEnd - gStats.CombatStart), format, NOX_IB.Format.Decimal);
end

function NoxCombatStats_GetPetDPS(format)
   local CombatEnd = gStats.CombatEnd;
   if (CombatEnd == 0 and gStats.CombatStart > 0) then
      CombatEnd = GetTime();
   end

   if (not (CombatEnd > gStats.CombatStart)) then
      return NOX_IB.Messages.NotAvailable;
   end

   return NoxInformationBar_FormatNumber(cStats.PetDamage / (CombatEnd - gStats.CombatStart), format, NOX_IB.Format.Decimal);
end

function NoxCombatStats_GetTotalDamage(format)
   return cStats.MeleeDamage + cStats.NonMeleeDamage + cStats.PetDamage;
end

function NoxCombatStats_GetTotalHeal(format)
   return cStats.Healed;
end

function NoxCombatStats_GetCombatDuration(format)
   local CombatEnd = gStats.CombatEnd;
   if (CombatEnd == 0 and gStats.CombatStart > 0) then
      CombatEnd = GetTime();
   end

   if (not (CombatEnd > gStats.CombatStart)) then
      return NOX_IB.Messages.NotAvailable;
   end

   return NoxInformationBar_FormatNumber(CombatEnd - gStats.CombatStart, format, NOX_IB.Format.Decimal);
end

function NoxCombatStats_GetMeleeHits(format)
   return cStats.MeleeHits;
end

function NoxCombatStats_GetMeleeMisses(format)
   return cStats.MeleeMisses;
end

function NoxCombatStats_GetMeleeCriticals(format)
   return cStats.MeleeCrits;
end

function NoxCombatStats_GetMeleeHitsPercentage(format)
   if (not (cStats.MeleeHits + cStats.MeleeMisses > 0)) then
      return NOX_IB.Messages.NotAvailable;
   end

   return NoxInformationBar_FormatNumber((cStats.MeleeHits * 100) / (cStats.MeleeHits + cStats.MeleeMisses), format, NOX_IB.Format.Decimal);
end

function NoxCombatStats_GetMeleeMissesPercentage(format)
   if (not (cStats.MeleeHits + cStats.MeleeMisses > 0)) then
      return NOX_IB.Messages.NotAvailable;
   end

   return NoxInformationBar_FormatNumber((cStats.MeleeMisses * 100) / (cStats.MeleeHits + cStats.MeleeMisses), format, NOX_IB.Format.Decimal);
end

function NoxCombatStats_GetMeleeCriticalsPercentage(format)
   if (not (cStats.MeleeHits + cStats.MeleeMisses > 0)) then
      return NOX_IB.Messages.NotAvailable;
   end

   return NoxInformationBar_FormatNumber((cStats.MeleeCrits * 100) / (cStats.MeleeHits + cStats.MeleeMisses), format, NOX_IB.Format.Decimal);
end

function NoxCombatStats_GetNonMeleeHits(format)
   return cStats.NonMeleeHits;
end

function NoxCombatStats_GetNonMeleeMisses(format)
   return cStats.NonMeleeMisses;
end

function NoxCombatStats_GetNonMeleeCriticals(format)
   return cStats.NonMeleeCrits;
end

function NoxCombatStats_GetNonMeleeHitsPercentage(format)
   if (not (cStats.NonMeleeHits + cStats.NonMeleeMisses > 0)) then
      return NOX_IB.Messages.NotAvailable;
   end

   return NoxInformationBar_FormatNumber((cStats.NonMeleeHits * 100) / (cStats.NonMeleeHits + cStats.NonMeleeMisses), format, NOX_IB.Format.Decimal);
end

function NoxCombatStats_GetNonMeleeMissesPercentage(format)
   if (not (cStats.NonMeleeHits + cStats.NonMeleeMisses > 0)) then
      return NOX_IB.Messages.NotAvailable;
   end

   return NoxInformationBar_FormatNumber((cStats.NonMeleeMisses * 100) / (cStats.NonMeleeHits + cStats.NonMeleeMisses), format, NOX_IB.Format.Decimal);
end

function NoxCombatStats_GetNonMeleeCriticalsPercentage(format)
   if (not (cStats.NonMeleeHits + cStats.NonMeleeMisses > 0)) then
      return NOX_IB.Messages.NotAvailable;
   end

   return NoxInformationBar_FormatNumber((cStats.NonMeleeCrits * 100) / (cStats.NonMeleeHits + cStats.NonMeleeMisses), format, NOX_IB.Format.Decimal);
end

function NoxCombatStats_GetHealHits(format)
   return cStats.HealHits;
end

function NoxCombatStats_GetHealMisses(format)
   return cStats.HealMisses;
end

function NoxCombatStats_GetHealCriticals(format)
   return cStats.HealCrits;
end

function NoxCombatStats_GetHealHitsPercentage(format)
   if (not (cStats.HealHits + cStats.HealMisses > 0)) then
      return NOX_IB.Messages.NotAvailable;
   end

   return NoxInformationBar_FormatNumber((cStats.HealHits * 100) / (cStats.HealHits + cStats.HealMisses), format, NOX_IB.Format.Decimal);
end

function NoxCombatStats_GetHealMissesPercentage(format)
   if (not (cStats.HealHits + cStats.HealMisses > 0)) then
      return NOX_IB.Messages.NotAvailable;
   end

   return NoxInformationBar_FormatNumber((cStats.HealMisses * 100) / (cStats.HealHits + cStats.HealMisses), format, NOX_IB.Format.Decimal);
end

function NoxCombatStats_GetHealCriticalsPercentage(format)
   if (not (cStats.HealHits + cStats.HealMisses > 0)) then
      return NOX_IB.Messages.NotAvailable;
   end

   return NoxInformationBar_FormatNumber((cStats.HealCrits * 100) / (cStats.HealHits + cStats.HealMisses), format, NOX_IB.Format.Decimal);
end

---------------------------------------------------------------------------
-- NoxCombatStats - Report Functions - Session
---------------------------------------------------------------------------

function NoxCombatStats_GetSessionDPS(format)
   local CombatEnd = gStats.CombatEnd;
   if (CombatEnd == 0 and gStats.CombatStart > 0) then
      CombatEnd = GetTime();
   end

   if (not (CombatEnd > gStats.CombatStart)) then
      return NOX_IB.Messages.NotAvailable;
   end

   return NoxInformationBar_FormatNumber((sStats.MeleeDamage + sStats.NonMeleeDamage + sStats.PetDamage) / (sStats.CombatTime + CombatEnd - gStats.CombatStart), format, NOX_IB.Format.Decimal);
end

function NoxCombatStats_GetSessionHPS(format)
   local CombatEnd = gStats.CombatEnd;
   if (CombatEnd == 0 and gStats.CombatStart > 0) then
      CombatEnd = GetTime();
   end

   if (not (CombatEnd > gStats.CombatStart)) then
      return NOX_IB.Messages.NotAvailable;
   end

   return NoxInformationBar_FormatNumber(sStats.Healed / (sStats.CombatTime + CombatEnd - gStats.CombatStart), format, NOX_IB.Format.Decimal);
end

function NoxCombatStats_GetSessionPetDPS(format)
   local CombatEnd = gStats.CombatEnd;
   if (CombatEnd == 0 and gStats.CombatStart > 0) then
      CombatEnd = GetTime();
   end

   if (not (CombatEnd > gStats.CombatStart)) then
      return NOX_IB.Messages.NotAvailable;
   end

   return NoxInformationBar_FormatNumber(sStats.PetDamage / (sStats.CombatTime + CombatEnd - gStats.CombatStart), format, NOX_IB.Format.Decimal);
end

function NoxCombatStats_GetSessionTotalDamage(format)
   return sStats.MeleeDamage + sStats.NonMeleeDamage + sStats.PetDamage;
end

function NoxCombatStats_GetSessionTotalHeal(format)
   return sStats.Healed;
end

function NoxCombatStats_GetSessionCombatDuration(format)
   local CombatEnd = gStats.CombatEnd;
   if (CombatEnd == 0 and gStats.CombatStart > 0) then
      CombatEnd = GetTime();
   end

   if (not (CombatEnd > gStats.CombatStart)) then
      return NOX_IB.Messages.NotAvailable;
   end

   return NoxInformationBar_FormatNumber(sStats.CombatTime + CombatEnd - gStats.CombatStart, format, NOX_IB.Format.Decimal);
end

function NoxCombatStats_GetSessionMeleeHits(format)
   return sStats.MeleeHits;
end

function NoxCombatStats_GetSessionMeleeMisses(format)
   return sStats.MeleeMisses;
end

function NoxCombatStats_GetSessionMeleeCriticals(format)
   return sStats.MeleeCrits;
end

function NoxCombatStats_GetSessionMeleeHitsPercentage(format)
   if (not (sStats.MeleeHits + sStats.MeleeMisses > 0)) then
      return NOX_IB.Messages.NotAvailable;
   end

   return NoxInformationBar_FormatNumber((sStats.MeleeHits * 100) / (sStats.MeleeHits + sStats.MeleeMisses), format, NOX_IB.Format.Decimal);
end

function NoxCombatStats_GetSessionMeleeMissesPercentage(format)
   if (not (sStats.MeleeHits + sStats.MeleeMisses > 0)) then
      return NOX_IB.Messages.NotAvailable;
   end

   return NoxInformationBar_FormatNumber((sStats.MeleeMisses * 100) / (sStats.MeleeHits + sStats.MeleeMisses), format, NOX_IB.Format.Decimal);
end

function NoxCombatStats_GetSessionMeleeCriticalsPercentage(format)
   if (not (sStats.MeleeHits + sStats.MeleeMisses > 0)) then
      return NOX_IB.Messages.NotAvailable;
   end

   return NoxInformationBar_FormatNumber((sStats.MeleeCrits * 100) / (sStats.MeleeHits + sStats.MeleeMisses), format, NOX_IB.Format.Decimal);
end

function NoxCombatStats_GetSessionNonMeleeHits(format)
   return sStats.NonMeleeHits;
end

function NoxCombatStats_GetSessionNonMeleeMisses(format)
   return sStats.NonMeleeMisses;
end

function NoxCombatStats_GetSessionNonMeleeCriticals(format)
   return sStats.NonMeleeCrits;
end

function NoxCombatStats_GetSessionNonMeleeHitsPercentage(format)
   if (not (sStats.NonMeleeHits + sStats.NonMeleeMisses > 0)) then
      return NOX_IB.Messages.NotAvailable;
   end

   return NoxInformationBar_FormatNumber((sStats.NonMeleeHits * 100) / (sStats.NonMeleeHits + sStats.NonMeleeMisses), format, NOX_IB.Format.Decimal);
end

function NoxCombatStats_GetSessionNonMeleeMissesPercentage(format)
   if (not (sStats.NonMeleeHits + sStats.NonMeleeMisses > 0)) then
      return NOX_IB.Messages.NotAvailable;
   end

   return NoxInformationBar_FormatNumber((sStats.NonMeleeMisses * 100) / (sStats.NonMeleeHits + sStats.NonMeleeMisses), format, NOX_IB.Format.Decimal);
end

function NoxCombatStats_GetSessionNonMeleeCriticalsPercentage(format)
   if (not (sStats.NonMeleeHits + sStats.NonMeleeMisses > 0)) then
      return NOX_IB.Messages.NotAvailable;
   end

   return NoxInformationBar_FormatNumber((sStats.NonMeleeCrits * 100) / (sStats.NonMeleeHits + sStats.NonMeleeMisses), format, NOX_IB.Format.Decimal);
end

function NoxCombatStats_GetSessionHealHits(format)
   return sStats.HealHits;
end

function NoxCombatStats_GetSessionHealMisses(format)
   return sStats.HealMisses;
end

function NoxCombatStats_GetSessionHealCriticals(format)
   return sStats.HealCrits;
end

function NoxCombatStats_GetSessionHealHitsPercentage(format)
   if (not (sStats.HealHits + sStats.HealMisses > 0)) then
      return NOX_IB.Messages.NotAvailable;
   end

   return NoxInformationBar_FormatNumber((sStats.HealHits * 100) / (sStats.HealHits + sStats.HealMisses), format, NOX_IB.Format.Decimal);
end

function NoxCombatStats_GetSessionHealMissesPercentage(format)
   if (not (sStats.HealHits + sStats.HealMisses > 0)) then
      return NOX_IB.Messages.NotAvailable;
   end

   return NoxInformationBar_FormatNumber((sStats.HealMisses * 100) / (sStats.HealHits + sStats.HealMisses), format, NOX_IB.Format.Decimal);
end

function NoxCombatStats_GetSessionHealCriticalsPercentage(format)
   if (not (sStats.HealHits + sStats.HealMisses > 0)) then
      return NOX_IB.Messages.NotAvailable;
   end

   return NoxInformationBar_FormatNumber((sStats.HealCrits * 100) / (sStats.HealHits + sStats.HealMisses), format, NOX_IB.Format.Decimal);
end

function NoxCombatStats_GetNumKills(format)
   return gStats.Kills;
end

function NoxCombatStats_GetXP(format)
   return gStats.XP;
end

function NoxCombatStats_GetXPPerKill(format)
   if (gStats.Kills > 0) then
      return NoxInformationBar_FormatNumber(gStats.XPPerKill, format, NOX_IB.Format.Decimal);
   else
      return NOX_IB.Messages.NotAvailable;
   end
end

function NoxCombatStats_GetKillsToLevel(format)
   if (gStats.XPPerKill > 0) then
      local xpToGo = UnitXPMax("player") - UnitXP("player");
      return math.ceil(xpToGo / gStats.XPPerKill);
   else
      return NOX_IB.Messages.NotAvailable;
   end
end
