local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()

local Window = Rayfield:CreateWindow({
    Name = "Westbridge Script",
    Icon = 0,
    LoadingTitle = "giga.ae Hub",
    LoadingSubtitle = "by giga.ae",
    Theme = "Default",

    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,

    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "giga.aeHub"
    },

    Discord = {
        Enabled = false,
        Invite = "e3knAyNqvR",
        RememberJoins = true
    },

    KeySystem = false,
    KeySettings = {
        Title = "Untitled",
        Subtitle = "Key System",
        Note = "No method of obtaining the key is provided",
        FileName = "Key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = { "Hello" }
    }
})

-- functions


-- checks if an object called "A-Chassis Interface" is in the PlayerGui folder
-- if player is in vehicle A-Chassis is in PlayerGui and if not there is no A-Chassis
-- no A-Chassis = not in vehicle | A-Chassis = in vehicle
local function checkIfInVehicle()
    local vehicleGui = game:GetService("Players").LocalPlayer.PlayerGui

    local inVehicle = false

    if vehicleGui:FindFirstChild('A-Chassis Interface') or vehicleGui:FindFirstChild('Interface') then -- in this case true
        inVehicle = true
        return inVehicle
    else
        inVehicle = false
        return inVehicle
    end
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

local function doesClientVehicleExist()
    local vehicleName = getVehicleNameAndARV()
    local doesVehicleExist = false
    if vehicleName == nil or false then
        doesVehicleExist = false
        return doesVehicleExist
    else
        doesVehicleExist = true
        return doesVehicleExist
    end
end

local function ClientVehicleExistNotification()
    local doesVehicleExist = doesClientVehicleExist()
    if doesVehicleExist == true then
        Rayfield:Notify({
            Title = "Vehicle Exist Status",
            Content = "You have a vehicle",
            Duration = getgenv().NotificationlengthValue,
            Image = "car",
        })
    elseif doesVehicleExist == false then
        Rayfield:Notify({
            Title = "Vehicle Exist Status",
            Content = "You do not have a vehicle",
            Duration = getgenv().NotificationlengthValue,
            Image = "car",
        })
    end
end

-- main tab
local MainTab = Window:CreateTab("🏡 Home", nil)
local FinancialInfoSection = MainTab:CreateSection("💸 Financial Info")

-- money label
local guimoney = game:GetService("Players").LocalPlayer.PlayerGui.GameUI.GameUIContainer.Balance
local moneylabel = MainTab:CreateLabel(guimoney.Text, "pound-sterling", false)
guimoney:GetPropertyChangedSignal("Text"):Connect(function()
    moneylabel:Set(guimoney.Text, "pound-sterling", false)
end)

local StatusInfoSection = MainTab:CreateSection("❤️ Status")
-- health label
local healthbar = game:GetService("Players").LocalPlayer.PlayerGui.GameUI.GameUIContainer.HealthBar.Bar
local healthbar_size = math.floor(healthbar.Size.X.Scale * 100)
local formatted_health = string.format("%03d", healthbar_size)
local healthlabel = MainTab:CreateLabel(formatted_health, "heart-pulse", false)
healthbar:GetPropertyChangedSignal("Size"):Connect(function()
    local healthbar_size = math.floor(healthbar.Size.X.Scale * 100)
    local formatted_health = string.format("%03d", healthbar_size)
    healthlabel:Set(formatted_health, "heart-pulse", false)
end)

-- hunger label
local hungerbar = game:GetService("Players").LocalPlayer.PlayerGui.GameUI.GameUIContainer.HungerBar.Bar
local hungerbar_size = math.floor(hungerbar.Size.X.Scale * 100)
local formatted_hunger = string.format("%03d", hungerbar_size)
local hungerlabel = MainTab:CreateLabel(formatted_hunger, "utensils", false)
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
    teamlabel:Set(team.Text, "users-round", false)
end)


local PlayerCountInfoSection = MainTab:CreateSection("🌐 Current Population")
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

local Teams = game:GetService("Teams")

-- Initialize teamcountlabel
local teamcountlabel = MainTab:CreateLabel("Initializing...", "scroll-text", false)

local function updateTeamCounts()
    local civTeam = Teams["Civilian"]:GetPlayers()
    local royalMilitaryPoliceTeam = Teams["Royal Military Police"]:GetPlayers()
    local westbridgeBouroughCouncilTeam = Teams["Westbridge Borough Council"]:GetPlayers()
    local metropolitanPoliceServiceTeam = Teams["Metropolitan Police Service"]:GetPlayers()
    local britishArmedForcesTeam = Teams["British Armed Forces"]:GetPlayers()
    local ministryOfDefencePolice = Teams["Ministry of Defence Police"]:GetPlayers()
    local londonAmbulanceServiceTeam = Teams["London Ambulance Service"]:GetPlayers()
    local londonFireBrigadeTeam = Teams["London Fire Brigade"]:GetPlayers()
    local racTeam = Teams["RAC"]:GetPlayers()
    local aATeam = Teams["Automobile Association"]:GetPlayers()
    local jackboysTeam = Teams["Jackboys"]:GetPlayers()

    local totalRepairTeam = #jackboysTeam + #aATeam + #racTeam
    local totalPoliceTeam = #metropolitanPoliceServiceTeam + #royalMilitaryPoliceTeam

    local teamString = "Civilians: " .. #civTeam ..
        " | Police: " ..
        totalPoliceTeam ..
        " (MET: " ..
        #metropolitanPoliceServiceTeam ..
        ", RMP: " .. #royalMilitaryPoliceTeam .. ", MODP: " .. #ministryOfDefencePolice .. ")" ..
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
local adminonlinelabel = MainTab:CreateLabel(adminonlinestring, "shield-half", false)

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
                adminInfo[userId] = { Name = username, InGame = isInGame }
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

local UserTab = Window:CreateTab("👤 User")
local HealthSection = UserTab:CreateSection("❤️ Health") -- health section
local Button = UserTab:CreateButton({
    Name = "💀 Reset",
    Callback = function()
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Reset"):FireServer()
    end,
})
local HungerSection = UserTab:CreateSection("🍽️ Hunger") -- hunger section

local AvatarSection = UserTab:CreateSection("🤵 Avatar") -- hunger section
local MetHelmetButton = UserTab:CreateButton({
    Name = "👮 MET Helmet",
    Callback = function()
        local Players = game:GetService("Players")
        local Workspace = game:GetService("Workspace")

        local Player = Players.LocalPlayer
        local character = Player.Character or Player.CharacterAdded:Wait()

        local user = character:WaitForChild("LeftLowerLeg")
        local MetHelmet = Workspace:FindFirstChild("MET")
        local TargetPart = MetHelmet and MetHelmet:FindFirstChild("Head")

        if TargetPart and user then
            firetouchinterest(user, TargetPart, 0)
            task.wait(0.1)
            firetouchinterest(user, TargetPart, 1)
        end
    end,
})

local RACHelmetButton = UserTab:CreateButton({
    Name = "🛠️ RAC Helmet",
    Callback = function()
        local Players = game:GetService("Players")
        local Workspace = game:GetService("Workspace")

        local Player = Players.LocalPlayer
        local character = Player.Character or Player.CharacterAdded:Wait()

        local user = character:WaitForChild("LeftLowerLeg")
        local targetPosition = Vector3.new(-1787.907470703125, 3.2102112770080566, -956.7196044921875)
        local tolerance = 0.01
        
        local function isClose(a, b, tol)
            return (a - b).Magnitude <= tol
        end
        
        for _, v in pairs(Workspace:GetChildren()) do
            if v.Name == "Helmet" and v:IsA("Model") then
                local success, worldPivot = pcall(function() return v.WorldPivot.Position end)
                if success and isClose(worldPivot, targetPosition, tolerance) then
                    local TargetPart = v:FindFirstChild("Head")
                    if TargetPart and user then
                        firetouchinterest(user, TargetPart, 0)
                        task.wait(0.1)
                        firetouchinterest(user, TargetPart, 1)
                    end
                end
            end
        end
    end,
})

local AAHelmetButton = UserTab:CreateButton({
    Name = "🔧 AA Helmet",
    Callback = function()
        local Players = game:GetService("Players")
        local Workspace = game:GetService("Workspace")

        local Player = Players.LocalPlayer
        local character = Player.Character or Player.CharacterAdded:Wait()

        local user = character:WaitForChild("LeftLowerLeg")
        local targetPosition = Vector3.new(-546.4539184570312, 2.6551926136016846, -419.2319030761719)
        local tolerance = 0.01
        
        local function isClose(a, b, tol)
            return (a - b).Magnitude <= tol
        end
        
        for _, v in pairs(Workspace:GetChildren()) do
            if v.Name == "Helmet" and v:IsA("Model") then
                local success, worldPivot = pcall(function() return v.WorldPivot.Position end)
                if success and isClose(worldPivot, targetPosition, tolerance) then
                    local TargetPart = v:FindFirstChild("Head")
                    if TargetPart and user then
                        firetouchinterest(user, TargetPart, 0)
                        task.wait(0.1)
                        firetouchinterest(user, TargetPart, 1)
                    end
                end
            end
        end
    end,
})

local CameraSection = UserTab:CreateSection("📹 Camera")

local DisableDamageBlur = UserTab:CreateButton({
    Name = "🩸 Disable/Enable Damage Blur",
    Callback = function()
        local damageBlur = workspace.Camera:FindFirstChild("damageBlur")
        if damageBlur then
            if damageBlur.Enabled == true then
                damageBlur.Enabled = false
                Rayfield:Notify({
                    Title = "damageBlur",
                    Content = "Disabled damageBlur",
                    Duration = getgenv().NotificationlengthValue,
                    Image = "circle-alert",
                })
            elseif damageBlur.Enabled == false then
                damageBlur.Enabled = true
                Rayfield:Notify({
                    Title = "damageBlur",
                    Content = "Enabled damageBlur",
                    Duration = getgenv().NotificationlengthValue,
                    Image = "circle-alert",
                })
            end
        else
            Rayfield:Notify({
                Title = "damageBlur",
                Content = "damageBlur doesn't exist right now",
                Duration = getgenv().NotificationlengthValue,
                Image = "circle-alert",
            })
        end
    end
})

local MaxZoomSlider = UserTab:CreateSlider({
    Name = "🔧 Max Zoom",
    Range = { 0, 3000 },
    Increment = 5,
    Suffix = "Max Zoom Level (/3000)",
    CurrentValue = 60,
    Flag = "maxzoomslider",
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        player.CameraMaxZoomDistance = Value
    end,
})

local FieldOfViewSlider = UserTab:CreateSlider({
    Name = "📷 Field Of View",
    Range = { 0, 120 },
    Increment = 1,
    Suffix = "Field Of View (/120)",
    CurrentValue = 70,
    Flag = "fieldofview",
    Callback = function(Value)
        local Camera = workspace.CurrentCamera
        Camera.FieldOfView = Value
    end,
})

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
                [2] = workspace:WaitForChild("Vehicles"):WaitForChild(vehicleName):WaitForChild("Body"):WaitForChild(ARV)
                    :WaitForChild("VehicleSeat"):WaitForChild("CurrentFuel"),
                [3] = 10
            }

            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("StoreFuel"):FireServer(unpack(args))

            Rayfield:Notify({
                Title = "Added Fuel",
                Content = "You have successfully added fuel to your vehicle.",
                Duration = getgenv().NotificationlengthValue,
                Image = "fuel",
            })
        elseif inVehicle == false then
            Rayfield:Notify({
                Title = "Not In Vehicle",
                Content = "Get in a vehicle to use this function",
                Duration = getgenv().NotificationlengthValue,
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
                [2] = workspace:WaitForChild("Vehicles"):WaitForChild(vehicleName):WaitForChild("Body"):WaitForChild(ARV)
                    :WaitForChild("VehicleSeat"):WaitForChild("CurrentFuel"),
                [3] = 0
            }

            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("StoreFuel"):FireServer(unpack(args))

            Rayfield:Notify({
                Title = "Removed Fuel",
                Content = "You have successfully removed fuel from your vehicle.",
                Duration = getgenv().NotificationlengthValue,
                Image = "fuel",
            })
        elseif inVehicle == false then
            Rayfield:Notify({
                Title = "Not In Vehicle",
                Content = "Get in a vehicle to use this function",
                Duration = getgenv().NotificationlengthValue,
                Image = "circle-alert",
            })
        end
    end,
})

local fuelslider = VehicleTab:CreateSlider({
    Name = "🔧 Adjust Fuel",
    Range = { 0, 10 },
    Increment = 0.1,
    Suffix = "Fuel Level (/10)",
    CurrentValue = 10,
    Flag = "fuelslider",
    Callback = function(Value)
        local vehicleName, ARV = getVehicleNameAndARV()
        local args = {
            [1] = workspace:WaitForChild("Vehicles"):WaitForChild(vehicleName),
            [2] = workspace:WaitForChild("Vehicles"):WaitForChild(vehicleName):WaitForChild("Body"):WaitForChild(ARV)
                :WaitForChild("VehicleSeat"):WaitForChild("CurrentFuel"),
            [3] = Value
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("StoreFuel"):FireServer(unpack(args))
    end,
})

local VehicleLockSection = VehicleTab:CreateSection("🔑 Lock Controls")

local LockVehicleButton = VehicleTab:CreateButton({
    Name = "🔐 Lock Vehicle",
    Callback = function()
        local vehicleName = getVehicleNameAndARV()
        local vehicleLock = workspace.Vehicles[vehicleName].Lock
        local function lockVehicle()
            local args = {
                [1] = workspace:WaitForChild("Vehicles"):WaitForChild(vehicleName)
            }

            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("LockCar"):FireServer(unpack(args))
        end
        lockVehicle()
        task.wait()
        if vehicleLock.Value == true then
            Rayfield:Notify({
                Title = "Vehicle Lock Status",
                Content = "Unlocked " .. vehicleName,
                Duration = getgenv().NotificationlengthValue,
                Image = "lock-keyhole-open",
            })
        elseif vehicleLock.Value == false then
            Rayfield:Notify({
                Title = "Vehicle Lock Status",
                Content = "Locked " .. vehicleName,
                Duration = getgenv().NotificationlengthValue,
                Image = "lock-keyhole",
            })
        end
    end,
})

local BrakesSection = VehicleTab:CreateSection("🛑 Brakes")

local UIS = game:GetService("UserInputService")

local inputBeganConnection
local inputEndedConnection

local StrongerBrakeToggle = VehicleTab:CreateToggle({
    Name = "🦾 Stronger Brakes",
    CurrentValue = false,
    Flag = "StrongerBrakes",
    Callback = function(Value)
        if Value then
            inputBeganConnection = UIS.InputBegan:Connect(function(input, gameProcessed)
                if not gameProcessed then
                    if input.KeyCode == Enum.KeyCode.S then
                        keypress(0x50)
                    end
                end
            end)

            inputEndedConnection = UIS.InputEnded:Connect(function(input, gameProcessed)
                if not gameProcessed then
                    if input.KeyCode == Enum.KeyCode.S then
                        keyrelease(0x50)
                    end
                end
            end)
        else
            if inputBeganConnection then
                inputBeganConnection:Disconnect()
                inputBeganConnection = nil
                secureprint("InputBegan connection disconnected")
            end
            
            if inputEndedConnection then
                inputEndedConnection:Disconnect()
                inputEndedConnection = nil
                secureprint("InputEnded connection disconnected")
            end
        end
    end,
})

local SpawnVehicleSection = VehicleTab:CreateSection("🛣️ Spawn Vehicle")

local vehicleDropdown = VehicleTab:CreateDropdown({
    Name = "📜 Select Vehicle",
    Options = {"Option 1","Option 2"},
    CurrentOption = {"Option 1"},
    MultipleOptions = false,
    Flag = "selectVehicleDropdown",
    Callback = function(Options)
        secureprint(Options)
    end,
})

local VehicleSpawnButton = VehicleTab:CreateButton({
    Name = "🚗 Spawn Vehicle",
    Callback = function()
        Rayfield:Notify({
            Title = "Selected Vehicle",
            Content = vehicleDropdown.CurrentOption,
            Duration = getgenv().NotificationlengthValue,
            Image = "car-front",
        })
    end,
})


-- fund tab
local FundsTab = Window:CreateTab("💸 Funds")
local QuickJobsSection = FundsTab:CreateSection("💵 Quick Jobs")

local VehicleTheftButton = FundsTab:CreateButton({
    Name = "🥷 Vehicle Theft",
    Callback = function()
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("VehicleTheftTaskGenerator"):FireServer()
    end,
})

-- RCS
local RoadsideCargoSolutionsSectionSection = FundsTab:CreateSection("🚚 Roadside Cargo Solutions")

local RCSBeginDeliveryButton = FundsTab:CreateButton({
    Name = "▶️ Begin Delivery",
    Callback = function()
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("BeginDelivery"):FireServer()
    end,
})

local RCSTakeCargoButton = FundsTab:CreateButton({
    Name = "📦 Collect Delivery",
    Callback = function()
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("CollectDelivery"):FireServer()
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

local NotificationLengthSlider = SystemTab:CreateSlider({
    Name = "🎛️ Adjust Notification Length",
    Range = { 0, 10 },
    Increment = 0.1,
    Suffix = "(Seconds)",
    CurrentValue = 3.5,
    Flag = "NotificationLengthSlider",
    Callback = function(Value)
        getgenv().NotificationlengthValue = Value
    end,
})

-- Development Section
-- I will test functions here
local DevelopmentSection = SystemTab:CreateSection("👨‍💻 Development (Debugging)")

local TestingNotificationButton = SystemTab:CreateButton({
    Name = "🔔 Notification",
    Callback = function()
        Rayfield:Notify({
            Title = "Notification",
            Content = "This is a notification",
            Duration = getgenv().NotificationlengthValue,
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
                Duration = getgenv().NotificationlengthValue,
                Image = "car",
            })
        elseif inVehicle == false then
            Rayfield:Notify({
                Title = "Vehicle Status",
                Content = "You are not in a vehicle.",
                Duration = getgenv().NotificationlengthValue,
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
            Duration = getgenv().NotificationlengthValue,
            Image = "car",
        })
    end,
})

local checkIfClientVehicleExist = SystemTab:CreateButton({
    Name = "🔍 Check If Client Vehicle Exists",
    Callback = function()
        ClientVehicleExistNotification()
    end,
})
