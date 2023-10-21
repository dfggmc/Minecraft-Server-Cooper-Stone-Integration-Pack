--
-- commandGUIPasswd
--
--------------------------------------------------------------------------------

function commandGUIPasswd(aSplit, aPlayer)
  local func_name = 'commandGUIPasswd()';

  local plUID = aPlayer:GetUniqueID();
  local plPassword = nil;
  local plName = aPlayer:GetName();
  local msgPasswordUpdateSuccess = 'Password update success';

  if #aSplit < 2 then
    aPlayer:SendMessageWarning('No password set');
    return true;
  end

  plPassword = aSplit[2];

  -- Set player data. Must be always ~= nil
  if gPlayers[plUID] == nil then
    return true;
  end

  -- Is it player authorized?
  if gPlayers[plUID]:getAuth() == false then
    return true;
  end

  -- Is it new player
  if gStore:existsPlayer(plName) == false then
    return true;
  end

  -- Set new password
  if gStore:updatePassword(plName, getHash(plPassword)) == false then
    aPlayer:SendMessageWarning('Error on password update');
    return true;
  end

  aPlayer:SendMessageSuccess(msgPasswordUpdateSuccess);

  return true;
end
--------------------------------------------------------------------------------

