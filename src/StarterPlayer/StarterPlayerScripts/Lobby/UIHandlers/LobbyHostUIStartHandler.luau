--!strict
local starterPlayer = game:GetService("StarterPlayer")

local starterPlayerScripts: Folder = starterPlayer.StarterPlayerScripts
local lobbyUIScriptsFolder: Folder = starterPlayerScripts.Lobby
local lobbyUIDataFolder: Folder = lobbyUIScriptsFolder.LobbyUIData

local lobbyUIData = require(lobbyUIDataFolder.LobbyUIDatabase)

local lobbyUIHandlersFolder: Folder = lobbyUIScriptsFolder.UIHandlers

local lobbyStartRequest: RemoteEvent = lobbyUIData.lobbyEventsFolder.LobbyStartRequest

local lobbyHostUIHandler = require(lobbyUIHandlersFolder.LobbyHostUIHandler)

local LobbyHostUIStartHandler = {}

function LobbyHostUIStartHandler.RequestLobbyStart()
	lobbyStartRequest:FireServer()
	lobbyHostUIHandler.DisableHostUI()
	print("Requested lobby start")
end

return LobbyHostUIStartHandler
