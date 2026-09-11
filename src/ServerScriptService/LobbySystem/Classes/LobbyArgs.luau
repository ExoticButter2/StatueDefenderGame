--!strict
local replicatedStorage = game:GetService("ReplicatedStorage")
local serverStorage = game:GetService("ServerStorage")

local lobbyEventsFolder: Folder = serverStorage.Events.Lobby

local lobbyArgsChangeEvent: BindableEvent = lobbyEventsFolder.OnLobbyArgsChange

local lobbyConfig = require(replicatedStorage.Lobby.Data.LobbyConfig)

local LobbyArgs = {}

export type LobbyArgs = typeof(setmetatable(
	{},
	{} :: {
		friendsOnly: boolean,
		playerLimit: number,
		teleportPlaceId: number,
	}
))

function LobbyArgs.new(teleportPlaceId: number?, friendsOnly: boolean?, playerLimit: number?): LobbyArgs
	local self = setmetatable({}, { __index = LobbyArgs })

	self.teleportPlaceId = teleportPlaceId or lobbyConfig.defaultTeleportPlaceId
	self.friendsOnly = friendsOnly or lobbyConfig.defaultFriendsOnly
	self.playerLimit = playerLimit or lobbyConfig.defaultPlayerLimit
	self.lobbyData = nil

	return self
end

local function ValidateSetting(setting, value): boolean
	if setting == "friendsOnly" then
		if type(value) ~= "boolean" then
			return false
		end
	elseif setting == "playerLimit" then
		if type(value) ~= "number" then
			return false
		end

		if value > lobbyConfig.maxPlayerLimit or value < lobbyConfig.minPlayerLimit then
			return false
		end
	elseif setting == "teleportPlaceId" then
		if type(value) ~= "number" then
			return false
		end
	end

	return true
end

function LobbyArgs:ResetArgsToDefault()
	self.friendsOnly = lobbyConfig.defaultFriendsOnly
	self.playerLimit = lobbyConfig.defaultPlayerLimit
	self.teleportPlaceId = lobbyConfig.defaultTeleportPlaceId
end

function LobbyArgs:ChangeArgs(argsToChange: {})
	for setting, v in pairs(argsToChange) do
		if self[setting] == nil then
			warn("Setting doesn't match with lobbyArgs settings!")
			continue
		end

		if not ValidateSetting(setting, v) then
			warn("Player who changed args possibly cheating")
			if setting == "playerLimit" then
				self[setting] = math.clamp(v, lobbyConfig.minPlayerLimit, lobbyConfig.maxPlayerLimit) --to allow without aborting entirely
			end

			continue --check next setting
		end

		self[setting] = v

		lobbyArgsChangeEvent:Fire(self.lobbyData.lobbyId, setting)

		print("Applied setting: " .. tostring(setting))
		print("To value: " .. tostring(v))
	end
end

return LobbyArgs
