local serverScriptService = game:GetService("ServerScriptService")
local serverStorage = game:GetService("ServerStorage")

local eventsFolder = serverStorage:FindFirstChild("Events")
local timerEventsFolder = eventsFolder:FindFirstChild("Timer")

local timerTickEvent: BindableEvent = timerEventsFolder:FindFirstChild("TimerTick")
local timerStartEvent: BindableEvent = timerEventsFolder:FindFirstChild("TimerStart")

local timerModule = require(serverScriptService.HelperModules.TimerModuleClass)

local TimerDisplay = {}

export type TimerDisplay = typeof(setmetatable({} :: {
	timer: timerModule.Timer,
	timeRemainingTextLabel: TextLabel,
	timerTickConnection: RBXScriptConnection,
	timerStartConnection: RBXScriptConnection,
	tickSound: Sound,
}))

local function OnTimerTick(timerId: number, self: TimerDisplay)
	if timerId == self.timer.id then
		self:UpdateTimeRemaining()
		self.tickSound:Play()
		print("Lobby timer " .. tostring(timerId) .. "tick!")
	end
end

local function OnTimerStart(self: TimerDisplay)
	self:UpdateTimeRemaining()
end

function TimerDisplay.new(timer: timerModule.Timer, textLabel: TextLabel, tickSound: Sound)
	local self = setmetatable({}, { __index = TimerDisplay })

	self.timer = timer
	self.timeRemainingTextLabel = textLabel

	self.timerTickConnection = timerTickEvent.Event:Connect(function(timerId)
		OnTimerTick(timerId, self)
	end)

	self.timerStartConnection = timerStartEvent.Event:Connect(function()
		OnTimerStart(self)
	end)

	self.tickSound = tickSound

	return self
end

function TimerDisplay:UpdateTimeRemaining()
	local timeLeft = self.timer.timeRemaining

	local minutes = math.floor(timeLeft / 60)
	local seconds = timeLeft % 60

	if minutes == 0 then
		self.timeRemainingTextLabel.Text = tostring(seconds)
	else
		self.timeRemainingTextLabel.Text = string.format("%d:%02d", minutes, seconds)
	end
end

return TimerDisplay
