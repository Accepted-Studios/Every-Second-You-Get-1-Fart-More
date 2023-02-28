-----Services-----
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-----Variables-----
local RemotesFolder = ReplicatedStorage:WaitForChild("Remotes")
local TrailSelectedEvent = RemotesFolder:WaitForChild("TrailSelected")
local TrailsFolder = ReplicatedStorage:WaitForChild("Trails")

-----Functions-----

-----**When TrailSelectedEvent is fired, then run this function**-----
TrailSelectedEvent.OnServerEvent:Connect(function(Player, TrailName, PriceValue)
	local Wins = Player:WaitForChild("leaderstats"):WaitForChild("Wins")

	if Wins.Value >= PriceValue then -- Checks if player has enough wins to buy the trail.
		local Character = Player.Character

		if not Character or not Character:FindFirstChild("HumanoidRootPart") then -- Checks if player has really loaded in yet or if the character exists.
			return
		end

		for i, child in pairs(Character.HumanoidRootPart:GetChildren()) do -- Loops through all children of the HumanoidRootPart.
			if child:IsA("Trail") then
				child:Destroy() -- Check if child being looped is a trail object, if it is we delete it.
			end
		end

		Wins.Value = Wins.Value - PriceValue

		local Trail = TrailsFolder:FindFirstChild(TrailName) -- Finds the trail in the trails folder.

		if Trail then
			local NewTrail = Trail:Clone() -- Makes clone of the trail being equipped.

			----If the humanoidrootpart does not have a trailtop and trailbottom, then create one----
			if not Character.HumanoidRootPart:FindFirstChild("TrailTop") then
				local TrailTop = Instance.new("Attachment")
				TrailTop.Name = "TrailTop"
				TrailTop.Position = Vector3.new(0, 0.766, 0)
				TrailTop.Parent = Character.HumanoidRootPart
			end

			if not Character.HumanoidRootPart:FindFirstChild("TrailBottom") then
				local TrailBottom = Instance.new("Attachment")
				TrailBottom.Name = "TrailBottom"
				TrailBottom.Position = Vector3.new(0, -0.766, 0)
				TrailBottom.Parent = Character.HumanoidRootPart
			end

			----If the humanoidrootpart has a trailtop and trailbottom, then attach the trail to the trailtop and trailbottom----
			if
				Character.HumanoidRootPart:FindFirstChild("TrailTop")
				and Character.HumanoidRootPart:FindFirstChild("TrailBottom")
			then
				NewTrail.Attachment0 = Character.HumanoidRootPart.TrailTop -- Attach to Trailtop.
				NewTrail.Attachment1 = Character.HumanoidRootPart.TrailBottom -- Attach to TrailBottom.
			end

			NewTrail.Parent = Character.HumanoidRootPart -- Parrent New Trail To HumanoidRootPart To Be Seen.
		end
	end
end)
