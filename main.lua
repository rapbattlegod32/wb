local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))() 

local Window = Rayfield:CreateWindow({
   Name = "Westbridge Script",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "giga.ae Hub",
   LoadingSubtitle = "by giga.ae",
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "giga.aeHub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "e3knAyNqvR", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

-- main tab
local MainTab = Window:CreateTab("🏡 Home", nil) -- Title, Image
local MainSection = MainTab:CreateSection("Information")

-- money statistic
local guimoney = game:GetService("Players").LocalPlayer.PlayerGui.GameUI.GameUIContainer.Balance
local moneylabel = MainTab:CreateLabel(guimoney.Text, "pound-sterling", false) -- Title, Icon, Color, IgnoreTheme
guimoney:GetPropertyChangedSignal("Text"):Connect(function()
    moneylabel:Set(guimoney.Text, "pound-sterling", false) -- Title, Icon, Color, IgnoreTheme
end)

-- health
local healthbar = game:GetService("Players").LocalPlayer.PlayerGui.GameUI.GameUIContainer.HealthBar.Bar
local healthbar_size = math.floor(healthbar.Size.X.Scale * 100) -- Convert to whole number
local formatted_health = string.format("%03d", healthbar_size) -- Format as 3-digit
local healthlabel = MainTab:CreateLabel(formatted_health, "heart-pulse", false) -- Title, Icon, Color, IgnoreTheme
healthbar:GetPropertyChangedSignal("Size"):Connect(function()
    local healthbar_size = math.floor(healthbar.Size.X.Scale * 100)
    local formatted_health = string.format("%03d", healthbar_size)
    healthlabel:Set(formatted_health, "heart-pulse", false)
end)

-- hunger
local hungerbar = game:GetService("Players").LocalPlayer.PlayerGui.GameUI.GameUIContainer.HungerBar.Bar
local hungerbar_size = math.floor(hungerbar.Size.X.Scale * 100) -- Convert to whole number
local formatted_hunger = string.format("%03d", hungerbar_size) -- Format as 3-digit
local hungerlabel = MainTab:CreateLabel(formatted_hunger, "utensils", false) -- Title, Icon, Color, IgnoreTheme
hungerbar:GetPropertyChangedSignal("Size"):Connect(function()
    local hungerbar_size = math.floor(hungerbar.Size.X.Scale * 100)
    local formatted_hunger = string.format("%03d", hungerbar_size)
    hungerlabel:Set(formatted_hunger, "utensils", false)
end)

-- team
local team = game:GetService("Players").LocalPlayer.PlayerGui.GameUI.GameUIContainer.Profile.Team
local teamlabel = MainTab:CreateLabel(team.Text, "users-round", false)
team:GetPropertyChangedSignal("Text"):Connect(function()
    teamlabel:Set(team.Text, "users-round", false) -- Title, Icon, Color, IgnoreTheme
end)

local Divider = MainTab:CreateDivider()

-- Get the Players service
local Players = game:GetService("Players")

-- Initial player count
local playerCount = #Players:GetPlayers()
local playercountlabel = MainTab:CreateLabel(tostring(playerCount), "server", false)

-- Function to update player count
local function updatePlayerCount()
    local playerCount = #game.Players:GetPlayers()
    playercountlabel:Set(tostring(playerCount), "server", false)
end

updatePlayerCount()
game.Players.PlayerAdded:Connect(updatePlayerCount)
game.Players.PlayerRemoving:Connect(updatePlayerCount)

-- police and admin online
local Teams = game:GetService("Teams") -- Define the Teams Service

-- Initialize teamcountlabel
local teamcountlabel = MainTab:CreateLabel("Initializing...", "scroll-text", false)

local function updateTeamCounts()
    local civTeam = Teams["Civilian"]:GetPlayers()
    local royalMilitaryPoliceTeam = Teams["Royal Military Police"]:GetPlayers()
    local westbridgeBouroughCouncilTeam = Teams["Westbridge Borough Council"]:GetPlayers()
    local metropolitanPoliceServiceTeam = Teams["Metropolitan Police Service"]:GetPlayers()
    local britishArmedForcesTeam = Teams["British Armed Forces"]:GetPlayers()
    local londonAmbulanceServiceTeam = Teams["London Ambulance Service"]:GetPlayers()
    local londonFireBrigadeTeam = Teams["London Fire Brigade"]:GetPlayers()
    local racTeam = Teams["RAC"]:GetPlayers()
    local aATeam = Teams["Automobile Association"]:GetPlayers()
    local jackboysTeam = Teams["Jackboys"]:GetPlayers()

    local totalRepairTeam = #jackboysTeam + #aATeam + #racTeam
    local totalPoliceTeam = #metropolitanPoliceServiceTeam + #royalMilitaryPoliceTeam 

    local teamString = "Civilians: " .. #civTeam ..
                       " | Police: " .. totalPoliceTeam ..
                       " | Ambulance: " .. #londonAmbulanceServiceTeam ..
                       " | Fire: " .. #londonFireBrigadeTeam ..
                       " | Repair: " .. totalRepairTeam

    teamcountlabel:Set(teamString, "scroll-text", false)
end

updateTeamCounts()
game.Players.PlayerAdded:Connect(updateTeamCounts)
game.Players.PlayerRemoving:Connect(updateTeamCounts)

-- admin online
local Players = game:GetService("Players")

-- modulescript with admin ids
local adminIds_path = game:GetService("ReplicatedStorage").Config.Admins
local adminIdArray = require(adminIds_path)

local adminInfo = {}
local adminsonline = 0
local adminsoffline = 0

-- Create the admin online label
local adminonlinestring = "Administrators: " .. adminsonline
local adminonlinelabel = MainTab:CreateLabel(adminonlinestring, "shield-half", false) -- Title, Icon, Color, IgnoreTheme

-- Function to update the admin counts and info
local function updateAdminCounts()
    adminsonline = 0
    adminsoffline = 0
    for _, userId in ipairs(adminIdArray) do
        local isInGame = false
        for _, player in ipairs(Players:GetPlayers()) do
            if player.UserId == userId then
                isInGame = true
                break
            end
        end

        -- Update the admin info
        if adminInfo[userId] then
            adminInfo[userId].InGame = isInGame
        else
            local success, username = pcall(function()
                return Players:GetNameFromUserIdAsync(userId)
            end)

            if success then
                adminInfo[userId] = {Name = username, InGame = isInGame}
            else
                warn("Failed to get name for ID:", userId)
            end
        end

        -- Update counters
        if isInGame then
            adminsonline = adminsonline + 1
        else
            adminsoffline = adminsoffline + 1
        end
    end

    -- Update the admin online label
    local adminonlinestring = "Administrators: " .. adminsonline
    adminonlinelabel:Set(adminonlinestring, "shield-half", false)
end

-- Initial update when script starts
updateAdminCounts()

-- Listen for changes in player status (player entering and leaving)
Players.PlayerAdded:Connect(function(player)
    -- Only update if the player is an admin
    if table.find(adminIdArray, player.UserId) then
        updateAdminCounts()
    end
end)

Players.PlayerRemoving:Connect(function(player)
    -- Only update if the player is an admin
    if table.find(adminIdArray, player.UserId) then
        updateAdminCounts()
    end
end)

-- vehicle tab
local VehicleTab = Window:CreateTab("🚗 Vehicle")
local VehicleFuel = VehicleTab:CreateSection("⛽ Fuel")

local addFuelButton = SystemTab:CreateButton({
    Name = "Add Fuel",
    Callback = function()
        Rayfield:Destroy()
    end,
})

-- system tab
local SystemTab = Window:CreateTab("🖥️ System")
local SystemControls = SystemTab:CreateSection("⚙️ System Controls")

local Button = SystemTab:CreateButton({
    Name = "⚠️ Terminate",
    Callback = function()
        Rayfield:Destroy()
    end,
})