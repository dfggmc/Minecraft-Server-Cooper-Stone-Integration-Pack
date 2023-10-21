--
-- OnPlayerLeftClick()
--
--------------------------------------------------------------------------------

function OnPlayerLeftClick(aPlayer, BlockX, BlockY, BlockZ, BlockFace, Action)

  local func_name = "OnPlayerLeftClick()";

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

