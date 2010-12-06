---------------------------------------------------------------------------
-- Nox Honor Stats
--
-- Makes honor stats available to the Nox Information Bar
--
-- @author   Gruma
---------------------------------------------------------------------------

---------------------------------------------------------------------------
-- Variables
---------------------------------------------------------------------------

local Original_NoxInformationBar_InitFormats;

NoxHonorStats = {
   session = {
      hk = 0,
   --   dk = 0,
      cp = 0,
   },
   yesterday = {
      hk = 0,
   --   dk = 0,
      cp = 0,
   },
   --thisweek = {
   --   hk = 0,
   --   cp = 0,
   --},
   --lastweek = {
   --   hk = 0,
   --   dk = 0,
   --   cp = 0,
   --   standing = NONE,
   --},
   lifetime = {
      hk = 0,
   --   dk = 0,
      rank = NONE,
   },
   current = {
      rank = NONE,
      standing = 0,
      progress = 0,
   },
};

---------------------------------------------------------------------------
-- Initialization
---------------------------------------------------------------------------

function NoxHonorStats_OnLoad(self)
   -- hook needed functions
   Original_NoxInformationBar_InitFormats = NoxInformationBar_InitFormats;
   NoxInformationBar_InitFormats = NoxHonorStats_InitFormats;

   -- register events we need
   self:RegisterEvent("PLAYER_ENTERING_WORLD");
   self:RegisterEvent("PLAYER_PVP_KILLS_CHANGED");
   self:RegisterEvent("PLAYER_PVP_RANK_CHANGED");
end

function NoxHonorStats_InitFormats()
   -- set up the base table first
   Original_NoxInformationBar_InitFormats();

   -- add new codes
   NoxInformationBar_AddFormats(
      { code = NOX_HS_PARAM.todayhk,          func = NoxHonorStats_GetSessionHK },
      --{ code = NOX_HS_PARAM.todaydk,          func = NoxHonorStats_GetSessionDK },
      { code = NOX_HS_PARAM.todayhonor,       func = NoxHonorStats_GetSessionCP },

      { code = NOX_HS_PARAM.yesterdayhk,      func = NoxHonorStats_GetYesterdayHK },
      --{ code = NOX_HS_PARAM.yesterdaydk,      func = NoxHonorStats_GetYesterdayDK },
      { code = NOX_HS_PARAM.yesterdayhonor,   func = NoxHonorStats_GetYesterdayCP },

      --{ code = NOX_HS_PARAM.thisweekhk,       func = NoxHonorStats_GetThisWeekHK },
      --{ code = NOX_HS_PARAM.thisweekhonor,    func = NoxHonorStats_GetThisWeekCP },

      --{ code = NOX_HS_PARAM.lastweekhk,       func = NoxHonorStats_GetLastWeekHK },
      --{ code = NOX_HS_PARAM.lastweekdk,       func = NoxHonorStats_GetLastWeekDK },
      --{ code = NOX_HS_PARAM.lastweekstanding, func = NoxHonorStats_GetLastWeekStanding },
      --{ code = NOX_HS_PARAM.lastweekhonor,    func = NoxHonorStats_GetLastWeekCP },

      { code = NOX_HS_PARAM.lifetimehk,       func = NoxHonorStats_GetLifetimeHK },
      --{ code = NOX_HS_PARAM.lifetimedk,       func = NoxHonorStats_GetLifetimeDK },
      { code = NOX_HS_PARAM.lifetimerank,     func = NoxHonorStats_GetLifetimeRank },

      { code = NOX_HS_PARAM.currentrank,      func = NoxHonorStats_GetCurrentRank },
      { code = NOX_HS_PARAM.currentstanding,  func = NoxHonorStats_GetCurrentStanding },
      { code = NOX_HS_PARAM.rankprogress,     func = NoxHonorStats_GetRankProgress },

      -- deprecated variables
      { code = NOX_HS_PARAM.yesterdaycp,      func = NoxHonorStats_GetYesterdayCP },
      --{ code = NOX_HS_PARAM.lastweekcp,       func = NoxHonorStats_GetLastWeekCP },
      { code = NOX_HS_PARAM.sessionhk,        func = NoxHonorStats_GetSessionHK }
      --{ code = NOX_HS_PARAM.sessiondk,        func = NoxHonorStats_GetSessionDK }
   );
end

---------------------------------------------------------------------------
-- Event Handlers
---------------------------------------------------------------------------

function NoxHonorStats_OnEvent(self, event, ...)
   if (event == "PLAYER_PVP_KILLS_CHANGED" or event == "PLAYER_PVP_RANK_CHANGED") then
      NoxHonorStats_UpdateSessionStats();
   elseif (event == "PLAYER_ENTERING_WORLD") then
      NoxHonorStats_UpdateHistoricalStats();
      NoxHonorStats_UpdateSessionStats();
   end
end

function NoxHonorStats_UpdateHistoricalStats()
   NoxHonorStats.yesterday.hk, NoxHonorStats.yesterday.cp = GetPVPYesterdayStats();
   --NoxHonorStats.thisweek.hk, NoxHonorStats.thisweek.cp = GetPVPThisWeekStats();
   --NoxHonorStats.lastweek.hk, NoxHonorStats.lastweek.dk, NoxHonorStats.lastweek.cp, NoxHonorStats.lastweek.rank = GetPVPLastWeekStats();
end

function NoxHonorStats_UpdateSessionStats()
   local lifetimeRank, rankNumber;

   NoxHonorStats.session.hk, NoxHonorStats.session.cp = GetPVPSessionStats();

   NoxHonorStats.lifetime.hk, lifetimeRank = GetPVPLifetimeStats();
   NoxHonorStats.lifetime.rank, rankNumber = GetPVPRankInfo(lifetimeRank);
   if (not NoxHonorStats.lifetime.rank) then
      NoxHonorStats.lifetime.rank = NONE;
   end

   NoxHonorStats.current.rank, NoxHonorStats.current.standing = GetPVPRankInfo(UnitPVPRank("player"));
   if (not NoxHonorStats.current.rank) then
      NoxHonorStats.current.rank = NONE;
   end

   NoxHonorStats.current.progress = GetPVPRankProgress() * 100;
end

---------------------------------------------------------------------------
-- Data functions
---------------------------------------------------------------------------

function NoxHonorStats_GetLifetimeHK()
   return NoxHonorStats.lifetime.hk;
end

--function NoxHonorStats_GetLifetimeDK()
--   return NoxHonorStats.lifetime.dk;
--end

function NoxHonorStats_GetLifetimeRank()
   return NoxHonorStats.lifetime.rank;
end

--function NoxHonorStats_GetLastWeekHK()
--   return NoxHonorStats.lastweek.hk;
--end

--function NoxHonorStats_GetLastWeekDK()
--   return NoxHonorStats.lastweek.dk;
--end

--function NoxHonorStats_GetLastWeekCP()
--   return NoxHonorStats.lastweek.cp;
--end

--function NoxHonorStats_GetThisWeekHK()
--   return NoxHonorStats.thisweek.hk;
--end

--function NoxHonorStats_GetThisWeekCP()
--   return NoxHonorStats.thisweek.cp;
--end

--function NoxHonorStats_GetLastWeekStanding()
--   return NoxHonorStats.lastweek.standing;
--end

function NoxHonorStats_GetYesterdayHK()
   return NoxHonorStats.yesterday.hk;
end

--function NoxHonorStats_GetYesterdayDK()
--   return NoxHonorStats.yesterday.dk;
--end

function NoxHonorStats_GetYesterdayCP()
   return NoxHonorStats.yesterday.cp;
end

function NoxHonorStats_GetSessionHK()
   return NoxHonorStats.session.hk;
end

--function NoxHonorStats_GetSessionDK()
--   return NoxHonorStats.session.dk;
--end

function NoxHonorStats_GetSessionCP()
   return NoxHonorStats.session.cp;
end

function NoxHonorStats_GetCurrentRank()
   return NoxHonorStats.current.rank;
end

function NoxHonorStats_GetCurrentStanding()
   return NoxHonorStats.current.standing;
end

function NoxHonorStats_GetRankProgress(format)
   return NoxInformationBar_FormatNumber(NoxHonorStats.current.progress, format, NOX_IB.Format.Decimal);
end
