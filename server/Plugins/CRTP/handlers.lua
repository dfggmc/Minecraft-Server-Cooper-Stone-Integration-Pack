function rtp(Cmd, User)

  if Cmd[1] == "/rtp" then
    if not User:HasPermission("crtp.tp") then
      User:SendMessageError('Invalid permissions.');
      return true;
    end

    x = math.random(-5000, 5000);
    y = math.random(0, 70);
    z = math.random(-5000, 5000);

    User:SetPosX(x);
    User:SetPosY(y);
    User:SetPosZ(z);

    xyz = '[X: ' .. tostring(x) .. ' Y: ' .. tostring(y) .. ' Z: ' .. tostring(z) .. ']';

    User:SendMessageInfo('You\'re teleported to: ' .. xyz);
    return true;
  end
end
