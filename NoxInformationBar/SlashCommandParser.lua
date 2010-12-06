---------------------------------------------------------------------------
-- Nox Information Bar
--
-- based on Mairelon's CommandParser Class 1.02
---------------------------------------------------------------------------
--
-- SlashCommandParser Class
--
-- The SlashCommandParser simplifies the addition of sophisticated
-- slash commands.  It replaces large if-then-elseif-else-end
-- constructs with a callback function system.  It also 
-- encapsulates basic usage messages and limited parameter
-- parsing.
--
-- Usage:
--
--     I. Create a global instance of the class.
--
--        ParserInstance = SlashCommandParser:New ( "ModName", "MessageHeader" );
--
--        where ModName is your mod's name and MessageHeader is the string
--        that the parser will prefix to all messages.
--
--
--    II. Set your slash commands.
--
--        SLASH_ModName1 = "/mod";
--        SLASH_ModName2 = "/mod2";
--
--
--   III. Register commands and parameters.
--
--        ParserInstance:RegisterCommand ( "command", Callback, "group", usage );
--        ParserInstance:AddParameter    ( "command", "param1", REQUIRED, NON_STRICT, TYPE, NO_BOUNDS, DefaultValue );
--        ParserInstance:AddParameter    ( "command", "param2", REQUIRED, NON_STRICT, TYPE, BOUNDS,    NO_DEFAULT   );
--
--        III a. Commands.
--
--              III a-1. Command name.
--
--              III a-2. Command callback.
--
--              III a-3. Command group.
--
--              III a-4. Command usage.
--
--        III b. Parameters.
--
--              III b-1. Parameter command.
--
--              III b-2. Parameter name.
--
--              III b-3. Parameter required attribute.
--
--              III b-4. Parameter strict attribute.
--
--              III b-5. Parameter type.
--
--              III b-6. Parameter allowed values.
--
--              III b-7. Parameter default value.
--
--
--    IV. Handle the callback function.
--
--        function Callback ( msg )
--            ...
--        end
--
--
--     V. Get parameters in the callback function.
--
--        local args = ParserInstance:GetParameters ( msg );
--
--
--    VI. Check parameters validity.
--        if not NoxInformationBarCommand:ValidateParameters ( NOX_IB.Commands.Show, args ) then
--            { Invalid command handling }
--            return;
--        end
--    
--        { Valid command handling }
--
--
--   VII. Have fun!
--
---------------------------------------------------------------------------

---------------------------------------------------------------------------
-- Localization
---------------------------------------------------------------------------

local SlashCommandParserMessages = { };

---------------------------------------------------------------------------
-- Localization - English
---------------------------------------------------------------------------

-- make English the default if the actual locale is unsupported or incomplete
--if (GetLocale() == "enUS") then

SlashCommandParserMessages.Error             = "|cffff3f3fError:|r";
SlashCommandParserMessages.Warning           = "|cffffff3fWarning:|r";
SlashCommandParserMessages.ArgumentRequired  = SlashCommandParserMessages.Error   .. " %s is required.";
SlashCommandParserMessages.TypeMismatch      = SlashCommandParserMessages.Error   .. " %s type mismatch %s not allowed.";
SlashCommandParserMessages.LowerBoundError   = SlashCommandParserMessages.Error   .. " %s must be higher than (or equal to) %s.";
SlashCommandParserMessages.LowerBoundWarning = SlashCommandParserMessages.Warning .. " %s should be higher than (or equal to) %s.";
SlashCommandParserMessages.UpperBoundError   = SlashCommandParserMessages.Error   .. " %s must be lower than (or equal to) %s.";
SlashCommandParserMessages.UpperBoundWarning = SlashCommandParserMessages.Warning .. " %s should be lower than (or equal to) %s.";
SlashCommandParserMessages.UnallowedValue    = SlashCommandParserMessages.Error   .. " %s not in range of allowed values.";
SlashCommandParserMessages.UnrecognizedValue = SlashCommandParserMessages.Warning .. " %s has an unrecognized value. Errors may occur.";

--end

---------------------------------------------------------------------------
-- Localization - Deutsch
---------------------------------------------------------------------------

if (GetLocale() == "deDE") then

   SlashCommandParserMessages.Error             = "|cffff3f3fError:|r";
   SlashCommandParserMessages.Warning           = "|cffffff3fWarning:|r";
   SlashCommandParserMessages.ArgumentRequired  = SlashCommandParserMessages.Error   .. " %s is required.";
   SlashCommandParserMessages.TypeMismatch      = SlashCommandParserMessages.Error   .. " %s type mismatch %s not allowed.";
   SlashCommandParserMessages.LowerBoundError   = SlashCommandParserMessages.Error   .. " %s must be higher than (or equal to) %s.";
   SlashCommandParserMessages.LowerBoundWarning = SlashCommandParserMessages.Warning .. " %s should be higher than (or equal to) %s.";
   SlashCommandParserMessages.UpperBoundError   = SlashCommandParserMessages.Error   .. " %s must be lower than (or equal to) %s.";
   SlashCommandParserMessages.UpperBoundWarning = SlashCommandParserMessages.Warning .. " %s should be lower than (or equal to) %s.";
   SlashCommandParserMessages.UnallowedValue    = SlashCommandParserMessages.Error   .. " %s not in range of allowed values.";
   SlashCommandParserMessages.UnrecognizedValue = SlashCommandParserMessages.Warning .. " %s has an unrecognized value. Errors may occur.";
    
end

---------------------------------------------------------------------------
-- Localization - Français
---------------------------------------------------------------------------

if (GetLocale() == "frFR") then

   SlashCommandParserMessages.Error             = "|cffff3f3fError:|r";
   SlashCommandParserMessages.Warning           = "|cffffff3fWarning:|r";
   SlashCommandParserMessages.ArgumentRequired  = SlashCommandParserMessages.Error   .. " %s is required.";
   SlashCommandParserMessages.TypeMismatch      = SlashCommandParserMessages.Error   .. " %s type mismatch %s not allowed.";
   SlashCommandParserMessages.LowerBoundError   = SlashCommandParserMessages.Error   .. " %s must be higher than (or equal to) %s.";
   SlashCommandParserMessages.LowerBoundWarning = SlashCommandParserMessages.Warning .. " %s should be higher than (or equal to) %s.";
   SlashCommandParserMessages.UpperBoundError   = SlashCommandParserMessages.Error   .. " %s must be lower than (or equal to) %s.";
   SlashCommandParserMessages.UpperBoundWarning = SlashCommandParserMessages.Warning .. " %s should be lower than (or equal to) %s.";
   SlashCommandParserMessages.UnallowedValue    = SlashCommandParserMessages.Error   .. " %s not in range of allowed values.";
   SlashCommandParserMessages.UnrecognizedValue = SlashCommandParserMessages.Warning .. " %s has an unrecognized value. Errors may occur.";
    
end

---------------------------------------------------------------------------
-- SlashCommandParser Class
---------------------------------------------------------------------------

if (not SlashCommandParser) or (not SlashCommandParser.Version) or (SlashCommandParser.Version < 1.03) then

   SlashCommandParser         = { };
   SlashCommandParser.Version = 1.0;
   
   ----------------------------------------------------------------
   -- Constructor
   ----------------------------------------------------------------
   
   function SlashCommandParser:New(modname, header)
      -- Assure mod's name is filled
      if (modname == nil) then 
         return nil; 
      end
      
      -- Create object
      local object          = { };
      
      -- Create lists
      object.CommandList    = { };
      object.UsageList      = { };
      object.UsageList.n    = 0;
      object.GroupList      = { };
      object.ParamList      = { };
      
      -- Set header
      object.Header         = header or "";
      
      -- Register slash command
      SlashCmdList[modname] = function(msg) object:SlashCommandHandler(msg); end
      
      -- Clone ourself into object
      setmetatable(object, self);
      self.__index = self;
      
      return object;
   end
   
   ----------------------------------------------------------------
   -- Slash Command Handler
   ----------------------------------------------------------------
   
   function SlashCommandParser:SlashCommandHandler(msg)
      -- Assure msg is not nil
      msg = msg or "";
      
      local token;
      
      -- First, pull off the first token to compare against the command text
      local firsti, lasti = string.find(msg, " ");
      if (firsti) then 
         token = string.sub(msg, 1, firsti - 1);
      else
         token = msg;
      end
      
      -- Treat the remainder of msg as an argument
      if (lasti) then 
         msg = string.sub(msg, lasti + 1);
      else
         msg = "";
      end
      
      -- If command exists, dispatch it, else, display the usage message
      if (self.CommandList[string.lower(token)]) then 
         self.CommandList[string.lower(token)](msg);
         -- No match found, display the usage message
      else
         self:DisplayUsage();
      end
   end
   
   ----------------------------------------------------------------
   -- Usage Display
   ----------------------------------------------------------------
   
   function SlashCommandParser:DisplayUsage(group)
      -- Assure group is not nil
      group = group or "main";
      
      -- Simply iterate through and display the usage line for each command in group
      local index, usage;
      for index, usage in ipairs(self.UsageList) do
         if (self.GroupList[index] == group) then
            DEFAULT_CHAT_FRAME:AddMessage(self.Header .. self.UsageList[index]);
         end
      end
   end
   
   ----------------------------------------------------------------
   -- Command Registrar
   ----------------------------------------------------------------
   
   function SlashCommandParser:RegisterCommand(command, dispatch, group, usage)
      -- Command -> Dispatch
      self.CommandList[string.lower(command)] = dispatch;
      
      -- Usage
      self.UsageList.n = self.UsageList.n + 1;
      self.UsageList[self.UsageList.n] = usage or command;
      
      -- Group
      self.GroupList[self.UsageList.n] = string.lower(group or "main");
      
      -- Parameters
      self.ParamList[string.lower(command)] = { };
   end
   
   ----------------------------------------------------------------
   -- Parameters Adder
   ----------------------------------------------------------------
   
   function SlashCommandParser:AddParameter(command, parameter, required, strict, types, allowed, default)
      -- Assure command exists
      if (not self.CommandList[string.lower(command)]) then
         return;
      end
      
      -- Add parameter
      self.ParamList[string.lower(command)][string.lower(parameter)] = { };
      self.ParamList[string.lower(command)][string.lower(parameter)]["required"] = required;
      self.ParamList[string.lower(command)][string.lower(parameter)]["strict"  ] = strict;
      self.ParamList[string.lower(command)][string.lower(parameter)]["types"   ] = types;
      self.ParamList[string.lower(command)][string.lower(parameter)]["default" ] = default;
      self.ParamList[string.lower(command)][string.lower(parameter)]["allowed" ] = allowed;
   end
   
   ----------------------------------------------------------------
   -- Parameters Retrieval
   ----------------------------------------------------------------
   
   function SlashCommandParser:GetParameters(msg)
      local params = { };
      
      if (msg == nil) then 
         return params;
      end
      
      -- Pattern to return "name=";
      local pattern = "([%a_][%w_]*)=";
      local index   = 1;
      
      -- While we have a "name=", process the info after it.
      local firsti, lasti, capture = string.find(msg, pattern);
      while capture do
         local varname = string.lower(capture);
         
         -- Find next parameter
         index = index + lasti;
         firsti, lasti, capture = string.find(string.sub(msg, index), pattern);
         if (not firsti) then
            firsti = string.len(msg); 
         else
            firsti = firsti - 2; 
         end
         
         -- Get parameter
         local str = string.sub(msg, index, index + firsti);
         
         --------------------------------------------------------
         -- String
         --------------------------------------------------------
         
         if (string.sub(str, 1, 1) == "'") then
            -- Find string's end
            local location = string.find(string.sub(str, 2), "'");
            if location and(location > 1) then
               -- Save string
               params[varname] = string.sub(str, 2, location);
            end
            
            --------------------------------------------------------
            -- Table
            --------------------------------------------------------
            
         elseif (string.sub(str, 1, 1) == "[") then
            local table = { };
            local element;
            
            local index = 1;
            
            --------------------------------------------------------
            -- Table string
            --------------------------------------------------------
            
            for element in string.gfind(str, "'([^']+)'") do
               table[index] = element;
               index = index + 1;
            end
            
            --------------------------------------------------------
            -- Table number
            --------------------------------------------------------
            
            for element in string.gfind(str, "([-]?%d+)") do
               local found = false;
               
               -- Check if if character is valid
               local first = string.sub(element, 1, 1);
               if not(first == "-" or(string.byte(first) >= string.byte("0") and string.byte(first) <= string.byte("9"))) then
                  element = string.sub(element, 2);
               end
               
               -- Check if number is not already in the list because of range
               if (not found) then
                  local i, v;
                  for i, v in ipairs(table) do
                     if (v == element + 0) then found = true; end
                  end
               end
               
               -- If not found, add number to table
               if (not found) then
                  table[index] = element + 0;
                  index = index + 1;
               end
            end
            
            --------------------------------------------------------
            -- Save table
            --------------------------------------------------------
            
            if (index > 1) then
               params[varname] = table;
            end
            
            --------------------------------------------------------
            -- Range
            --------------------------------------------------------
            
         elseif (string.find(str, "([-]?%d+)-([-]?%d+)")) then
            local table = { };
            local value;
            
            local index = 1;
            local firsti, lasti, startrange, endrange = string.find(str, "([-]?%d+)-([-]?%d+)");
            if firsti then
               -- Assure range is incremental
               if (startrange + 0 > endrange + 0) then
                  local temprange = startrange;
                  startrange = endrange;
                  endrange = temprange;
               end
               
               for value = startrange + 0, endrange + 0 do
                  table[index] = value;
                  index = index + 1;
               end
            end
            
            if (index > 1) then
               params[varname] = table;
            end
            
            --------------------------------------------------------
            -- Number
            --------------------------------------------------------
            
         else
            local firsti, lasti, value = string.find(str, "([-]?%d+)");
            if (value) then
               params[varname] = value + 0;
            end
         end
      end
      
      return params;
   end    
   
   ----------------------------------------------------------------
   -- Parameters Validation
   ----------------------------------------------------------------
   
   function SlashCommandParser:ValidateParameters(command, args)
      local index, param, i, value;
      for index, param in pairs(self.ParamList[string.lower(command)]) do
         
         ----------------------------------------------------------------
         -- Optional / Required
         ----------------------------------------------------------------
         
         if (not args[index] and param["required"]) then
            DEFAULT_CHAT_FRAME:AddMessage(self.Header .. format(SlashCommandParserMessages.ArgumentRequired, index));
            return false;
         elseif (not args[index] and not param["required"]) then
            args[index] = param["default"];
         end
         
         ----------------------------------------------------------------
         -- Types
         ----------------------------------------------------------------
         
         if (param["types"] and args[index]) then
            
            -- Create type availability table 
            local types = { };
            for i = 1, 3 do
               if (param["types"][i]) then
                  types[param["types"][i]] = true;
               end
            end
            
            -- Basic type checking
            if (not types[type(args[index])]) then 
               DEFAULT_CHAT_FRAME:AddMessage(self.Header .. format(SlashCommandParserMessages.TypeMismatch, index, type(args[index])));
               return false;
            end
            
            -- If the argument was a table, and tables are allowed then check each value in the table.
            -- Since tables of tables will not be parsed by SlashCommandParser we can explicitly check
            -- one level down without needing recursion.
            if (type(args[index]) == "table") then
               for i, value in ipairs(args[index]) do
                  if not types[type(value)] then 
                     DEFAULT_CHAT_FRAME:AddMessage(self.Header .. format(SlashCommandParserMessages.TypeMismatch, index, type(value)));
                     return false;
                  end
               end
            end
         end
         
         ----------------------------------------------------------------
         -- Allowed Values
         ----------------------------------------------------------------
         
         if (param["allowed"] and args[index]) then
            -- Check for lower and upper bound
            if param["allowed"].lowerbound or param["allowed"].upperbound then
               
               -- Simple bound checking for non-table types
               if (type(args[index]) == "number") then
                  if (param["allowed"].lowerbound and args[index] < param["allowed"].lowerbound) then
                     if (param["strict"]) then
                        DEFAULT_CHAT_FRAME:AddMessage(self.Header .. format(SlashCommandParserMessages.LowerBoundError,   index, param["allowed"].lowerbound));
                        return false;
                     else
                        DEFAULT_CHAT_FRAME:AddMessage(self.Header .. format(SlashCommandParserMessages.LowerBoundWarning, index, param["allowed"].lowerbound));
                     end
                  elseif (param["allowed"].upperbound and args[index] > param["allowed"].upperbound) then
                     if (param["strict"]) then
                        DEFAULT_CHAT_FRAME:AddMessage(self.Header .. format(SlashCommandParserMessages.UpperBoundError,   index, param["allowed"].upperbound)); 
                        return false;
                     else
                        DEFAULT_CHAT_FRAME:AddMessage(self.Header .. format(SlashCommandParserMessages.UpperBoundWarning, index, param["allowed"].upperbound));
                     end
                  end
                  
                  -- Bound checking for each individual value for table types
               elseif (type(args[index]) == "table" and type(args[index][1]) == "number") then
                  for i, value in ipairs(args[index]) do
                     if (param["allowed"].lowerbound and value < param["allowed"].lowerbound) then 
                        if (param["strict"]) then
                           DEFAULT_CHAT_FRAME:AddMessage(self.Header .. format(SlashCommandParserMessages.LowerBoundError,   index, param["allowed"].lowerbound));
                           return false;
                        else
                           DEFAULT_CHAT_FRAME:AddMessage(self.Header .. format(SlashCommandParserMessages.LowerBoundWarning, index, param["allowed"].lowerbound));
                        end
                     elseif (param["allowed"].upperbound and value > param["allowed"].upperbound) then
                        if (param["strict"]) then
                           DEFAULT_CHAT_FRAME:AddMessage(self.Header .. format(SlashCommandParserMessages.UpperBoundError,   index, param["allowed"].upperbound));
                           return false;
                        else
                           DEFAULT_CHAT_FRAME:AddMessage(self.Header .. format(SlashCommandParserMessages.UpperBoundWarning, index, param["allowed"].upperbound));
                        end
                     end
                  end
               end
               
            else
               -- Without bounds, we just check against each individual element of allowed
               local valid = false;
               if (type(args[index]) ~= "table") then
                  for i, value in ipairs(param["allowed"]) do
                     if (args[index] == value) then
                        valid = true;
                     end
                  end
               else
                  -- If it's a table, we compare each element of the table against the elements of allowed
                  for i, value in ipairs(args[index]) do
                     local j, allowedvalue;
                     for j, allowedvalue in ipairs(param["allowed"]) do
                        if (value == allowedvalue) then
                           valid = true;
                        end
                     end
                  end
               end
               
               if ((not valid) and param["strict"]) then
                  DEFAULT_CHAT_FRAME:AddMessage(self.Header .. format(SlashCommandParserMessages.UnallowedValue,    index));
                  return false;
               elseif (not valid) then
                  DEFAULT_CHAT_FRAME:AddMessage(self.Header .. format(SlashCommandParserMessages.UnrecognizedValue, index));
               end
            end
         end
      end
      
      return true;
   end
   
   ---------------------------------------------------------------------------
   -- Utilities
   ---------------------------------------------------------------------------
   
   function SlashCommandParser:GetValueList(list)
      -- Regularize arguments to functions that take button lists.
      -- Returns a list of buttons to be affected as a list, with the
      -- number of buttons in list.n.
      
      local result = { }; result.n = 0;
      
      if (list == nil) then
         -- Do nothing...
      elseif (type(list) == "number") then
         result[1] = list;
         result.n = result.n + 1;
      elseif (type(list) == "string") then
         result[1] = list;
         result.n = result.n + 1;
      elseif (type(list) == "table" ) then 
         list.n = 0;
         
         local index;
         for index in ipairs(list) do
            list.n = list.n + 1;
         end
         
         result = list;
      end
      
      return result;
   end
   
end
