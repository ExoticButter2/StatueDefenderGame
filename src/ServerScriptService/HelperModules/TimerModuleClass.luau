local serverStorage = game:GetService("ServerStorage")
local eventsFolder = serverStorage:FindFirstChild("Events")

local timerFinishedEvent = eventsFolder:FindFirstChild("TimerFinished")
local timerTickEvent = eventsFolder:FindFirstChild("TimerTick")

local TimerModule = {}

TimerModule.defaultSpeed = 1
TimerModule.defaultDuration = 60

export type Timer = typeof(setmetatable({} :: {
	timerSpeed: number,
	prePauseSpeed: number,
	duration: number,
	timeLeft: number,
	id: number,
}))

function TimerModule.new(timerSpeed: number?, duration: number?, id: number): Timer
	local self = setmetatable({}, { __index = TimerModule })

	self.timerSpeed = timerSpeed or TimerModule.defaultSpeed
	self.prePauseSpeed = self.timerSpeed
	self.duration = duration or TimerModule.defaultDuration
	self.timeLeft = self.duration --for displaying time text
	self.id = id

	return self
end

local function OnTimerTick(self: Timer)
	timerTickEvent:Fire(self.id)
end

local function OnTimerFinish(self: Timer)
	timerFinishedEvent:Fire(self.id)
	print("Timer finished")
end

function TimerModule:StartTimer()
	local timeElapsed = 0

	while timeElapsed < self.duration do
		task.wait(1 / self.timerSpeed)
		timeElapsed += 1
		self.timeLeft = self.duration - timeElapsed
		OnTimerTick(self)
	end

	OnTimerFinish(self)
end

function TimerModule:PauseTimer()
	self.prePauseSpeed = self.timerSpeed
	self.timerSpeed = 0
end

function TimerModule:ResumeTimer()
	self.timerSpeed = self.prePauseSpeed
end

function TimerModule:ChangeTimerSpeed(newSpeed: number)
	self.timerSpeed = newSpeed
	self.prePauseSpeed = newSpeed --to prevent resuming resetting new speed
end

function TimerModule:ChangeTimerDuration(newDuration: number)
	self.duration = newDuration
end

return TimerModule
