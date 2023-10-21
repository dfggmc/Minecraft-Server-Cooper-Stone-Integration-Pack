function Initialize(Plugin)
	Plugin:SetName(g_PluginInfo.Name);
	Plugin:SetVersion(g_PluginInfo.Version);

	dofile(cPluginManager:GetPluginsPath() .. "/InfoReg.lua");
	RegisterPluginInfoCommands();
	RegisterPluginInfoConsoleCommands();

	LOG("Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())
	return true
end
