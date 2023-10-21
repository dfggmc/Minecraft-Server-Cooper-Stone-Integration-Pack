--------------------------------------------------------------------------------

function hooks()
  cPluginManager:AddHook(cPluginManager.HOOK_EXECUTE_COMMAND,    OnExecuteCommand)
  cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_SPAWNED,     OnPlayerSpawned);
  cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_DESTROYED,   OnPlayerDestroyed);
  cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_MOVING,      OnPlayerMoving);
  cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_LEFT_CLICK,  OnPlayerLeftClick);
  cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_BREAKING_BLOCK, OnPlayerBreakingBlock);
  cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_RIGHT_CLICK, OnPlayerRightClick);
  cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_USING_BLOCK, OnPlayerUsingBlock);
  cPluginManager:AddHook(cPluginManager.HOOK_CHAT,               OnChat);
  cPluginManager:AddHook(cPluginManager.HOOK_TAKE_DAMAGE,        OnTakeDamage)
end
--------------------------------------------------------------------------------

