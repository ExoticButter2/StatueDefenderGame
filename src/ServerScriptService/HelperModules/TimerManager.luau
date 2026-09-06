--!strict
local serverScriptService = game:GetService("ServerScriptService")

local timerClass = require(serverScriptService.HelperModules.TimerModuleClass)

local TimerManager = {}

local id = 0

local timerIdToTimerDictionary = {}
local timerIdToLobbyIdDictionary = {}

function TimerManager.CreateTimer(timerSpeed: number?, timerDuration: number?)
	local timer = timerClass.new(timerSpeed, timerDuration, id)

	timerIdToTimerDictionary[id] = timer
	id += 1

	return id - 1
end

function TimerManager.CreateLobbyTimer(lobbyId: number, timerSpeed: number?, timerDuration: number?)
	timerIdToLobbyIdDictionary[id] = lobbyId

	TimerManager.CreateTimer(timerSpeed, timerDuration) --id += 1

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

function TimerManager.FindLobbyIdFromTimerId(timerId: number)
	print("Finding lobby with timer id: " .. timerId)
	local lobby = timerIdToLobbyIdDictionary[timerId]

	if not lobby then
		return nil
	end

	return lobby
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
