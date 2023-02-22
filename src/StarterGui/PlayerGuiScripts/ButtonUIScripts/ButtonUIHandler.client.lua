---------Services-------
local Players = game:GetService("Players")

---------Variables-------
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local ButtonsGui = PlayerGui:WaitForChild("ButtonsGui")
local ButtonFrame = ButtonsGui:WaitForChild("ButtonFrame")
local RebirthButton = ButtonFrame:WaitForChild("Rebirth")
local TeleportButton = ButtonFrame:WaitForChild("Teleport")

---------Functions-------
---Open Rebirth Gui---
RebirthButton.MouseButton1Click:Connect(function()
	--Open Rebirth Gui
	local RebirthGui = PlayerGui:WaitForChild("RebirthGui")
	RebirthGui.Enabled = true
end)

---Open Teleport Gui---
TeleportButton.MouseButton1Click:Connect(function()
	--Open Teleport Gui
	local TeleportGui = PlayerGui:WaitForChild("TeleportGui")
	TeleportGui.Enabled = true
end)

------**TODO: Write a more faster/efficent/easier to Open Gui system**------
