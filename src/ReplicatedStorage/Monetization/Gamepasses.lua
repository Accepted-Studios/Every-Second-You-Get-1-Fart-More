---@diagnostic disable: unused-local
------Services----
local MarketplaceService = game:GetService("MarketplaceService")

---**Compare Words Function To Check If They Are the Same**---
local function CompareWords(Name1, Name2)
	local FilteredName1 = string.lower(Name1:gsub("%s+", "")) --Remove Spaces and make lowerspace
	local FilteredName2 = string.lower(Name2:gsub("%s+", "")) --Remove Spaces and make lowerspace
	if FilteredName1 == FilteredName2 then --If Names Are The Same
		return true --Return True
	else
		return false --Return False
	end
end

------*Module------
local Gamepasses = {}
Gamepasses.__index = Gamepasses

Gamepasses.GamepassesTable = {
	{ Name = "x2 FartPower", GamepassId = "123456789", Type = "x2 FartPower" },
	{ Name = "x2 Wins", GamepassId = "123456789", Type = "x2 Wins" },
}

-----**Function To Get GamepassId by Name-----
function Gamepasses:GetGamepassId(GamepassName)
	for i, Gamepass in pairs(self.GamepassesTable) do --- Loop through GamepassesTable
		if CompareWords(Gamepass.Name, GamepassName) then --- If GamepassName is the same as Gamepass.Name
			return Gamepass.GamepassId --- Return GamepassId
		end
	end
end

------** Checks if player Owns Gamepass----
function Gamepasses:CheckIfPlayerOwnsGamepass(player, GamepassName)
	local GamepassId = self:GetGamepassId(GamepassName) --- Get GamepassId by Name
	local hasPass, expiration = MarketplaceService:UserOwnsGamePassAsync(player.UserId, GamepassId) --- Check if player owns gamepass
	if hasPass then --- If player owns gamepass
		return true --- Return true
	else
		return false --- Return false
	end
end

return Gamepasses
