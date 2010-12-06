---------------------------------------------------------------------------
-- Nox Information Bar
---------------------------------------------------------------------------

---------------------------------------------------------------------------
-- Helper functions
---------------------------------------------------------------------------

local function NoxInformationBar_Pluralize(singularFormat, pluralFormat, value)
   if (value > 1) then 
      return format(pluralFormat, value);
   end
   
   return format(singularFormat, value);
end

function NoxInformationBar_FormatTime(time, format)
   if (format == NOX_IB.Format.Short) then
      return NoxInformationBar_FormatTimeShort(time);
   elseif (format == NOX_IB.Format.Long) then
      return NoxInformationBar_FormatTimeLong(time);
   else
      return NoxInformationBar_FormatTimeNormal(time);
   end
end

function NoxInformationBar_FormatTimeLong(time)
   local text = "";
   local skip = 1;

   -- Parse date
   local d, h, m, s = ChatFrame_TimeBreakDown(time);
   
   -- Format date
   if (d > 0) then 
      text = text .. NoxInformationBar_Pluralize(NOX_IB.Clock.Day,    NOX_IB.Clock.Days,    d) .. ", "; 
      skip = 0; 
   end
   if (skip == 0 or h > 0) then 
      text = text .. NoxInformationBar_Pluralize(NOX_IB.Clock.Hour,   NOX_IB.Clock.Hours,   h) .. ", "; 
      skip = 0; 
   end
   if (skip == 0 or m > 0) then 
      text = text .. NoxInformationBar_Pluralize(NOX_IB.Clock.Minute, NOX_IB.Clock.Minutes, m) .. ", "; 
      skip = 0; 
   end
   if (skip == 0 or s > 0) then 
      text = text .. NoxInformationBar_Pluralize(NOX_IB.Clock.Second, NOX_IB.Clock.Seconds, s);
   end
   
   return text;
end

function NoxInformationBar_FormatTimeNormal(time)
   local text = "";
   local skip = 1;

   -- Parse date
   local d, h, m, s = ChatFrame_TimeBreakDown(time);
   s = floor(s);
   
   -- Format date
   if (d > 0) then 
      text = text .. d .. NOX_IB.Clock.Short.Day    .. " "; 
      skip = 0; 
   end
   if (skip == 0 or h > 0) then 
      text = text .. h .. NOX_IB.Clock.Short.Hour   .. " "; 
      skip = 0; 
   end
   if (skip == 0 or m > 0) then 
      text = text .. m .. NOX_IB.Clock.Short.Minute .. " "; 
      skip = 0; 
   end
   if (skip == 0 or s > 0) then 
      text = text .. s .. NOX_IB.Clock.Short.Second;                  
   end
   
   return text;
end

function NoxInformationBar_FormatTimeShort(time)
   local text = "";
   local skip = 1;

   -- Parse date
   local d, h, m, s = ChatFrame_TimeBreakDown(time);
   s = floor(s);
   
   -- Format date
   if (d > 0) then 
      text = text .. d .. "."; 
      skip = 0; 
   end
   if (skip == 0 or  h > 0) then 
      text = text .. h .. ":"; 
      skip = 0; 
   end
   if (skip == 0)           then 
      text = text .. format("%02d", m) .. ":";           
   end
   if (skip == 1)           then 
      text = text .. m .. ":";           
   end
   text = text .. format("%02d", s);
   
   return text;
end

function NoxInformationBar_FormatMoney(money, format, arg1, arg2)
   if (format == NOX_IB.Format.Gold) then
      local g = floor(money / 10000);
      return NoxInformationBar_FormatMoneyPlace(g, nil, NOX_IB.Format.GoldColor, arg1);
   elseif (format == NOX_IB.Format.Silver) then
      local s = floor(math.fmod(money, 10000) / 100);
      return NoxInformationBar_FormatMoneyPlace(s, nil, NOX_IB.Format.SilverColor, arg1);
   elseif (format == NOX_IB.Format.Copper) then
      local c = floor(math.fmod(money, 100));
      return NoxInformationBar_FormatMoneyPlace(c, nil, NOX_IB.Format.CopperColor, arg1);
   elseif (format == NOX_IB.Format.AsGold) then
      local g = NoxInformationBar_FormatNumber(money / 10000, arg1, NOX_IB.Format.Decimal);
      return NoxInformationBar_FormatMoneyPlace(g, nil, NOX_IB.Format.GoldColor, arg2);
   elseif (format == NOX_IB.Format.AsSilver) then
      local s = NoxInformationBar_FormatNumber(money / 100, arg1, NOX_IB.Format.Decimal);
      return NoxInformationBar_FormatMoneyPlace(s, nil, NOX_IB.Format.SilverColor, arg2);
   elseif (format == NOX_IB.Format.AsCopper) then
      local c = NoxInformationBar_FormatNumber(money, arg1, NOX_IB.Format.Integer);
      return NoxInformationBar_FormatMoneyPlace(c, nil, NOX_IB.Format.CopperColor, arg2);
   elseif (format == NOX_IB.Format.ShortMoney) then
      return NoxInformationBar_FormatMoneyNamed(money, NOX_IB.Money.Short, arg1, arg2);
   elseif (format == NOX_IB.Format.LongMoney) then
      return NoxInformationBar_FormatMoneyNamed(money, NOX_IB.Money.Long, arg1, arg2);
   elseif (format == NOX_IB.Format.NumericMoney) then
      return NoxInformationBar_FormatMoneySeparated(money, " ", arg1);
   elseif (format == NOX_IB.Format.CompactMoney) then
      return NoxInformationBar_FormatMoneySeparated(money, NOX_IB.Format.MoneySeparator, arg1);
   else
      return NoxInformationBar_FormatMoneyNamed(money, NOX_IB.Money.Short);
   end
end

function NoxInformationBar_FormatMoneySeparated(money, separator, colorDigits)
   local skip = 1;
   
   local neg = (money < 0);
   money = math.abs(money);

   local g = floor(money / 10000);
   local s = floor(math.fmod(money, 10000) / 100);
   local c = floor(math.fmod(money, 100));

   local goldPart   = "";
   local silverPart = "";
   local copperPart = "";

   -- Format money
   if (g > 0) then
      goldPart = NoxInformationBar_FormatMoneyPlace(g, separator, NOX_IB.Format.GoldColor, colorDigits);
      skip = 0; 
   end
   if (skip == 0 or s > 0) then 
      silverPart = NoxInformationBar_FormatMoneyPlace(s, separator, NOX_IB.Format.SilverColor, colorDigits);
      skip = 0; 
   end
   copperPart = NoxInformationBar_FormatMoneyPlace(c, nil, NOX_IB.Format.CopperColor, colorDigits);

   if (neg) then
      return "-" .. goldPart .. silverPart .. copperPart;
   else
      return goldPart .. silverPart .. copperPart;
   end
end

function NoxInformationBar_FormatMoneyNamed(money, names, colorDigits, colorNames)
   local skip = 1;

   local neg = (money < 0);
   money = math.abs(money);

   local g = floor(money / 10000);
   local s = floor(math.fmod(money, 10000) / 100);
   local c = floor(math.fmod(money, 100));

   local goldPart   = "";
   local silverPart = "";
   local copperPart = "";

   -- Format money
   if (g > 0) then
      goldPart = NoxInformationBar_FormatMoneyPlace(g, names.Gold, NOX_IB.Format.GoldColor, colorDigits, colorNames);
      skip = 0; 
   end
   if (skip == 0 or s > 0) then 
      silverPart = NoxInformationBar_FormatMoneyPlace(s, names.Silver, NOX_IB.Format.SilverColor, colorDigits, colorNames);
      skip = 0; 
   end
   copperPart = NoxInformationBar_FormatMoneyPlace(c, names.Copper, NOX_IB.Format.CopperColor, colorDigits, colorNames);
   
   if (neg) then
      return "-" .. goldPart .. silverPart .. copperPart;
   else
      return goldPart .. silverPart .. copperPart;
   end
end

function NoxInformationBar_FormatMoneyPlace(value, name, color, colorDigits, colorNames)
   local text = "";
   if (colorDigits) then
      text = text .. color;
   end
   text = text .. value;
   if (colorDigits and not colorNames) then
      text = text .. FONT_COLOR_CODE_CLOSE;
   end
   if (name) then
      text = text .. name;
   end
   if (colorNames) then
      text = text .. FONT_COLOR_CODE_CLOSE;
   end
   return text;
end

function NoxInformationBar_FormatNumber(value, format, default)
   format = format or default;  -- optimization for nil format specified
   if (format == NOX_IB.Format.Decimal) then
      return string.format("%0.2f", value);
   elseif (format == NOX_IB.Format.Integer) then
      return string.format("%d", value);
   elseif (default) then
      return NoxInformationBar_FormatNumber(value, default);
   else
      return value;
   end
end

function NoxInformationBar_FormatBoolean(value, trueval, falseval)
   if (value) then
      return trueval or NOX_IB.Format.True;
   else
      return falseval or NOX_IB.Format.False;
   end
end

function NoxInformationBar_PlayerXP()
   local currXP = UnitXP("player");
   local nextXP = UnitXPMax("player");
   local restXP = GetXPExhaustion() or 0;
   local togoXP = nextXP - currXP;

   if (not(restXP > 0)) then 
      return format(NOX_IB.XP,         currXP, togoXP, nextXP);
   else
      return format(NOX_IB.XPWithRest, currXP, togoXP, nextXP, restXP + currXP);
   end
   
   return "";
end

function round(value)
   return floor(value + 0.5);
end
