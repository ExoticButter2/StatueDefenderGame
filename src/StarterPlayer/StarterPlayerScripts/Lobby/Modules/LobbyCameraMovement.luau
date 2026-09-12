--!strict
local runService = game:GetService("RunService")
local players = game:GetService("Players")

local camera = workspace:WaitForChild("Camera")

local LobbyCameraMovement = {}

local frameUpdateConnection: RBXScriptConnection = nil

local movementIntensity = 0.7 --1 = 50% rotation to player, 2 = 75% rotation to player...

local cameraSmoothing = 7.5

local playerCharacter = players.LocalPlayer.character or players.LocalPlayer.CharacterAdded:Wait()
local playerHumanoid

local playerPrimaryPart

function LobbyCameraMovement.OnStart(character: Model)
	playerPrimaryPart = character:WaitForChild("HumanoidRootPart")
	playerHumanoid = character:WaitForChild("Humanoid")

	LobbyCameraMovement.StopCameraMovement()
end

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
	camera.CameraType = Enum.CameraType.Custom
	camera.CameraSubject = playerHumanoid

	if frameUpdateConnection then
		frameUpdateConnection:Disconnect()
		frameUpdateConnection = nil
	end
end

LobbyCameraMovement.OnStart(playerCharacter)

return LobbyCameraMovement
