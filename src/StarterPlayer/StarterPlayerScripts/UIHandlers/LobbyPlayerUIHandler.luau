local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

local playerGui = players.LocalPlayer:WaitForChild("PlayerGui")

local eventsFolder = replicatedStorage:WaitForChild("Events")
local lobbyEventsFolder = eventsFolder:WaitForChild("Lobby")

local lobbyExitRequestEvent: RemoteEvent = lobbyEventsFolder:WaitForChild("LobbyExitRequest")

local lobbyUIFolder: Folder = playerGui:WaitForChild("LobbyUI")

local exitButtonGui: SurfaceGui = lobbyUIFolder:WaitForChild("PlayerGui")
local exitButton: TextButton = exitButtonGui:WaitForChild("Frame"):WaitForChild("ExitButton")

local lobbyPlayerUIHandler = {}

function lobbyPlayerUIHandler.EnablePlayerUI()
	exitButtonGui.Enabled = true
	print("Enabled Player lobby UI")
end

function lobbyPlayerUIHandler.DisablePlayerUI()
	exitButtonGui.Enabled = false
	print("Disabled Player lobby UI")
end

local function OnExitButtonPress()
	lobbyExitRequestEvent:FireServer()
	print("Exit button pressed")
end

function lobbyPlayerUIHandler.Initialize()
	exitButton.MouseButton1Click:Connect(OnExitButtonPress)
end

return lobbyPlayerUIHandler
