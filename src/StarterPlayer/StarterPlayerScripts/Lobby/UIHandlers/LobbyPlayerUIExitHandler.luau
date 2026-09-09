local starterPlayer = game:GetService("StarterPlayer")

local starterPlayerScripts: Folder = starterPlayer:WaitForChild("StarterPlayerScripts")
local lobbyUIScriptsFolder: Folder = starterPlayerScripts:WaitForChild("Lobby")
local lobbyUIDataFolder: Folder = lobbyUIScriptsFolder:WaitForChild("LobbyUIData")

local lobbyUIData = require(lobbyUIDataFolder.LobbyUIDatabase)

local lobbyExitRequestEvent = lobbyUIData.lobbyEventsFolder:WaitForChild("LobbyExitRequest")

local LobbyPlayerUIExitHandler = {}

function LobbyPlayerUIExitHandler.OnExitButtonPress()
	lobbyExitRequestEvent:FireServer()
	print("Exit button pressed")
end

return LobbyPlayerUIExitHandler
