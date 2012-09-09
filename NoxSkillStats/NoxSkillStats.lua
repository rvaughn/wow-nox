---------------------------------------------------------------------------
-- Nox Skill Stats
--
-- Makes skill stats available to the Nox Information Bar
--
-- @author Gruma
---------------------------------------------------------------------------

---------------------------------------------------------------------------
-- Variables
---------------------------------------------------------------------------

local Original_NoxInformationBar_InitFormats;

NoxSkillStats = {};
NoxSkillEvents = {};

---------------------------------------------------------------------------
-- Initialization
---------------------------------------------------------------------------

function NoxSkillStats_OnLoad(self)
   -- hook needed functions
   Original_NoxInformationBar_InitFormats = NoxInformationBar_InitFormats;
   NoxInformationBar_InitFormats = NoxSkillStats_InitFormats;

   -- register events we need
   self:RegisterEvent("PLAYER_ENTERING_WORLD");
   self:RegisterEvent("SKILL_LINES_CHANGED");
   self:RegisterEvent("CHARACTER_POINTS_CHANGED");
end

function NoxSkillStats_InitFormats()
   -- set up the base table first
   Original_NoxInformationBar_InitFormats();

   -- add new codes
   NoxInformationBar_AddFormats(
      { code = NOX_SS_PARAM.skillrank,  func = NoxSkillStats_GetSkillRank, desc="the player's current skill level" },
      { code = NOX_SS_PARAM.skillmax,   func = NoxSkillStats_GetSkillMax,  desc="the player's current skill max" },
      { code = NOX_SS_PARAM.skillname,  func = NoxSkillStats_GetSkillName, desc="the skill name, useful for 'generic' skill lookups" },
      { code = NOX_SS_PARAM.skilltitle, func = NoxSkillStats_GetSkillTitle, desc="the title for the player's current rank" }
   );
end

local function CanonicalName(name)
   return string.lower(string.gsub(name, "%s", ""));
end

---------------------------------------------------------------------------
-- Event Handlers
---------------------------------------------------------------------------

function NoxSkillStats_OnEvent(self, event, ...)
   NoxSkillStats_UpdateSkills();
end

function NoxSkillStats_UpdateSkills()
   local profs = {GetProfessions()}; -- returns primary 1, 2, arch, fishing, cooking, first aid
   for i = 1,#profs do
      if profs[i] then
         local skillName, texture, skillRank, skillMaxRank, numSpells, spelloffset, skillLine = GetProfessionInfo(profs[i]);
         if skillName then
            local skill = NoxSkillStats[CanonicalName(skillName)];
            if (skill) then
               skill.rank = skillRank;
               skill.max  = skillMaxRank;
            else
               skill = { name=skillName, rank=skillRank, max=skillMaxRank };
               NoxSkillStats[CanonicalName(skillName)] = skill;
            end
            for i = 1,#PROFESSION_RANKS do
               local value,title = PROFESSION_RANKS[i][1], PROFESSION_RANKS[i][2];
               if skillMaxRank < value then 
                  break 
               end
               skill.title = title;
            end
            -- for compatibility with old version
            NoxSkillStats[CanonicalName("Professions " .. i)] = skill;
            -- this reads better
            NoxSkillStats[CanonicalName("Profession " .. i)] = skill;
         end
      end
   end
end

---------------------------------------------------------------------------
-- Data functions
---------------------------------------------------------------------------

function NoxSkillStats_GetSkillRank(name)
   local skill = NoxSkillStats[CanonicalName(name)];
   if (skill) then
      return skill.rank;
   else
      return 0;
   end
end

function NoxSkillStats_GetSkillMax(name)
   local skill = NoxSkillStats[CanonicalName(name)];
   if (skill) then
      return skill.max;
   else
      return 0;
   end
end

function NoxSkillStats_GetSkillName(name)
   local skill = NoxSkillStats[CanonicalName(name)];
   if (skill) then
      return skill.name;
   else
      return NOX_IB.Messages.NotAvailable;
   end
end

function NoxSkillStats_GetSkillTitle(name)
   local skill = NoxSkillStats[CanonicalName(name)];
   if (skill) then
      return skill.title;
   else
      return NOX_IB.Messages.NotAvailable;
   end
end
