--------Services--------
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")

--------Variables--------
local Player = Players.LocalPlayer
local Wins = Player:WaitForChild("leaderstats"):WaitForChild("Wins")
local PlayerGui = Player:WaitForChild("PlayerGui")
local ToolShop = PlayerGui:WaitForChild("ToolShop")
local Frame = ToolShop:WaitForChild("Frame")
local TemplateLabel = Frame:WaitForChild("TemplateLabel")
local CloseBtn = Frame:WaitForChild("Close")
local ScrollingFrame = Frame:WaitForChild("ScrollingFrame")

------ReplicatedStorage Variables------
local ToolsFolder = ReplicatedStorage:WaitForChild("Tools")
local RemotesFolder = ReplicatedStorage:WaitForChild("Remotes")
local ToolSelectedEvent = RemotesFolder:WaitForChild("ToolSelected")
local GetMonetizedFunction = RemotesFolder:WaitForChild("GetMonetized")

--------Functions--------
for i, Tool in pairs(ToolsFolder:GetChildren()) do
	local ToolCost = Tool:WaitForChild("Cost")

	-----Clone the TemplateLabel and set the properties of the clone-----
	local ToolBtn = TemplateLabel:Clone()
	ToolBtn.Name = Tool.Name
	ToolBtn.Image = Tool.TextureId
	ToolBtn.Price.Text = ToolCost.Value .. " Wins"
	ToolBtn.LayoutOrder = ToolCost.Value
	ToolBtn.Visible = true
	ToolBtn.Parent = ScrollingFrame

	-----If the player has enough wins to buy the tool, then fire the event-----
	local BuyBtn = ToolBtn:WaitForChild("Buy")
	BuyBtn.MouseButton1Click:Connect(function()
		if Wins.Value >= ToolCost.Value then
			ToolSelectedEvent:FireServer(ToolBtn.Name, ToolCost.Value)
		else
			---Prompt a product purchase if the player does not have enough wins----
			local ProductId = GetMonetizedFunction:InvokeServer(
				"DevProducts", -- This is the name of the module in ServerStorage
				"GetNearestProductIdByTypeAndValue", -- This is the name of the function in the module
				"Wins", -- This is the first argument of the function
				Wins.Value, -- This is the second argument of the function
				ToolCost.Value -- This is the third argument of the function
			)

			if ProductId then
				MarketplaceService:PromptProductPurchase(Player, ProductId)
			end
		end
	end)
end

-----**Make the CloseButton work**-----
CloseBtn.MouseButton1Click:Connect(function()
	ToolShop.Enabled = false
end)
