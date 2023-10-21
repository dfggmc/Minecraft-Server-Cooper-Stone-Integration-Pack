--
-- commandGUILogin
--
--------------------------------------------------------------------------------

function commandGUILogin(aSplit, aPlayer)
  local func_name = 'commandGUILogin()';

  local plUID = aPlayer:GetUniqueID();
  local plPassword = nil;
  local plName = aPlayer:GetName();

  if #aSplit < 2 then
    return true;
  end

  plPassword = aSplit[2];

  -- Set player data. Must be always ~= nil
  if gPlayers[plUID] == nil then
    gPlayers[plUID] = cPlayers:new();
    gPlayers[plUID]:setPlName(plName);
  end

  -- Is it player authorized?
  if gPlayers[plUID]:getAuth() == true then
    return true;
  end

  -- Is it new player
  if gStore:existsPlayer(plName) == false then
    -- Create new player
    if gStore:addPlayer(plName, getHash(plPassword)) == false then
      aPlayer:SendMessageWarning(msgPlayerCreateError);
      return true;
    end
  else
    -- Check player password
    if gStore:isPasswordRight(plName, getHash(plPassword)) == false then
      aPlayer:SendMessageWarning(msgWrongPasswordOrLogin);
      return true;
    end
  end

  -- Password is right
  gPlayers[plUID]:setAuth(true);

  -- Set player visible
  aPlayer:SetVisible(true);

  aPlayer:SendMessageSuccess(msgLoginSuccess);

  return true;
end
--------------------------------------------------------------------------------

