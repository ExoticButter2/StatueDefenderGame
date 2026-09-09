--!strict
local starterPlayer = game:GetService("StarterPlayer")

local starterPlayerScripts: Folder = starterPlayer:WaitForChild("StarterPlayerScripts")
local lobbyUIScriptsFolder: Folder = starterPlayerScripts:WaitForChild("Lobby")
local lobbyUIDataFolder: Folder = lobbyUIScriptsFolder:WaitForChild("LobbyUIData")

local lobbyUIData = require(lobbyUIDataFolder.LobbyUIDatabase)

local lobbyUIHandlersFolder: Folder = lobbyUIScriptsFolder:WaitForChild("UIHandlers")

local lobbyStartRequest: RemoteEvent = lobbyUIData.lobbyEventsFolder:WaitForChild("LobbyStartRequest")

local lobbyHostUIHandler = require(lobbyUIHandlersFolder.LobbyHostUIHandler)

local LobbyHostUIStartHandler = {}

function LobbyHostUIStartHandler.RequestLobbyStart()
	lobbyStartRequest:FireServer()
	lobbyHostUIHandler.DisableHostUI()
	print("Requested lobby start")
end

return LobbyHostUIStartHandler
