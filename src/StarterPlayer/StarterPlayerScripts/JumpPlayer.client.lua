-------Services----------
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

------Variables------
local Player = Players.LocalPlayer
local character = Player.Character or Player.CharacterAdded:Wait()
local PlayerGui = Player:WaitForChild("PlayerGui")

-----Debounces and Events-----
local isJumping = false
local ParticleEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ParticleEvent")

local humanoid = character:WaitForChild("Humanoid")

------**Listen to Humanoid State Changed to detect when the player is jumping or landing------
local function onStateChanged(_oldState, newState)
	if newState == Enum.HumanoidStateType.Jumping then
		if not isJumping then
			isJumping = true
			ParticleEvent:FireServer("Jump")
		end
	elseif newState == Enum.HumanoidStateType.Landed then
		if isJumping then
			isJumping = false
			ParticleEvent:FireServer("Land")
		end
	end
end

humanoid.StateChanged:Connect(onStateChanged)

-----**TODO: Change ParticleEvent to BridgeNetV2 For Faster Signal**-----
