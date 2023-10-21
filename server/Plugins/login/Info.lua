g_PluginInfo = {
  Name = "Signin2",
  Version = "2016090502",
  Date = "2016-09-05-02",
  Description = [=[ Signin2 ]=],

  ConsoleCommands =
  {
  },

--------------------------------------------------------------------------------

  Commands = {
    ['/login'] = {
      Alias = {'/l', '/log', '/register', '/reg', '/sign', '/s', '/signin'},
      Permission = "signin2.core",
      HelpString = "Login",
      Handler = commandGUILogin,
    },  -- /login

    ['/passwd'] = {
      Permission = 'signin2.core',
      HelpString = 'Change password',
      Handler = commandGUIPasswd,
    },

    ['/chpasswd'] = {
      Permission = 'signin2.chpasswd',
      HelpString = 'Change password for other player',
      Handler = commandGUIChpasswd,
    },
  },  -- Commands

--------------------------------------------------------------------------------

} -- g_PluginInfo

