--!strict
local serverScriptService = game:GetService("ServerScriptService")
local replicatedStorage = game:GetService("ReplicatedStorage")

local helperModulesFolder: Folder = serverScriptService:FindFirstChild("HelperModules")

local timerModule = require(helperModulesFolder.TimerModuleClass)
local timerDisplayModule = require(helperModulesFolder.TimerDisplay)
local lobbyArgsModule = require(replicatedStorage.Lobby.Data.LobbyArgs)

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
	lobbyOpen: boolean?,
	timer: timerModule.Timer,
	timerDisplay: timerDisplayModule.TimerDisplay,
}))

function LobbyData.new(
	args: lobbyArgsModule.LobbyArgs,
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
