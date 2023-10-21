--
-- OnTakeDamage()
--
--------------------------------------------------------------------------------

function OnTakeDamage(aReceiver, aTDI)

  local func_name = "OnTakeDamage()";
  local receverIsPlayer = aReceiver:IsPlayer();
  local attackerIsPlayer = false;
  local plUID = 0;

  if aTDI.Attacker ~= nil and aTDI.Attacker:IsPlayer() then
    attackerIsPlayer = true;
  end

  -- Is it player take damage?
  if receverIsPlayer == false and attackerIsPlayer == false then
    return false;
  end

  if receverIsPlayer == true then

    plUID = aReceiver:GetUniqueID();

    -- Safe authorize
    if gPlayers[plUID] == nil then
      return true;
    end

    -- Is it player authorized?
    if gPlayers[plUID]:getAuth() == false then
      return true;
    end
  end

  if attackerIsPlayer == true then
    plUID = aTDI.Attacker:GetUniqueID();

    -- Safe authorize
    if gPlayers[plUID] == nil then
      return true;
    end

    -- Is it player authorized?
    if gPlayers[plUID]:getAuth() == false then
      return true;
    end
  end

  return false;
end

--------------------------------------------------------------------------------

