---------Services-------
local Players = game:GetService("Players")

---------Variables-------
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local ButtonsGui = PlayerGui:WaitForChild("ButtonsGui")
local ButtonFrame = ButtonsGui:WaitForChild("ButtonFrame")
local RebirthButton = ButtonFrame:WaitForChild("Rebirth")

---------Functions-------
RebirthButton.MouseButton1Click:Connect(function()
	--Open Rebirth Gui
	local RebirthGui = PlayerGui:WaitForChild("RebirthGui")
	RebirthGui.Enabled = true
end)

------**TODO: Write a more faster/efficent/easier to Open Gui system**------
