---Services---
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
		else
			playerprofile:Release()
		end
	else
		player:Kick("Sorry, can't find your data, PlayerAdded_1")
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
	-- local Pets = player.Pets
	-- local Data = player.Data

	-- local PetData = {}
	-- local PlayerData = {}

	-- for i, PetObject in pairs(Pets:GetChildren()) do
	-- 	PetData[#PetData + 1] = {

	-- 		Name = PetObject.Name,
	-- 		TotalXP = PetObject.TotalXP.Value,
	-- 		Equipped = PetObject.Equipped.Value,
	-- 		PetID = PetObject.PetID.Value,
	-- 		Multiplier1 = PetObject.Multiplier1.Value,
	-- 		Multiplier2 = PetObject.Multiplier2.Value,
	-- 		Type = PetObject.Type.Value,
	-- 	}
	-- end

	-- for i, DataValue in pairs(Data:GetChildren()) do
	-- 	PlayerData[#PlayerData + 1] = {

	-- 		Name = DataValue.Name,
	-- 		ClassName = DataValue.ClassName,
	-- 		Value = DataValue.Value,
	-- 	}
	-- end

	-- profile.Data.PetTable.PetData = PetData --- Saves the Pet Data
	-- profile.Data.PetTable.PlayerData = PlayerData --- Saves the Player Data
end

-----Module For Loading the Data Saved------
function module.LoadData(player)
	local profileplayer = Profiles[player]

	-- local Pets = Instance.new("Folder")
	-- Pets.Name = "Pets"
	-- Pets.Parent = player

	-- local Data = Instance.new("Folder")
	-- Data.Name = "Data"
	-- Data.Parent = player

	-- local DataTemplate = script.Parent.PetData.Data
	-- local PetsTemplate = script.Parent.PetData.Pets

	if profileplayer ~= nil then
		-----Load Leaderstats Values-----
		local leaderstats = player:WaitForChild("leaderstats")
		local Wins = leaderstats:WaitForChild("Wins")
		local FartRebirths = leaderstats:WaitForChild("FartRebirths")
		local FartPower = leaderstats:WaitForChild("FartPower")

		Wins.Value = profileplayer.Data.Wins
		FartRebirths.Value = profileplayer.Data.FartRebirths
		FartPower.Value = profileplayer.Data.FartPower

		-----Load Pets Data---------

		-- 	local PetData = profileplayer.Data.PetTable.PetData
		-- 	local PlayerData = profileplayer.Data.PetTable.PlayerData

		-- 	if PetData ~= nil then
		-- 		for i, v in pairs(PetData) do
		-- 			local PetObject = ReplicatedStorage.Pets.PetFolderTemplate:Clone()
		-- 			local Settings = ReplicatedStorage.Pets.Models:FindFirstChild(v.Name).Settings
		-- 			local TypeNumber = ReplicatedStorage.Pets.CraftingTiers:FindFirstChild(v.Type).Value
		-- 			local Level = getLevel(v.TotalXP)

		-- 			PetObject.Name = v.Name
		-- 			PetObject.Equipped.Value = v.Equipped
		-- 			PetObject.TotalXP.Value = v.TotalXP
		-- 			PetObject.Multiplier1.Value = Settings.Multiplier1.Value
		-- 					* (ReplicatedStorage.Pets.Settings.CraftMultiplier.Value ^ TypeNumber)
		-- 				+ (Settings.LevelIncrement.Value * Level)
		-- 			PetObject.Multiplier2.Value = Settings.Multiplier2.Value
		-- 					* (ReplicatedStorage.Pets.Settings.CraftMultiplier.Value ^ TypeNumber)
		-- 				+ (Settings.LevelIncrement.Value * Level)
		-- 			PetObject.PetID.Value = v.PetID
		-- 			PetObject.Type.Value = v.Type
		-- 			PetObject.Parent = Pets
		-- 		end
		-- 	end

		-- 	for i, v in pairs(DataTemplate:GetChildren()) do
		-- 		local DataValue = v:Clone()
		-- 		local DataTable = nil

		-- 		DataValue.Parent = Data

		-- 		if PlayerData ~= nil then
		-- 			for i, v in pairs(PlayerData) do
		-- 				if v.Name == DataValue.Name then
		-- 					DataTable = v
		-- 				end
		-- 			end
		-- 		end

		-- 		if DataTable ~= nil then
		-- 			if DataValue.Name == "MaxStorage" or v.Name == "MaxEquipped" then
		-- 				DataValue.Value = ReplicatedStorage.Pets.Settings:FindFirstChild("Default" .. DataValue.Name).Value
		-- 			else
		-- 				DataValue.Value = DataTable.Value
		-- 			end
		-- 		else
		-- 			if DataValue.Name == "MaxStorage" or v.Name == "MaxEquipped" then
		-- 				DataValue.Value = ReplicatedStorage.Pets.Settings:FindFirstChild("Default" .. DataValue.Name).Value
		-- 			end
		-- 		end
		-- 	end
		-- else
		-- 	for i, v in pairs(DataTemplate:GetChildren()) do
		-- 		local DataValue = v:Clone()
		-- 		DataValue.Parent = Data
		-- 		if DataValue.Name == "MaxStorage" or v.Name == "MaxEquipped" then
		-- 			DataValue.Value = ReplicatedStorage.Pets.Settings:FindFirstChild("Default" .. DataValue.Name).Value
		-- 		end
		-- 	end
	end
end

return module
