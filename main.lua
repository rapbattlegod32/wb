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

-- functions


-- checks if an object called "A-Chassis Interface" is in the PlayerGui folder
-- if player is in vehicle A-Chassis is in PlayerGui and if not there is no A-Chassis
-- no A-Chassis = not in vehicle | A-Chassis = in vehicle
local function checkIfInVehicle()
    local AChassisInterface_Path = game:GetService("Players").LocalPlayer.PlayerGui

    local inVehicle = nil

    if AChassisInterface_Path:FindFirstChild('A-Chassis Interface') then -- in this case true
        inVehicle = true
    else
        inVehicle = false
    end

    return inVehicle
end

local function getVehicleNameAndARV()
    local Player = game:GetService("Players").LocalPlayer
    local name = Player.Name
    local vehiclesFolder = game.Workspace:FindFirstChild("Vehicles")
    local targetOwner = name
    if vehiclesFolder then
        for _, vehicle in pairs(vehiclesFolder:GetChildren()) do
            if vehicle:IsA("Model") then
                local vehicleName = vehicle.Name
                local carBody = vehicle:FindFirstChild("Body")
                local ownerValue = vehicle:FindFirstChild("Owner")
                if ownerValue and ownerValue:IsA("ObjectValue") and ownerValue.Value and ownerValue.Value.Name == targetOwner then
                    print("Vehicle found: " .. vehicle.Name)

                    -- Find a model in the body that begins with "ARV"
                    for _, part in pairs(carBody:GetChildren()) do
                        if part:IsA("Model") and part.Name:sub(1, 3) == "ARV" then
                            print("ARV model found: " .. part.Name)
                            local ARV = part.Name
                            return vehicleName, ARV
                        end
                    end

                    break -- Stop searching once found
                end
            end
        end
    else
        warn("Vehicles folder not found")
    end
    return nil, nil
end

-- main tab
local MainTab = Window:CreateTab("🏡 Home", nil) -- Title, Image
local FinancialInfoSection = MainTab:CreateSection("💸 Financial Info")

-- money label
local guimoney = game:GetService("Players").LocalPlayer.PlayerGui.GameUI.GameUIContainer.Balance
local moneylabel = MainTab:CreateLabel(guimoney.Text, "pound-sterling", false) -- Title, Icon, Color, IgnoreTheme
guimoney:GetPropertyChangedSignal("Text"):Connect(function()
    moneylabel:Set(guimoney.Text, "pound-sterling", false) -- Title, Icon, Color, IgnoreTheme
end)

local StatusInfoSection = MainTab:CreateSection("❤️ Status")
-- health label
local healthbar = game:GetService("Players").LocalPlayer.PlayerGui.GameUI.GameUIContainer.HealthBar.Bar
local healthbar_size = math.floor(healthbar.Size.X.Scale * 100) -- Convert to whole number
local formatted_health = string.format("%03d", healthbar_size) -- Format as 3-digit
local healthlabel = MainTab:CreateLabel(formatted_health, "heart-pulse", false) -- Title, Icon, Color, IgnoreTheme
healthbar:GetPropertyChangedSignal("Size"):Connect(function()
    local healthbar_size = math.floor(healthbar.Size.X.Scale * 100)
    local formatted_health = string.format("%03d", healthbar_size)
    healthlabel:Set(formatted_health, "heart-pulse", false)
end)

-- hunger label
local hungerbar = game:GetService("Players").LocalPlayer.PlayerGui.GameUI.GameUIContainer.HungerBar.Bar
local hungerbar_size = math.floor(hungerbar.Size.X.Scale * 100) -- Convert to whole number
local formatted_hunger = string.format("%03d", hungerbar_size) -- Format as 3-digit
local hungerlabel = MainTab:CreateLabel(formatted_hunger, "utensils", false) -- Title, Icon, Color, IgnoreTheme
hungerbar:GetPropertyChangedSignal("Size"):Connect(function()
    local hungerbar_size = math.floor(hungerbar.Size.X.Scale * 100)
    local formatted_hunger = string.format("%03d", hungerbar_size)
    hungerlabel:Set(formatted_hunger, "utensils", false)
end)

local TeamInfoSection = MainTab:CreateSection("🧑‍💼 Occupation")
-- team label
local team = game:GetService("Players").LocalPlayer.PlayerGui.GameUI.GameUIContainer.Profile.Team
local teamlabel = MainTab:CreateLabel(team.Text, "users-round", false)
team:GetPropertyChangedSignal("Text"):Connect(function()
    teamlabel:Set(team.Text, "users-round", false) -- Title, Icon, Color, IgnoreTheme
end)


local PlayerCountInfoSection = MainTab:CreateSection("🌐 Current Population")
-- player count label
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

-- civ/police/ambulance/fire/repair online label
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

-- administrators online label
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
    local onlineAdmins = {}

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

        -- Update counters and collect online admin names
        if isInGame then
            adminsonline = adminsonline + 1
            table.insert(onlineAdmins, adminInfo[userId].Name)
        else
            adminsoffline = adminsoffline + 1
        end
    end

    -- Update the admin online label
    local adminonlinestring = "Administrators: " .. adminsonline
    if #onlineAdmins > 0 then
        adminonlinestring = adminonlinestring .. " (" .. table.concat(onlineAdmins, ", ") .. ")"
    end
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

local maxFuelButton = VehicleTab:CreateButton({
    Name = "Max Fuel",
    Callback = function()
        local inVehicle = checkIfInVehicle()
        if inVehicle == true then
            local vehicleName, ARV = getVehicleNameAndARV()
            local args = {
                [1] = workspace:WaitForChild("Vehicles"):WaitForChild(vehicleName),
                [2] = workspace:WaitForChild("Vehicles"):WaitForChild(vehicleName):WaitForChild("Body"):WaitForChild(ARV):WaitForChild("VehicleSeat"):WaitForChild("CurrentFuel"),
                [3] = 10
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("StoreFuel"):FireServer(unpack(args))

            Rayfield:Notify({
                Title = "Added Fuel",
                Content = "You have successfully added fuel to your vehicle.",
                Duration = 3.5,
                Image = "fuel",
            })
        elseif inVehicle == false then
            Rayfield:Notify({
                Title = "Not In Vehicle",
                Content = "Get in a vehicle to use this function",
                Duration = 3.5,
                Image = "circle-alert",
             })
        end
    end,
})

local noFuelButton = VehicleTab:CreateButton({
    Name = "No Fuel",
    Callback = function()
        local inVehicle = checkIfInVehicle()
        if inVehicle == true then
            local vehicleName, ARV = getVehicleNameAndARV()
            local args = {
                [1] = workspace:WaitForChild("Vehicles"):WaitForChild(vehicleName),
                [2] = workspace:WaitForChild("Vehicles"):WaitForChild(vehicleName):WaitForChild("Body"):WaitForChild(ARV):WaitForChild("VehicleSeat"):WaitForChild("CurrentFuel"),
                [3] = 0
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("StoreFuel"):FireServer(unpack(args))

            Rayfield:Notify({
                Title = "Removed Fuel",
                Content = "You have successfully removed fuel from your vehicle.",
                Duration = 3.5,
                Image = "fuel",
            })
        elseif inVehicle == false then
            Rayfield:Notify({
                Title = "Not In Vehicle",
                Content = "Get in a vehicle to use this function",
                Duration = 3.5,
                Image = "circle-alert",
             })
        end
    end,
})

local fuelslider = VehicleTab:CreateSlider({
    Name = "🔧 Adjust Fuel",
    Range = {0, 10},
    Increment = 0.1,
    Suffix = "Fuel Level (/10)",
    CurrentValue = 10,
    Flag = "fuelslider", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        local vehicleName, ARV = getVehicleNameAndARV()
        local args = {
            [1] = workspace:WaitForChild("Vehicles"):WaitForChild(vehicleName),
            [2] = workspace:WaitForChild("Vehicles"):WaitForChild(vehicleName):WaitForChild("Body"):WaitForChild(ARV):WaitForChild("VehicleSeat"):WaitForChild("CurrentFuel"),
            [3] = Value
        }
        
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("StoreFuel"):FireServer(unpack(args))
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

-- Development Section
-- I will test functions here
local DevelopmentSection = SystemTab:CreateSection("👨‍💻 Development (Debugging)")

local TestingNotificationLengthSlider = SystemTab:CreateSlider({
    Name = "🎛️ Adjust Notification Length",
    Range = {0, 10},
    Increment = 0.1,
    Suffix = "(Seconds)",
    CurrentValue = 3.5,
    Flag = "DevNotificationLengthSlider", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        getgenv().DevNotificationLengthValue = Value
    end,
 })

local TestingNotificationButton = SystemTab:CreateButton({
    Name = "🔔 Notification",
    Callback = function()
        Rayfield:Notify({
            Title = "Notification",
            Content = "This is a notification",
            Duration = getgenv().DevNotificationLengthValue,
            Image = "bell-ring",
        })
    end,
})

local checkIfInVehicleButton = SystemTab:CreateButton({
    Name = "🚗 Check If In Vehicle",
    Callback = function()
        local inVehicle = checkIfInVehicle()
        if inVehicle == true then
            Rayfield:Notify({
                Title = "Vehicle Status",
                Content = "You are in a vehicle.",
                Duration = 3.5,
                Image = "car",
            })
        elseif inVehicle == false then
            Rayfield:Notify({
                Title = "Vehicle Status",
                Content = "You are not in a vehicle.",
                Duration = 3.5,
                Image = "car",
            })
        end
    end,
})


local GetVehicleButton = SystemTab:CreateButton({
    Name = "📃 Get Current Vehicle Info",
    Callback = function()
        local vehicleName, ARV = getVehicleNameAndARV()
        Rayfield:Notify({
            Title = vehicleName,
            Content = ARV,
            Duration = 3.5,
            Image = "car",
        })
    end,
})