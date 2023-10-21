--
-- OnPlayerUsingBlock()
--
--------------------------------------------------------------------------------

function OnPlayerUsingBlock(aPlayer, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ, BlockType, BlockMeta)

  local func_name = "OnPlayerUsingBlock()";

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

