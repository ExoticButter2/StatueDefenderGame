--!strict
local players = game:GetService("Players")
local runService = game:GetService("RunService")

local camera = workspace:WaitForChild("Camera")

local LobbyCameraMovement = {}

local frameUpdateConnection: RBXScriptConnection = nil

local movementIntensity = 0.7 --1 = 50% rotation to player, 2 = 75% rotation to player...

local cameraSmoothing = 7.5

local playerCharacter = players.LocalPlayer.Character or players.LocalPlayer.CharacterAdded:Wait()
local playerHumanoid = playerCharacter:WaitForChild("Humanoid")

local playerPrimaryPart = playerCharacter:WaitForChild("HumanoidRootPart")

players.LocalPlayer.CharacterAdded:Connect(function(character)
	playerPrimaryPart = character:WaitForChild("HumanoidRootPart")
	playerHumanoid = playerCharacter:WaitForChild("Humanoid")
end)

local function OnFrameUpdate(dt: number, cameraPositionPart: BasePart)
	local playerCFrame: CFrame = playerPrimaryPart.CFrame

	local baseCFrame: CFrame = cameraPositionPart.CFrame

	local targetLookAtRotation: CFrame = (playerCFrame.Position - baseCFrame.Position).Unit

	local middleRotation = (targetLookAtRotation + baseCFrame.LookVector / movementIntensity).Unit

	camera.CFrame = camera.CFrame:Lerp(CFrame.lookAlong(baseCFrame.Position, middleRotation), cameraSmoothing * dt)
end

function LobbyCameraMovement.StartCameraMovement(cameraPositionPart: BasePart)
	camera.CameraType = Enum.CameraType.Scriptable

	frameUpdateConnection = runService.PreRender:Connect(function(dt)
		OnFrameUpdate(dt, cameraPositionPart)
	end)
end

function LobbyCameraMovement.StopCameraMovement()
	camera:Destroy()
	camera = workspace:WaitForChild("Camera")

	camera.CameraType = Enum.CameraType.Custom
	camera.CameraSubject = playerHumanoid

	if frameUpdateConnection then
		frameUpdateConnection:Disconnect()
		frameUpdateConnection = nil
	end
end

return LobbyCameraMovement
