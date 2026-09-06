--!strict
local replicatedStorage = game:GetService("ReplicatedStorage")
local starterPlayer = game:GetService("StarterPlayer")

local starterPlayerScripts: Folder = starterPlayer:WaitForChild("StarterPlayerScripts")
local lobbyUIScriptsFolder: Folder = starterPlayerScripts:WaitForChild("Lobby")
local lobbyUIDataFolder: Folder = lobbyUIScriptsFolder:WaitForChild("LobbyUIData")

local lobbyUIData = require(lobbyUIDataFolder.LobbyUIDatabase)

local lobbyUIHandlersFolder: Folder = lobbyUIScriptsFolder:WaitForChild("UIHandlers")

local eventsFolder: Folder = replicatedStorage:WaitForChild("Events")
local lobbyEventsFolder: Folder = eventsFolder:WaitForChild("Lobby")

local lobbyStartRequest: RemoteEvent = lobbyEventsFolder:WaitForChild("LobbyStartRequest")

local lobbyHostUIHandler = require(lobbyUIHandlersFolder.LobbyHostUIHandler)

local LobbyHostUIStartHandler = {}

local startButtonClickEvent: RBXScriptConnection = nil

local function RequestLobbyStart()
	lobbyStartRequest:FireServer()
	lobbyHostUIHandler.DisableHostUI()
	print("Requested lobby start")
end

function LobbyHostUIStartHandler.UpdateUIEvents()
	if startButtonClickEvent then
		startButtonClickEvent:Disconnect()
	end

	startButtonClickEvent = lobbyUIData.startLobbyButton.MouseButton1Click:Connect(RequestLobbyStart)
end

function LobbyHostUIStartHandler.Initialize()
	LobbyHostUIStartHandler.UpdateUIEvents()

	startButtonClickEvent = lobbyUIData.startLobbyButton.MouseButton1Click:Connect(RequestLobbyStart)
end

return LobbyHostUIStartHandler
