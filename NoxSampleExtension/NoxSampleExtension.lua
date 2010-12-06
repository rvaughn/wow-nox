---------------------------------------------------------------------------
-- Nox Sample Extension
--
-- Demonstrates how to write addons to add new variables to the Nox 
-- Information Bar.
--
-- @author   Gruma
---------------------------------------------------------------------------

---------------------------------------------------------------------------
-- Variables
---------------------------------------------------------------------------

local Original_NoxInformationBar_InitFormats;
local Original_NoxInformationBar_FormatText;

---------------------------------------------------------------------------
-- Initialization
---------------------------------------------------------------------------

function NoxSampleExtension_OnLoad()

   -- hook functions for various extension methods
   -- method 1
   Original_NoxInformationBar_InitFormats = NoxInformationBar_InitFormats;
   NoxInformationBar_InitFormats = NoxSampleExtension_InitFormats;

   -- method 2
   Original_NoxInformationBar_FormatText = NoxInformationBar_FormatText;
   NoxInformationBar_FormatText = NoxSampleExtension_FormatText;

end

---------------------------------------------------------------------------
-- Extension Method 1
--
-- Append to the NoxInformationBar formatters.  This is appropriate
-- for all simple-text replacements.  You must supply the format code
-- and a function returning a single string to go along with it.
--
-- We set this up as a hook to NoxInformationBar_InitFormats so that
-- we ensure it gets called at the proper time.  It should be possible
-- to do this directly in *OnLoad, but it is a better idea to wait for
-- Nox to complete its initialization first as shown here.
---------------------------------------------------------------------------

-- extension method 1: append to NoxInformationBar format table at 
-- assignment time
function NoxSampleExtension_InitFormats()

   -- set up the base table first
   Original_NoxInformationBar_InitFormats();

   -- add new codes
   NoxInformationBar_AddFormats(
      { code = "sample1", func = NoxSampleExtension_GetSample1 },
      { code = "sample2", func = NoxSampleExtension_GetSample2 }
   );

end

---------------------------------------------------------------------------
-- Extension Method 2
--
-- Define a custom formatter.  This is useful only if you need to do 
-- something other than a simple text replacement.
---------------------------------------------------------------------------

function NoxSampleExtension_FormatText(display)

   -- first, let Nox do its replacements
   display = Original_NoxInformationBar_FormatText(display);

   local index,format;
   for index, format in pairs(NoxSampleExtensionFormats) do
      if (string.find(display, format.code)) then
         display = string.gsub(display, format.code, format.func());
      end
   end

   return display;

end

---------------------------------------------------------------------------
-- Data functions
---------------------------------------------------------------------------

function NoxSampleExtension_GetSample1(arg)
   return "text1";
end

function NoxSampleExtension_GetSample2(arg)
   return "text2";
end

function NoxSampleExtension_GetSample3(arg)
   return "text3";
end

function NoxSampleExtension_GetSample4(arg)
   return "text4";
end

---------------------------------------------------------------------------
-- Format table
---------------------------------------------------------------------------

-- You can also create format tables this way - AFTER the data functions
-- referenced - instead of in a function.  If you do this before the
-- functions, the "func" parameter will get filled with "nil".
NoxSampleExtensionFormats = {
   { code = "{sample3}", func = NoxSampleExtension_GetSample3 },
   { code = "{sample4}", func = NoxSampleExtension_GetSample4 }
};
