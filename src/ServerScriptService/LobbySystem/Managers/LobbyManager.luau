local serverScriptService = game:GetService("ServerScriptService")

local lobbyClass = require(serverScriptService.LobbySystem.Classes.LobbyClass)
local lobbyData = require(serverScriptService.LobbySystem.Data.LobbyData)

local lobbiesFolder = game.Workspace.Lobbies

local LobbyManager = {}

local touchPartName = "TouchPart"
local enterPartName = "EnterPart"
local exitPartName = "ExitPart"

LobbyManager.Lobbies = {}

local playerIdToLobbyId = {}

local lobbyId = 0

local function CreateLobby(lobbyModel: Model): lobbyClass.Lobby
	local touchPart
	local enterPart
	local exitPart

	if lobbyModel:IsA("Model") then
		touchPart = lobbyModel:FindFirstChild(touchPartName)
		enterPart = lobbyModel:FindFirstChild(enterPartName)
		exitPart = lobbyModel:FindFirstChild(exitPartName)
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

	local lobbyDataInstance = lobbyData.new(nil, nil, nil, lobbyId)
	local lobbyClassInstance = lobbyClass.new(touchPart, enterPart, exitPart, lobbyDataInstance)

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

function LobbyManager.FindLobby(id: number): lobbyClass.Lobby
	local lobby = LobbyManager.Lobbies[id]

	if lobby then
		return lobby
	end

	return nil
end

function LobbyManager.FindLobbyIdFromPlayerId(playerId: number): number
	local playerLobbyId = playerIdToLobbyId[playerId]

	if playerLobbyId then
		return playerLobbyId
	end

	return nil
end

function LobbyManager.AddIdToPlayerIdLobbyDictionary(playerId: number, playerLobbyId: number)
	playerIdToLobbyId[playerId] = playerLobbyId
end

function LobbyManager.RemoveIdFromPlayerIdLobbyDictionary(playerId: number)
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

return LobbyManager
