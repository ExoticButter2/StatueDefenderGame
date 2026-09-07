--!strict
local players = game:GetService("Players")
local serverScriptService = game:GetService("ServerScriptService")
local teleportService = game:GetService("TeleportService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local serverStorage = game:GetService("ServerStorage")

local lobbyDataModule = require(serverScriptService.LobbySystem.Data.LobbyData)

local eventsFolderShared: Folder = replicatedStorage:FindFirstChild("Events")
local lobbyEventsFolderShared: Folder = eventsFolderShared:FindFirstChild("Lobby")

local eventsFolderServer: Folder = serverStorage:FindFirstChild("Events")
local lobbyEventsFolderServer: Folder = eventsFolderServer:FindFirstChild("Lobby")

local lobbyHostJoinEvent: RemoteEvent = lobbyEventsFolderShared:FindFirstChild("OnLobbyHostJoin")
local lobbyHostLeaveEvent: RemoteEvent = lobbyEventsFolderShared:FindFirstChild("OnLobbyHostLeave")

local onPlayerTeleportEvent: RemoteEvent = lobbyEventsFolderShared:FindFirstChild("OnPlayerTeleport")

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
	playerResetConnection: RBXScriptConnection,
	lobbyData: lobbyDataModule.LobbyData,
}))

function LobbyClass:ResetLobby()
	self.lobbyData.players = {}
	self.lobbyData.friendsOnly = lobbyDataModule.defaultFriendsOnly
	self.lobbyData.playerLimit = lobbyDataModule.defaultPlayerLimit
	self.lobbyData.teleportPlaceId = lobbyDataModule.defaultTeleportPlaceId

	print("Reset lobby " .. self.lobbyData.lobbyId)
end

function LobbyClass:StartLobby()
	task.spawn(function()
		self.lobbyData.timer:StartTimer()
	end)

	self:OpenLobby()

	print("Started lobby from lobby class")
end

-- function LobbyClass:ChangeLobbySettings(args: {}) --changes lobby settings args
-- 	local lobbyData = self.lobbyData

-- 	for setting, v in pairs(args) do
-- 		if not lobbyData.args[setting] then --if setting doesn't exist
-- 			warn("No setting found in args with given args table")
-- 			continue
-- 		end

-- 		lobbyData.args[setting] = v
-- 	end

-- 	local playerLimit = lobbyData.args["playerLimit"]

-- 	lobbyData.args["playerLimit"] =
-- 		math.clamp(playerLimit, lobbyDataModule.minPlayerLimit, lobbyDataModule.maxPlayerLimit) --prevent cheaters going beyond limits
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

	if lobbyData.args["friendsOnly"] and not player:IsFriendsWithAsync(lobbyData.hostId) then
		return false
	end
	if #lobbyData.playerIds >= lobbyData.args["playerLimit"] then
		return false
	end
	if table.find(lobbyData.playerIds, player.UserId) then
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

	local hostIndex = table.find(lobbyData.playerIds, lobbyData.hostId)

	if not hostIndex then
		warn("No host to remove!")
		return
	end

	lobbyData.playerIds[hostIndex] = nil
	lobbyData.hostId = nil

	lobbyHostLeaveEvent:FireClient(player, lobbyData.lobbyId)
	lobbyHostLeaveBindableEvent:Fire(lobbyData.lobbyId)

	if not player.Character then
		return
	end

	player.Character:PivotTo(lobbyData.exitPart.CFrame)
end

local function AttemptJoin(otherPart: BasePart, self: Lobby) --validate before adding player
	local player = players:GetPlayerFromCharacter(otherPart.Parent)

	if player then
		if #self.lobbyData.playerIds == 0 then --if host, dont validate
			AddHost(player, self)
			return
		end

		if ValidatePlayerWithConfig(player, self) then --if regular player, validate
			self:AddPlayer(player)
		end
	end
end

local function OnPlayerLeave(player: Player, self: Lobby)
	local playerId = player.UserId

	if table.find(self.lobbyData.playerIds, playerId) then
		self:RemovePlayer(player)
	end
end

local function OnPlayerReset(character: Model, self: Lobby)
	print("Player reset!")
	local player: Player = players:GetPlayerFromCharacter(character)

	if not player then
		warn("No player character found from reset")
		return
	end

	local playerId: number = player.UserId

	if table.find(self.lobbyData.playerIds, playerId) then
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

	players.PlayerAdded:Connect(function(player)
		player.CharacterAdded:Connect(function(character: Model)
			OnPlayerReset(character, self)
		end)
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
	local playerIds = lobbyData.playerIds

	print("Adding player..")
	print("Players in lobby: " .. #playerIds)

	if not table.find(playerIds, playerId) then
		table.insert(playerIds, playerId)
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

	local playerIndex = table.find(lobbyData.playerIds, playerId)

	if not playerIndex then
		warn(player.Name .. " is not in the lobby")
		return
	end

	if playerId == lobbyData.hostId then
		RemoveHost(self, player) --only calls host leave event
		self:RemoveAllPlayers()
	end

	table.remove(lobbyData.playerIds, playerIndex)
	print("Removed " .. player.Name .. " from the lobby")

	lobbyPlayerLeaveRemoteEvent:FireClient(player, lobbyData.lobbyId)
	lobbyPlayerLeaveBindableEvent:Fire(player, lobbyData.lobbyId)

	if #lobbyData.playerIds == 0 then
		self:ResetLobby()
	end

	if not player.Character then
		warn("No player character found when removing player")
		return
	end

	player.Character:PivotTo(lobbyData.exitPart.CFrame)
end

function LobbyClass:RemoveAllPlayers()
	for _, player in ipairs(self.lobbyData.playerIds) do
		self:RemovePlayer(player)
	end

	self:OpenLobby()
	self.lobbyData.timer:StopTimer()
	print("Removed all players from lobby")
end

function LobbyClass:TeleportAllPlayersToPlace()
	for _, playerId in ipairs(self.lobbyData.playerIds) do
		onPlayerTeleportEvent:FireClient(players:GetPlayerByUserId(playerId))
	end

	local placeId = self.lobbyData.args["teleportPlaceId"]

	if not placeId then
		warn("No place ID found in lobby args")
		return
	end

	local privateServerId = teleportService:ReserveServerAsync(placeId)

	local teleportOptions = Instance.new("TeleportOptions")
	teleportOptions.ReservedServerAccessCode = privateServerId

	local playerInstanceTable = {}

	for _, playerId in ipairs(self.lobbyData.playerIds) do
		local player = players:GetPlayerByUserId(playerId)

		if player then
			table.insert(playerInstanceTable, player)
		end
	end

	teleportService:TeleportAsync(placeId, playerInstanceTable, teleportOptions)

	task.wait(lobbyDataModule.teleportWaitTime)
	self:ResetLobby()
end

return LobbyClass
