-----Services-----
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-----Variables-----
local RemotesFolder = ReplicatedStorage:WaitForChild("Remotes")
local ToolSelectedEvent = RemotesFolder:WaitForChild("ToolSelected")
local ToolsFolder = ReplicatedStorage:WaitForChild("Tools")

-----Functions-----

-----**When ToolSelectedEvent is fired, then run this function**-----
ToolSelectedEvent.OnServerEvent:Connect(function(Player, ToolName, PriceValue)
	local Wins = Player:WaitForChild("leaderstats"):WaitForChild("Wins")

	if Wins.Value >= PriceValue then -- Checks if player has enough wins to buy the tool.
		local Character = Player.Character

		Wins.Value = Wins.Value - PriceValue

		local Tool = ToolsFolder:FindFirstChild(ToolName) -- Finds the tool in the tools folder.

		if ToolName then
			local ToolClone = Tool:Clone() -- Clones the tool.
			ToolClone.Parent = Character -- Sets the parent of the tool clone to the player's character.
		end
	end
end)
