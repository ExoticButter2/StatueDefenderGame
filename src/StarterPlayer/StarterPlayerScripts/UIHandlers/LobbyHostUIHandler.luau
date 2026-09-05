local players = game:GetService("Players")

local playerGui: PlayerGui = players.LocalPlayer:WaitForChild("PlayerGui")
local lobbyUiFolder: Folder = playerGui:WaitForChild("LobbyUI")

local hostGui: ScreenGui = lobbyUiFolder:WaitForChild("HostGui")

local lobbyHostUIHandler = {}

function lobbyHostUIHandler.EnableHostUI()
	hostGui.Enabled = true
	print("Enabled host ui")
end

function lobbyHostUIHandler.DisableHostUI()
	hostGui.Enabled = false
	print("Disabled host ui")
end

return lobbyHostUIHandler
