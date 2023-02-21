-----This is a funcion that can convert a percentage parameter to a number-----
local function ConvertPercentageToNumber(Percentage)
	local Number = Percentage / 100
	return Number
end

----Modules----
local Transactions = {}

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

return Transactions
