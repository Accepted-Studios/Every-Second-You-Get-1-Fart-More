----------Services----------
local CollectionService = game:GetService("CollectionService")
local ServerStorage = game:GetService("ServerStorage")

-------Variables--------
local GameModules = ServerStorage:WaitForChild("GameModules")
local CollectionModule = require(GameModules:WaitForChild("CollectionModule"))
local Spawn = workspace:WaitForChild("SpawnLocation")

-----------Functions-------
------**Check if Object is a WinPads or FartPads Tagged Object**------
local WinPads = CollectionService:GetTagged("WinPads")
local FartPowerPads = CollectionService:GetTagged("FartPowerPads")

for index, Object in pairs(WinPads) do
	local CollectionObject = CollectionModule.new(Object)
	CollectionObject:GetProductId()
end

for index, Object in pairs(FartPowerPads) do
	local CollectionObject = CollectionModule.new(Object)
	CollectionObject:GetProductId()
end

----**Check if Object is a CollectWins Tagged Object Which Gives Player Wins**------
for index, Object in pairs(CollectionService:GetTagged("CollectWins")) do
	local CollectionObject = CollectionModule.new(Object)
	CollectionObject:GiveWins(Spawn)
end
