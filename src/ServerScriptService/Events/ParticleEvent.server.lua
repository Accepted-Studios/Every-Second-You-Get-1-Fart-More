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
		if not HumanoidRootPart:FindFirstChild("FartGas") then
			local FartGasClone = FartGas:Clone()
			FartGasClone.Parent = HumanoidRootPart
		end
	elseif State == "Land" then
		local NewFartGas = HumanoidRootPart:FindFirstChild("FartGas")
		if not NewFartGas then
			return
		end
		if not table.find(PlayerDebounce, player) then --- If player is not in debounce table, add them to the table and wait for cooldown
			table.insert(PlayerDebounce, player)
			task.wait(Cooldown)
			table.remove(PlayerDebounce, table.find(PlayerDebounce, player))
			NewFartGas:Destroy()
		end
	end
end)
