local starterPlayer = game:GetService("StarterPlayer")
local replicatedStorage = game:GetService("ReplicatedStorage")

local starterPlayerScripts: Folder = starterPlayer.StarterPlayerScripts
local lobbyUIScriptsFolder: Folder = starterPlayerScripts.Lobby
local lobbyUIDataFolder: Folder = lobbyUIScriptsFolder.LobbyUIData

local lobbyUIData = require(lobbyUIDataFolder.LobbyUIDatabase)
local lobbyConfig = require(replicatedStorage.Lobby.Data.LobbyConfig)

local LobbyPlayerLimitHandler = {}

local playerLimit: number = lobbyConfig.defaultPlayerLimit

local function UpdatePlayerLimitDisplayLabel()
	lobbyUIData.playerLimitDisplayLabel.Text = tostring(playerLimit)
end

local function SetPlayerLimitToValue(value: number)
	playerLimit = math.clamp(value, lobbyConfig.minPlayerLimit, lobbyConfig.maxPlayerLimit)

	lobbyUIData.changeLobbyArgsEvent:FireServer({ ["playerLimit"] = playerLimit })
	UpdatePlayerLimitDisplayLabel()
end

function LobbyPlayerLimitHandler.ResetPlayerLimit()
	SetPlayerLimitToValue(lobbyConfig.defaultPlayerLimit)
end

function LobbyPlayerLimitHandler.IncreasePlayerLimit()
	SetPlayerLimitToValue(playerLimit + 1)
	UpdatePlayerLimitDisplayLabel()
end

function LobbyPlayerLimitHandler.DecreasePlayerLimit()
	SetPlayerLimitToValue(playerLimit - 1)
	UpdatePlayerLimitDisplayLabel()
end

return LobbyPlayerLimitHandler
