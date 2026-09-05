local serverStorage = game:GetService("ServerStorage")
local eventsFolder = serverStorage:FindFirstChild("Events")

local timerEventsFolder = eventsFolder:FindFirstChild("Timer")

local timerStartEvent: BindableEvent = timerEventsFolder:FindFirstChild("TimerStart")
local timerFinishedEvent: BindableEvent = timerEventsFolder:FindFirstChild("TimerFinish")
local timerTickEvent: BindableEvent = timerEventsFolder:FindFirstChild("TimerTick")

local TimerModule = {}

TimerModule.defaultSpeed = 1
TimerModule.defaultDuration = 4

local paused: boolean = false

export type Timer = typeof(setmetatable({} :: {
	timerSpeed: number,
	prePauseSpeed: number,
	duration: number,
	timeRemaining: number,
	id: number,
	paused: boolean,
	timerEnabled: boolean,
}))

function TimerModule.new(timerSpeed: number?, duration: number?, id: number): Timer
	local self = setmetatable({}, { __index = TimerModule })

	self.timerSpeed = timerSpeed or TimerModule.defaultSpeed
	self.duration = duration or TimerModule.defaultDuration
	self.timeRemaining = self.duration --for displaying time text
	self.id = id
	self.paused = paused
	self.timerEnabled = false

	print("Timer duration: " .. self.timeRemaining)
	timerTickEvent.Event:Connect(function(timerId)
		self:OnTimerTick(timerId)
	end)
	timerStartEvent.Event:Connect(function(timerId)
		self:OnTimerStart(timerId)
	end)
	timerFinishedEvent.Event:Connect(function(timerId)
		self:OnTimerFinish(timerId)
	end)

	return self
end

function TimerModule:OnTimerStart(timerId: number)
	print("Timer started")
end

function TimerModule:OnTimerTick(timerId: number)
	print("Timer tick")
end

function TimerModule:OnTimerFinish(timerId: number)
	print("Timer finished")
end

function TimerModule:StartTimer() --starts time ticking
	self.timerEnabled = true
	local timeElapsed = 0

	timerStartEvent:Fire()
	print("Timer duration: " .. self.duration)

	print("Started timer!")
	while timeElapsed < self.duration and self.timerEnabled do
		if self.paused then --wait if paused
			task.wait(0.5)
			continue
		end

		timeElapsed += 1
		self.timeRemaining = self.duration - timeElapsed --tick
		print("Time remaining: " .. self.timeRemaining)
		timerTickEvent:Fire(self.id)

		task.wait(1 / self.timerSpeed)
	end

	if self.timerEnabled then
		timerFinishedEvent:Fire(self.id)
	end
end

function TimerModule:PauseTimer()
	self.paused = true
	print("Paused timer")
end

function TimerModule:StopTimer()
	self.timerEnabled = false
	print("Stopped timer")
end

function TimerModule:ResumeTimer()
	self.paused = false
end

function TimerModule:ChangeTimerSpeed(newSpeed: number)
	self.timerSpeed = newSpeed
	self.prePauseSpeed = newSpeed --to prevent resuming resetting new speed
	print("Changed timer speed")
end

function TimerModule:ChangeTimerDuration(newDuration: number)
	self.duration = newDuration
	print("Changed timer duration")
end

return TimerModule
