--
-- cPlayers:setLastMsgToPlayerTime()
--
-------------------------------------------------------------------------------

function cPlayers:setLastMsgToPlayerTime(aTime)

  -- Check income data
  if aTime == nil then
    aTime = 0;
  end

  -- Unix time
  self.lastMsgToPlayerTime = aTime;

end
-------------------------------------------------------------------------------

