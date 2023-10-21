-- =============================================================================
--
-- Signin2
-- Written by DrMasik
--
-- The best Minecraft server
-- www.cuberite.org
-------------------------------------------------------------------------------

gPluginName = '';
-------------------------------------------------------------------------------

function Initialize(Plugin)
  Plugin:SetName("Signin2")
  Plugin:SetVersion(2016090502)

  gPluginName = Plugin:GetName();

  local pluginDir = cRoot:Get():GetPluginManager():GetCurrentPlugin():GetLocalFolder();

  console_log('-------------------------------------');
  console_log(gPluginName .. " initialize...")

  -- Load the InfoReg shared library:
  dofile(cPluginManager:GetPluginsPath() .. "/InfoReg.lua")

  -- Bind all the console commands:
  -- RegisterPluginInfoConsoleCommands()

  -- Bind all the commands (userspace):
  RegisterPluginInfoCommands()

  -- Load hooks
  hooks();

  -- Create DB class
  gStore = cStore:new(pluginDir, 'logins.sqlite3');

  -- Create DB
  if gStore:createDB() ~= true then
    console_log('Can not create DB');
    return false;
  end

  -- Nice message :)
  console_log(gPluginName ..": Initialized " .. gPluginName .. " v." .. Plugin:GetVersion())

  console_log('-------------------------------------');

  return true
end
-------------------------------------------------------------------------------

-- :%s/\s\+$//g

-- =============================================================================

