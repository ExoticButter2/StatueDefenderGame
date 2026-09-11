local starterPlayer = game:GetService("StarterPlayer")

local lobbyUIData = require(starterPlayer.StarterPlayerScripts.Lobby.LobbyUIData.LobbyUIDatabase)

local lobbyStartHandler = require(lobbyUIData.uiHandlersFolder.LobbyHostUIStartHandler)
local lobbyFriendsOnlyHandler = require(lobbyUIData.uiHandlersFolder.LobbyFriendsOnlyHandler)
local lobbyPlayerLimitHandler = require(lobbyUIData.uiHandlersFolder.LobbyPlayerLimitHandler)

local lobbyHostUiHandler = require(lobbyUIData.uiHandlersFolder.LobbyHostUIHandler)
local lobbyPlayerUiHandler = require(lobbyUIData.uiHandlersFolder.LobbyPlayerUIHandler)

local lobbyExitHandler = require(lobbyUIData.uiHandlersFolder.LobbyPlayerUIExitHandler)

local LobbyUIEventHandler = {}

local startButtonPress: RBXScriptConnection = nil
local playerLimitIncreasePress: RBXScriptConnection = nil
local playerLimitDecreasePress: RBXScriptConnection = nil
local friendsOnlyTogglePress: RBXScriptConnection = nil
local exitButtonPress: RBXScriptConnection = nil

local hostLeaveEvent: RemoteEvent = lobbyUIData.lobbyEventsFolder:WaitForChild("OnLobbyHostLeave")
local playerTeleportEvent: RemoteEvent = lobbyUIData.lobbyEventsFolder:WaitForChild("OnPlayerTeleport")

local function OnStartButtonPress()
	lobbyStartHandler.RequestLobbyStart()
end

local function OnPlayerLimitIncreasePress()
	lobbyPlayerLimitHandler.IncreasePlayerLimit()
end

local function OnPlayerLimitDecreasePress()
	lobbyPlayerLimitHandler.DecreasePlayerLimit()
end

local function OnExitButtonPress()
	lobbyExitHandler.OnExitButtonPress()
end

local function OnFriendsOnlyButtonPress()
	lobbyFriendsOnlyHandler.OnFriendsOnlyButtonPress()
end

local function OnHostLeave()
	lobbyHostUiHandler.ResetUIToDefault()
end

local function OnPlayerTeleport()
	lobbyPlayerUiHandler.OnTeleport()
end

function LobbyUIEventHandler.UpdateUIEvents()
	if startButtonPress then
		startButtonPress:Disconnect()
		startButtonPress = nil
	end

	if exitButtonPress then
		exitButtonPress:Disconnect()
		exitButtonPress = nil
	end

	if playerLimitIncreasePress then
		playerLimitIncreasePress:Disconnect()
		playerLimitIncreasePress = nil
	end

	if playerLimitDecreasePress then
		playerLimitDecreasePress:Disconnect()
		playerLimitDecreasePress = nil
	end

	if friendsOnlyTogglePress then
		friendsOnlyTogglePress:Disconnect()
		friendsOnlyTogglePress = nil
	end

	startButtonPress = lobbyUIData.startLobbyButton.MouseButton1Click:Connect(OnStartButtonPress)
	exitButtonPress = lobbyUIData.playerExitButton.MouseButton1Click:Connect(OnExitButtonPress)

	playerLimitIncreasePress =
		lobbyUIData.playerLimitIncreaseButton.MouseButton1Click:Connect(OnPlayerLimitIncreasePress)
	playerLimitDecreasePress =
		lobbyUIData.playerLimitDecreaseButton.MouseButton1Click:Connect(OnPlayerLimitDecreasePress)

	friendsOnlyTogglePress = lobbyUIData.friendsOnlyToggleButton.MouseButton1Click:Connect(OnFriendsOnlyButtonPress)
end

function LobbyUIEventHandler.Initialize()
	LobbyUIEventHandler.UpdateUIEvents()

	hostLeaveEvent.OnClientEvent:Connect(OnHostLeave)
	playerTeleportEvent.OnClientEvent:Connect(OnPlayerTeleport)
end

LobbyUIEventHandler.Initialize()

return LobbyUIEventHandler
