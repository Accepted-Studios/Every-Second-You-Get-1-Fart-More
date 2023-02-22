----Make a Welcome Badge for new players
local BadgeService = game:GetService("BadgeService")
local Players = game:GetService("Players")

local WelcomeBadgeId = 2141410099

Players.PlayerAdded:Connect(function(Player)
	if not BadgeService:UserHasBadgeAsync(Player.UserId, WelcomeBadgeId) then
		BadgeService:AwardBadge(Player.UserId, WelcomeBadgeId)
	end
end)
