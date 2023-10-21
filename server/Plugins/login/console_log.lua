-- =============================================================================
--
-- Written by DrMasik
--
-- The best Minecraft server
-- www.cuberite.org

gShowConsoleDebugMessages = true;  -- Disable debug messages to console

-------------------------------------------------------------------------------

function console_log(aStr, msgType)
-- 0 - standart
-- 1 - debug
-- 2 - error

  local str = '';

  if msgType == nil then
    msgType =0;
  end

  if msgType == 0 then
    str = aStr;
  elseif msgType == 1 then
    if gShowConsoleDebugMessages then
      str = "Debug: ".. aStr;
    end
  else
    str = "Error: ".. aStr;
  end

  if str ~= '' then
    LOG(gPluginName ..": ".. str);
  end
end

-------------------------------------------------------------------------------

-- :%s/\s\+$//g

-- =============================================================================
