--!strict
local starterPlayer = game:GetService("StarterPlayer")
local tweenService = game:GetService("TweenService")

local starterPlayerScripts: Folder = starterPlayer.StarterPlayerScripts
local lobbyUIScriptsFolder: Folder = starterPlayerScripts.Lobby
local lobbyUIDataFolder: Folder = lobbyUIScriptsFolder.LobbyUIData

local lobbyUIData = require(lobbyUIDataFolder.LobbyUIDatabase)

local friendsOnlyHandler = require(lobbyUIData.uiHandlersFolder.LobbyFriendsOnlyHandler)
local playerLimitHandler = require(lobbyUIData.uiHandlersFolder.LobbyPlayerLimitHandler)

local lobbyHostUIHandler = {}

local hiddenFramePosition: UDim2 = UDim2.fromScale(0.25, -0.8)
local targetFramePosition: UDim2 = UDim2.fromScale(0.25, 0.125)

local tweenTime = 0.6

local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Circular, Enum.EasingDirection.Out, 0, false)

local tween = nil

function lobbyHostUIHandler.EnableHostUI()
	lobbyUIData.lobbyHostGui.Enabled = true

	tween = tweenService:Create(lobbyUIData.hostBackgroundFrame, tweenInfo, { Position = targetFramePosition })

	tween:Play()
end

function lobbyHostUIHandler.DisableHostUI()
	if tween then
		tween:Cancel()
		tween = nil
	end

	lobbyUIData.lobbyHostGui.Enabled = false
	lobbyUIData.hostBackgroundFrame.Position = hiddenFramePosition
end

function lobbyHostUIHandler.ResetUIToDefault()
	friendsOnlyHandler.ResetFriendsOnly()
	playerLimitHandler.ResetPlayerLimit()
end

return lobbyHostUIHandler
