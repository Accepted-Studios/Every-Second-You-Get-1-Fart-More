----------Services------
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

----------Variables------
local Player = Players.LocalPlayer
local Wins = Player:WaitForChild("leaderstats"):WaitForChild("Wins")
local PlayerGui = Player:WaitForChild("PlayerGui")
local TeleportGui = PlayerGui:WaitForChild("TeleportGui")
local TeleportFrame = TeleportGui:WaitForChild("TeleportFrame")
local ExitBtn = TeleportFrame:WaitForChild("Exit")

local ScrollingFrame = TeleportFrame:WaitForChild("Frame")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local CheckWinsFunction = Remotes:WaitForChild("CheckWins")

----------Functions------
-----**Click the Exit Button**-----
ExitBtn.MouseButton1Click:Connect(function()
	TeleportGui.Enabled = false
end)

-----**Check if the player has enough money to unlock the teleport-----
local function CheckMoney()
	for i, Frame in pairs(ScrollingFrame:GetChildren()) do
		if Frame:IsA("Frame") then
			----Randomize the Frame's BackgroundColor3----
			local RandomColor = Color3.fromHSV(math.random(), 1, 1)
			Frame.BackgroundColor3 = RandomColor

			---Check if the Frame has a WinsAmount value----
			local WinsAmount = Frame:FindFirstChild("WinsAmount")
			if not WinsAmount then
				return
			end

			----Check if the Frame has a BtnFrame----
			local BtnFrame = Frame:WaitForChild("BtnFrame")
			local LockedButton = BtnFrame:FindFirstChild("Locked")
			local TeleportButton = BtnFrame:FindFirstChild("Teleport")

			----Check if the player has enough money to unlock the teleport----

			local Bought = CheckWinsFunction:InvokeServer(WinsAmount.Value)
			if Bought then
				LockedButton.Visible = false
				TeleportButton.Visible = true
			else
				LockedButton.Visible = true
				LockedButton.Text = "Unlock with " .. WinsAmount.Value .. " Wins"
				TeleportButton.Visible = false
			end

			----Script the Teleport Button----
			TeleportButton.MouseButton1Click:Connect(function()
				for i2, TeleportPart in pairs(CollectionService:GetTagged("TeleportAreas")) do
					if TeleportPart.Name == Frame.Name then
						Player.Character:PivotTo(TeleportPart.CFrame)
					end
				end
			end)
		end
	end
end

-----**Contantly check if the player has enough money to unlock the teleport-----
CheckMoney()
Wins.Changed:Connect(function()
	CheckMoney()
end)
