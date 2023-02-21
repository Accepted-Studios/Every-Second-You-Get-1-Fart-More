--------Services------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

--------Variables------
local MonetisationFolder = ReplicatedStorage:WaitForChild("Monetization")
local DevProducts = require(MonetisationFolder:WaitForChild("DevProducts"))

------Nuke Variables-----
local NukeFolder = ReplicatedStorage:WaitForChild("NukeFolder")
local NukeRemoteEvent = NukeFolder:WaitForChild("NukeRemoteEvent")
local isNuking = NukeFolder:WaitForChild("IsNuking")

-----**Process Receipt Function When Player Purchases DevProduct**-----
MarketplaceService.ProcessReceipt = function(ReceiptInfo)
	local ProductId = ReceiptInfo.ProductId
	local Player = Players:GetPlayerFromUserId(ReceiptInfo.PlayerId)
	local ProductInfoTable = DevProducts:GetProductInfoTableByProductId(ProductId)
	if ProductInfoTable then
		-- If ProductInfoTable.Type is Wins
		if ProductInfoTable.Type == "Wins" then
			local Wins = Player:WaitForChild("leaderstats"):WaitForChild("Wins")
			Wins.Value = Wins.Value + ProductInfoTable.Value
			return Enum.ProductPurchaseDecision.PurchaseGranted

			---If ProductInfoTable.Type is FartPower
		elseif ProductInfoTable.Type == "FartPower" then
			local FartPower = Player:WaitForChild("leaderstats"):WaitForChild("FartPower")
			FartPower.Value = FartPower.Value + ProductInfoTable.Value
			return Enum.ProductPurchaseDecision.PurchaseGranted

			---If ProductInfoTable.Type is FartIncrease
		elseif ProductInfoTable.Type == "FartIncrease" then
			local FartIncrease = Player:WaitForChild("leaderstats"):WaitForChild("FartIncrease")
			FartIncrease.Value = FartIncrease.Value + ProductInfoTable.Value
			return Enum.ProductPurchaseDecision.PurchaseGranted

			---If ProductInfoTable.Type is Nuke
		elseif ProductInfoTable.Type == "Nuke" then
			-----If Nuke is already in progress, return Enum.ProductPurchaseDecision.NotProcessedYet----
			if isNuking.Value == true then
				return Enum.ProductPurchaseDecision.NotProcessedYet
			else
				-----If Nuke is not in progress, set isNuking to true and  the Nuke Function-----
				isNuking.Value = true

				NukeRemoteEvent:FireAllClients("nuke message", Player.Name .. " has launched a nuke!")

				local alarmSound = NukeFolder.AlarmSound:Clone()
				alarmSound.Parent = workspace
				alarmSound.Looped = true
				alarmSound:Play()

				task.wait(8)

				local nuke = NukeFolder:WaitForChild("Nuke"):Clone()

				local nukeSound = NukeFolder.NukeSound:Clone()
				nukeSound.Parent = nuke
				nukeSound.Looped = true
				nukeSound:Play()

				local LandingPart = workspace:WaitForChild("Maps"):WaitForChild("Map1"):WaitForChild("MainLobbyFloor")
				if not LandingPart then
					return warn("Error, can't find land")
				end
				nuke.Position = LandingPart.Position + Vector3.new(0, nuke.Size.Y * 5, 0)
				nuke.Anchored = true
				nuke.Parent = workspace

				local nukeTweenInfo = TweenInfo.new(8, Enum.EasingStyle.Linear)
				local nukeTween = TweenService:Create(
					nuke,
					nukeTweenInfo,
					{ Position = LandingPart.Position + Vector3.new(0, nuke.Size.Y / 2 + 7, 0) }
				)
				nukeTween:Play()

				nukeTween.Completed:Wait()
				nuke:Destroy()

				NukeRemoteEvent:FireAllClients("shake camera")

				local explosionPart = NukeFolder.ExplosionPart:Clone()
				explosionPart.Anchored = true
				explosionPart.CanCollide = false
				explosionPart.Size = Vector3.new(0, 0, 0)
				explosionPart.Position = LandingPart.Position
				explosionPart.Parent = workspace

				local explosionSound = NukeFolder.ExplosionSound:Clone()
				explosionSound.Parent = explosionPart
				explosionSound:Play()

				local oldRespawnTime = game.Players.RespawnTime
				game.Players.RespawnTime = explosionSound.TimeLength

				local explosionTweenInfo = TweenInfo.new(explosionSound.TimeLength, Enum.EasingStyle.Linear)
				local explosionTween = TweenService:Create(
					explosionPart,
					explosionTweenInfo,
					{ Size = Vector3.new(LandingPart.Size.X, LandingPart.Size.X, LandingPart.Size.X) }
				)
				explosionTween:Play()

				for i, player in pairs(game.Players:GetPlayers()) do
					local char = player.Character
					if char then
						local distance = (char.HumanoidRootPart.Position - explosionPart.Position).Magnitude

						task.spawn(function()
							repeat
								task.wait(0.2)
							until explosionPart.Size.X / 2 >= distance - 30

							NukeRemoteEvent:FireClient(player, "lighting effect")

							task.wait(1)
							char.Humanoid.Health = 0
						end)
					end
				end

				explosionSound.Ended:Wait()

				Players.RespawnTime = oldRespawnTime
				alarmSound:Destroy()
				explosionPart:Destroy()

				task.wait(5)

				isNuking.Value = false
				return Enum.ProductPurchaseDecision.PurchaseGranted
			end
		end
	end
end
