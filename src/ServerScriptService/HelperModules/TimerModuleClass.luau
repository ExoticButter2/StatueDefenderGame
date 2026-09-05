local serverStorage = game:GetService("ServerStorage")
local eventsFolder = serverStorage:FindFirstChild("Events")

local timerEventsFolder = eventsFolder:FindFirstChild("Timer")

local timerStartEvent: BindableEvent = timerEventsFolder:FindFirstChild("TimerStart")
local timerFinishedEvent: BindableEvent = timerEventsFolder:FindFirstChild("TimerFinish")
local timerTickEvent: BindableEvent = timerEventsFolder:FindFirstChild("TimerTick")

local TimerModule = {}

TimerModule.defaultSpeed = 1
TimerModule.defaultDuration = 60

local paused: boolean = false

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
	self.duration = duration or TimerModule.defaultDuration
	self.timeLeft = self.duration --for displaying time text
	self.id = id
	self.paused = paused
	self.timeRemaining = TimerModule.defaultDuration
	self.timerEnabled = false

	timerStartEvent.Event:Connect(self.OnTimerStart)
	timerTickEvent.Event:Connect(self.OnTimerTick)
	timerFinishedEvent.Event:Connect(self.OnTimerFinish)

	return self
end

function TimerModule:OnTimerStart()
	print("Timer started")
end

function TimerModule:OnTimerTick()
	print("Timer tick")
end

function TimerModule:OnTimerFinish()
	print("Timer finished")
end

function TimerModule:StartTimer() --starts time ticking
	self.timerEnabled = true
	local timeElapsed = 0

	timerStartEvent:Fire()

	print("Started timer!")
	while timeElapsed < self.duration do
		if self.paused then --wait if paused
			task.wait(0.5)
			continue
		end

		task.wait(1 / self.timerSpeed)

		if not self.timerEnabled then
			return
		end

		timeElapsed += 1
		self.timeLeft = self.duration - timeElapsed --tick
		timerTickEvent:Fire(self.id)
	end

	timerFinishedEvent:Fire(self)
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
end

function TimerModule:ChangeTimerDuration(newDuration: number)
	self.duration = newDuration
end

return TimerModule
