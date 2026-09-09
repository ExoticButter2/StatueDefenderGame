--!strict
local starterPlayer = game:GetService("StarterPlayer")
local tweenService = game:GetService("TweenService")

local starterPlayerScripts: Folder = starterPlayer:WaitForChild("StarterPlayerScripts")
local lobbyUIScriptsFolder: Folder = starterPlayerScripts:WaitForChild("Lobby")
local lobbyUIDataFolder: Folder = lobbyUIScriptsFolder:WaitForChild("LobbyUIData")

local lobbyUIData = require(lobbyUIDataFolder.LobbyUIDatabase)

local hiddenFramePosition: UDim2 = UDim2.fromScale(0.4, 1)
local targetFramePosition: UDim2 = UDim2.fromScale(0.4, 0.85)

local tweenTime = 0.6

local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Circular, Enum.EasingDirection.Out, 0, false)
local tween: Tween = nil

local lobbyPlayerUIHandler = {}

function lobbyPlayerUIHandler.EnablePlayerUI()
	lobbyUIData.lobbyPlayerGui.Enabled = true

	tween = tweenService:Create(lobbyUIData.playerExitFrame, tweenInfo, { Position = targetFramePosition })

	print("Enabled Player lobby UI")
	tween:Play()
end

function lobbyPlayerUIHandler.DisablePlayerUI()
	if tween then
		tween:Cancel()
		tween = nil
	end

	lobbyUIData.lobbyPlayerGui.Enabled = false
	lobbyUIData.playerExitFrame.Position = hiddenFramePosition
	print("Disabled Player lobby UI")
end

function lobbyPlayerUIHandler.OnTeleport()
	lobbyPlayerUIHandler.DisablePlayerUI()
end

return lobbyPlayerUIHandler
