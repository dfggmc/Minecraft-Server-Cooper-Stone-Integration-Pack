
-- Info.lua

-- Declares the plugin metadata, commands, permissions etc.





g_PluginInfo =
{
	Name = "PluginMemory",
	Date = "2015-06-25",
	Description =
	[[
This is a plugin for {%a http://mc-server.org}MCServer{%/a} that allows admins to see per-plugin memory usage.

The plugin provides a console command for listing the current values, and a webadmin page with history graphs.
	]],
	
	ConsoleCommands =
	{
		plugmem =
		{
			HelpString = "Lists current memory usage for each plugin",
			Handler = HandleConsoleCmdPlugMem,
		},  -- plugmem
	},  -- ConsoleCommands
}




