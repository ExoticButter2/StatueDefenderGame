local LobbyClass = {}

export type Lobby = typeof(setmetatable({} :: {
	players: {},
	touchPart: BasePart,
	enterPart: BasePart,
	exitPart: BasePart,
	connection: RBXScriptConnection
}))

local function OnTouchPart(otherPart: BasePart, self: Lobby)
	local player = game.Players:GetPlayerFromCharacter(otherPart.Parent)

	if player then
		self:AddPlayer(player)
	end

	print("Part touched!")
end

function LobbyClass.new(touchPart: BasePart, enterPart: BasePart, exitPart: BasePart): Lobby
	local self = setmetatable({}, { __index = LobbyClass })

	self.players = {}
	self.touchPart = touchPart
	self.enterPart = enterPart
	self.exitPart = exitPart

	self.connection = touchPart.Touched:Connect(function(otherPart)
		OnTouchPart(otherPart, self)
	end)

	return self
end

function LobbyClass:OnLobbyRemove()
    self.connection:Disconnect()
	print("Lobby removed!")
end

function LobbyClass:AddPlayer(player: Player) --all checks already performed
	local playerId = player.UserId

	if not self.players[playerId] then
		self.players[playerId] = player
		player.Character:PivotTo(self.enterPart.CFrame)
		print("Added " .. player.Name .. " to the lobby")
	else
		self.players[playerId] = nil
		print("Removed " .. player.Name .. " from the lobby")
		warn(player.Name .. " is already in the lobby")
	end
end

function LobbyClass:RemovePlayer(player: Player)
	local playerId = player.UserId

	if not self.players[playerId] then
		warn(player.Name .. " is not in the lobby")
	else
		self.players[playerId] = nil
		player.Character:PivotTo(self.exitPart.CFrame)
		print("Removed " .. player.Name .. " from the lobby")
	end
end

return LobbyClass
