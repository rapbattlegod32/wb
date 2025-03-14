-- checks if an object called "A-Chassis Interface" is in the PlayerGui folder
-- if player is in vehicle A-Chassis is in PlayerGui and if not there is no A-Chassis
-- no A-Chassis = not in vehicle | A-Chassis = in vehicle

local AChassisInterface_Path = game:GetService("Players").LocalPlayer.PlayerGui

local inVehicle = nil

if AChassisInterface_Path:FindFirstChild('A-Chassis Interface') then -- in this case true
    print('player is in vehicle')
    inVehicle = true
else
    print('player isnt in vehicle')
    inVehicle = false
 end