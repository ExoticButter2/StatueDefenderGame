--!strict
local serverScriptService = game:GetService("ServerScriptService")
local helperModulesFolder: Folder = serverScriptService:FindFirstChild("HelperModules")

local timerModule = require(helperModulesFolder.TimerModuleClass)
local timerDisplayModule = require(helperModulesFolder.TimerDisplay)

local LobbyData = {}

LobbyData.maxPlayerLimit = 8
LobbyData.minPlayerLimit = 1

LobbyData.defaultPlayerLimit = 4

LobbyData.teleportWaitTime = 4

LobbyData.defaultFriendsOnly = false

LobbyData.touchPartName = "TouchPart"
LobbyData.enterPartName = "EnterPart"
LobbyData.exitPartName = "ExitPart"

LobbyData.defaultTeleportPlaceId = 138540525852189

export type LobbyData = typeof(setmetatable({} :: {
	args: LobbyArgs,
	hostId: number,
	lobbyId: number,
	playerIds: { Player },
	touchPart: BasePart,
	enterPart: BasePart,
	exitPart: BasePart,
	lobbyOpen: boolean?,
	timer: timerModule.Timer,
	timerDisplay: timerDisplayModule.TimerDisplay,
}))

export type LobbyArgs = {
	["friendsOnly"]: boolean,
	["playerLimit"]: number,
	["teleportPlaceId"]: number,
}

function LobbyData.new(
	args: LobbyArgs,
	lobbyId: number,
	touchPart: BasePart,
	enterPart: BasePart,
	exitPart: BasePart,
	lobbyOpen: boolean?,
	timer: timerModule.Timer,
	timerDisplay: timerDisplayModule.TimerDisplay
): LobbyData
	local self = setmetatable({}, { __index = LobbyData })

	self.args = args
	self.hostId = nil
	self.lobbyId = lobbyId
	self.playerIds = {}

	self.touchPart = touchPart
	self.enterPart = enterPart
	self.exitPart = exitPart

	self.lobbyOpen = lobbyOpen or true --open by default

	self.timer = timer
	self.timerDisplay = timerDisplay

	return self
end

return LobbyData
