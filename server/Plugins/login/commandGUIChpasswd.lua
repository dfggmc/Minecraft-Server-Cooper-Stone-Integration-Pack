--
-- commandGUIChpasswd
--
-- Change other player password
--------------------------------------------------------------------------------

function commandGUIChpasswd(aSplit, aPlayer)
  local func_name = 'commandGUIChpasswd()';

  local plPassword = nil;
  local plName = '';
  local msgPasswordUpdateSuccess = 'Password update success';

  if #aSplit < 3 then
    aPlayer:SendMessageWarning('No password set. Set player name and new password');
    return true;
  end

  plPassword = aSplit[3];
  plName = aSplit[2];

  -- Is it new player
  if gStore:existsPlayer(plName) == false then
    aPlayer:SendMessageWarning('Player not found into DB');
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

