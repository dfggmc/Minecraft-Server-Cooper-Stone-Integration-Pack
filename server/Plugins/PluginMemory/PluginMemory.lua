
-- PluginMemory.lua

-- Implements the entire plugin





--- cPlugin instance representing this plugin
-- Used for not calling self via cPluginManager:CallPlugin()
local g_Self

--- The entire graphing library (jquery flot) javascript
-- Loaded at runtime from jquery.js and jquery.flot.js files
local g_JS

--- Sorted array of plugin names for plugins that are currently tracked
local g_PluginNames = {}

--- Collect the statistics only once per this number of ticks
local g_TicksPerStat = 5

--- How many seconds of history to keep
local g_HistorySeconds = 500

--- Memory statistics for individual plugins
-- Map of "PluginName" => array of numbers
-- The arrays are considered a circular buffer, starting at index g_CurTick
local g_PluginMemData = {}

--- The index into g_PluginMemData's arrays that contains the latest data
local g_CurTick = 1

--- How many values should be kept in the history. Based on the g_HistorySeconds value
local g_MaxTicks = math.ceil(g_HistorySeconds * 20 / g_TicksPerStat)

--- The start of the regular webadmin page.
-- Defines the style and the helper functions
local g_PageStart =
[[
<style>
.graph
{
	width: 700px;
	height: 300px;
}
</style>

<script type="text/javascript" src="/~webadmin/PluginMemory/Graphs/?js=1"></script>

<script>
// Map of PluginName -> Graph object, used for updating the data series
var g_Graphs = [];
</script>
]]

local g_FooterJS =
[[
<script type="text/javascript">
function CreateXHR() 
{
	var request = false;
	try
	{
		request = new ActiveXObject('Msxml2.XMLHTTP');
	}
	catch (err2)
	{
		try
		{
			request = new ActiveXObject('Microsoft.XMLHTTP');
		}
		catch (err3)
		{
			try
			{
				request = new XMLHttpRequest();
			}
			catch (err1)
			{
				request = false;
			}
		}
	}
	return request;
}

function UpdateDataSeries(a_PluginName)
{
	var xhr = CreateXHR();
	xhr.OriginalPluginName = a_PluginName;
	xhr.onreadystatechange = function()
	{
		if (xhr.readyState != 4)
		{
			return;
		}
		var resp = xhr.responseText;
		var series = JSON.parse(resp);

		// We've received the raw series (Y data), interlace it with X values:
		var len = series.length;
		var data = [];
		for (var i = len - 1; i > 0; i--)
		{
			if (series[i] > 0)  // Only push valid datapoints
			{
				data.push([i - len, series[i] ]);
			}
		}
		
		// Plot the data series in the graph:
		var graph = g_Graphs[xhr.OriginalPluginName];
		graph.setData([{data: data}]);
		graph.setupGrid();
		graph.draw();
	}; 
	xhr.open("POST", "/~webadmin/PluginMemory/Graphs/", true);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send("PluginName=" + a_PluginName);
}

function ReloadData()
{
	var len = g_PluginNames.length;
	for (var i = 0; i < len; i++)
	{
		UpdateDataSeries(g_PluginNames[i]);
	}
}

setInterval(ReloadData, 1000);
window.onload = ReloadData;
</script>
]]






function HandleConsoleCmdPlugMem(a_Split)
	-- Enumerate the plugins and their memory use:
	local pm = cPluginManager:Get()
	local PluginTable = {}
	local maxNameLen = 0
	pm:ForEachPlugin(
		function (a_CBPlugin)
			if (a_CBPlugin:GetStatus() == pm.psLoaded) then
				local name = a_CBPlugin:GetName()
				local mem
				if (a_CBPlugin == g_Self) then
					mem = collectgarbage("count") 
				else
					mem = cPluginManager:CallPlugin(name, "collectgarbage", "count")
				end
				table.insert(PluginTable,
					{
						Name = name,
						Mem = mem,
						Folder = a_CBPlugin:GetFolderName(),
					}
				)
				local nameLen = #name
				if (nameLen > maxNameLen) then
					maxNameLen = nameLen
				end
			end
		end
	)
	
	-- Sort plugins by their name:
	table.sort(PluginTable,
		function (a_Plugin1, a_Plugin2)
			return (a_Plugin1.Name < a_Plugin2.Name)
		end
	)
	
	-- Format the output:
	local out = {}
	for _, plugin in ipairs(PluginTable) do
		local name = plugin.Name
		local nameLen = #name
		local mem = plugin.Mem
		if not(mem) then
			mem = "<unknown>"
		else
			mem = math.floor(mem)
		end
		table.insert(out, string.format("%s%s %s KiB", name, string.rep(" ", maxNameLen - nameLen), mem))
	end
	
	return true, table.concat(out, "\n")
end





--- Reads the contents of the specified file (filename relative to cPlugin:GetLocalFolder() )
-- Returns the contents on success, false and optional error msg on failure
local function ReadLocalFile(a_FileName)
	local fnam = g_Self:GetLocalFolder() .. cFile:GetPathSeparator() .. a_FileName
	local f, msg = io.open(fnam, "rb")
	if not(f) then
		return false, msg
	end
	local contents
	contents, msg = f:read("*all")
	f:close()
	if not(contents) then
		return false, msg
	end
	return contents
end





--- Reads the JS files required for the graphs
-- Returns true if successful, false and optional error msg otherwise
local function ReadJSFiles()
	local jquery, msg = ReadLocalFile("jquery.js")
	if not(jquery) then
		LOGWARNING("PluginMemory: Cannot read file jquery.js (" .. (msg or "<unknown error>") .. "), webadmin page will not be available")
		return false, msg
	end
	
	local flot
	flot, msg = ReadLocalFile("jquery.flot.js")
	if not(flot) then
		LOGWARNING("PluginMemory: Cannot read file jquery.flot.js (" .. (msg or "<unknown error>") .. "), webadmin page will not be available")
		return false, msg
	end
	
	g_JS = jquery .. flot
	return true
end





--- Returns the string representing the data series for the specified plugin, as a JSON array
local function GetSeries(a_PluginName)
	local data = g_PluginMemData[a_PluginName]
	if not(data) then
		return "[]"
	end
	local part1 = table.concat(data, ", ", g_CurTick + 1, g_MaxTicks)
	local part2 = table.concat(data, ", ", 1, g_CurTick)
	if ((part1 ~= "") and (part2 ~= "")) then
		return "[" .. part1 .. ", " .. part2 .. "]"
	end
	return "[" .. part1 .. part2 .. "]"
end





local function GetBasePage()
	-- Insert the page start:
	local out = { g_PageStart }
	
	-- Insert the per-plugin graph areas:
	local ins = table.insert
	for _, name in ipairs(g_PluginNames) do
		ins(out, (string.gsub(
			[[
<p>
Memory usage, plugin <b>&PLUGINNAME&</b>:
<div id="ramgraph_&PLUGINNAME&" class="graph"></div>
</p>
<script type="text/javascript">
g_Graphs["&PLUGINNAME&"] = $.plot(
	$("#ramgraph_&PLUGINNAME&"),
	[ ],
	{
		lines: { show: true},
		xaxis:
		{
			min: &XMIN&
		}
	}
);
</script>
			]], "&PLUGINNAME&", name
		):gsub("&XMIN&", tostring(-g_MaxTicks))))
	end
	
	-- Insert the plugin name list for the refresh JS:
	ins(out,
		[[
		<script type="text/javascript">
		var g_PluginNames = ["]]
	)
	ins(out, table.concat(g_PluginNames, "\", \""))
	ins(out, [["];
		</script>
	]])
	ins(out, g_FooterJS)
	return table.concat(out)
end





--- Handles the webadmin requests, returns the web page contents
local function WebadminHandler(a_Request)
	-- If the request is for the JS, return it:
	if (a_Request.Params["js"]) then
		return g_JS, "text/javascript"
	end
	
	-- If the request is for a data series, return it:
	local PluginName = a_Request.PostParams["PluginName"]
	if (PluginName) then
		return GetSeries(PluginName)
	end
	
	-- The request is for the base page:
	return GetBasePage()
end





--- Creates an array representing a new plugin memory data series.
-- The returned array has exactly g_MaxTicks numbers in it
local function CreatePluginMemData()
	local res = {}
	for i = 1, g_MaxTicks do
		res[i] = 0
	end
	return res
end





local g_ServerTickNum = 0

local function OnServerTick()
	-- Only collect data every N ticks:
	if (g_ServerTickNum < g_TicksPerStat) then
		g_ServerTickNum = g_ServerTickNum + 1
		return
	end
	g_ServerTickNum = 0
	
	-- Advance the current tick pointer:
	g_CurTick = g_CurTick + 1
	if (g_CurTick > g_MaxTicks) then
		g_CurTick = 1
	end
	
	-- Enumerate the plugins and their memory use:
	local pm = cPluginManager:Get()
	pm:ForEachPlugin(
		function (a_CBPlugin)
			-- Want only loaded plugins
			if (a_CBPlugin:GetStatus() ~= pm.psLoaded) then
				return
			end

			-- Get the memory use:
			local name = a_CBPlugin:GetName()
			local mem
			if (a_CBPlugin == g_Self) then
				mem = collectgarbage("count") 
			else
				mem = cPluginManager:CallPlugin(name, "collectgarbage", "count")
			end
			
			-- Store into the plugin data, creating it if not already created:
			local data = g_PluginMemData[name]
			if not(data) then
				data = CreatePluginMemData()
				g_PluginMemData[name] = data
				table.insert(g_PluginNames, name)
				table.sort(g_PluginNames)
			end
			data[g_CurTick] = mem
		end
	)
end





function Initialize(a_Plugin)
	g_Self = a_Plugin
	a_Plugin:SetName("PluginMemory")
	
	-- Register the commands:
	dofile(cPluginManager:GetPluginsPath() .. "/InfoReg.lua")
	RegisterPluginInfoConsoleCommands()
	
	-- If the JS files are available, register the webadmin page and associated hooks:
	if (ReadJSFiles()) then
		a_Plugin:AddWebTab("Graphs", WebadminHandler)
		cPluginManager:AddHook(cPluginManager.HOOK_TICK, OnServerTick)
	end
	
	return true
end




