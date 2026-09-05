local replicatedStorage = game:GetService("ReplicatedStorage")
local starterPlayer = game:GetService("StarterPlayer")
local players = game:GetService("Players")

local eventsFolder: Folder = replicatedStorage:WaitForChild("Events")
local lobbyEventsFolder: Folder = eventsFolder:WaitForChild("Lobby")

local lobbyStartRequest: RemoteEvent = lobbyEventsFolder:WaitForChild("LobbyStartRequest")

local playerGui: PlayerGui = players.LocalPlayer:WaitForChild("PlayerGui")
local lobbyUiFolder: Folder = playerGui:WaitForChild("LobbyUI")

local hostGui: ScreenGui = lobbyUiFolder:WaitForChild("HostGui")
local hostGuiBackgroundFrame: Frame = hostGui:WaitForChild("BackgroundFrame")
local hostGuiStartFrame: Frame = hostGuiBackgroundFrame:WaitForChild("StartFrame")

local lobbyStartButton: TextButton = hostGuiStartFrame:WaitForChild("LobbyStartButton")

local lobbyHostUIHandler =
	require(starterPlayer:WaitForChild("StarterPlayerScripts"):WaitForChild("UIHandlers").LobbyHostUIHandler)

local LobbyHostUIStartHandler = {}

local function RequestLobbyStart()
	lobbyStartRequest:FireServer()
	lobbyHostUIHandler.DisableHostUI()
	print("Requested lobby start")
end

function LobbyHostUIStartHandler.Initialize()
	lobbyStartButton.MouseButton1Click:Connect(RequestLobbyStart)
end

return LobbyHostUIStartHandler
