local players = game:GetService("Players")
local serverScriptService = game:GetService("ServerScriptService")
local teleportService = game:GetService("TeleportService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local serverStorage = game:GetService("ServerStorage")

local lobbyDataModule = require(serverScriptService.LobbySystem.Data.LobbyData)
local timerModule = require(serverScriptService.HelperModules.TimerModuleClass)
local timerDisplayModule = require(serverScriptService.HelperModules.TimerDisplay)

local eventsFolderShared: Folder = replicatedStorage:FindFirstChild("Events")
local lobbyEventsFolderShared: Folder = eventsFolderShared:FindFirstChild("Lobby")

local eventsFolderServer: Folder = serverStorage:FindFirstChild("Events")
local lobbyEventsFolderServer: Folder = eventsFolderServer:FindFirstChild("Lobby")

local lobbyHostJoinEvent: RemoteEvent = lobbyEventsFolderShared:FindFirstChild("OnLobbyHostJoin")
local lobbyHostLeaveEvent: RemoteEvent = lobbyEventsFolderShared:FindFirstChild("OnLobbyHostLeave")

local lobbyStartEvent: RemoteEvent = lobbyEventsFolderShared:FindFirstChild("LobbyStartRequest")

local lobbyPlayerJoinRemoteEvent: RemoteEvent = lobbyEventsFolderShared:FindFirstChild("OnLobbyPlayerJoin")
local lobbyPlayerLeaveRemoteEvent: RemoteEvent = lobbyEventsFolderShared:FindFirstChild("OnLobbyPlayerLeave")

local lobbyPlayerJoinBindableEvent: BindableEvent = lobbyEventsFolderServer:FindFirstChild("LobbyPlayerJoinServer")
local lobbyPlayerLeaveBindableEvent: BindableEvent = lobbyEventsFolderServer:FindFirstChild("LobbyPlayerLeaveServer")
local lobbyHostJoinBindableEvent: BindableEvent = lobbyEventsFolderServer:FindFirstChild("LobbyHostJoinServer")
local lobbyHostLeaveBindableEvent: BindableEvent = lobbyEventsFolderServer:FindFirstChild("LobbyHostLeaveServer")

local LobbyClass = {}

export type Lobby = typeof(setmetatable({} :: {
	touchConnection: RBXScriptConnection,
	playerLeaveConnection: RBXScriptConnection,
	lobbyData: lobbyDataModule.LobbyData,
}))

function LobbyClass:StartLobby()
	--lobbyStartEvent:FireAllClients(self.lobbyData.lobbyId)
	print("Started lobby")

	if not self.lobbyData then
		warn("Lobby data for lobby missing")
		return
	end

	if not self.lobbyData.lobbyDuration then
		warn("Lobby duration missing")
		return
	end

	if not self.lobbyData.timer then
		warn("Lobby timer missing")
		return
	end
	self.lobbyData.timer.duration = self.lobbyData.lobbyDuration
	self.lobbyData.timer:StartTimer()
end

-- function LobbyClass:ChangeLobbySettings(args: {})--changes lobby settings args
-- 	local lobbyData = self.lobbyData

-- 	for setting, v in pairs(args) do
-- 		if lobbyData[setting] then--if setting doesn't exist

-- 		end
-- 	end
-- end

function LobbyClass:OpenLobby()
	self.lobbyData.lobbyOpen = true
	print("Opened lobby")
end

function LobbyClass:CloseLobby()
	self.lobbyData.lobbyOpen = false
	print("Closed lobby")
end

local function ValidatePlayerWithConfig(player: Player, self: Lobby)
	local lobbyData = self.lobbyData

	if lobbyData.friendsOnly and not player:IsFriendsWithAsync(lobbyData.hostId) then
		return false
	end
	if #lobbyData.players >= lobbyData.playerLimit then
		return false
	end
	if table.find(lobbyData.players, player.UserId) then
		return false
	end
	if not lobbyData.lobbyOpen then
		return false
	end

	return true
end

local function AddHost(player: Player, self: Lobby)
	self:AddPlayer(player)
	self:CloseLobby() --make setup open lobby after

	self.lobbyData.hostId = player.UserId

	lobbyHostJoinEvent:FireClient(player, self.lobbyData.lobbyId)
	lobbyHostJoinBindableEvent:Fire(self.lobbyData.lobbyId)
	print("Added host!")
end

local function RemoveHost(self: Lobby, player: Player)
	local lobbyData = self.lobbyData

	local hostIndex = table.find(lobbyData.players, lobbyData.hostId)

	if not hostIndex then
		warn("No host to remove!")
		return
	end

	lobbyData.players[hostIndex] = nil
	lobbyData.hostId = nil

	lobbyHostLeaveEvent:FireClient(player, lobbyData.lobbyId)
	lobbyHostLeaveBindableEvent:Fire(lobbyData.lobbyId)

	if not player.Character then
		warn("No player character found when removing player")
		return
	end

	player.Character:PivotTo(lobbyData.exitPart.CFrame)
end

local function AttemptJoin(otherPart: BasePart, self: Lobby) --validate before adding player
	local player = players:GetPlayerFromCharacter(otherPart.Parent)

	if player then
		if #self.lobbyData.players == 0 then --if host, dont validate
			AddHost(player, self)
			return
		end

		if ValidatePlayerWithConfig(player, self) then --if regular player, validate
			self:AddPlayer(player)
		end
	end

	print("Part touched!")
end

local function OnPlayerLeave(player: Player, self: Lobby)
	local playerId = player.UserId

	if table.find(self.lobbyData.players, playerId) then
		self:RemovePlayer(player)
	end
end

function LobbyClass.new(lobbyData: lobbyDataModule.LobbyData): Lobby
	local self = setmetatable({}, { __index = LobbyClass })

	self.lobbyData = lobbyData

	self.touchConnection = lobbyData.touchPart.Touched:Connect(function(otherPart)
		AttemptJoin(otherPart, self)
	end)

	self.playerLeaveConnection = players.PlayerRemoving:Connect(function(player)
		OnPlayerLeave(player, self)
	end)

	self.hostId = self.lobbyData.hostId
	self.lobbyId = self.lobbyData.lobbyId

	return self
end

function LobbyClass:RemoveLobby()
	if self.touchConnection then
		self.touchConnection:Disconnect()
		self.touchConnection = nil
	end

	if self.playerLeaveConnection then
		self.playerLeaveConnection:Disconnect()
		self.playerLeaveConnection = nil
	end
end

function LobbyClass:AddPlayer(player: Player) --all checks already performed
	local lobbyData = self.lobbyData
	local playerId = player.UserId

	print("Adding player..")
	print("Players in lobby: " .. #lobbyData.players)

	if not table.find(lobbyData.players, playerId) then
		table.insert(lobbyData.players, playerId)
		player.Character:PivotTo(lobbyData.enterPart.CFrame)
		print("Added " .. player.Name .. " to the lobby")
	end

	lobbyPlayerJoinRemoteEvent:FireClient(player)
	lobbyPlayerJoinBindableEvent:Fire(player, lobbyData.lobbyId)
	print("Added player")
end

function LobbyClass:RemovePlayer(player: Player)
	local playerId = player.UserId
	local lobbyData = self.lobbyData

	local playerIndex = table.find(lobbyData.players, playerId)

	if not playerIndex then
		warn(player.Name .. " is not in the lobby")
		return
	end

	if playerId == lobbyData.hostId then
		RemoveHost(self, player) --only calls host leave event
		self:RemoveAllPlayers()
	end

	table.remove(lobbyData.players, playerIndex)
	print("Removed " .. player.Name .. " from the lobby")

	lobbyPlayerLeaveRemoteEvent:FireClient(player, lobbyData.lobbyId)
	lobbyPlayerLeaveBindableEvent:Fire(player, lobbyData.lobbyId)

	if not player.Character then
		warn("No player character found when removing player")
		return
	end

	player.Character:PivotTo(lobbyData.exitPart.CFrame)
end

function LobbyClass:RemoveAllPlayers()
	for _, player in ipairs(self.lobbyData.players) do
		self:RemovePlayer(player)
	end

	self:OpenLobby()
	self.lobbyData.timer:StopTimer()
	print("Removed all players from lobby")
end

function LobbyClass:TeleportAllPlayersToPlace()
	local placeId = self.lobbyData.teleportPlaceId
	local privateServerId = teleportService:ReserveServerAsync(placeId)

	local teleportOptions = Instance.new("TeleportOptions")
	teleportOptions.ReservedServerAccessCode = privateServerId

	teleportService:TeleportAsync(placeId, self.lobbyData.players, teleportOptions)
end

return LobbyClass
