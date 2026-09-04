local replicatedStorage = game:GetService("ReplicatedStorage")
local starterPlayer = game:GetService("StarterPlayer")

local starterPlayerScripts = starterPlayer:WaitForChild("StarterPlayerScripts")
local uiHandlersFolder: Folder = starterPlayerScripts:WaitForChild("UIHandlers")

local eventsFolder = replicatedStorage:WaitForChild("Events")

local onLobbyPlayerJoin: RemoteEvent = eventsFolder:FindFirstChild("OnLobbyPlayerJoin")
local onLobbyHostJoin: RemoteEvent = eventsFolder:FindFirstChild("OnLobbyHostJoin")
local onLobbyPlayerLeave: RemoteEvent = eventsFolder:FindFirstChild("OnLobbyPlayerLeave")

local lobbyPlayerUIHandler = require(uiHandlersFolder.LobbyPlayerUIHandler)

local LobbyClientEventHandler = {}

local function OnPlayerJoin()
	print("Joined lobby as regular player and received via event")
	lobbyPlayerUIHandler.EnablePlayerUI()
end

local function OnHostJoin()
	print("Joined lobby as host and received via event")
end

local function OnPlayerLeave()
	print("Left lobby")
	lobbyPlayerUIHandler.DisablePlayerUI()
end

function LobbyClientEventHandler.Initialize()
	onLobbyPlayerJoin.OnClientEvent:Connect(OnPlayerJoin)
	onLobbyHostJoin.OnClientEvent:Connect(OnHostJoin)
	onLobbyPlayerLeave.OnClientEvent:Connect(OnPlayerLeave)
end

return LobbyClientEventHandler
