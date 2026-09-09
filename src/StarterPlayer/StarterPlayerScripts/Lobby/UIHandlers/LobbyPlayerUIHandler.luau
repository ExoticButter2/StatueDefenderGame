--!strict
local starterPlayer = game:GetService("StarterPlayer")

local starterPlayerScripts: Folder = starterPlayer:WaitForChild("StarterPlayerScripts")
local lobbyUIScriptsFolder: Folder = starterPlayerScripts:WaitForChild("Lobby")
local lobbyUIDataFolder: Folder = lobbyUIScriptsFolder:WaitForChild("LobbyUIData")

local lobbyUIData = require(lobbyUIDataFolder.LobbyUIDatabase)

local lobbyPlayerUIHandler = {}

function lobbyPlayerUIHandler.EnablePlayerUI()
	lobbyUIData.lobbyPlayerGui.Enabled = true
	print("Enabled Player lobby UI")
end

function lobbyPlayerUIHandler.DisablePlayerUI()
	lobbyUIData.lobbyPlayerGui.Enabled = false
	print("Disabled Player lobby UI")
end

function lobbyPlayerUIHandler.OnTeleport()
	lobbyPlayerUIHandler.DisablePlayerUI()
end

return lobbyPlayerUIHandler
