--!strict
local starterPlayerScripts = game:GetService("StarterPlayer").StarterPlayerScripts
local players = game:GetService("Players")

local lobbyClientFolder: Folder = starterPlayerScripts.Lobby
local handlersFolder: Folder = lobbyClientFolder.Handlers

local lobbyUIDataFolder: Folder = lobbyClientFolder.LobbyUIData

local lobbyUIData = require(lobbyUIDataFolder.LobbyUIDatabase)

require(handlersFolder.LobbyClientEventHandler)

local lobbyUIEventHandler = require(lobbyUIData.uiHandlersFolder.LobbyUIEventHandler)

local lobbyHostUIHandler = require(lobbyUIData.uiHandlersFolder.LobbyHostUIHandler)
local lobbyPlayerUIHandler = require(lobbyUIData.uiHandlersFolder.LobbyPlayerUIHandler)

local lobbyCameraMovementModule = require(lobbyUIData.lobbyClientFolder.Modules.LobbyCameraMovement)

local function OnCharacterAdded(character: Model)
	lobbyUIData.UpdateUIVariables()
	lobbyUIEventHandler.UpdateUIEvents()

	lobbyHostUIHandler.OnStart()
	lobbyPlayerUIHandler.OnStart()

	lobbyCameraMovementModule.OnStart(character)
end

players.LocalPlayer.CharacterAdded:Connect(OnCharacterAdded)
