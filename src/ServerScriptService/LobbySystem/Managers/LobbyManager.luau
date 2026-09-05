local serverScriptService = game:GetService("ServerScriptService")

local lobbySystemFolder: Folder = serverScriptService:FindFirstChild("LobbySystem")

local lobbyClass = require(lobbySystemFolder.Classes.LobbyClass)
local lobbyData = require(lobbySystemFolder.Data.LobbyData)

local helperModulesFolder: Folder = serverScriptService:FindFirstChild("HelperModules")

local timerManager = require(helperModulesFolder.TimerManager)
local timerModule = require(helperModulesFolder.TimerModuleClass)
local timerDisplayModule = require(helperModulesFolder.TimerDisplay)

local lobbiesFolder = game.Workspace.Lobbies

local LobbyManager = {}

local touchPartName = "TouchPart"
local enterPartName = "EnterPart"
local exitPartName = "ExitPart"
local timeTextLabelName = "TimeTextLabel"
local timeTickSoundName = "TickSound"

LobbyManager.Lobbies = {}

local playerIdToLobbyId = {}

local lobbyId = 0

local function CreateLobby(lobbyModel: Model): lobbyClass.Lobby
	local touchPart
	local enterPart
	local exitPart
	local timeTextLabel
	local timeTickSound

	if lobbyModel:IsA("Model") then
		touchPart = lobbyModel:FindFirstChild(touchPartName)
		enterPart = lobbyModel:FindFirstChild(enterPartName)
		exitPart = lobbyModel:FindFirstChild(exitPartName)
		timeTextLabel = lobbyModel:FindFirstChild(timeTextLabelName, true)
		timeTickSound = lobbyModel:FindFirstChild(timeTickSoundName, true)
	end

	if not touchPart then
		warn("Add part named " .. touchPartName .. " to the lobby model: " .. lobbyModel.Name)
		return
	end

	if not enterPart then
		warn("Add part named " .. enterPartName .. " to the lobby model: " .. lobbyModel.Name)
		return
	end

	if not exitPart then
		warn("Add part named " .. exitPartName .. " to the lobby model: " .. lobbyModel.Name)
		return
	end

	if not timeTextLabel then
		warn("Add text label named " .. timeTextLabelName .. " to the lobby model: " .. lobbyModel.Name)
		return
	end

	if not timeTickSound then
		warn("Add sound named " .. timeTickSoundName .. " to the lobby model: " .. lobbyModel.Name)
		return
	end

	local timerInstanceId: number = timerManager.CreateLobbyTimer(lobbyId)
	local timerInstance: timerModule.Timer = timerManager.FindTimer(timerInstanceId)

	local timerDisplayInstance: timerDisplayModule.TimerDisplay =
		timerDisplayModule.new(timerInstance, timeTextLabel, timeTickSound)

	local lobbyDataInstance: lobbyData.LobbyData =
		lobbyData.new(nil, nil, nil, lobbyId, touchPart, enterPart, exitPart, nil, timerInstance, timerDisplayInstance)

	local lobbyClassInstance: lobbyClass.Lobby = lobbyClass.new(lobbyDataInstance)

	LobbyManager.Lobbies[lobbyId] = lobbyClassInstance

	lobbyId += 1
	print("Created lobby!")
	return lobbyClassInstance
end

function LobbyManager.Initialize() --creates lobby functionality and enables lobby event handler
	for _, lobbyModel in ipairs(lobbiesFolder:GetChildren()) do
		CreateLobby(lobbyModel)
	end

	print("Initialized lobby manager")
end

function LobbyManager.OpenLobby(openingLobbyId: number)
	local lobby: lobbyClass.Lobby = LobbyManager.FindLobby(openingLobbyId)

	if not lobby then
		warn("No lobby found for searching lobby!")
		return
	end

	lobby:OpenLobby()
end

function LobbyManager.CloseLobby(closingLobbyId: number)
	local lobby: lobbyClass.Lobby = LobbyManager.FindLobby(closingLobbyId)

	if not lobby then
		warn("No lobby found for searching lobby!")
		return
	end

	lobby:CloseLobby()
end

function LobbyManager.OnLobbyTimerFinish(timerId: number)
	local lobbyId: number = timerManager.FindLobbyIdFromTimerId(timerId)

	if not lobbyId then
		warn("No lobby id found from timer id")
		return
	end

	local lobby: lobbyClass.Lobby = LobbyManager.FindLobby(lobbyId)

	if not lobby then
		warn("No lobby found from lobby id")
		return
	end

	lobby:TeleportAllPlayersToPlace() --finally teleport everyone away
	print("Teleporting all players to place..")
end

function LobbyManager.StartLobby(startingLobbyId: number, lobbySettingsArgs: {})
	local lobby: lobbyClass.Lobby = LobbyManager.FindLobby(startingLobbyId)

	if not lobby then
		warn("No lobby found with lobby ID!")
		return
	end

	lobby:StartLobby(startingLobbyId, {})
	print("Started lobby")
end

function LobbyManager.StartLobbyFromPlayerId(playerId: number)
	local startingLobbyId: number = LobbyManager.FindLobbyIdFromPlayerId(playerId)

	if not startingLobbyId then
		warn("No lobby id found for player, possible cheating")
		return
	end

	LobbyManager.StartLobby(startingLobbyId, {})
end

--HELPER MODULES

function LobbyManager.FindLobby(id: number): lobbyClass.Lobby --returns lobby class with LobbyID
	local lobby = LobbyManager.Lobbies[id] --search global database

	if lobby then
		return lobby
	end

	return nil
end

function LobbyManager.FindLobbyIdFromPlayerId(playerId: number): number --returns LobbyID with player ID
	local playerLobbyId = playerIdToLobbyId[playerId]

	if playerLobbyId then
		return playerLobbyId
	end

	return nil
end

function LobbyManager.AddIdToPlayerIdLobbyIdDictionary(playerId: number, playerLobbyId: number)
	playerIdToLobbyId[playerId] = playerLobbyId --Adds PlayerID to global PlayerID-Lobby lookup dictionary
end

function LobbyManager.RemoveIdFromPlayerIdLobbyIdDictionary(playerId: number) --Removes player
	playerIdToLobbyId[playerId] = nil
end

function LobbyManager.RemovePlayerFromLobby(player: Player)
	local playerId = player.UserId

	local playerLobbyId = LobbyManager.FindLobbyIdFromPlayerId(playerId)

	if not playerLobbyId then
		warn("Player not inside a lobby, possible cheating!")
		return
	end

	local lobby: lobbyClass.Lobby = LobbyManager.FindLobby(playerLobbyId)

	if not lobby then
		warn("No lobby found with lobby id, bug!")
		return
	end

	lobby:RemovePlayer(player)
	print("Removed player from lobby via global lookup!")
end

return LobbyManager
