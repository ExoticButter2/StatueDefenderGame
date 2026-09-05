local serverScriptService = game:GetService("ServerScriptService")
local serverStorage = game:GetService("ServerStorage")

local eventsFolder: Folder = serverStorage:FindFirstChild("Events")

local timerTickEvent: BindableEvent = eventsFolder:FindFirstChild("TimerTick")
local timerClass = require(serverScriptService.HelperModules.TimerModuleClass)

local TimerManager = {}

local id = 0

local timerIdToTimerDictionary = {}
local timerIdToLobby = {}

function TimerManager.CreateTimer()
	local timer = timerClass.new(nil, 60, id)

	timerIdToTimerDictionary[id] = timer
	id += 1

	return id - 1
end

function TimerManager.CreateLobbyTimer(lobby)
	local timer = timerClass.new()

	timerIdToTimerDictionary[id] = timer
	--timerIdToLobby[id] = lobby
	id += 1

	return id - 1
end

function TimerManager.FindTimer(timerId: number)
	print("Finding timer: " .. timerId)
	local timer = timerIdToTimerDictionary[timerId]

	if not timer then
		return nil
	end

	return timer
end

-- function TimerManager.UpdateLobbyTimerDisplay(timerId: number)
-- 	local lobby = TimerManager.timerIdToLobby[timerId]

-- 	if not lobby then
-- 		warn("No lobby found for timer")
-- 		return
-- 	end

-- 	lobby.lobbyData.timerDisplay:UpdateTimerDisplay()
-- 	print("Updated lobby timer display")
-- end

return TimerManager
