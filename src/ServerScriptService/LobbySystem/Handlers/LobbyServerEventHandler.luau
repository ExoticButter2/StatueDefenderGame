local serverStorage = game:GetService("ServerStorage")
local serverScriptService = game:GetService("ServerScriptService")
local replicatedStorage = game:GetService("ReplicatedStorage")

local eventsFolderServer: Folder = serverStorage:FindFirstChild("Events")
local eventsFolderClient: Folder = replicatedStorage:FindFirstChild("Events")

local lobbySystemFolder: Folder = serverScriptService:FindFirstChild("LobbySystem")

local managersFolder: Folder = lobbySystemFolder:FindFirstChild("Managers")

local lobbyManager = require(managersFolder.LobbyManager)

--local lobbyHostJoinEvent = eventsFolder:FindFirstChild("OnLobbyHostJoin")
local timerTickEvent: RemoteEvent = eventsFolderServer:FindFirstChild("TimerTick")

local lobbyPlayerJoinEvent: BindableEvent = eventsFolderServer:FindFirstChild("LobbyPlayerJoinServer")
local lobbyPlayerLeaveEvent: BindableEvent = eventsFolderServer:FindFirstChild("LobbyPlayerLeaveServer")
local lobbyHostJoinEvent: BindableEvent = eventsFolderServer:FindFirstChild("LobbyHostJoinServer")
local lobbyHostLeaveEvent: BindableEvent = eventsFolderServer:FindFirstChild("LobbyHostLeaveServer")

local lobbyExitRequestEvent: RemoteEvent = eventsFolderClient:FindFirstChild("LobbyExitRequest")

local LobbyServerEventHandler = {}

local function OnTimerTick(timerId: number) end

local function OnLobbyPlayerJoin(player: Player, lobbyId: number)
	local playerId = player.UserId

	lobbyManager.AddIdToPlayerIdLobbyDictionary(playerId, lobbyId)
end

local function OnLobbyPlayerLeave(player: Player, lobbyId: number)
	local playerId = player.UserId

	lobbyManager.RemoveIdFromPlayerIdLobbyDictionary(playerId, lobbyId)
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

function LobbyServerEventHandler.Initialize()
	timerTickEvent.Event:Connect(OnTimerTick)
	lobbyPlayerJoinEvent.Event:Connect(OnLobbyPlayerJoin)
	lobbyPlayerLeaveEvent.Event:Connect(OnLobbyPlayerLeave)
	lobbyExitRequestEvent.OnServerEvent:Connect(OnPlayerLobbyExitRequest)
	lobbyHostJoinEvent.Event:Connect(OnHostLobbyJoin)
	lobbyHostLeaveEvent.Event:Connect(OnHostLobbyLeave)
end

return LobbyServerEventHandler
