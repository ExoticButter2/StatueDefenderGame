--!strict
local serverScriptService = game:GetService("ServerScriptService")

local helperModulesFolder: Folder = serverScriptService.HelperModules
local lobbyClassesFolder: Folder = serverScriptService.LobbySystem.Classes

local timerModule = require(helperModulesFolder.TimerModuleClass)
local timerDisplayModule = require(helperModulesFolder.TimerDisplay)
local lobbyArgsModule = require(lobbyClassesFolder.LobbyArgs)

local playerLimitDisplayModule = require(lobbyClassesFolder.PlayerLimitDisplay)

local LobbyData = {}

LobbyData.teleportWaitTime = 4

LobbyData.touchPartName = "TouchPart"
LobbyData.enterPartName = "EnterPart"
LobbyData.exitPartName = "ExitPart"

export type LobbyData = typeof(setmetatable({} :: {
	args: lobbyArgsModule.LobbyArgs,
	hostId: number,
	lobbyId: number,
	playerIds: { Player },
	touchPart: BasePart,
	enterPart: BasePart,
	exitPart: BasePart,
	cameraPart: BasePart,
	lobbyOpen: boolean?,
	timer: timerModule.Timer,
	timerDisplay: timerDisplayModule.TimerDisplay,
	playerLimitDisplay: playerLimitDisplayModule.PlayerLimitDisplay,
}))

function LobbyData.new(
	args: lobbyArgsModule.LobbyArgs,
	lobbyId: number,
	touchPart: BasePart,
	enterPart: BasePart,
	exitPart: BasePart,
	cameraPart: BasePart,
	lobbyOpen: boolean?,
	timer: timerModule.Timer,
	timerDisplay: timerDisplayModule.TimerDisplay,
	playerLimitDisplay: playerLimitDisplayModule.PlayerLimitDisplay
): LobbyData
	local self = setmetatable({}, { __index = LobbyData })

	self.args = args

	self.hostId = nil
	self.lobbyId = lobbyId
	self.playerIds = {}

	self.touchPart = touchPart
	self.enterPart = enterPart
	self.exitPart = exitPart
	self.cameraPart = cameraPart

	self.lobbyOpen = lobbyOpen or true --open by default

	self.timer = timer
	self.timerDisplay = timerDisplay

	self.playerLimitDisplay = playerLimitDisplay

	return self
end

return LobbyData
