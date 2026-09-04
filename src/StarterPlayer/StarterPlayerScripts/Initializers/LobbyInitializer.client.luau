local starterPlayerScripts = game:GetService("StarterPlayer"):FindFirstChild("StarterPlayerScripts")

local handlersFolder = starterPlayerScripts:FindFirstChild("Handlers")
local uiHandlersFolder = starterPlayerScripts:FindFirstChild("UIHandlers")

local lobbyEventHandler = require(handlersFolder.LobbyClientEventHandler)
local lobbyPlayerUIHandler = require(uiHandlersFolder.LobbyPlayerUIHandler)
local lobbyHostUIHandler = require(uiHandlersFolder.LobbyHostUIHandler)

local function Initialize()
	lobbyEventHandler.Initialize()
	lobbyPlayerUIHandler.Initialize()
	lobbyHostUIHandler.Initialize()
end

Initialize()
