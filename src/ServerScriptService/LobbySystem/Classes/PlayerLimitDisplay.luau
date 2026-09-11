local serverStorage = game:GetService("ServerStorage")
local serverScriptService = game:GetService("ServerScriptService")

local lobbyDataModule = serverScriptService.LobbySystem.Data.LobbyData

local playerLimitImages: Folder = serverStorage.Lobby.Images

local playerLimitEmptyImage: ImageLabel = playerLimitImages.EmptyPlayerImage
local playerLimitFilledImage: ImageLabel = playerLimitImages.FilledPlayerImage

export type PlayerLimitDisplay = typeof(setmetatable(
	{},
	{} :: {
		playerLimitGui: SurfaceGui,
		lobbyData: lobbyDataModule.LobbyData,
		filledPlayerImages: {},
		emptyPlayerImages: {},
	}
))

local PlayerLimitDisplay = {}

local filledString = "filled"
local emptyString = "empty"

function PlayerLimitDisplay.new(playerLimitGui: SurfaceGui): PlayerLimitDisplay
	local self = setmetatable({}, { __index = PlayerLimitDisplay })

	self.playerLimitGui = playerLimitGui
	self.lobbyData = nil

	self.filledPlayerImages = {}
	self.emptyPlayerImages = {}

	return self
end

function PlayerLimitDisplay:RemoveAllPlayerImages()
	for _, image in ipairs(self.emptyPlayerImages) do
		image:Destroy()
	end

	table.clear(self.emptyPlayerImages)

	for _, image in ipairs(self.filledPlayerImages) do
		image:Destroy()
	end

	table.clear(self.filledPlayerImages)
end

local function AddImage(imageType: string, amount: number, self: PlayerLimitDisplay)
	if imageType == filledString then
		for _ = 1, amount, 1 do
			local clonedFilledPlayerImage: ImageLabel = playerLimitFilledImage:Clone()
			clonedFilledPlayerImage.Parent = self.playerLimitGui

			table.insert(self.filledPlayerImages, clonedFilledPlayerImage)
		end
	elseif imageType == emptyString then
		for _ = 1, amount, 1 do
			local clonedEmptyPlayerImage: ImageLabel = playerLimitEmptyImage:Clone()
			clonedEmptyPlayerImage.Parent = self.playerLimitGui

			table.insert(self.emptyPlayerImages, clonedEmptyPlayerImage)
		end
	else
		warn("Wrong image type")
	end
end

function PlayerLimitDisplay:UpdateDisplay()
	local playersInLobby = #self.lobbyData.playerIds
	local playerLimit = self.lobbyData.args["playerLimit"]

	local emptyPlayerSlots = playerLimit - playersInLobby

	if not playersInLobby then
		warn("Players in lobby data not found")
		return
	end

	if not playerLimit then
		warn("Player limit args not found for lobby")
		return
	end

	self:RemoveAllPlayerImages()

	AddImage(filledString, playersInLobby, self)
	AddImage(emptyString, emptyPlayerSlots, self)
end

return PlayerLimitDisplay
