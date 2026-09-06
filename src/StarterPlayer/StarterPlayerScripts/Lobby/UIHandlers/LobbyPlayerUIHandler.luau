--!strict
local replicatedStorage = game:GetService("ReplicatedStorage")
local starterPlayer = game:GetService("StarterPlayer")

local starterPlayerScripts: Folder = starterPlayer:WaitForChild("StarterPlayerScripts")
local lobbyUIScriptsFolder: Folder = starterPlayerScripts:WaitForChild("Lobby")
local lobbyUIDataFolder: Folder = lobbyUIScriptsFolder:WaitForChild("LobbyUIData")

local lobbyUIData = require(lobbyUIDataFolder.LobbyUIDatabase)

local eventsFolder = replicatedStorage:WaitForChild("Events")
local lobbyEventsFolder = eventsFolder:WaitForChild("Lobby")

local onTeleportEvent: RemoteEvent = lobbyEventsFolder:WaitForChild("OnPlayerTeleport")

local lobbyExitRequestEvent: RemoteEvent = lobbyEventsFolder:WaitForChild("LobbyExitRequest")

local exitButtonClickEvent: RBXScriptConnection = nil

local lobbyPlayerUIHandler = {}

function lobbyPlayerUIHandler.EnablePlayerUI()
	lobbyUIData.lobbyPlayerGui.Enabled = true
	print("Enabled Player lobby UI")
end

function lobbyPlayerUIHandler.DisablePlayerUI()
	lobbyUIData.lobbyPlayerGui.Enabled = false
	print("Disabled Player lobby UI")
end

local function OnExitButtonPress()
	lobbyExitRequestEvent:FireServer()
	print("Exit button pressed")
end

local function OnTeleport()
	lobbyPlayerUIHandler.DisablePlayerUI()
end

function lobbyPlayerUIHandler.UpdateUIEvents()
	if exitButtonClickEvent then
		exitButtonClickEvent:Disconnect()
	end

	exitButtonClickEvent = lobbyUIData.lobbyExitButton.MouseButton1Click:Connect(OnExitButtonPress)
end

function lobbyPlayerUIHandler.Initialize()
	lobbyPlayerUIHandler.UpdateUIEvents()
	onTeleportEvent.OnClientEvent:Connect(OnTeleport)
end

return lobbyPlayerUIHandler
