--
-- OnPlayerSpawned()
--
--------------------------------------------------------------------------------

function OnPlayerSpawned(aPlayer)
  func_name = "OnPlayerSpawned()";

  if not aPlayer then
    return false;
  end

  local plUID = aPlayer:GetUniqueID();

  -- Is it player registered?
  if gPlayers[plUID] == nil then
    gPlayers[plUID] = cPlayers:new();
    gPlayers[plUID]:setPlName(aPlayer:GetName());
    gPlayers[plUID]:setSpawnPosition(Vector3i(aPlayer:GetPosX(), aPlayer:GetPosY(), aPlayer:GetPosZ()));
  end

  -- Set player invisible if not authorezed
  if gPlayers[plUID]:getAuth() == false then
    aPlayer:SetVisible(false);
  end

  return false;
end

--------------------------------------------------------------------------------

