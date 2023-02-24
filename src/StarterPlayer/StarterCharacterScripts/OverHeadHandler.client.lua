---------Services--------
local Players = game:GetService("Players")

-------Variables--------
local Player = Players.LocalPlayer
local leaderstats = Player:WaitForChild("leaderstats")
local FartPower = leaderstats:WaitForChild("FartPower")
local Wins = leaderstats:WaitForChild("Wins")
local Character = script.Parent
local OverHeadGUI = Character:WaitForChild("OverHead")
OverHeadGUI.Adornee = Character:WaitForChild("Head")
local Frame = OverHeadGUI:WaitForChild("Frame")
local FartPowerLabel = Frame:WaitForChild("FartPowerLabel")
local WinsLabel = Frame:WaitForChild("WinsLabel")

-------Functions--------
local function UpdateFartPower()
	FartPowerLabel.Text = "FartPower: " .. FartPower.Value
end

local function UpdateWins()
	WinsLabel.Text = "Wins: " .. Wins.Value
end

-------Connections-------
FartPower.Changed:Connect(UpdateFartPower)
Wins.Changed:Connect(UpdateWins)

-------Main--------
UpdateFartPower()
UpdateWins()
