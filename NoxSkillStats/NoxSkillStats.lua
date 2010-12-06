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
      { code = NOX_SS_PARAM.skilltitle, func = NoxSkillStats_GetSkillTitle, desc="the title for the player's current rank" },
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
--[[
   local genericName, genericNum;
   local n = GetNumSkillLines();
   for i = 1,n do
      local skillName, isHeader, isExpanded, skillRank, numTempPoints, skillModifier, skillMaxRank, isAbandonable, stepCost, rankCost, minLevel, skillCostType = GetSkillLineInfo(i);
      if (skillName) then
         if (isHeader) then
            genericName = skillName;
            genericNum = 1;
         else
            local skill = NoxSkillStats[CanonicalName(skillName)];
            if (skill) then
               skill.rank = skillRank;
               skill.max  = skillMaxRank;
            else
               skill = { name=skillName, rank=skillRank, max=skillMaxRank };
               NoxSkillStats[CanonicalName(skillName)] = skill;
            end
            NoxSkillStats[CanonicalName(genericName .. " " .. genericNum)] = skill;
            genericNum = genericNum + 1;
         end
      end
   end
]]

   local profs = GetProfessions(); -- returns primary 1, 2, arch, fishing, cooking, first aid
   for i,v in ipairs(profs) do
      local skillName, texture, skillRank, skillMaxRank, numSpells, spelloffset, skillLine = GetProfessionInfo(v);
      if skillName then
         local skill = NoxSkillStats[CanonicalName(skillName)];
         if (skill) then
            skill.rank = skillRank;
            skill.max  = skillMaxRank;
         else
            skill = { name=skillName, rank=skillRank, max=skillMaxRank };
            for i = 1,#PROFESSION_RANKS do
               local value,title = PROFESSION_RANKS[i][1], PROFESSION_RANKS[i][2];
               if skillMaxRank < value then 
                  break 
               end
              skill.title = title;
            end
            NoxSkillStats[CanonicalName(skillName)] = skill;
         end
         NoxSkillStats[CanonicalName("Profession " .. i)] = skill;
      end
   end

--[[
   local link;

   link = GetInventoryItemLink("player", GetInventorySlotInfo("MainHandSlot"));
   if (link) then
      local _, _, _, _, _, _, type = GetItemInfo(link);
      if (type) then
         type = string.gsub(type, "One.Handed ", "");
         NoxSkillStats[NOX_SS_SLOT.mainhand] = NoxSkillStats[CanonicalName(type)]; 
      else
         NoxSkillStats[NOX_SS_SLOT.mainhand] = "n/a";
      end
   end

   link = GetInventoryItemLink("player", GetInventorySlotInfo("SecondaryHandSlot"));
   if (link) then
      local _, _, _, _, _, _, type = GetItemInfo(link);
      if (type) then
         type = string.gsub(type, "One.Handed ", "");
         NoxSkillStats[NOX_SS_SLOT.offhand] = NoxSkillStats[CanonicalName(type)];
      else
         NoxSkillStats[NOX_SS_SLOT.mainhand] = "n/a";
      end
   end

   link = GetInventoryItemLink("player", GetInventorySlotInfo("RangedSlot"));
   if (link) then
      local _, _, _, _, _, _, type = GetItemInfo(link);
      if (type) then
         NoxSkillStats[NOX_SS_SLOT.ranged] = NoxSkillStats[CanonicalName(type)];
      else
         NoxSkillStats[NOX_SS_SLOT.mainhand] = "n/a";
      end
   end
]]--
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
