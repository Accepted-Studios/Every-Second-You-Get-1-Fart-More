-----------Services--------
local Players = game:GetService("Players")

-----Variables-----
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local TopGui = PlayerGui:WaitForChild("TopGui")
local TopFrame = TopGui:WaitForChild("TopFrame")
local FartTopBar = TopFrame:WaitForChild("FartTopBar")
local WinTopBar = TopFrame:WaitForChild("WinTopBar")
local FartPower = Player:WaitForChild("leaderstats"):WaitForChild("FartPower")
local Wins = Player:WaitForChild("leaderstats"):WaitForChild("Wins")

-----Functions-----
--**Update Fart Power Top Bar----
FartPower.Changed:Connect(function()
	FartTopBar.TextLabel.Text = FartPower.Value
end)

--**Update Wins Top Bar----
Wins.Changed:Connect(function()
	WinTopBar.TextLabel.Text = Wins.Value
end)
