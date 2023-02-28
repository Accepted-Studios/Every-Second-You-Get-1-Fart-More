----------Services----------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

----------Variables----------
local RemotesFolder = ReplicatedStorage:WaitForChild("Remotes")
local GetMonetizedFunction = RemotesFolder:WaitForChild("GetMonetized")

local MonetizationFolder = ServerStorage:WaitForChild("Monetization")
local DevProductsModule = require(MonetizationFolder:WaitForChild("DevProducts"))
local GamepassModule = require(MonetizationFolder:WaitForChild("Gamepasses"))

----------Functions----------
GetMonetizedFunction.OnServerInvoke = function(Player, Module, ModuleFunction, ...)
	if Module == "DevProducts" then
		return DevProductsModule[ModuleFunction](DevProductsModule, ...)
	elseif Module == "Gamepasses" then
		return GamepassModule[ModuleFunction](GamepassModule, ...)
	end
end
