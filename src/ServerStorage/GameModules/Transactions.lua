-----Services-----
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")

-----Variables-----
local MonetisationFolder = ReplicatedStorage:WaitForChild("Monetization")
local GamepassesModule = require(MonetisationFolder.Gamepasses)

----This is a funcion that can convert a percentage parameter to a number-----
local function ConvertPercentageToNumber(Percentage)
	local Number = Percentage / 100
	return Number
end

----Modules----
local Transactions = {}

----**Transaction for Rebirth**----
function Transactions.Rebirth(player, Price)
	local leaderstats = player:WaitForChild("leaderstats")
	local FartPower = leaderstats:WaitForChild("FartPower")
	local FartRebirths = leaderstats:WaitForChild("FartRebirths")
	local Wins = leaderstats:WaitForChild("Wins")

	if Wins.Value >= Price then
		Wins.Value = 0
		FartPower.Value = 0
		FartRebirths.Value = FartRebirths.Value + ConvertPercentageToNumber(Price) -- Rebirths are 25% more powerful
	end
end

-------**Function to Detect if player has bought a gamepass and update stats accordingly**------
MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, gamepassId, purchased)
	if purchased then
		for i, GamepassValue in pairs(GamepassesModule.GamepassesTable) do
			if GamepassValue.GamepassId == gamepassId then
				if not GamepassesModule:CheckIfPlayerOwnsGamepass(player, GamepassValue.Name) then --Check if player owns gamepass
					local leaderstats = player:WaitForChild("leaderstats")
					if GamepassValue.Type == "x2 FartPower" then
						local FartPower = leaderstats:WaitForChild("FartPower")
						FartPower.Value = FartPower.Value * 1 + 2
					else
						if GamepassValue.Type == "x2 Wins" then
							local Wins = leaderstats:WaitForChild("Wins")
							Wins.Value = Wins.Value * 1 + 2
						end
					end
				end
			end
		end
	end
end)

return Transactions
