--!strict
local starterPlayer = game:GetService("StarterPlayer")
local tweenService = game:GetService("TweenService")

local starterPlayerScripts: Folder = starterPlayer.StarterPlayerScripts
local lobbyUIScriptsFolder: Folder = starterPlayerScripts.Lobby
local lobbyUIDataFolder: Folder = lobbyUIScriptsFolder.LobbyUIData

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

	tween:Play()
end

function lobbyPlayerUIHandler.DisablePlayerUI()
	if tween then
		tween:Cancel()
		tween = nil
	end

	lobbyUIData.lobbyPlayerGui.Enabled = false
	lobbyUIData.playerExitFrame.Position = hiddenFramePosition
end

function lobbyPlayerUIHandler.OnTeleport()
	lobbyPlayerUIHandler.DisablePlayerUI()
end

return lobbyPlayerUIHandler
