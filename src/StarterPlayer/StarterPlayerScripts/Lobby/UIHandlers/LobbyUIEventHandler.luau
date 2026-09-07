local starterPlayer = game:GetService("StarterPlayer")
local players = game:GetService("Players")

local lobbyUIData = require(starterPlayer.StarterPlayerScripts.Lobby.LobbyUIData.LobbyUIDatabase)

local LobbyUIEventHandler = {}

local startButtonPress: RBXScriptConnection = nil
local playerLimitIncreasePress: RBXScriptConnection = nil
local playerLimitDecreasePress: RBXScriptConnection = nil
local exitButtonPress: RBXScriptConnection = nil

local function OnStartButtonPress() end

local function OnPlayerLimitIncreasePress() end

local function OnPlayerLimitDecreasePress() end

local function OnExitButtonPress() end

local function UpdateUIEvents()
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

	startButtonPress = lobbyUIData.startLobbyButton.MouseButton1Click:Connect(OnStartButtonPress)
	exitButtonPress = lobbyUIData.playerExitButton.MouseButton1Click:Connect(OnExitButtonPress)

	playerLimitIncreasePress =
		lobbyUIData.playerLimitIncreaseButton.MouseButton1Click:Connect(OnPlayerLimitIncreasePress)
	playerLimitDecreasePress =
		lobbyUIData.playerLimitDecreaseButton.MouseButton1Click:Connect(OnPlayerLimitDecreasePress)
end

function LobbyUIEventHandler.Initialize()
	UpdateUIEvents()
	players.LocalPlayer.CharacterAdded:Connect(UpdateUIEvents)
end

return LobbyUIEventHandler
