local serverScriptService = game:GetService("ServerScriptService")

local timerClass = require(serverScriptService.HelperModules.TimerModuleClass)

local TimerManager = {}

local id = 0

local idToTimerDictionary = {}

function TimerManager.CreateTimer()
	local timer = timerClass.new()

	idToTimerDictionary[id] = timer
	id += 1

	return id
end

function TimerManager.FindTimer(id: number)
	local timer = idToTimerDictionary[id]

	if not timer then
		return nil
	end

	return timer
end

return TimerManager
