--!strict
local starterPlayerScripts = game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local players = game:GetService("Players")

local lobbyClientFolder: Folder = starterPlayerScripts:WaitForChild("Lobby")
local handlersFolder: Folder = lobbyClientFolder:WaitForChild("Handlers")
local uiHandlersFolder: Folder = lobbyClientFolder:WaitForChild("UIHandlers")
local lobbyUIDataFolder: Folder = lobbyClientFolder:WaitForChild("LobbyUIData")

local lobbyEventHandler = require(handlersFolder.LobbyClientEventHandler)

local lobbyUIEventHandler = require(uiHandlersFolder.LobbyUIEventHandler)
local lobbyPlayerUIHandler = require(uiHandlersFolder.LobbyPlayerUIHandler)
local lobbyPlayerUIStartHandler = require(uiHandlersFolder.LobbyHostUIStartHandler)
local lobbyHostUIHandler = require(uiHandlersFolder.LobbyHostUIHandler)
local lobbyUIDatabase = require(lobbyUIDataFolder.LobbyUIDatabase)

local function Initialize()
	lobbyUIDatabase.Initialize() --ALWAYS INITIALIZE FIRST HERE

	lobbyUIEventHandler.Initialize()

	lobbyEventHandler.Initialize()
	lobbyPlayerUIHandler.Initialize()
	lobbyPlayerUIStartHandler.Initialize()
	lobbyHostUIHandler.Initialize()

	players.LocalPlayer.CharacterAdded:Connect(function()
		lobbyUIDatabase.UpdateUIVariables()

		lobbyPlayerUIHandler.UpdateUIEvents()
		lobbyPlayerUIStartHandler.UpdateUIEvents()
	end)
end

Initialize()
