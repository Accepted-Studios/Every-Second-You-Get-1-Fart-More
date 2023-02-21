---------Services-------
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

---------Variables-------
local Player = Players.LocalPlayer
local FartRebirths = Player:WaitForChild("leaderstats"):WaitForChild("FartRebirths")
local PlayerGui = Player:WaitForChild("PlayerGui")
local RebirthGui = PlayerGui:WaitForChild("RebirthGui")
local Frame = RebirthGui:WaitForChild("Frame")
local ExitBtn = Frame:WaitForChild("Exit")
local UnlockButton = Frame:WaitForChild("UnlockButton")
local RebirthStat = Frame:WaitForChild("RebirthStat")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local TransactionEvent = Remotes:WaitForChild("TransactionEvent")

---------Functions-------
-----**Click the Exit Button**-----
ExitBtn.MouseButton1Click:Connect(function()
	RebirthGui.Enabled = false
end)

-----**Click the Unlock Button To Rebirth**-----
UnlockButton.MouseButton1Click:Connect(function()
	TransactionEvent:FireServer("Rebirth")
end)

-----** Update the Rebirth Button Text **-----
FartRebirths.Changed:Connect(function()
	RebirthStat.Text = "Current Fart Rebirth: " .. FartRebirths.Value .. " FartPower/Second"
end)
