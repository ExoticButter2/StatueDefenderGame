--!strict
local LobbyArgs = {}

LobbyArgs.maxPlayerLimit = 8
LobbyArgs.minPlayerLimit = 1

LobbyArgs.defaultPlayerLimit = 4

LobbyArgs.defaultFriendsOnly = false

local defaultTeleportPlaceId: number = 138540525852189

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

	self.teleportPlaceId = teleportPlaceId or defaultTeleportPlaceId
	self.friendsOnly = friendsOnly or LobbyArgs.defaultFriendsOnly
	self.playerLimit = playerLimit or LobbyArgs.defaultPlayerLimit

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

		if value > LobbyArgs.maxPlayerLimit or value < LobbyArgs.minPlayerLimit then
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
	self.friendsOnly = LobbyArgs.defaultFriendsOnly
	self.playerLimit = LobbyArgs.defaultPlayerLimit
	self.teleportPlaceId = defaultTeleportPlaceId
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
				self[setting] = math.clamp(v, LobbyArgs.minPlayerLimit, LobbyArgs.maxPlayerLimit) --to allow without aborting entirely
			end

			continue --check next setting
		end

		self[setting] = v

		print("Applied setting: " .. tostring(setting))
		print("To value: " .. tostring(v))
	end
end

return LobbyArgs
