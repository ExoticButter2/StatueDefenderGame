--!strict
local starterPlayerScripts = game:GetService("StarterPlayer").StarterPlayerScripts
local players = game:GetService("Players")

local lobbyClientFolder: Folder = starterPlayerScripts.Lobby
local handlersFolder: Folder = lobbyClientFolder.Handlers

local lobbyUIDataFolder: Folder = lobbyClientFolder.LobbyUIData

local lobbyUIData = require(lobbyUIDataFolder.LobbyUIDatabase)

require(handlersFolder.LobbyClientEventHandler)

local lobbyUIEventHandler = require(lobbyUIData.uiHandlersFolder.LobbyUIEventHandler)

local function OnCharacterAdded()
	lobbyUIData.UpdateUIVariables()
	lobbyUIEventHandler.UpdateUIEvents()
end

players.LocalPlayer.CharacterAdded:Connect(OnCharacterAdded)
