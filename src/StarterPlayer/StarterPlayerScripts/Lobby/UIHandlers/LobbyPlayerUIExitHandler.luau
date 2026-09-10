local starterPlayer = game:GetService("StarterPlayer")

local starterPlayerScripts: Folder = starterPlayer.StarterPlayerScripts
local lobbyUIScriptsFolder: Folder = starterPlayerScripts.Lobby
local lobbyUIDataFolder: Folder = lobbyUIScriptsFolder.LobbyUIData

local lobbyUIData = require(lobbyUIDataFolder.LobbyUIDatabase)

local lobbyExitRequestEvent = lobbyUIData.lobbyEventsFolder.LobbyExitRequest

local LobbyPlayerUIExitHandler = {}

function LobbyPlayerUIExitHandler.OnExitButtonPress()
	lobbyExitRequestEvent:FireServer()
	print("Exit button pressed")
end

return LobbyPlayerUIExitHandler
