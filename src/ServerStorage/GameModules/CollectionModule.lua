--------Services--------
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")

-----Variables-----
local MonetisationFolder = ReplicatedStorage:WaitForChild("Monetization")
local DevProducts = require(MonetisationFolder:WaitForChild("DevProducts"))

-------Modules--------
local CollectionModule = {}
CollectionModule.__index = CollectionModule

-----**Constructor**-----
function CollectionModule.new(Object) -- Creates a new table from the object passed in and returns it as self (self is the table)
	local self = setmetatable({}, CollectionModule)
	self.Object = Object
	return self
end

----**Check if Object is a WinPads or FartPads Tagged Object**------
function CollectionModule:DetermineTag()
	local Tags = CollectionService:GetTags(self.Object)
	for index, Tag in pairs(Tags) do
		if Tag == "WinPads" then
			return "Wins"
		elseif Tag == "FartPowerPads" then
			return "FartPower"
		end
	end
end

-----**Get ProductId From DevProducts Module**-----
function CollectionModule:GetProductId()
	local Tag = self:DetermineTag()
	local Value = self.Object.Amount.Value

	local ProductId = DevProducts:GetProductIdByTypeAndValue(Tag, Value)

	if ProductId then
		self:Touch(ProductId)
	end
end

-----**Touch Function**-----
function CollectionModule:Touch(ProductId)
	self.Object.Touched:Connect(function(Hit)
		if Hit.Parent:FindFirstChild("Humanoid") then
			local Player = game.Players:GetPlayerFromCharacter(Hit.Parent)
			if Player then
				MarketplaceService:PromptProductPurchase(Player, ProductId)
			end
		end
	end)
end

-----**Give Wins Function**-----
function CollectionModule:GiveWins(Spawn)
	local debounce = false
	local Wins = self.Object.Amount.Value
	self.Object.Touched:Connect(function(Hit)
		if Hit.Parent:FindFirstChild("Humanoid") then
			if not debounce then
				debounce = true
				local Player = game.Players:GetPlayerFromCharacter(Hit.Parent)
				if Player then
					local leaderstats = Player:WaitForChild("leaderstats")
					leaderstats.Wins.Value = leaderstats.Wins.Value + Wins

					----Teleport Player To Spawn----
					Player.Character.HumanoidRootPart:PivotTo(Spawn.CFrame)
				end
				debounce = false
			end
		end
	end)
end

return CollectionModule
