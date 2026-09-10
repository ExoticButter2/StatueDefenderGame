--!strict
local players = game:GetService("Players")
local starterPlayer = game:GetService("StarterPlayer")
local replicatedStorage = game:GetService("ReplicatedStorage")

local starterPlayerScripts: Folder = starterPlayer.StarterPlayerScripts

local LobbyUIDatabase = {}

LobbyUIDatabase.lobbyClientFolder = starterPlayerScripts.Lobby
LobbyUIDatabase.handlersFolder = LobbyUIDatabase.lobbyClientFolder.Handlers
LobbyUIDatabase.uiHandlersFolder = LobbyUIDatabase.lobbyClientFolder.UIHandlers

LobbyUIDatabase.lobbyEventsFolder = replicatedStorage.Lobby.Events
LobbyUIDatabase.changeLobbyArgsEvent = LobbyUIDatabase.lobbyEventsFolder.ChangeLobbyArgs

function LobbyUIDatabase.UpdateUIVariables()
	LobbyUIDatabase.playerGui = players.LocalPlayer.PlayerGui

	LobbyUIDatabase.lobbyUiFolder = LobbyUIDatabase.playerGui.LobbyUI

	LobbyUIDatabase.lobbyHostGui = LobbyUIDatabase.lobbyUiFolder.HostGui
	LobbyUIDatabase.lobbyPlayerGui = LobbyUIDatabase.lobbyUiFolder.PlayerGui

	LobbyUIDatabase.playerExitFrame = LobbyUIDatabase.lobbyPlayerGui.Frame
	LobbyUIDatabase.playerExitButton = LobbyUIDatabase.playerExitFrame.ExitButton

	LobbyUIDatabase.lobbyExitFrame = LobbyUIDatabase.lobbyPlayerGui.Frame
	LobbyUIDatabase.lobbyExitButton = LobbyUIDatabase.lobbyExitFrame.ExitButton

	LobbyUIDatabase.hostBackgroundFrame = LobbyUIDatabase.lobbyHostGui.BackgroundFrame

	LobbyUIDatabase.startLobbyFrame = LobbyUIDatabase.hostBackgroundFrame.StartFrame
	LobbyUIDatabase.startLobbyButton = LobbyUIDatabase.startLobbyFrame.LobbyStartButton

	LobbyUIDatabase.friendsOnlyFrame = LobbyUIDatabase.hostBackgroundFrame.FriendsOnlyFrame
	LobbyUIDatabase.friendsOnlyToggleButton = LobbyUIDatabase.friendsOnlyFrame.FriendsOnlyToggle

	LobbyUIDatabase.playerLimitFrame = LobbyUIDatabase.hostBackgroundFrame.PlayerLimitFrame

	LobbyUIDatabase.playerLimitDisplayLabel = LobbyUIDatabase.playerLimitFrame.AmountLabel
	LobbyUIDatabase.playerLimitIncreaseButton = LobbyUIDatabase.playerLimitFrame.IncreaseButton
	LobbyUIDatabase.playerLimitDecreaseButton = LobbyUIDatabase.playerLimitFrame.DecreaseButton
end

function LobbyUIDatabase.Initialize()
	LobbyUIDatabase.UpdateUIVariables()
	print("Initialized lobby UI database")
end

LobbyUIDatabase.Initialize()

return LobbyUIDatabase
