--!strict
local players = game:GetService("Players")
local serverScriptService = game:GetService("ServerScriptService")
local teleportService = game:GetService("TeleportService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local serverStorage = game:GetService("ServerStorage")

local lobbyDataModule = require(serverScriptService.LobbySystem.Data.LobbyData)

local eventsFolderShared: Folder = replicatedStorage.Lobby.Events

local eventsFolderServer: Folder = serverStorage.Events
local lobbyEventsFolderServer: Folder = eventsFolderServer.Lobby

local lobbyHostJoinEvent: RemoteEvent = eventsFolderShared.OnLobbyHostJoin
local lobbyHostLeaveEvent: RemoteEvent = eventsFolderShared.OnLobbyHostLeave

local onPlayerTeleportEvent: RemoteEvent = eventsFolderShared.OnPlayerTeleport

local lobbyPlayerJoinRemoteEvent: RemoteEvent = eventsFolderShared.OnLobbyPlayerJoin
local lobbyPlayerLeaveRemoteEvent: RemoteEvent = eventsFolderShared.OnLobbyPlayerLeave

local startCameraMovementEvent: RemoteEvent = eventsFolderShared.StartCameraMovement
local stopCameraMovementEvent: RemoteEvent = eventsFolderShared.StopCameraMovement

local lobbyPlayerJoinBindableEvent: BindableEvent = lobbyEventsFolderServer.LobbyPlayerJoinServer
local lobbyPlayerLeaveBindableEvent: BindableEvent = lobbyEventsFolderServer.LobbyPlayerLeaveServer
local lobbyHostJoinBindableEvent: BindableEvent = lobbyEventsFolderServer.LobbyHostJoinServer
local lobbyHostLeaveBindableEvent: BindableEvent = lobbyEventsFolderServer.LobbyHostLeaveServer

local fullLobbyTimerSpeed = 2
local defaultLobbyTimerSpeed = 1

local teleportingDisplayText = "TELEPORTING.."

local LobbyClass = {}

export type Lobby = typeof(setmetatable({} :: {
	touchConnection: RBXScriptConnection,
	playerLeaveConnection: RBXScriptConnection,
	playerResetConnection: RBXScriptConnection,
	lobbyData: lobbyDataModule.LobbyData,
	timerSpedUp: boolean,
}))

local function SpeedUpLobbyTimer(self: Lobby)
	if not self.lobbyStarted then
		return
	end

	if self.timerSpedUp then
		return
	end

	self.lobbyData.timer:ChangeTimerSpeed(fullLobbyTimerSpeed)
	self.timerSpedUp = true
end

local function ResetLobbyTimerSpeed(self: Lobby)
	if not self.timerSpedUp then
		return
	end

	self.lobbyData.timer:ChangeTimerSpeed(defaultLobbyTimerSpeed)
	self.timerSpedUp = false
end

function LobbyClass:ResetLobby()
	self.lobbyStarted = false

	self.lobbyData.players = {}
	self.lobbyData.args:ResetArgsToDefault()

	self.timerSpedUp = false

	self.lobbyData.timerDisplay:HideDisplay()

	self.lobbyData.playerLimitDisplay:RemoveAllPlayerImages()
end

function LobbyClass:StartLobby()
	self.lobbyStarted = true

	local lobbyData = self.lobbyData
	local lobbyArgs = lobbyData.args

	lobbyData.timerDisplay:ShowDisplay()

	if #lobbyData.playerIds == lobbyArgs.playerLimit then
		SpeedUpLobbyTimer(self)
	end

	task.spawn(function()
		lobbyData.timer:StartTimer()
	end)

	lobbyData.playerLimitDisplay:UpdateDisplay()

	startCameraMovementEvent:FireClient(players:GetPlayerByUserId(lobbyData.hostId), lobbyData.cameraPart)
	self:OpenLobby()
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
end

function LobbyClass:CloseLobby()
	self.lobbyData.lobbyOpen = false
end

local function ValidatePlayerWithConfig(player: Player, self: Lobby)
	local lobbyData = self.lobbyData

	if lobbyData.args["friendsOnly"] and not player:IsFriendsWithAsync(lobbyData.hostId) then
		return false
	elseif #lobbyData.playerIds >= lobbyData.args["playerLimit"] then
		return false
	elseif table.find(lobbyData.playerIds, player.UserId) then
		return false
	elseif not lobbyData.lobbyOpen then
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
end

local function RemoveHost(self: Lobby, player: Player)
	local lobbyData = self.lobbyData

	print(lobbyData.playerIds)
	local hostIndex = table.find(lobbyData.playerIds, lobbyData.hostId)

	if not hostIndex then
		warn("No host to remove!")
		return
	end

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

	self.timerSpedUp = false

	players.PlayerAdded:Connect(function(player)
		player.CharacterAdded:Connect(function(character: Model)
			OnPlayerReset(character, self)
		end)
	end)

	self.hostId = self.lobbyData.hostId
	self.lobbyId = self.lobbyData.lobbyId

	self.lobbyStarted = false

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

	if table.find(lobbyData.playerIds, playerId) then
		return
	end

	table.insert(lobbyData.playerIds, playerId)
	player.Character:PivotTo(lobbyData.enterPart.CFrame)

	lobbyData.playerLimitDisplay:UpdateDisplay()

	lobbyPlayerJoinRemoteEvent:FireClient(player)
	lobbyPlayerJoinBindableEvent:Fire(player, lobbyData.lobbyId)

	if self.lobbyStarted then
		startCameraMovementEvent:FireClient(player, lobbyData.cameraPart)
	end

	if #playerIds == lobbyData.args.playerLimit then
		SpeedUpLobbyTimer(self)
	end
end

function LobbyClass:RemovePlayer(player: Player)
	local playerId = player.UserId
	local lobbyData = self.lobbyData

	local playerIndex = table.find(lobbyData.playerIds, playerId)

	if not playerIndex then
		warn(player.Name .. " is not in the lobby")
		return
	end

	if playerId == lobbyData.hostId and lobbyData.hostId then
		print("Player " .. player.Name .. " is host")
		RemoveHost(self, player) --only calls host leave event and removes host from ids table
		self:RemoveAllPlayers()

		return
	end

	table.remove(lobbyData.playerIds, playerIndex)

	print("Removed: " .. player.Name .. " from lobby")

	lobbyData.playerLimitDisplay:UpdateDisplay()
	print("Updated player limit display")
	lobbyPlayerLeaveRemoteEvent:FireClient(player, lobbyData.lobbyId)
	print("Fired player leave remote event")
	lobbyPlayerLeaveBindableEvent:Fire(player, lobbyData.lobbyId)
	print("Fired plaeyr leave bindable event")

	if self.lobbyStarted then --if lobby already started only then stop
		stopCameraMovementEvent:FireClient(player, lobbyData.cameraPart)
		print("Fired stop camera movement event")
	end

	ResetLobbyTimerSpeed(self)
	print("Reset lobby timer speed")

	if #lobbyData.playerIds == 0 then
		self:ResetLobby()
		print("Reset lobby")
	end

	if not player.Character then
		warn("No player character found when removing player")
		return
	end

	player.Character:PivotTo(lobbyData.exitPart.CFrame)
	print("Done with remove player function")
end

function LobbyClass:RemoveAllPlayers()
	print("Removing " .. #self.lobbyData.playerIds .. " players from lobby")
	print(self.lobbyData.playerIds)

	local playerIdsClone = table.clone(self.lobbyData.playerIds)

	for _, playerId in ipairs(playerIdsClone) do
		local player: Player = players:GetPlayerByUserId(playerId)

		print("Removing player: " .. player.Name)
		self:RemovePlayer(player)
	end

	self:OpenLobby()
	self.lobbyData.timer:StopTimer()
	print(self.lobbyData.playerIds)
	print("Removed all players")
end

function LobbyClass:TeleportAllPlayersToPlace()
	local lobbyData = self.lobbyData

	for _, playerId in ipairs(lobbyData.playerIds) do
		onPlayerTeleportEvent:FireClient(players:GetPlayerByUserId(playerId))
	end

	local placeId = lobbyData.args["teleportPlaceId"]

	if not placeId then
		warn("No place ID found in lobby args")
		return
	end

	local privateServerId = teleportService:ReserveServerAsync(placeId)

	local teleportOptions = Instance.new("TeleportOptions")
	teleportOptions.ReservedServerAccessCode = privateServerId

	local playerInstanceTable = {}

	for _, playerId in ipairs(lobbyData.playerIds) do
		local player = players:GetPlayerByUserId(playerId)

		if player then
			table.insert(playerInstanceTable, player)
		end
	end

	lobbyData.timerDisplay:DisplayText(teleportingDisplayText)
	teleportService:TeleportAsync(placeId, playerInstanceTable, teleportOptions)

	task.wait(lobbyDataModule.teleportWaitTime)
	self:ResetLobby()
end

return LobbyClass
