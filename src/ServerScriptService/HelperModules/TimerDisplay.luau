local serverScriptService = game:GetService("ServerScriptService")

local timerModule = require(serverScriptService.HelperModules.TimerModuleClass)

local TimerDisplay = {}

export type TimerDisplay = typeof(setmetatable({} :: {
	timer: timerModule.Timer,
	timeRemainingTextLabel: TextLabel,
}))

function TimerDisplay.new(timer: timerModule.Timer, textLabel: TextLabel)
	local self = setmetatable({}, { __index = TimerDisplay })

	self.timer = timer
	self.timeRemainingTextLabel = textLabel

	return self
end

function TimerDisplay:UpdateTimeRemaining()
	local timeLeft = self.timer.timeLeft

	local minutes = math.floor(timeLeft / 60)
	local seconds = timeLeft % 60

	if minutes == 0 then
		self.timeRemainingTextLabel.text = seconds.toString()
	else
		self.timeRemainingTextLabel.text = string.format("%d:%d", minutes, seconds)
	end
end

return TimerDisplay
