local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

local eventsFolder: Folder = replicatedStorage:WaitForChild("Events")
local lobbyEventsFolder: Folder = eventsFolder:WaitForChild("Lobby")

local lobbyStartRequest: RemoteEvent = lobbyEventsFolder:WaitForChild("LobbyStartRequest")

local playerGui: PlayerGui = players.LocalPlayer:WaitForChild("PlayerGui")
local lobbyUiFolder: Folder = playerGui:WaitForChild("LobbyUI")

local hostGui: ScreenGui = lobbyUiFolder:WaitForChild("HostGui")
local hostGuiFrame: Frame = hostGui:WaitForChild("Frame")

local lobbyStartButton: TextButton = hostGuiFrame:WaitForChild("LobbyStartButton")

local lobbyHostUIHandler = {}

function lobbyHostUIHandler.EnableHostUI()
	hostGui.Enabled = true
	print("Enabled host ui")
end

function lobbyHostUIHandler.DisableHostUI()
	hostGui.Enabled = false
	print("Disabled host ui")
end

local function RequestLobbyStart()
	lobbyStartRequest:FireServer()
	lobbyHostUIHandler.DisableHostUI()
	print("Requested lobby start")
end

function lobbyHostUIHandler.Initialize()
	lobbyStartButton.MouseButton1Click:Connect(RequestLobbyStart)
end

return lobbyHostUIHandler
