-----Services----------
local Players = game:GetService("Players")

local ServerStorage = game:GetService("ServerStorage")

-------Datastore Variables------
local DatastoreModulesFolder = ServerStorage:WaitForChild("DatastoreModules")
local DataServiceModule = require(DatastoreModulesFolder.DataService)

-----Functions-----

-----** Main Function To Run When Player Joins **-----
local function PlayerJoined(player)
	DataServiceModule.PlayerJoining(player)
end

----**When Player Leaves The Game-------
local function PlayerLeaving(player)
	DataServiceModule.PlayerLeaving(player)
end

------**PlayerAdded Connects to PlayerJoin------
Players.PlayerAdded:Connect(PlayerJoined)

------Loops for Players in the Game-----
for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(PlayerJoined, player)
end

------PlayersRemoving Connects to PlayerLeaving-----
Players.PlayerRemoving:Connect(PlayerLeaving)
