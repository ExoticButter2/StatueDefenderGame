--!strict
local starterPlayer = game:GetService("StarterPlayer")

local starterPlayerScripts = starterPlayer:WaitForChild("StarterPlayerScripts")

local lobbyUIDataFolder: Folder = starterPlayerScripts:WaitForChild("Lobby"):WaitForChild("LobbyUIData")
local lobbyUIData = require(lobbyUIDataFolder.LobbyUIDatabase)

local onLobbyPlayerJoin: RemoteEvent = lobbyUIData.lobbyEventsFolder:WaitForChild("OnLobbyPlayerJoin")
local onLobbyHostJoin: RemoteEvent = lobbyUIData.lobbyEventsFolder:WaitForChild("OnLobbyHostJoin")
local onLobbyPlayerLeave: RemoteEvent = lobbyUIData.lobbyEventsFolder:WaitForChild("OnLobbyPlayerLeave")
local onLobbyHostLeave: RemoteEvent = lobbyUIData.lobbyEventsFolder:WaitForChild("OnLobbyHostLeave")

local lobbyPlayerUIHandler = require(lobbyUIData.uiHandlersFolder.LobbyPlayerUIHandler)
local lobbyHostUIHandler = require(lobbyUIData.uiHandlersFolder.LobbyHostUIHandler)

local LobbyClientEventHandler = {}

local function OnPlayerJoin()
	print("Joined lobby as regular player and received via event")
	lobbyPlayerUIHandler.EnablePlayerUI()
end

local function OnHostJoin()
	print("Joined lobby as host and received via event")
	lobbyHostUIHandler.EnableHostUI()
end

local function OnPlayerLeave()
	print("Left lobby as player and received via event")
	lobbyPlayerUIHandler.DisablePlayerUI()
end

local function OnHostLeave()
	print("Left lobby as host and received via event")
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
