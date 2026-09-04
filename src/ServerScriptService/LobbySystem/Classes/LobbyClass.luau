local players = game:GetService("Players")
local serverScriptService = game:GetService("ServerScriptService")
local teleportService = game:GetService("TeleportService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local serverStorage = game:GetService("ServerStorage")

local lobbyDataModule = require(serverScriptService.LobbySystem.Data.LobbyData)
local timerModule = require(serverScriptService.HelperModules.TimerModuleClass)

local eventsFolderShared: Folder = replicatedStorage:FindFirstChild("Events")
local eventsFolderServer: Folder = serverStorage:FindFirstChild("Events")

local lobbyHostJoinEvent: RemoteEvent = eventsFolderShared:FindFirstChild("OnLobbyHostJoin")
local lobbyPlayerJoinRemoteEvent: RemoteEvent = eventsFolderShared:FindFirstChild("OnLobbyPlayerJoin")
local lobbyPlayerLeaveRemoteEvent: RemoteEvent = eventsFolderShared:FindFirstChild("OnLobbyPlayerLeave")

local lobbyPlayerJoinBindableEvent: BindableEvent = eventsFolderServer:FindFirstChild("LobbyPlayerJoinServer")
local lobbyPlayerLeaveBindableEvent: BindableEvent = eventsFolderServer:FindFirstChild("LobbyPlayerLeaveServer")
local lobbyHostJoinBindableEvent: BindableEvent = eventsFolderServer:FindFirstChild("LobbyHostJoinServer")
local lobbyHostLeaveBindableEvent: BindableEvent = eventsFolderServer:FindFirstChild("LobbyHostLeaveServer")

local LobbyClass = {}

export type Lobby = typeof(setmetatable({} :: {
	players: {},
	touchConnection: RBXScriptConnection,
	playerLeaveConnection: RBXScriptConnection,
	lobbyData: lobbyDataModule.LobbyData,
	timer: timerModule.Timer,
	touchPart: BasePart,
	enterPart: BasePart,
	exitPart: BasePart,
	lobbyOpen: boolean,
	lobbyId: number,
	hostId: number,
}))

function LobbyClass:OpenLobby()
	self.lobbyOpen = true
	print("Opened lobby")
end

function LobbyClass:CloseLobby()
	self.lobbyOpen = false
	print("Closed lobby")
end

local function ValidatePlayerWithConfig(player: Player, self: Lobby)
	if self.lobbyData.friendsOnly and not player:IsFriendsWithAsync(self.lobbyData.hostId) then
		return false
	end
	if #self.players >= self.lobbyData.playerLimit then
		return false
	end
	if table.find(self.players, player.UserId) then
		return false
	end
	if not self.lobbyOpen then
		return false
	end

	return true
end

local function AddHost(player: Player, self: Lobby)
	self:AddPlayer(player)
	self:CloseLobby() --make setup open lobby after

	self.hostId = player.UserId

	lobbyHostJoinEvent:FireClient(player)
	lobbyHostJoinBindableEvent:Fire(self.lobbyId)
	print("Added host!")
end

local function RemoveHost(self: Lobby, player: Player)
	local hostIndex = table.find(self.players, self.hostId)

	if not hostIndex then
		warn("No host to remove!")
		return
	end

	self.players[hostIndex] = nil
	self.hostId = nil

	lobbyHostLeaveBindableEvent:Fire(self.lobbyId)

	if not player.Character then
		warn("No player character found when removing player")
		return
	end

	player.Character:PivotTo(self.exitPart.CFrame)
end

local function AttemptJoin(otherPart: BasePart, self: Lobby) --validate before adding player
	local player = players:GetPlayerFromCharacter(otherPart.Parent)

	if player then
		if #self.players == 0 then --if host, dont validate
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

	if table.find(self.players, playerId) then
		self:RemovePlayer(player)
	end
end

function LobbyClass.new(
	touchPart: BasePart,
	enterPart: BasePart,
	exitPart: BasePart,
	lobbyData: lobbyDataModule.LobbyData
): Lobby
	local self = setmetatable({}, { __index = LobbyClass })

	self.players = {}
	self.touchPart = touchPart
	self.enterPart = enterPart
	self.exitPart = exitPart

	self.lobbyOpen = true

	self.touchConnection = touchPart.Touched:Connect(function(otherPart)
		AttemptJoin(otherPart, self)
	end)

	self.playerLeaveConnection = players.PlayerRemoving:Connect(function(player)
		OnPlayerLeave(player, self)
	end)

	self.lobbyData = lobbyData
	self.timer = timerModule.new()

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
	local playerId = player.UserId

	print("Adding player..")
	print("Players in lobby: " .. #self.players)

	if not table.find(self.players, playerId) then
		table.insert(self.players, playerId)
		player.Character:PivotTo(self.enterPart.CFrame)
		print("Added " .. player.Name .. " to the lobby")
	end

	lobbyPlayerJoinRemoteEvent:FireClient(player)
	lobbyPlayerJoinBindableEvent:Fire(player, self.lobbyId)
	print("Added player")
end

function LobbyClass:RemovePlayer(player: Player)
	local playerId = player.UserId

	local playerIndex = table.find(self.players, playerId)

	if not playerIndex then
		warn(player.Name .. " is not in the lobby")
		return
	end

	if playerId == self.hostId then
		RemoveHost(self, player) --only calls host leave event
		self:RemoveAllPlayers()
	end

	table.remove(self.players, playerIndex)
	print("Removed " .. player.Name .. " from the lobby")

	lobbyPlayerLeaveRemoteEvent:FireClient(player, self.lobbyId)
	lobbyPlayerLeaveBindableEvent:Fire(player, self.lobbyId)

	if not player.Character then
		warn("No player character found when removing player")
		return
	end

	player.Character:PivotTo(self.exitPart.CFrame)
end

function LobbyClass:RemoveAllPlayers()
	for _, player in ipairs(self.players) do
		self:RemovePlayer(player)
	end

	self:OpenLobby()
	print("Removed all players from lobby")
end

function LobbyClass:TeleportAllPlayersToPlace()
	local placeId = self.lobbyData.teleportPlaceId
	local privateServerId = teleportService:ReserveServerAsync(placeId)

	local teleportOptions = Instance.new("TeleportOptions")
	teleportOptions.ReservedServerAccessCode = privateServerId

	teleportService:TeleportAsync(placeId, self.players, teleportOptions)
end

return LobbyClass
