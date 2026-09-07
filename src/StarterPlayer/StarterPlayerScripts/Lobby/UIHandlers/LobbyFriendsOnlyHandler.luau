local starterPlayer = game:GetService("StarterPlayer")
local players = game:GetService("Players")

local starterPlayerScripts: Folder = starterPlayer:WaitForChild("StarterPlayerScripts")
local lobbyUIScriptsFolder: Folder = starterPlayerScripts:WaitForChild("Lobby")
local lobbyUIDataFolder: Folder = lobbyUIScriptsFolder:WaitForChild("LobbyUIData")

local lobbyUIData = require(lobbyUIDataFolder.LobbyUIDatabase)

local LobbyFriendsOnlyHandler = {}

local friendsOnly: boolean = false

local greenColor: Color3 = Color3.new(0, 1, 0)
local redColor: Color3 = Color3.new(1, 0, 0)

function LobbyFriendsOnlyHandler.OnFriendsOnlyButtonPress()
	friendsOnly = not friendsOnly --toggle friendsonly
	lobbyUIData.changeLobbyArgsEvent:FireServer({ ["friendsOnly"] = friendsOnly }, players.LocalPlayer)

	if friendsOnly then
		lobbyUIData.friendsOnlyToggleButton.BackgroundColor3 = greenColor
	else
		lobbyUIData.friendsOnlyToggleButton.BackgroundColor3 = redColor
	end
end

return LobbyFriendsOnlyHandler
