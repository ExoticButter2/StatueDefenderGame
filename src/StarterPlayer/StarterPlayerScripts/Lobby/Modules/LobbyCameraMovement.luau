--!strict
local players = game:GetService("Players")
local runService = game:GetService("RunService")

local camera = workspace:WaitForChild("Camera")

local LobbyCameraMovement = {}

local frameUpdateConnection: RBXScriptConnection = nil

local movementIntensity = 1.4 --1 = 50% rotation to player, 2 = 75% rotation to player...

local playerCharacter = players.LocalPlayer.Character or players.LocalPlayer.CharacterAdded:Wait()
local playerHumanoid = playerCharacter:WaitForChild("Humanoid")

local playerPrimaryPart = playerCharacter:WaitForChild("HumanoidRootPart")

players.LocalPlayer.CharacterAdded:Connect(function(character)
	playerPrimaryPart = character:WaitForChild("HumanoidRootPart")
	playerHumanoid = playerCharacter:WaitForChild("Humanoid")
end)

local function OnFrameUpdate(cameraPositionPart: BasePart)
	local playerCFrame: CFrame = playerPrimaryPart.CFrame

	local baseCFrame: CFrame = cameraPositionPart.CFrame

	local targetLookAtRotation: CFrame = (playerCFrame.Position - baseCFrame.Position).Unit

	local middleRotation = (targetLookAtRotation + baseCFrame.LookVector / movementIntensity).Unit

	camera.CFrame = CFrame.lookAlong(baseCFrame.Position, middleRotation)
end

function LobbyCameraMovement.StartCameraMovement(cameraPositionPart: BasePart)
	camera.CameraType = Enum.CameraType.Scriptable

	camera.CFrame = cameraPositionPart.CFrame

	frameUpdateConnection = runService.PreRender:Connect(function()
		OnFrameUpdate(cameraPositionPart)
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
