--
-- OnPlayerRightClick()
--
--------------------------------------------------------------------------------

function OnPlayerRightClick(aPlayer, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ)

  local func_name = "OnPlayerRightClick()";

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

