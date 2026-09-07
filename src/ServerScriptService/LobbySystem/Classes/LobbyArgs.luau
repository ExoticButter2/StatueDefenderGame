--!strict
local LobbyArgs = {}

local maxPlayerLimit: number = 8
local minPlayerLimit: number = 1

local defaultPlayerLimit: number = 4

local defaultFriendsOnly: boolean = false

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
	self.friendsOnly = friendsOnly or defaultFriendsOnly
	self.playerLimit = playerLimit or defaultPlayerLimit

	return self
end

local function ValidateSetting(setting, value): boolean
	if setting == "friendsOnly" then
		if type(setting) ~= "boolean" then
			return false
		end
	elseif setting == "playerLimit" then
		if type(setting) ~= "number" then
			return false
		end

		if value > maxPlayerLimit or value < minPlayerLimit then
			return false
		end
	elseif setting == "teleportPlaceId" then
		if type(setting) ~= "number" then
			return false
		end
	end

	return true
end

function LobbyArgs:ChangeArgs(argsToChange: {})
	for setting, v in pairs(argsToChange) do
		if not self[setting] then
			continue
		end

		if not ValidateSetting(setting, v) then
			warn("Player who changed args possibly cheating")
			if setting == "playerLimit" then
				self[setting] = math.clamp(v, minPlayerLimit, maxPlayerLimit) --to allow without aborting entirely
			end

			continue --check next setting
		end

		self[setting] = v

		print("Applied setting: " .. setting)
		print("To value: " .. v)
	end
end

return LobbyArgs
