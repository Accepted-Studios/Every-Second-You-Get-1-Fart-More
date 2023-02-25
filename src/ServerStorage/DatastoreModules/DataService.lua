---Services---
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

---Functions---
local ProfileTemplate = {

	---Leaderstats Values-----
	Wins = 0,
	FartRebirths = 0,
	FartPower = 0,

	PetTable = {}, --- All Pets are saved in this table
}

-----Variables----
local DatastoreModulesFolder = ServerStorage:WaitForChild("DatastoreModules")
local ProfileService = require(DatastoreModulesFolder:WaitForChild("ProfileService"))
local PetDataFolder = ServerStorage:WaitForChild("PetData")

----ProfileService Variables----
----The official datastore is "OfficialAccepted"
local GameProfileStore = ProfileService.GetProfileStore("OfficialAccepted", ProfileTemplate) --- Datastore Change name
local Profiles = {}

----Calculations To Calculate XP-----
function getLevel(totalXP)
	local Increment = 0
	local RequiredXP = 100
	for i = 0, ReplicatedStorage.Pets.Settings.MaxPetLevel.Value do
		RequiredXP = 100 + (25 * i)
		if totalXP >= (100 * i) + Increment then
			if i ~= ReplicatedStorage.Pets.Settings.MaxPetLevel.Value then
				if totalXP < ((100 * i) + Increment) + RequiredXP then
					return i
				end
			else
				return i
			end
		end
		Increment = Increment + (i * 25)
	end
end

---*Function To Add JumpPower*---
local function AddJumpPower(
	player: Player,
	FartPower: IntValue,
	FartRebirths: NumberValue,
	FartIncrease: IntValue,
	Wins: IntValue,
	OwnsX2Wins,
	OwnsX2FartPower
)
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

			-----Add Wins to JumpPower if Wins is Greater than 0-----
			if Wins.Value > 0 then
				FartPower.Value = FartPower.Value + Wins.Value
			end
			---Check if Player Owns x2 Fart Power------
			if OwnsX2FartPower == true then
				FartPower.Value = FartPower.Value * 1 + 2
			end

			-- -- -- -----Check if Player Owns x2 Wins------
			if OwnsX2Wins == true then
				Wins.Value = Wins.Value * 1 + 2
			end
		end
	end)
end

---*Function To Update Player JumpPower*---
local function UpdateJumpPower(humanoid: Humanoid, FartPower: IntValue)
	humanoid.JumpPower = FartPower.Value
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

local function onCharacterAdded(player, character)
	print("Character Added")
	local FartPower = player:WaitForChild("leaderstats"):WaitForChild("FartPower")
	local Wins = player:WaitForChild("leaderstats"):WaitForChild("Wins")

	local humanoid = character:WaitForChild("Humanoid")
	if not humanoid then
		return warn("No Humanoid")
	end

	-----*Whenever a character respwns, Update JumpPower*--
	UpdateJumpPower(humanoid, FartPower)
	FartPower.Changed:Connect(function()
		UpdateJumpPower(humanoid, FartPower)
	end)
	UpdateOverHead(character, FartPower, Wins)
end

----Variables---
local MonetisationFolder = ReplicatedStorage:WaitForChild("Monetization")
local GamepassesModule = require(MonetisationFolder.Gamepasses)

---Modules---
local module = {}

----_Allows ProfileService to be Accessed From Another Script-------
function module:GetPlayerProfile(player, Yield)
	local profile = Profiles[player]

	if Yield and not profile then
		repeat
			task.wait(0.1)

			profile = Profiles[player]

		until profile or not player.Parent
	end
	return profile
end

----Module for PlayerAdded-------
function module.PlayerJoining(player)
	local playerprofile = GameProfileStore:LoadProfileAsync(tostring(player.UserId))

	if playerprofile then
		playerprofile:AddUserId(player.UserId) -- GDPR Compliance
		playerprofile:Reconcile() -- putting all missing template values into player data

		playerprofile:ListenToRelease(function()
			Profiles[player] = nil
			-- The profile could've been loaded on another Roblox server:
			player:Kick("Couldn't find your data : PlayerAdded_2")
		end)

		if player:IsDescendantOf(Players) == true then
			Profiles[player] = playerprofile
			module.LoadData(player)
		else
			playerprofile:Release()
		end

		player.CharacterAdded:Connect(function(character)
			onCharacterAdded(player, character)
		end)
		if player.Character then
			onCharacterAdded(player, player.Character)
		end
	end
end

-----Module For PlayerLeaving-----------
function module.PlayerLeaving(player)
	local playerprofile = Profiles[player]

	if playerprofile then
		module.SaveData(player)
		---release the profile so other games can load it
		playerprofile:Release()
	end
end

-----Module To Save Pets And Money------
function module.SaveData(player)
	local profile = Profiles[player]

	------Save Leaderstats Area--------
	local leaderstats = player:WaitForChild("leaderstats")
	local Wins = leaderstats:WaitForChild("Wins")
	local FartRebirths = leaderstats:WaitForChild("FartRebirths")
	local FartPower = leaderstats:WaitForChild("FartPower")

	profile.Data.Wins = Wins.Value
	profile.Data.FartRebirths = FartRebirths.Value
	profile.Data.FartPower = FartPower.Value

	------Save Pets Area------------------------
	local Pets = player:WaitForChild("Pets")
	local Data = player:WaitForChild("Data")

	local PetData = {}
	local PlayerData = {}

	for i, PetObject in pairs(Pets:GetChildren()) do
		PetData[#PetData + 1] = {

			Name = PetObject.Name,
			TotalXP = PetObject.TotalXP.Value,
			Equipped = PetObject.Equipped.Value,
			PetID = PetObject.PetID.Value,
			Multiplier1 = PetObject.Multiplier1.Value,
			Multiplier2 = PetObject.Multiplier2.Value,
			Type = PetObject.Type.Value,
		}
	end

	for i, DataValue in pairs(Data:GetChildren()) do
		PlayerData[#PlayerData + 1] = {

			Name = DataValue.Name,
			ClassName = DataValue.ClassName,
			Value = DataValue.Value,
		}
	end

	profile.Data.PetTable.PetData = PetData --- Saves the Pet Data
	profile.Data.PetTable.PlayerData = PlayerData --- Saves the Player Data
end

-----Module For Loading the Data Saved------
function module.LoadData(player)
	local profileplayer = Profiles[player]

	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local FartPower = Instance.new("IntValue")
	FartPower.Name = "FartPower"
	FartPower.Value = profileplayer.Data.FartPower
	FartPower.Parent = leaderstats

	local Wins = Instance.new("IntValue")
	Wins.Name = "Wins"
	Wins.Value = profileplayer.Data.Wins
	Wins.Parent = leaderstats

	local FartRebirths = Instance.new("NumberValue")
	FartRebirths.Name = "FartRebirths"
	FartRebirths.Value = profileplayer.Data.FartRebirths
	FartRebirths.Parent = leaderstats

	local FartIncrease = Instance.new("IntValue")
	FartIncrease.Name = "FartIncrease"
	FartIncrease.Value = 0
	FartIncrease.Parent = player

	local Multiplier = Instance.new("IntValue")
	Multiplier.Name = "Multiplier"
	Multiplier.Value = 0
	Multiplier.Parent = player

	local OwnsX2Wins = GamepassesModule:CheckIfPlayerOwnsGamepass(player, "x2 Wins")
	local OwnsX2FartPower = GamepassesModule:CheckIfPlayerOwnsGamepass(player, "x2 Fart Power")

	-----**Add JumpPower To Player's Humanoid**-----
	AddJumpPower(player, FartPower, FartRebirths, FartIncrease, Wins, OwnsX2FartPower, OwnsX2Wins)

	-----**Detects When Character Is Added**-----
	-- player.CharacterAdded:Connect(function(character)

	-- end)

	local Pets = Instance.new("Folder")
	Pets.Name = "Pets"
	Pets.Parent = player

	local Data = Instance.new("Folder")
	Data.Name = "Data"
	Data.Parent = player

	local DataTemplate = PetDataFolder.Data
	local PetsTemplate = PetDataFolder.Pets

	if profileplayer ~= nil then
		-----Load Pets Data---------

		local PetData = profileplayer.Data.PetTable.PetData
		local PlayerData = profileplayer.Data.PetTable.PlayerData

		if PetData ~= nil then
			for i, v in pairs(PetData) do
				local PetObject = ReplicatedStorage.Pets.PetFolderTemplate:Clone()
				local Settings = ReplicatedStorage.Pets.Models:FindFirstChild(v.Name).Settings
				local TypeNumber = ReplicatedStorage.Pets.CraftingTiers:FindFirstChild(v.Type).Value
				local Level = getLevel(v.TotalXP)

				PetObject.Name = v.Name
				PetObject.Equipped.Value = v.Equipped
				PetObject.TotalXP.Value = v.TotalXP
				PetObject.Multiplier1.Value = Settings.Multiplier1.Value
						* (ReplicatedStorage.Pets.Settings.CraftMultiplier.Value ^ TypeNumber)
					+ (Settings.LevelIncrement.Value * Level)
				PetObject.Multiplier2.Value = Settings.Multiplier2.Value
						* (ReplicatedStorage.Pets.Settings.CraftMultiplier.Value ^ TypeNumber)
					+ (Settings.LevelIncrement.Value * Level)
				PetObject.PetID.Value = v.PetID
				PetObject.Type.Value = v.Type
				PetObject.Parent = Pets
			end
		end

		for i, v in pairs(DataTemplate:GetChildren()) do
			local DataValue = v:Clone()
			local DataTable = nil

			DataValue.Parent = Data

			if PlayerData ~= nil then
				for i, v in pairs(PlayerData) do
					if v.Name == DataValue.Name then
						DataTable = v
					end
				end
			end

			if DataTable ~= nil then
				if DataValue.Name == "MaxStorage" or v.Name == "MaxEquipped" then
					DataValue.Value = ReplicatedStorage.Pets.Settings:FindFirstChild("Default" .. DataValue.Name).Value
				else
					DataValue.Value = DataTable.Value
				end
			else
				if DataValue.Name == "MaxStorage" or v.Name == "MaxEquipped" then
					DataValue.Value = ReplicatedStorage.Pets.Settings:FindFirstChild("Default" .. DataValue.Name).Value
				end
			end
		end
	else
		for i, v in pairs(DataTemplate:GetChildren()) do
			local DataValue = v:Clone()
			DataValue.Parent = Data
			if DataValue.Name == "MaxStorage" or v.Name == "MaxEquipped" then
				DataValue.Value = ReplicatedStorage.Pets.Settings:FindFirstChild("Default" .. DataValue.Name).Value
			end
		end
		return true
	end
end

return module
