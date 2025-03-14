local Players = game:GetService("Players")

-- modulescript with admin ids
local adminIds_path = game:GetService("ReplicatedStorage").Config.Admins
local adminIdArray = require(adminIds_path)

local adminInfo = {}
local adminsonline = 0
local adminsoffline = 0

for _, userId in ipairs(adminIdArray) do
    local success, username = pcall(function()
        return Players:GetNameFromUserIdAsync(userId)
    end)

    if success then
        -- currently in game checker
        local isInGame = false
        for _, player in ipairs(Players:GetPlayers()) do
            if player.UserId == userId then
                isInGame = true
                break
            end
        end

        -- stores admin info
        adminInfo[userId] = {Name = username, InGame = isInGame}
        
        -- update counters
        if isInGame then
            adminsonline = adminsonline + 1
        else
            adminsoffline = adminsoffline + 1
        end

        print("Admin ID:", userId, "Name:", username, "In Game:", isInGame)
    else
        warn("Failed to get name for ID:", userId)
    end
end

for userId, info in pairs(adminInfo) do
    print("Admin ID:", userId, "-> Name:", info.Name, "-> In Game:", info.InGame)
end

print("Total Admins Online:", adminsonline)
print("Total Admins Offline:", adminsoffline)
