--
-- OnExecuteCommand()
--
--------------------------------------------------------------------------------

function OnExecuteCommand(aPlayer, aCommand)

  if aPlayer == nil then
    return false;
  end

  local plUID = aPlayer:GetUniqueID();
  local plName = aPlayer:GetName();
  local plCommand = aCommand[1]:lower();
  local commands = {'/login', '/l', '/log', '/register', '/reg', '/sign', '/s', '/signin'};
  local commandID = 1;

  -- is it player into not exists
  if gPlayers[plUID] == nil then
    -- Add player to DB
    gPlayers[plUID] = cPlayers:new();
    gPlayers[plUID]:setPlName(plName);
  end

  -- Is it player authorized?
  if gPlayers[plUID]:getAuth() == true then
    return false;
  end

  while commandID <= #commands do
    if commands[commandID] == plCommand then
      return false;
    end

    commandID = commandID + 1;
  end

  -- Disable any other commands
  return true;
end

--------------------------------------------------------------------------------
