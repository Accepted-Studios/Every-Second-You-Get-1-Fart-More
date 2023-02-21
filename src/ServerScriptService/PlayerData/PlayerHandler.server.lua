------Services----------
local Players = game:GetService("Players")

-------Variables----------

---*Function To Update Player JumpPower*---
local function updateJumpPower(character: Instance, FartPower: IntValue)
	if character then
		local humanoid = character:WaitForChild("Humanoid")
		humanoid.JumpPower = FartPower.Value
	end
end

---*Function To Add JumpPower*---
local function addJumpPower(player: Player, FartPower: IntValue, FartRebirths: IntValue, FartIncrease: IntValue)
	task.spawn(function()
		while task.wait(1) do
			--If player is premium, add 2 to JumpPower, else add 1----
			if player.MembershipType == Enum.MembershipType.Premium then
				FartPower.Value = FartPower.Value + 2
			else
				FartPower.Value = FartPower.Value + 1
			end

			---Add FartRebirths to JumpPower if FartRebirths is Greater than 0---
			if FartRebirths.Value > 0 then
				FartPower.Value = FartPower.Value + FartRebirths.Value
			end

			---Add FartIncrease to JumpPower if FartIncrease is Greater than 0---
			if FartIncrease.Value > 0 then
				FartPower.Value = FartPower.Value + FartIncrease.Value
			end
		end
	end)
end

-----** Function To Run When Player Joins **-----
Players.PlayerAdded:Connect(function(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local FartPower = Instance.new("IntValue")
	FartPower.Name = "FartPower"
	FartPower.Value = 0
	FartPower.Parent = leaderstats

	local Wins = Instance.new("IntValue")
	Wins.Name = "Wins"
	Wins.Value = 0
	Wins.Parent = leaderstats

	local FartRebirths = Instance.new("IntValue")
	FartRebirths.Name = "FartRebirths"
	FartRebirths.Value = 0
	FartRebirths.Parent = leaderstats

	local FartIncrease = Instance.new("IntValue")
	FartIncrease.Name = "FartIncrease"
	FartIncrease.Value = 0
	FartIncrease.Parent = player

	player.CharacterAdded:Connect(function(character)
		-----*Whenever a character respwns, Update JumpPower*---
		updateJumpPower(character, FartPower)
		FartPower.Changed:Connect(function()
			updateJumpPower(character, FartPower)
		end)

		addJumpPower(player, FartPower, FartRebirths, FartIncrease)
	end)
end)
