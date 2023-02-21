-----Services-------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

-----Variables------
local PlayerDebounce = {}
local Cooldown = 2
local ParticleEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ParticleEvent")
local EmittersFolder = ServerStorage:WaitForChild("Emitters")
local FartGas = EmittersFolder:WaitForChild("FartGas")

-----**Once ParicleEvent is fired, attach the particle effect to player**-----
ParticleEvent.OnServerEvent:Connect(function(player, State)
	local character = player.Character or player.CharacterAdded:Wait()
	local HumanoidRootPart = character:WaitForChild("HumanoidRootPart") or character.PrimaryPart

	if State == "Jump" then
		local FartGasClone = FartGas:Clone()
		FartGasClone.Parent = HumanoidRootPart
	elseif State == "Land" then
		local FartGas = HumanoidRootPart:FindFirstChild("FartGas")
		if not FartGas then
			return
		end
		if not table.find(PlayerDebounce, player) then --- If player is not in debounce table, add them to the table and wait for cooldown
			table.insert(PlayerDebounce, player)
			task.wait(Cooldown)
			FartGas:Destroy()
		end
	end
end)
