--!strict
local serverStorage = game:GetService("ServerStorage")
local serverScriptService = game:GetService("ServerScriptService")
local replicatedStorage = game:GetService("ReplicatedStorage")

local eventsFolderServer: Folder = serverStorage:FindFirstChild("Events")
local lobbyEventsFolderServer: Folder = eventsFolderServer:FindFirstChild("Lobby")
local timerEventsFolderServer: Folder = eventsFolderServer:FindFirstChild("Timer")

local eventsFolderClient: Folder = replicatedStorage:FindFirstChild("Events")
local lobbyEventsFolderClient: Folder = eventsFolderClient:FindFirstChild("Lobby")

local lobbySystemFolder: Folder = serverScriptService:FindFirstChild("LobbySystem")

local managersFolder: Folder = lobbySystemFolder:FindFirstChild("Managers")

local lobbyManager = require(managersFolder.LobbyManager)

local lobbyPlayerJoinEvent: BindableEvent = lobbyEventsFolderServer:FindFirstChild("LobbyPlayerJoinServer")
local lobbyPlayerLeaveEvent: BindableEvent = lobbyEventsFolderServer:FindFirstChild("LobbyPlayerLeaveServer")
local lobbyHostJoinEvent: BindableEvent = lobbyEventsFolderServer:FindFirstChild("LobbyHostJoinServer")
local lobbyHostLeaveEvent: BindableEvent = lobbyEventsFolderServer:FindFirstChild("LobbyHostLeaveServer")

local changeLobbyArgs: RemoteEvent = lobbyEventsFolderClient:FindFirstChild("ChangeLobbyArgs")

local lobbyExitRequestEvent: RemoteEvent = lobbyEventsFolderClient:FindFirstChild("LobbyExitRequest")

local lobbyStartRequest: RemoteEvent = lobbyEventsFolderClient:FindFirstChild("LobbyStartRequest")

local timerFinishEvent: BindableEvent = timerEventsFolderServer:FindFirstChild("TimerFinish")

local LobbyServerEventHandler = {}

local function OnLobbyPlayerJoin(player: Player, lobbyId: number)
	local playerId = player.UserId

	lobbyManager.AddIdToPlayerIdLobbyIdDictionary(playerId, lobbyId)
end

local function OnLobbyPlayerLeave(player: Player, lobbyId: number)
	local playerId = player.UserId

	lobbyManager.RemoveIdFromPlayerIdLobbyIdDictionary(playerId, lobbyId)
end

local function OnPlayerLobbyExitRequest(player: Player)
	lobbyManager.RemovePlayerFromLobby(player)
	print("Exit request received from server")
end

local function OnHostLobbyJoin(lobbyId: number)
	lobbyManager.CloseLobby(lobbyId)
end

local function OnHostLobbyLeave(lobbyId: number)
	lobbyManager.OpenLobby(lobbyId)
end

local function OnLobbyStartRequest(player: Player)
	print("Start requested from player id: " .. player.UserId)
	print("Starting lobby..")
	lobbyManager.StartLobbyFromPlayerId(player.UserId, {})
end

local function OnLobbyTimerFinish(timerId: number)
	lobbyManager.OnLobbyTimerFinish(timerId)
end

local function OnChangeLobbyArgs(argsToChange: {}, player: Player)
	lobbyManager.ChangeLobbyArgs(argsToChange, player)
	print("Change lobby args event handling")
end

function LobbyServerEventHandler.Initialize()
	lobbyPlayerJoinEvent.Event:Connect(OnLobbyPlayerJoin)
	lobbyPlayerLeaveEvent.Event:Connect(OnLobbyPlayerLeave)
	lobbyExitRequestEvent.OnServerEvent:Connect(OnPlayerLobbyExitRequest)
	lobbyHostJoinEvent.Event:Connect(OnHostLobbyJoin)
	lobbyHostLeaveEvent.Event:Connect(OnHostLobbyLeave)
	lobbyStartRequest.OnServerEvent:Connect(OnLobbyStartRequest)

	changeLobbyArgs.OnServerEvent:Connect(OnChangeLobbyArgs)

	timerFinishEvent.Event:Connect(OnLobbyTimerFinish)
end

return LobbyServerEventHandler
