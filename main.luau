local library = loadstring(game:HttpGet('https://raw.githubusercontent.com/Stratxgy/PepsiUI/refs/heads/main/pepsi.lua'))()
local Wait = library.subs.Wait -- Only returns if the GUI has not been terminated. For 'while Wait() do' loops

local PepsisWorld = library:CreateWindow({
    Name = "Westbridge",
    Themeable = {
        Info = "Discord Server:"
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

                    
                    for _, part in pairs(carBody:GetChildren()) do
                        if part:IsA("Model") and part.Name:sub(1, 3) == "ARV" then
                            print("ARV model found: " .. part.Name)
                            local ARV = part.Name
                            return vehicleName, ARV
                        end
                    end

                    break
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
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Vehicle Exist Status",
                Text = "You have a vehicle",
            })
    elseif doesVehicleExist == false then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Vehicle Exist Status",
                Text = "You do not have a vehicle",
            })
    end
end

local MainTab = PepsisWorld:CreateTab({
    Name = "🏡 Home"
})

-- financial section
local FinancialSection = MainTab:CreateSection({
    Name = "💸 Financial Info"
})

-- money label
local guimoney = game:GetService("Players").LocalPlayer.PlayerGui.GameUI.GameUIContainer.Balance
local moneylabel = FinancialSection:AddLabel({
    Text = guimoney.Text,
})
guimoney:GetPropertyChangedSignal("Text"):Connect(function()
    moneylabel:Set(guimoney.Text)
end)

-- status section
local StatusSection = MainTab:CreateSection({
    Name = "❤️ Status"
})
-- health label
local healthbar = game:GetService("Players").LocalPlayer.PlayerGui.GameUI.GameUIContainer.HealthBar.Bar
local healthbar_size = math.floor(healthbar.Size.X.Scale * 100)
local formatted_health = string.format("%03d", healthbar_size)
local healthlabel = StatusSection:AddLabel({
    Text = formatted_health .. " health",
})
healthbar:GetPropertyChangedSignal("Size"):Connect(function()
    local healthbar_size = math.floor(healthbar.Size.X.Scale * 100)
    local formatted_health = string.format("%03d", healthbar_size)
    healthlabel:Set(formatted_health .. " health")
end)

-- hunger label
local hungerbar = game:GetService("Players").LocalPlayer.PlayerGui.GameUI.GameUIContainer.HungerBar.Bar
local hungerbar_size = math.floor(hungerbar.Size.X.Scale * 100)
local formatted_hunger = string.format("%03d", hungerbar_size)
local hungerlabel = StatusSection:AddLabel({
    Text = formatted_hunger .. " hunger",
})
hungerbar:GetPropertyChangedSignal("Size"):Connect(function()
    local hungerbar_size = math.floor(hungerbar.Size.X.Scale * 100)
    local formatted_hunger = string.format("%03d", hungerbar_size)
    hungerlabel:Set(formatted_hunger .. " hunger")
end)

-- TeamInfoSection section
local TeamInfoSection = MainTab:CreateSection({
    Name = "🧑‍💼 Occupation"
})

-- team label
local team = game:GetService("Players").LocalPlayer.PlayerGui.GameUI.GameUIContainer.Profile.Team
local teamlabel = TeamInfoSection:AddLabel({
    Text = team.Text,
})
team:GetPropertyChangedSignal("Text"):Connect(function()
    teamlabel:Set(team.Text)
end)

-- player count section
local PlayerCountInfoSection = MainTab:CreateSection({
    Name = "🌐 Player Count"
})
local Players = game:GetService("Players")

-- Initial player count
local playerCount = #Players:GetPlayers()
local playercountlabel = PlayerCountInfoSection:AddLabel({
    Text = tostring(playerCount),
})

-- Function to update player count
local function updatePlayerCount()
    local playerCount = #game.Players:GetPlayers()
    playercountlabel:Set(tostring(playerCount))
end

updatePlayerCount()
game.Players.PlayerAdded:Connect(updatePlayerCount)
game.Players.PlayerRemoving:Connect(updatePlayerCount)

-- admin section
local AdminCountSection = MainTab:CreateSection({
    Name = "🛡️ Administrator Count",
    Side = "Right",
})


-- administrators online label
local Players = game:GetService("Players")

-- modulescript with admin ids
local adminIds_path = game:GetService("ReplicatedStorage").Config.Admins
local adminIdArray = require(adminIds_path)

local adminInfo = {}
local adminsonline = 0
local adminsoffline = 0

local emptyadmincountlabel3 = AdminCountSection:AddLabel({
    Text = " ",
})
local emptyadmincountlabel3 = AdminCountSection:AddLabel({
    Text = " ",
})

-- Create the admin online label
local adminonlinestring = "Administrators: " .. adminsonline
local adminonlinelabel = AdminCountSection:AddLabel({
    Text = adminonlinestring,
})

local emptyadmincountlabel3 = AdminCountSection:AddLabel({
    Text = " ",
})
local emptyadmincountlabel3 = AdminCountSection:AddLabel({
    Text = " ",
})


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
        adminonlinestring = adminonlinestring .. " \n(" .. table.concat(onlineAdmins, ",\n ") .. ")"
    end
    adminonlinelabel:Set(adminonlinestring)
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

-- teams section
local TeamCountInfoSection = MainTab:CreateSection({
    Name = "🏢 Team Count",
    Side = "Right",
})

local Teams = game:GetService("Teams")


local emptyteamcountlabel3 = TeamCountInfoSection:AddLabel({
    Text = " ",
})

-- Initialize teamcountlabel
local teamcountlabel = TeamCountInfoSection:AddLabel({
    Text = "Initializing...",
})

local emptyteamcountlabel1 = TeamCountInfoSection:AddLabel({
    Text = " ",
})

local emptyteamcountlabel2 = TeamCountInfoSection:AddLabel({
    Text = " ",
})

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
        " \n(MET: " ..
        #metropolitanPoliceServiceTeam ..
        ", RMP: " .. #royalMilitaryPoliceTeam .. ", MODP: " .. #ministryOfDefencePolice .. ")" ..
        " \n| Ambulance: " .. #londonAmbulanceServiceTeam ..
        " | Fire: " .. #londonFireBrigadeTeam ..
        " \n| Repair: " .. totalRepairTeam

    teamcountlabel:Set(teamString)
end

updateTeamCounts()
game.Players.PlayerAdded:Connect(updateTeamCounts)
game.Players.PlayerRemoving:Connect(updateTeamCounts)

local UserTab = PepsisWorld:CreateTab({
    Name = "👤 User"
})

-- teams section
local HealthSection = UserTab:CreateSection({
    Name = "❤️ Health",
    Side = "Left",
})

HealthSection:AddButton({
    Name = "💀 Reset",
    Callback = function()
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Reset"):FireServer()
    end
})

-- hunger (not in use)
-- local HungerSection = UserTab:CreateSection({
--     Name = "🍽️ Hunger",
--     Side = "Left",
-- })

-- hunger (not in use)
local AvatarSection = UserTab:CreateSection({
    Name = "🤵 Avatar",
    Side = "Left",
})

AvatarSection:AddButton({
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
    end
})

AvatarSection:AddButton({
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
    end
})

AvatarSection:AddButton({
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
    end
})

local CameraSection = UserTab:CreateSection({
    Name = "📹 Camera",
    Side = "Right",
})

CameraSection:AddButton({
    Name = "🩸 Dis/Enable Damage Blur",
    Callback = function()
        local damageBlur = workspace.Camera:FindFirstChild("damageBlur")
        if damageBlur then
            if damageBlur.Enabled == true then
                damageBlur.Enabled = false
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "damageBlur",
                    Text = "Disabled damageBlur",
                })
            elseif damageBlur.Enabled == false then
                damageBlur.Enabled = true
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "damageBlur",
                    Text = "Enabled damageBlur",
                })
            end
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "damageBlur",
                Text = "damageBlur doesn't exist right now",
            })
        end
    end
})

CameraSection:AddSlider({
    Name = "🔧 Max Zoom",
    Flag = "maxzoomslider",
    Value = 60,
    Precise = 5,
    Min = 0,
    Max = 3000,
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        player.CameraMaxZoomDistance = Value
    end
})

CameraSection:AddSlider({
    Name = "📷 Field Of View",
    Flag = "fieldofviewslider",
    Value = 70,
    Precise = 1,
    Min = 0,
    Max = 120,
    Callback = function(Value)
        local Camera = workspace.CurrentCamera
        Camera.FieldOfView = Value
    end
})


local VehicleTab = PepsisWorld:CreateTab({
    Name = "🚗 Vehicle"
})

local FuelSection = VehicleTab:CreateSection({
    Name = "⛽ Fuel",
    Side = "Left",
})

FuelSection:AddButton({
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

            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Added Fuel",
                Text = "You have successfully added fuel to your vehicle.",
            })
        elseif inVehicle == false then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Not In Vehicle",
                Text = "Get in a vehicle to use this function",
            })
        end
    end
})

FuelSection:AddButton({
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

            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Removed Fuel",
                Text = "You have successfully removed fuel from your vehicle.",
            })
        elseif inVehicle == false then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Not In Vehicle",
                Text = "Get in a vehicle to use this function",
            })
        end
    end
})

FuelSection:AddSlider({
    Name = "🔧 Adjust Fuel",
    Flag = "adjustfuelslider",
    Value = 10,
    Precise = 1,
    Min = 0,
    Max = 10,
    Callback = function(Value)
        local vehicleName, ARV = getVehicleNameAndARV()
        local args = {
            [1] = workspace:WaitForChild("Vehicles"):WaitForChild(vehicleName),
            [2] = workspace:WaitForChild("Vehicles"):WaitForChild(vehicleName):WaitForChild("Body"):WaitForChild(ARV)
                :WaitForChild("VehicleSeat"):WaitForChild("CurrentFuel"),
            [3] = Value
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("StoreFuel"):FireServer(unpack(args))
    end
})

local LockControlsSection = VehicleTab:CreateSection({
    Name = "🔑 Lock Controls",
    Side = "Left",
})

LockControlsSection:AddButton({
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
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Vehicle Lock Status",
                Text = "Unlocked " .. vehicleName,
            })
        elseif vehicleLock.Value == false then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Vehicle Lock Status",
                Text = "Locked " .. vehicleName,
            })
        end
    end
})

local BrakesSection = VehicleTab:CreateSection({
    Name = "🛑 Brakes",
    Side = "Left",
})

local UIS = game:GetService("UserInputService")

local inputBeganConnection
local inputEndedConnection

BrakesSection:AddToggle({
    Name = "🦾 Stronger Brakes",
    Value = false,
    Flag = "strongerbrakestoggle",
    Callback = function(Value, OldValue)
        if Value then
            inputBeganConnection = UIS.InputBegan:Connect(function(input, gameProcessed)
                if not gameProcessed and input.KeyCode == Enum.KeyCode.S then
                    keypress(0x50)
                end
            end)

            inputEndedConnection = UIS.InputEnded:Connect(function(input, gameProcessed)
                if not gameProcessed and input.KeyCode == Enum.KeyCode.S then
                    keyrelease(0x50)
                end
            end)

            secureprint("Input connections enabled.")
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
    end
})

local FundsTab = PepsisWorld:CreateTab({
    Name = "💸 Funds"
})

local QuickJobsSection = FundsTab:CreateSection({
    Name = "💵 Quick Jobs",
    Side = "Left",
})

QuickJobsSection:AddButton({
    Name = "🥷 Vehicle Theft",
    Callback = function()
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("VehicleTheftTaskGenerator"):FireServer()
    end
})

-- RCS
local RoadsideCargoSolutionsSection = FundsTab:CreateSection({
    Name = "🚚 Roadside Cargo Solutions",
    Side = "Left",
})

RoadsideCargoSolutionsSection:AddButton({
    Name = "▶️ Begin Delivery",
    Callback = function()
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("BeginDelivery"):FireServer()
    end
})

RoadsideCargoSolutionsSection:AddButton({
    Name = "📦 Collect Delivery",
    Callback = function()
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("CollectDelivery"):FireServer()
    end
})

local SystemTab = PepsisWorld:CreateTab({
    Name = "🖥️ System"
})
local DevelopmentSection = SystemTab:CreateSection({
    Name = "👨‍💻 Development",
    Side = "Left",
})

DevelopmentSection:AddButton({
    Name = "🔔 Notification",
    Callback = function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Notification",
                Text = "This is a notification",
            })
    end
})

DevelopmentSection:AddButton({
    Name = "🚗 Check If In Vehicle",
    Callback = function()
        local inVehicle = checkIfInVehicle()
        if inVehicle == true then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Vehicle Status",
                Text = "You are in a vehicle",
            })
        elseif inVehicle == false then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Vehicle Status",
                Text = "You are not in a vehicle",
            })
        end
    end
})

DevelopmentSection:AddButton({
    Name = "📃 Get Current Vehicle Info",
    Callback = function()
        local vehicleName, ARV = getVehicleNameAndARV()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = vehicleName,
                Text = ARV,
            })
    end
})

DevelopmentSection:AddButton({
    Name = "🔍 Client Vehicle Exist?",
    Callback = function()
        ClientVehicleExistNotification()
    end
})