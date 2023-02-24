-----Services----------
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")

-----Developer Variables-----
local InStudio = RunService:IsStudio() -- Check if in studio

--------Gamepass Variables----------
local MonetisationFolder = ReplicatedStorage:WaitForChild("Monetization")
local GamepassesModule = require(MonetisationFolder.Gamepasses)

-------Datastore Variables------
local DatastoreModulesFolder = ServerStorage:WaitForChild("DatastoreModules")
local DataServiceModule = require(DatastoreModulesFolder.DataService)

-----Functions-----
---*Function To Update Player JumpPower*---
local function UpdateJumpPower(humanoid: Humanoid, FartPower: IntValue)
	humanoid.JumpPower = FartPower.Value
end

---*Function To Add JumpPower*---
local function AddJumpPower(
	player: Player,
	FartPower: IntValue,
	FartRebirths: IntValue,
	FartIncrease: IntValue,
	Wins: IntValue,
	OwnsX2FartPower: BoolValue,
	OwnsX2Wins: BoolValue
)
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

		-----Add Wins to JumpPower if Wins is Greater than 0-----
		if Wins.Value > 0 then
			FartPower.Value = FartPower.Value + Wins.Value
		end
		---Check if Player Owns x2 Fart Power------
		if OwnsX2FartPower == true then
			FartPower.Value = FartPower.Value * 1 + 2
		end

		-- -- -----Check if Player Owns x2 Wins------
		if OwnsX2Wins == true then
			Wins.Value = Wins.Value * 1 + 2
		end
	end
end

local function UpdateOverHead(char, FartPower, Wins)
	local OverHead = char:WaitForChild("OverHead")
	OverHead.Adornee = char:WaitForChild("Head")
	local Frame = OverHead:WaitForChild("Frame")
	local FartPowerLabel = Frame:WaitForChild("FartPowerLabel")
	local WinsLabel = Frame:WaitForChild("WinsLabel")

	local function UpdateFartPower()
		FartPowerLabel.Text = "FartPower: " .. FartPower.Value
	end

	local function UpdateWins()
		WinsLabel.Text = "Wins: " .. Wins.Value
	end

	FartPower.Changed:Connect(UpdateFartPower)
	Wins.Changed:Connect(UpdateWins)

	UpdateFartPower()
	UpdateWins()
end

-----** Main Function To Run When Player Joins **-----
local function PlayerJoined(player)
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

	local FartRebirths = Instance.new("NumberValue")
	FartRebirths.Name = "FartRebirths"
	FartRebirths.Value = 0
	FartRebirths.Parent = leaderstats

	local FartIncrease = Instance.new("IntValue")
	FartIncrease.Name = "FartIncrease"
	FartIncrease.Value = 0
	FartIncrease.Parent = player

	local Multiplier = Instance.new("IntValue")
	Multiplier.Name = "Multiplier"
	Multiplier.Value = 0
	Multiplier.Parent = player

	-----**Detects When Character Is Added**-----
	player.CharacterAdded:Connect(function(character)
		print("Character Added")
		local humanoid = character:WaitForChild("Humanoid")
		if not humanoid then
			return warn("No Humanoid")
		end

		-----*Whenever a character respwns, Update JumpPower*---
		UpdateJumpPower(humanoid, FartPower)
		FartPower.Changed:Connect(function()
			UpdateJumpPower(humanoid, FartPower)
		end)
		UpdateOverHead(character, FartPower, Wins)
	end)

	-----**Load Data**-----
	DataServiceModule.PlayerJoining(player)

	-----**Check If Player Owns x2 Wins Gamepass or Owns x2 FartPower or Both**-----

	local OwnsX2Wins = GamepassesModule:CheckIfPlayerOwnsGamepass(player, "x2 Wins")
	local OwnsX2FartPower = GamepassesModule:CheckIfPlayerOwnsGamepass(player, "x2 Fart Power")

	-----**Add JumpPower To Player's Humanoid**-----
	AddJumpPower(player, FartPower, FartRebirths, FartIncrease, Wins, OwnsX2FartPower, OwnsX2Wins)

	-- end
end

----**When Player Leaves The Game-------
local function PlayerLeaving(player)
	DataServiceModule.SaveData(player)
end

------**PlayerAdded Connects to PlayerJoin------
Players.PlayerAdded:Connect(PlayerJoined)

------Loops for Players in the Game-----
for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(PlayerJoined(player))
end

------PlayersRemoving Connects to PlayerLeaving-----
Players.PlayerRemoving:Connect(PlayerLeaving)
