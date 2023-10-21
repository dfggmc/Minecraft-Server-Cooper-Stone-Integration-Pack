--
-- OnChat()
--
--------------------------------------------------------------------------------

function OnChat(aPlayer, aMessage)

  local func_name = "OnChat()";

  local plUID = aPlayer:GetUniqueID();

  -- Safe authorize
  if gPlayers[plUID] == nil then
    gPlayers[plUID] = cPlayers:new();
    gPlayers[plUID]:setPlName(aPlayer:GetName());
    return true;
  end

  -- Is it player authorized?
  if gPlayers[plUID]:getAuth() == false then
    return true;
  end

  return false;
end

--------------------------------------------------------------------------------

