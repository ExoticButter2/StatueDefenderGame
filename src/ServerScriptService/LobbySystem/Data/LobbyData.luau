local serverScriptService = game:GetService("ServerScriptService")
local helperModulesFolder: Folder = serverScriptService:FindFirstChild("HelperModules")

local timerModule = require(helperModulesFolder.TimerModuleClass)
local timerDisplayModule = require(helperModulesFolder.TimerDisplay)

local LobbyData = {}

LobbyData.maxPlayerLimit = 8
LobbyData.minPlayerLimit = 1

LobbyData.defaultPlayerLimit = 4

LobbyData.defaultFriendsOnly = false

LobbyData.touchPartName = "TouchPart"
LobbyData.enterPartName = "EnterPart"
LobbyData.exitPartName = "ExitPart"

LobbyData.defaultTeleportPlaceId = 138540525852189
LobbyData.defaultDuration = 30

export type LobbyData = typeof(setmetatable({} :: {
	playerLimit: number,
	friendsOnly: boolean,
	hostId: number,
	teleportPlaceId: number,
	lobbyId: number,
	players: {},
	touchPart: BasePart,
	enterPart: BasePart,
	exitPart: BasePart,
	lobbyOpen: boolean?,
	timer: timerModule.Timer,
	timerDisplay: timerDisplayModule.TimerDisplay,
	lobbyDuration: number,
}))

function LobbyData.new(
	playerLimit: number?,
	friendsOnly: boolean?,
	teleportPlaceId: number?,
	lobbyId: number,
	touchPart: BasePart,
	enterPart: BasePart,
	exitPart: BasePart,
	lobbyOpen: boolean?,
	timer: timerModule.Timer,
	timerDisplay: timerDisplayModule.TimerDisplay
): LobbyData
	local self = setmetatable({}, { __index = LobbyData })

	self.playerLimit = playerLimit or LobbyData.defaultPlayerLimit
	self.friendsOnly = friendsOnly
	self.hostId = nil
	self.teleportPlaceId = teleportPlaceId or LobbyData.defaultTeleportPlaceId
	self.lobbyId = lobbyId
	self.players = {}

	self.touchPart = touchPart
	self.enterPart = enterPart
	self.exitPart = exitPart

	self.lobbyOpen = lobbyOpen or true --open by default

	self.timer = timer
	self.timerDisplay = timerDisplay

	self.lobbyDuration = LobbyData.defaultDuration

	return self
end

return LobbyData
