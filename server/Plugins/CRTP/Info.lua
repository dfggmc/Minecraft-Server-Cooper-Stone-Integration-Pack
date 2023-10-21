g_PluginInfo =
{
	Name = "CRTP",
	Version = "1",
	Date = "2020-11-19",
	Description = [[Random teleportation]],
	Commands =
	{
		["/rtp"] =
		{
			Permission = "crtp.tp",
			HelpString = "Teleports into a random place",
			Handler = rtp,
			Alias = "/randomtp"
		}
	}
}
