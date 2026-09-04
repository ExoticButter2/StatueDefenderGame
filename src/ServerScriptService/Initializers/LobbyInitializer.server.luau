local serverScriptService = game:GetService("ServerScriptService")

local lobbySystemFolder: Folder = serverScriptService:FindFirstChild("LobbySystem")

local lobbyManagersFolder: Folder = lobbySystemFolder:FindFirstChild("Managers")
local lobbyHandlersFolder: Folder = lobbySystemFolder:FindFirstChild("Handlers")

local lobbyManager = require(lobbyManagersFolder.LobbyManager)
local lobbyEventManager = require(lobbyHandlersFolder.LobbyServerEventHandler)

local function InitializeLobby()
	lobbyManager.Initialize()
	lobbyEventManager.Initialize()
end

InitializeLobby()
