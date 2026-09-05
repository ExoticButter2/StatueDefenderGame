local starterPlayerScripts = game:GetService("StarterPlayer"):FindFirstChild("StarterPlayerScripts")

local handlersFolder = starterPlayerScripts:FindFirstChild("Handlers")
local uiHandlersFolder = starterPlayerScripts:FindFirstChild("UIHandlers")

local lobbyEventHandler = require(handlersFolder.LobbyClientEventHandler)
local lobbyPlayerUIHandler = require(uiHandlersFolder.LobbyPlayerUIHandler)
local lobbyPlayerUIStartHandler = require(uiHandlersFolder.LobbyHostUIStartHandler)

local function Initialize()
	lobbyEventHandler.Initialize()
	lobbyPlayerUIHandler.Initialize()
	lobbyPlayerUIStartHandler.Initialize()
end

Initialize()
