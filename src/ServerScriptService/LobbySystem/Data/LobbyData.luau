local LobbyData = {}

LobbyData.maxPlayerLimit = 8
LobbyData.minPlayerLimit = 1

LobbyData.defaultPlayerLimit = 4

LobbyData.defaultFriendsOnly = false

LobbyData.touchPartName = "TouchPart"
LobbyData.enterPartName = "EnterPart"
LobbyData.exitPartName = "ExitPart"

LobbyData.defaultTeleportPlaceId = 138540525852189

export type LobbyData = typeof(setmetatable({} :: {
	playerLimit: number,
	friendsOnly: boolean,
	hostId: number,
	teleportPlaceId: number,
}))

function LobbyData.new(playerLimit: number?, friendsOnly: boolean, teleportPlaceId: number?, lobbyId: number): LobbyData
	local self = setmetatable({}, { __index = LobbyData })

	self.playerLimit = playerLimit or LobbyData.defaultPlayerLimit
	self.friendsOnly = friendsOnly
	self.hostId = nil
	self.teleportPlaceId = teleportPlaceId or LobbyData.defaultTeleportPlaceId
	self.lobbyId = lobbyId

	return self
end

return LobbyData
