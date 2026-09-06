--!strict
local replicatedStorage = game:GetService("ReplicatedStorage")
local starterPlayer = game:GetService("StarterPlayer")

local starterPlayerScripts = starterPlayer:WaitForChild("StarterPlayerScripts")
local lobbyScriptsFolder: Folder = starterPlayerScripts:WaitForChild("Lobby")
local uiHandlersFolder: Folder = lobbyScriptsFolder:WaitForChild("UIHandlers")

local eventsFolder: Folder = replicatedStorage:WaitForChild("Events")
local lobbyEventsFolder: Folder = eventsFolder:WaitForChild("Lobby")

local onLobbyPlayerJoin: RemoteEvent = lobbyEventsFolder:WaitForChild("OnLobbyPlayerJoin")
local onLobbyHostJoin: RemoteEvent = lobbyEventsFolder:WaitForChild("OnLobbyHostJoin")
local onLobbyPlayerLeave: RemoteEvent = lobbyEventsFolder:WaitForChild("OnLobbyPlayerLeave")
local onLobbyHostLeave: RemoteEvent = lobbyEventsFolder:WaitForChild("OnLobbyHostLeave")

local lobbyPlayerUIHandler = require(uiHandlersFolder.LobbyPlayerUIHandler)
local lobbyHostUIHandler = require(uiHandlersFolder.LobbyHostUIHandler)

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

return LobbyClientEventHandler
