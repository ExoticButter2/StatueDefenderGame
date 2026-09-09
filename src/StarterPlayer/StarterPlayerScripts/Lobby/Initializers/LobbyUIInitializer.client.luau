--!strict
local starterPlayerScripts = game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")

local lobbyClientFolder: Folder = starterPlayerScripts:WaitForChild("Lobby")
local handlersFolder: Folder = lobbyClientFolder:WaitForChild("Handlers")

local lobbyUIDataFolder: Folder = lobbyClientFolder:WaitForChild("LobbyUIData")
local lobbyUIData = require(lobbyUIDataFolder.LobbyUIDatabase)

local lobbyEventHandler = require(handlersFolder.LobbyClientEventHandler)

local lobbyUIEventHandler = require(lobbyUIData.uiHandlersFolder.LobbyUIEventHandler)

local function Initialize()
	lobbyUIData.Initialize() --ALWAYS INITIALIZE FIRST HERE

	lobbyUIEventHandler.Initialize()

	lobbyEventHandler.Initialize()
end

Initialize()
