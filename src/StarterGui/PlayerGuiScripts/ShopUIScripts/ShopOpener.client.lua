--------Services------
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")

--------Variables------
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local debounce = false
--------Functions------

----**Use CollectionService to Open Tool Shop and open Trail Shop**----
for i, ShopPart in pairs(CollectionService:GetTagged("OpenShop")) do
	ShopPart.Touched:Connect(function(Hit)
		if not debounce then
			debounce = true
			if Hit.Parent == Player.Character then -- If the player touches the shop part
				local GUIName = string.gsub(ShopPart.Name, "Open", "Shop") -- Get the name of the shop

				local GUI = PlayerGui:FindFirstChild(GUIName) -- Find the shop
				if GUI then -- If the shop exists
					GUI.Enabled = true -- Open the shop
				end
			end
			debounce = false
		end
	end)
end
