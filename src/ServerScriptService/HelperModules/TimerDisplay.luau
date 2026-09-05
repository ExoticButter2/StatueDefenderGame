local serverScriptService = game:GetService("ServerScriptService")
local serverStorage = game:GetService("ServerStorage")

local eventsFolder = serverStorage:FindFirstChild("Events")
local timerEventsFolder = eventsFolder:FindFirstChild("Timer")

local timerTickEvent: BindableEvent = timerEventsFolder:FindFirstChild("TimerTick")

local timerModule = require(serverScriptService.HelperModules.TimerModuleClass)

local TimerDisplay = {}

export type TimerDisplay = typeof(setmetatable({} :: {
	timer: timerModule.Timer,
	timeRemainingTextLabel: TextLabel,
}))

local function OnTimerTick(timerId: number, self: TimerDisplay)
	if timerId == self.timer.id then
		self:UpdateTimeRemaining()
		print("Updated timer time!")
	end
end

function TimerDisplay.new(timer: timerModule.Timer, textLabel: TextLabel)
	local self = setmetatable({}, { __index = TimerDisplay })

	self.timer = timer
	self.timeRemainingTextLabel = textLabel

	self.timerTickConnection = timerTickEvent.Event:Connect(function(timerId)
		OnTimerTick(timerId, self)
	end)

	return self
end

function TimerDisplay:UpdateTimeRemaining()
	local timeLeft = self.timer.timeLeft

	local minutes = math.floor(timeLeft / 60)
	local seconds = timeLeft % 60

	if minutes == 0 then
		self.timeRemainingTextLabel.Text = tostring(seconds)
	else
		self.timeRemainingTextLabel.Text = string.format("%d:%d", minutes, seconds)
	end
end

return TimerDisplay
