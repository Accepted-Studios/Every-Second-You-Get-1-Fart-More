-------Services------
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")

-------Variables------
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local ProductsGui = PlayerGui:WaitForChild("ProductsGui")
local MonetisationFolder = ReplicatedStorage:WaitForChild("Monetization")
local DevProducts = require(MonetisationFolder:WaitForChild("DevProducts"))

------**Loop Through the Descendants of the ProductsGui-----
for i, v in pairs(ProductsGui:GetDescendants()) do
	if v:IsA("TextButton") then
		v.MouseButton1Click:Connect(function()
			local ProductId = DevProducts:GetProductId(v.Name) --- Get ProductId from DevProductsModule
			if ProductId then
				MarketplaceService:PromptProductPurchase(LocalPlayer, ProductId) --- Prompt Purchase
			end
		end)
	end
end
