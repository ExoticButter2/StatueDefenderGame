--!strict
local starterPlayer = game:GetService("StarterPlayer")

local starterPlayerScripts: Folder = starterPlayer:WaitForChild("StarterPlayerScripts")
local lobbyUIScriptsFolder: Folder = starterPlayerScripts:WaitForChild("Lobby")
local lobbyUIDataFolder: Folder = lobbyUIScriptsFolder:WaitForChild("LobbyUIData")

local lobbyUIData = require(lobbyUIDataFolder.LobbyUIDatabase)

local friendsOnlyHandler = require(lobbyUIData.uiHandlersFolder.LobbyFriendsOnlyHandler)
local playerLimitHandler = require(lobbyUIData.uiHandlersFolder.LobbyPlayerLimitHandler)

local lobbyHostUIHandler = {}

function lobbyHostUIHandler.EnableHostUI()
	lobbyUIData.lobbyHostGui.Enabled = true
	print("Enabled host ui")
end

function lobbyHostUIHandler.DisableHostUI()
	lobbyUIData.lobbyHostGui.Enabled = false
	print("Disabled host ui")
end

function lobbyHostUIHandler.ResetUIToDefault()
	friendsOnlyHandler.ResetFriendsOnly()
	playerLimitHandler.ResetPlayerLimit()
end

return lobbyHostUIHandler
