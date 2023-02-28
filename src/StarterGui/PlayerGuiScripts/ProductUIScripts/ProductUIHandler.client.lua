-------Services------
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")

-------Variables------
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local ProductsGui = PlayerGui:WaitForChild("ProductsGui")
local RemotesFolder = ReplicatedStorage:WaitForChild("Remotes")
local GetMonetizedFunction = RemotesFolder:WaitForChild("GetMonetized")

------**Loop Through the Descendants of the ProductsGui-----
for i, v in pairs(ProductsGui:GetDescendants()) do
	if v:IsA("TextButton") then
		v.MouseButton1Click:Connect(function()
			local ProductId = GetMonetizedFunction:InvokeServer(
				"DevProducts", -- This is the name of the module in ServerStorage
				"GetProductId", -- This is the name of the function in the module
				v.Name -- This is the first argument of the function
			)
			if ProductId then
				MarketplaceService:PromptProductPurchase(LocalPlayer, ProductId) --- Prompt Purchase
			end
		end)
	end
end
