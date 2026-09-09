--!strict
local starterPlayerScripts = game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local players = game:GetService("Players")

local lobbyClientFolder: Folder = starterPlayerScripts:WaitForChild("Lobby")
local handlersFolder: Folder = lobbyClientFolder:WaitForChild("Handlers")

local lobbyUIDataFolder: Folder = lobbyClientFolder:WaitForChild("LobbyUIData")

local lobbyUIData = require(lobbyUIDataFolder.LobbyUIDatabase)

local lobbyEventHandler = require(handlersFolder.LobbyClientEventHandler)

local lobbyUIEventHandler = require(lobbyUIData.uiHandlersFolder.LobbyUIEventHandler)

local function OnCharacterAdded()
	lobbyUIData.UpdateUIVariables()
	lobbyUIEventHandler.UpdateUIEvents()
end

players.LocalPlayer.CharacterAdded:Connect(OnCharacterAdded)
