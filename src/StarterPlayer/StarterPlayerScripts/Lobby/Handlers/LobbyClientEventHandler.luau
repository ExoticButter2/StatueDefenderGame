--!strict
local starterPlayer = game:GetService("StarterPlayer")

local starterPlayerScripts = starterPlayer.StarterPlayerScripts

local lobbyUIDataFolder: Folder = starterPlayerScripts.Lobby.LobbyUIData
local lobbyUIData = require(lobbyUIDataFolder.LobbyUIDatabase)

local onLobbyPlayerJoin: RemoteEvent = lobbyUIData.lobbyEventsFolder.OnLobbyPlayerJoin
local onLobbyHostJoin: RemoteEvent = lobbyUIData.lobbyEventsFolder.OnLobbyHostJoin
local onLobbyPlayerLeave: RemoteEvent = lobbyUIData.lobbyEventsFolder.OnLobbyPlayerLeave
local onLobbyHostLeave: RemoteEvent = lobbyUIData.lobbyEventsFolder.OnLobbyHostLeave

local lobbyPlayerUIHandler = require(lobbyUIData.uiHandlersFolder.LobbyPlayerUIHandler)
local lobbyHostUIHandler = require(lobbyUIData.uiHandlersFolder.LobbyHostUIHandler)
local lobbyCameraMovement = require(starterPlayerScripts.Lobby.Modules.LobbyCameraMovement)

local startCameraMovementEvent: RemoteEvent = lobbyUIData.lobbyEventsFolder.StartCameraMovement
local stopCameraMovementEvent: RemoteEvent = lobbyUIData.lobbyEventsFolder.StopCameraMovement

startCameraMovementEvent.OnClientEvent:Connect(lobbyCameraMovement.StartCameraMovement)
stopCameraMovementEvent.OnClientEvent:Connect(lobbyCameraMovement.StopCameraMovement)

local LobbyClientEventHandler = {}

local function OnPlayerJoin()
	lobbyPlayerUIHandler.EnablePlayerUI()
end

local function OnHostJoin()
	lobbyHostUIHandler.EnableHostUI()
end

local function OnPlayerLeave()
	lobbyPlayerUIHandler.DisablePlayerUI()
end

local function OnHostLeave()
	lobbyHostUIHandler.DisableHostUI()
end

function LobbyClientEventHandler.Initialize()
	onLobbyPlayerJoin.OnClientEvent:Connect(OnPlayerJoin)
	onLobbyPlayerLeave.OnClientEvent:Connect(OnPlayerLeave)

	onLobbyHostJoin.OnClientEvent:Connect(OnHostJoin)
	onLobbyHostLeave.OnClientEvent:Connect(OnHostLeave)
end

LobbyClientEventHandler.Initialize()

return LobbyClientEventHandler
