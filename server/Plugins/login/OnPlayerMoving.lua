--
-- OnPlayerMoving()
--
--------------------------------------------------------------------------------

function OnPlayerMoving(aPlayer, aOldPosition, aNewPosition)
  local func_name = "OnPlayerMoving()";

  if not aPlayer then
    return fasle;
  end

  local bedPosition = {};
  local plPosition = {};
  local chunkLoaded = false;
  local posY = 0;
  local delta = 3; -- Delta blocks to move without authentication
  local worldObj;
  local messageTimeDelay = 3;

  local plUID = aPlayer:GetUniqueID();

  -- Is it player registered?
  if gPlayers[plUID] == nil then
    gPlayers[plUID] = cPlayers:new();
    gPlayers[plUID]:setPlName(aPlayer:GetName());
  end

  -- Set player invisible if not authorezed
  if gPlayers[plUID]:getAuth() == false then
    aPlayer:SetVisible(false);
  else
    return false;
  end

  -- Save world link
  worldObj = aPlayer:GetWorld();

  -- Convert player current position
  plPosition = gPlayers[plUID]:getSpawnPosition();

  -- Check is it plugin reloaded?
  if plPosition.x == nil then
    aPlayer:GetClientHandle():Kick(msgRelogin);
    return false;
  end

  -- Show massage to player
  if os.time() - gPlayers[plUID]:getLastMsgToPlayerTime() > messageTimeDelay then
    aPlayer:SendMessageInfo(msgAuthenticatePlease);
    gPlayers[plUID]:setLastMsgToPlayerTime(os.time())
  end

  -- Allow player no move into some distance
  if math.abs(plPosition.x - aNewPosition.x) < delta and math.abs(plPosition.z - aNewPosition.z) < delta then
    return false;
  end

  -- Back player to spawn position
  aPlayer:TeleportToCoords(plPosition.x, plPosition.y, plPosition.z);

  -- Disable moving
  return false;
end

--------------------------------------------------------------------------------

