--
-- OnPlayerDestroyed()
--
--------------------------------------------------------------------------------

function OnPlayerDestroyed(aPlayer)
  func_name = "OnPlayerDestroyed()";

  if not aPlayer then
    return false;
  end

  local plUID = aPlayer:GetUniqueID();

  gPlayers[plUID] = nil;

  return false;
end

--------------------------------------------------------------------------------

