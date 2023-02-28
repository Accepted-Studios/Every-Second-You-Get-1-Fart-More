---------Services-------
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")

---------Variables-------
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local ButtonsGui = PlayerGui:WaitForChild("ButtonsGui")
local ButtonFrame = ButtonsGui:WaitForChild("ButtonFrame")
local RebirthButton = ButtonFrame:WaitForChild("Rebirth")
local TeleportButton = ButtonFrame:WaitForChild("Teleport")
local X2WinsButton = ButtonFrame:WaitForChild("X2 Wins")
local X2FartPowerButton = ButtonFrame:WaitForChild("X2 Fart Power")
local PetsButton = ButtonFrame:WaitForChild("Pets")

local RemotesFolder = ReplicatedStorage:WaitForChild("Remotes")
local GetMonetizedFunction = RemotesFolder:WaitForChild("GetMonetized")

---------Functions----------
---**Open Rebirth Gui---
RebirthButton.MouseButton1Click:Connect(function()
	--Open Rebirth Gui
	local RebirthGui = PlayerGui:WaitForChild("RebirthGui")
	RebirthGui.Enabled = true
end)

---**Open Teleport Gui---
TeleportButton.MouseButton1Click:Connect(function()
	--Open Teleport Gui
	local TeleportGui = PlayerGui:WaitForChild("TeleportGui")
	TeleportGui.Enabled = true
end)

----**Prompt Player To Buy X2 Wins----
X2WinsButton.MouseButton1Click:Connect(function()
	local GamepassId = GetMonetizedFunction:InvokeServer("Gamepasses", "GetGamepassId", X2WinsButton.Name)
	if not GamepassId then
		warn("GamepassId not found for gamepass: " .. X2WinsButton.Name)
		return
	end
	MarketplaceService:PromptGamePassPurchase(Player, GamepassId)
end)

----**Prompt Player To Buy X2 Fart Power----
X2FartPowerButton.MouseButton1Click:Connect(function()
	local GamepassId = GetMonetizedFunction:InvokeServer("Gamepasses", "GetGamepassId", X2FartPowerButton.Name)
	if not GamepassId then
		warn("GamepassId not found for gamepass: " .. X2FartPowerButton.Name)
		return
	end
	MarketplaceService:PromptGamePassPurchase(Player, GamepassId)
end)

----**Open Pets Gui----
PetsButton.MouseButton1Click:Connect(function()
	local PetMainGui = PlayerGui:WaitForChild("PetMain")
	local PetInventory = PetMainGui:WaitForChild("PetInventory")

	PetInventory.Visible = not PetInventory.Visible
end)

------**TODO: Write a more faster/efficent/easier to Open Gui system**------
