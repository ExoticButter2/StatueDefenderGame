local lobbiesFolder = game.Workspace.Lobbies

local LobbyManager = {}

local touchPartName = "TouchPart"
local enterPartName = "EnterPart"
local exitPartName = "ExitPart"

local function CreateLobby(lobbyModel: Model)
	local touchPart
	local enterPart
	local exitPart

	if lobbyModel:IsA("Model") then
		touchPart = lobbyModel:FindFirstChild(touchPartName)
		enterPart = lobbyModel:FindFirstChild(enterPartName)
		exitPart = lobbyModel:FindFirstChild(exitPartName)
	end

	if not touchPart then
		warn("Add part named " .. touchPartName .. " to the lobby model: " .. lobbyModel.Name)
		return
	end

	if not enterPart then
		warn("Add part named " .. enterPartName .. " to the lobby model: " .. lobbyModel.Name)
		return
	end

	if not exitPart then
		warn("Add part named " .. exitPartName .. " to the lobby model: " .. lobbyModel.Name)
		return
	end

    
end

function LobbyManager.Initialize()
	for _, lobbyModel in ipairs(lobbiesFolder:GetChildren()) do
		CreateLobby(lobbyModel)
	end
end

return LobbyManager
