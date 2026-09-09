local starterPlayer = game:GetService("StarterPlayer")
local replicatedStorage = game:GetService("ReplicatedStorage")

local starterPlayerScripts: Folder = starterPlayer:WaitForChild("StarterPlayerScripts")
local lobbyUIScriptsFolder: Folder = starterPlayerScripts:WaitForChild("Lobby")
local lobbyUIDataFolder: Folder = lobbyUIScriptsFolder:WaitForChild("LobbyUIData")

local lobbyUIData = require(lobbyUIDataFolder.LobbyUIDatabase)
local lobbyArgs = require(replicatedStorage.Lobby.Data.LobbyArgs)

local LobbyPlayerLimitHandler = {}

local playerLimit: number = lobbyArgs.defaultPlayerLimit

local function UpdatePlayerLimitDisplayLabel()
	lobbyUIData.playerLimitDisplayLabel.Text = tostring(playerLimit)
end

local function SetPlayerLimitToValue(value: number)
	playerLimit = math.clamp(value, lobbyArgs.minPlayerLimit, lobbyArgs.maxPlayerLimit)

	lobbyUIData.changeLobbyArgsEvent:FireServer({ ["playerLimit"] = playerLimit })
	UpdatePlayerLimitDisplayLabel()
end

function LobbyPlayerLimitHandler.ResetPlayerLimit()
	SetPlayerLimitToValue(lobbyArgs.defaultPlayerLimit)
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
