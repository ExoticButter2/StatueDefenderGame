local starterPlayer = game:GetService("StarterPlayer")
local replicatedStorage = game:GetService("ReplicatedStorage")

local starterPlayerScripts: Folder = starterPlayer:WaitForChild("StarterPlayerScripts")
local lobbyUIScriptsFolder: Folder = starterPlayerScripts:WaitForChild("Lobby")
local lobbyUIDataFolder: Folder = lobbyUIScriptsFolder:WaitForChild("LobbyUIData")

local lobbyUIData = require(lobbyUIDataFolder.LobbyUIDatabase)
local lobbyArgs = require(replicatedStorage.Lobby.Data.LobbyArgs)

local LobbyFriendsOnlyHandler = {}

local friendsOnly: boolean = lobbyArgs.defaultFriendsOnly

local greenColor: Color3 = Color3.new(0, 1, 0)
local redColor: Color3 = Color3.new(1, 0, 0)

local function UpdateFriendsOnlyButtonColor()
	if friendsOnly then
		lobbyUIData.friendsOnlyToggleButton.BackgroundColor3 = greenColor
	else
		lobbyUIData.friendsOnlyToggleButton.BackgroundColor3 = redColor
	end
end

local function SetFriendsOnlyToValue(value: number)
	friendsOnly = value
	UpdateFriendsOnlyButtonColor()
end

function LobbyFriendsOnlyHandler.ResetFriendsOnly()
	SetFriendsOnlyToValue(lobbyArgs.defaultFriendsOnly)
end

function LobbyFriendsOnlyHandler.OnFriendsOnlyButtonPress()
	SetFriendsOnlyToValue(not friendsOnly) --toggle friendsonly
	lobbyUIData.changeLobbyArgsEvent:FireServer({ ["friendsOnly"] = friendsOnly })

	print("Pressed friends only button")
end

return LobbyFriendsOnlyHandler
