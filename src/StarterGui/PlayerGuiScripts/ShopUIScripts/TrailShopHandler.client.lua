---------Services--------
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")

---------Variables--------
local Player = Players.LocalPlayer
local Wins = Player:WaitForChild("leaderstats"):WaitForChild("Wins")
local PlayerGui = Player:WaitForChild("PlayerGui")
local TrailShop = PlayerGui:WaitForChild("TrailShop")
local Frame = TrailShop:WaitForChild("Frame")
local CloseBtn = Frame:WaitForChild("Close")
local ScrollingFrame = Frame:WaitForChild("ScrollingFrame")

local RemotesFolder = ReplicatedStorage:WaitForChild("Remotes")
local TrailSelectedEvent = RemotesFolder:WaitForChild("TrailSelected")
local GetMonetizedFunction = RemotesFolder:WaitForChild("GetMonetized")

---------Functions--------

-----**Loop Through TrailShop and add Trail to Player**-----
for i, TrailBtn in pairs(ScrollingFrame:GetChildren()) do
	if TrailBtn:IsA("ImageLabel") then
		local BuyBtn = TrailBtn:WaitForChild("Buy")
		local Price = TrailBtn:WaitForChild("Price")
		local PriceLabel = TrailBtn:WaitForChild("PriceLabel")

		----Sort the layout order of the trails with the price----
		TrailBtn.LayoutOrder = tonumber(Price.Value)

		----Set the PriceLabel to the price of the trail----
		PriceLabel.Text = Price.Value .. " Wins"

		----If the player has enough wins to buy the trail, then fire the event----
		BuyBtn.MouseButton1Click:Connect(function()
			if Wins.Value >= tonumber(Price.Value) then
				TrailSelectedEvent:FireServer(TrailBtn.Name, Price.Value)
			else
				---Prompt a product purchase if the player does not have enough wins----
				local ProductId = GetMonetizedFunction:InvokeServer(
					"DevProducts", -- This is the name of the module in ServerStorage
					"GetNearestProductIdByTypeAndValue", -- This is the name of the function in the module
					"Wins", -- This is the first argument of the function
					Wins.Value, -- This is the second argument of the function
					Price.Value -- This is the third argument of the function
				)
				if ProductId then
					MarketplaceService:PromptProductPurchase(Player, ProductId)
				end
			end
		end)
	end
end

----**Make the CloseButton work**----
CloseBtn.MouseButton1Click:Connect(function()
	TrailShop.Enabled = false
end)
