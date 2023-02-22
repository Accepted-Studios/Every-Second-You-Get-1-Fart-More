------Services---------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

------Variables---------
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local TransactionEvent = Remotes:WaitForChild("TransactionEvent")
local CheckWinsFunction = Remotes:WaitForChild("CheckWins")
local GameModules = ServerStorage:WaitForChild("GameModules")
local Transactions = require(GameModules.Transactions)

------Functions---------
----*Once TransactionEvent is fired, this function will run*----
TransactionEvent.OnServerEvent:Connect(function(player, TransactionType)
	if TransactionType == "Rebirth" then
		--Rebirth the player
		local RebirthPercentage = 25
		Transactions.Rebirth(player, RebirthPercentage)
	end
end)

----*Check if the player has Enough wins*----
CheckWinsFunction.OnServerInvoke = function(player, AmountValue)
	local WinsValue = player.leaderstats.Wins.Value
	if WinsValue >= AmountValue then
		return true
	else
		return false
	end
end
