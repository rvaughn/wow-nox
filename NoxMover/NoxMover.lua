---------------------------------------------------------------------------
-- Nox Move Buffs
--
-- Moves buff icons to make room for the Info Bar
--
-- @author Gruma
---------------------------------------------------------------------------

NoxMoverDefaults = {
   buffs = {
      on = true;
      x = -24;
      y = -24;
   },
   bgflag = {
     on = false;
     x = 0;
     y = -24;
   },     
   minimap = {
     on = false;
     x = 0;
     y = -24;
   },     
   player = {
     on = false;
     x = 0;
     y = -24;
   },     
   target = {
     on = false;
     x = 0;
     y = -24;
   },
};

NoxMoverConfig = {};

function NoxMover_OnLoad(self)
   self:RegisterEvent("VARIABLES_LOADED");
end

function NoxMover_OnEvent(self, event, ...)
   if (event == "VARIABLES_LOADED") then
      NoxMover_DuplicateTable(NoxMoverDefaults, NoxMoverConfig);
      NoxMover_PlaceFrames();
   end
end

function NoxMover_PlaceFrames()
   NoxMover_PlaceBuffs();
   NoxMover_PlaceBGFlag();
   NoxMover_PlacePlayer();
   NoxMover_PlaceTarget();
   NoxMover_PlaceMinimap();
end

function NoxMover_OnUpdate(self, elapsed)
   NoxMover_UpdateBuffs();
   NoxMover_UpdateBGFlag();
   NoxMover_UpdatePlayer();
   NoxMover_UpdateTarget();
   NoxMover_UpdateMinimap();
end

function NoxMover_PlaceBuffs()
   local xpos = round(TemporaryEnchantFrame:GetRight() - UIParent:GetRight());
   local ypos = round(TemporaryEnchantFrame:GetTop() - UIParent:GetTop());

   NoxBuffsFrame:ClearAllPoints();
   NoxBuffsFrame:SetPoint("TOPRIGHT", "UIParent", "TOPRIGHT", xpos, ypos);
end

function NoxMover_UpdateBuffs()
   local x = 0;
   local y = 0;

   if (NoxMoverConfig.buffs.on) then
      x = NoxMoverConfig.buffs.x;
      y = NoxMoverConfig.buffs.y;
   end

   if (round(TemporaryEnchantFrame:GetTop()) ~= round(NoxBuffsFrame:GetTop() + y) or 
       round(TemporaryEnchantFrame:GetRight()) ~= round(NoxBuffsFrame:GetRight() + x)) then
      NoxMover_MoveBuffs(x, y);
   end
end

function NoxMover_MoveBuffs(x, y)
   TemporaryEnchantFrame:ClearAllPoints();
   TemporaryEnchantFrame:SetPoint("TOPRIGHT", "NoxBuffsFrame", "TOPRIGHT", x, y);
end

function NoxMover_PlaceBGFlag()
   local xpos = round(WorldStateAlwaysUpFrame:GetLeft() + (WorldStateAlwaysUpFrame:GetWidth() / 2) - (UIParent:GetRight() / 2));
   local ypos = round(WorldStateAlwaysUpFrame:GetTop() - UIParent:GetTop());

   NoxBGFlagFrame:ClearAllPoints();
   NoxBGFlagFrame:SetPoint("TOP", "UIParent", "TOP", xpos, ypos);
end

function NoxMover_UpdateBGFlag()
   local x = 0;
   local y = 0;

   if (NoxMoverConfig.bgflag.on) then
      x = NoxMoverConfig.bgflag.x;
      y = NoxMoverConfig.bgflag.y;
   end

   if ((round(WorldStateAlwaysUpFrame:GetLeft() + (WorldStateAlwaysUpFrame:GetWidth() / 2)) ~= round(NoxBGFlagFrame:GetLeft() + x)) or
       (round(WorldStateAlwaysUpFrame:GetTop()) ~= round(NoxBGFlagFrame:GetTop() + y))) then
      NoxMover_MoveBGFlag(x, y);
   end
end

function NoxMover_MoveBGFlag(x, y)
   WorldStateAlwaysUpFrame:ClearAllPoints();
   WorldStateAlwaysUpFrame:SetPoint("TOP", "NoxBGFlagFrame", "TOPLEFT", x, y);
end

function NoxMover_PlaceMinimap()
   local xpos = round(MinimapCluster:GetRight() - UIParent:GetRight());
   local ypos = round(MinimapCluster:GetTop() - UIParent:GetTop());

   NoxMinimapFrame:ClearAllPoints();
   NoxMinimapFrame:SetPoint("TOPRIGHT", "UIParent", "TOPRIGHT", xpos, ypos);
end

function NoxMover_UpdateMinimap()
   local x = 0;
   local y = 0;

   if (NoxMoverConfig.minimap.on) then
      x = NoxMoverConfig.minimap.x;
      y = NoxMoverConfig.minimap.y;
   end

   if (round(MinimapCluster:GetTop()) ~= round(NoxMinimapFrame:GetTop() + y) or 
       round(MinimapCluster:GetRight()) ~= round(NoxMinimapFrame:GetRight() + x)) then
      NoxMover_MoveMinimap(x, y);
   end
end

function NoxMover_MoveMinimap(x, y)
   MinimapCluster:ClearAllPoints();
   MinimapCluster:SetPoint("TOPRIGHT", "NoxMinimapFrame", "TOPRIGHT", x, y);
end

function NoxMover_PlacePlayer()
   local xpos = round(PlayerFrame:GetLeft());
   local ypos = round(PlayerFrame:GetTop() - UIParent:GetTop());

   NoxPlayerFrame:ClearAllPoints();
   NoxPlayerFrame:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", xpos, ypos);
end

function NoxMover_UpdatePlayer()
   local x = 0;
   local y = 0;

   if (NoxMoverConfig.player.on) then
      x = NoxMoverConfig.player.x;
      y = NoxMoverConfig.player.y;
   end

   if (round(PlayerFrame:GetTop()) ~= round(NoxPlayerFrame:GetTop() + y) or 
       round(PlayerFrame:GetLeft()) ~= round(NoxPlayerFrame:GetLeft() + x)) then
      NoxMover_MovePlayer(x, y);
   end
end

function NoxMover_MovePlayer(x, y)
   PlayerFrame:ClearAllPoints();
   PlayerFrame:SetPoint("TOPLEFT", "NoxPlayerFrame", "TOPLEFT", x, y);
end

function NoxMover_PlaceTarget()
   local xpos = round(TargetFrame:GetLeft());
   local ypos = round(TargetFrame:GetTop() - UIParent:GetTop());

   NoxTargetFrame:ClearAllPoints();
   NoxTargetFrame:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", xpos, ypos);
end

function NoxMover_UpdateTarget()
   local x = 0;
   local y = 0;

   if (NoxMoverConfig.target.on) then
      x = NoxMoverConfig.target.x;
      y = NoxMoverConfig.target.y;
   end

   if (round(TargetFrame:GetTop()) ~= round(NoxTargetFrame:GetTop() + y) or 
       round(TargetFrame:GetLeft()) ~= round(NoxTargetFrame:GetLeft() + x)) then
      NoxMover_MoveTarget(x, y);
   end
end

function NoxMover_MoveTarget(x, y)
   TargetFrame:ClearAllPoints();
   TargetFrame:SetPoint("TOPLEFT", "NoxTargetFrame", "TOPLEFT", x, y);
end

if (not round) then
   function round(value)
      return floor(value + 0.5);
   end
end

if (NoxInformationBar_DuplicateTable) then
   NoxMover_DuplicateTable = NoxInformationBar_DuplicateTable;
else
   function NoxMover_DuplicateTable(src, dst, overwrite)
      -- warning: this function assumes that dst has tables
      -- in the same keys as src.  If dst has a scalar value
      -- at the same key src has a table value, an error will occur
   
      dst = dst or {};

      for k,v in pairs(src) do
         if (type(v) == "table") then
            dst[k] = NoxMover_DuplicateTable(v, dst[k], overwrite);
         elseif (dst[k] == nil or overwrite) then
            dst[k] = v;
         end
      end

      return dst;
   end
end

