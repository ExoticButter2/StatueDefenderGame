--!strict
local players = game:GetService("Players")
local starterPlayer = game:GetService("StarterPlayer")
local replicatedStorage = game:GetService("ReplicatedStorage")

local starterPlayerScripts: Folder = starterPlayer:WaitForChild("StarterPlayerScripts")

local LobbyUIDatabase = {}

LobbyUIDatabase.lobbyClientFolder = starterPlayerScripts:WaitForChild("Lobby")
LobbyUIDatabase.handlersFolder = LobbyUIDatabase.lobbyClientFolder:WaitForChild("Handlers")
LobbyUIDatabase.uiHandlersFolder = LobbyUIDatabase.lobbyClientFolder:WaitForChild("UIHandlers")

LobbyUIDatabase.lobbyEventsFolder = replicatedStorage:WaitForChild("Events"):WaitForChild("Lobby")
LobbyUIDatabase.changeLobbyArgsEvent = LobbyUIDatabase.lobbyEventsFolder:WaitForChild("ChangeLobbyArgs")

function LobbyUIDatabase.UpdateUIVariables()
	LobbyUIDatabase.playerGui = players.LocalPlayer:WaitForChild("PlayerGui")

	LobbyUIDatabase.lobbyUiFolder = LobbyUIDatabase.playerGui:WaitForChild("LobbyUI")

	LobbyUIDatabase.lobbyHostGui = LobbyUIDatabase.lobbyUiFolder:WaitForChild("HostGui")
	LobbyUIDatabase.lobbyPlayerGui = LobbyUIDatabase.lobbyUiFolder:WaitForChild("PlayerGui")

	LobbyUIDatabase.playerExitButton = LobbyUIDatabase.lobbyPlayerGui:WaitForChild("Frame"):WaitForChild("ExitButton")

	LobbyUIDatabase.lobbyExitFrame = LobbyUIDatabase.lobbyPlayerGui:WaitForChild("Frame")
	LobbyUIDatabase.lobbyExitButton = LobbyUIDatabase.lobbyExitFrame:WaitForChild("ExitButton")

	LobbyUIDatabase.hostBackgroundFrame = LobbyUIDatabase.lobbyHostGui:WaitForChild("BackgroundFrame")

	LobbyUIDatabase.startLobbyFrame = LobbyUIDatabase.hostBackgroundFrame:WaitForChild("StartFrame")
	LobbyUIDatabase.startLobbyButton = LobbyUIDatabase.startLobbyFrame:WaitForChild("LobbyStartButton")

	LobbyUIDatabase.friendsOnlyFrame = LobbyUIDatabase.hostBackgroundFrame:WaitForChild("FriendsOnlyFrame")
	LobbyUIDatabase.friendsOnlyToggleButton = LobbyUIDatabase.friendsOnlyFrame:WaitForChild("FriendsOnlyToggle")

	LobbyUIDatabase.playerLimitFrame = LobbyUIDatabase.hostBackgroundFrame:WaitForChild("PlayerLimitFrame")

	LobbyUIDatabase.playerLimitDisplayLabel = LobbyUIDatabase.playerLimitFrame:WaitForChild("AmountLabel")
	LobbyUIDatabase.playerLimitIncreaseButton = LobbyUIDatabase.playerLimitFrame:WaitForChild("IncreaseButton")
	LobbyUIDatabase.playerLimitDecreaseButton = LobbyUIDatabase.playerLimitFrame:WaitForChild("DecreaseButton")
end

function LobbyUIDatabase.Initialize()
	LobbyUIDatabase.UpdateUIVariables()
end

return LobbyUIDatabase
