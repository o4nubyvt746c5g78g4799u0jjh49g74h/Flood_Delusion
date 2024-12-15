getgenv().delusion = {
    ["Aimbot"] = {
        ["Keybind"] = Enum.KeyCode.X,

        ["CamlockPrediction"] = 0.0432,
        ["TargetPart"] = "HumanoidRootPart",

        ["NearestPart"] = false,
        ["SelectedParts"] = {"Head", "HumanoidRootPart", "LowerTorso"},

        ["CameraSmoothing"] = 0.0243,

        ["ThirdPerson"] = false,
        ["FirstPerson"] = true,

        ["HitChance"] = true,
        ["ShakePower"] = 0,

        ["JumpOffset"] = -0.65,
        ["FallOffset"] = -0.15,

        ["PredictMovement"] = true,
    },
    ['Silent'] = {
        ["Prediction"] = 0.139,
        ["Detection"] = {
            ['Close'] = 35, 
            ['Mid'] = 65, 
            ['Far'] = math.huge
        },
        ["Config"] = {
            ["Points"] = {
                ["Point Offset"] = 0

            }
        }
    },
    ['RangeHit'] = {
        ["Enabled"] = false,
        ["Prediction"] = {
            ['Close'] = 0.138, 
            ['Mid'] = 0.1247, 
            ['Far'] = 0.123
        }
    },

    ["Safety"] = {
        ["AntiGroundShots"] = false,
        ["Curve"] = false,
    },

    ["Checks"] = {
        ["DisableOnTargetDeath"] = true,
        ["DisableOnPlayerDeath"] = true,
        ["CheckKoStatus"] = true,
    },

    ["MouseTp"] = {
        ['Smoothness'] = 0.2,
        ['HorizontalPrediction'] = 0.2,
        ['VerticalPrediction'] = 0.8,
        ['Part'] = "Head",

        ['Shake'] = false,
        ['ShakeAmount'] = {
            ["X"] = 2,
            ["Y"] = 2,
            ["Z"] = 0.4
        },
    },
    ["Spin"] = {
        ['Enabled'] = true,
        ['SpinSpeed'] = 4900,
        ['Degrees'] = 360,
        ['Keybind'] = Enum.KeyCode.V,
    },

    ["Esp"] = {
        ['Chams'] = true,
        ['Key'] = Enum.KeyCode.T,
        ['Color'] = Color3.fromRGB(10, 50, 10),
        ['Outline'] = Color3.fromRGB(50, 50, 50)
    },

    ["Cframe"] = {
        ['Enabled'] = true,
        ['Toggle'] = "Z",
        ['Multiplier'] = 0.5,
        ['Speed'] = 5 
    }
}

if (not getgenv().Loaded) then
local userInputService = game:GetService("UserInputService")

if getgenv().delusion.Spin.Enabled == true then
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local Camera = workspace.CurrentCamera
    local Toggle = getgenv().delusion.Spin.Enabled
    local RotationSpeed = getgenv().delusion.Spin.SpinSpeed
    local Keybind = getgenv().delusion.Spin.Keybind

    local function OnKeyPress(Input, GameProcessedEvent)
        if Input.KeyCode == Keybind and not GameProcessedEvent then 
            Toggle = not Toggle
        end
    end

    UserInputService.InputBegan:Connect(OnKeyPress)

    local LastRenderTime = 0
    local TotalRotation = 0
    local function RotateCamera()
        if Toggle then
            local CurrentTime = tick()
            local TimeDelta = math.min(CurrentTime - LastRenderTime, 0.01)
            LastRenderTime = CurrentTime

            local RotationAngle = RotationSpeed * TimeDelta
            local Rotation = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), math.rad(RotationAngle))
            Camera.CFrame = Camera.CFrame * Rotation
            TotalRotation = TotalRotation + RotationAngle
            if TotalRotation >= getgenv().delusion.Spin.Degrees then 
                Toggle = false
                TotalRotation = 0
            end
        end
    end

    RunService.RenderStepped:Connect(RotateCamera)
    end

--// Chams

if getgenv().delusion.Esp.Chams == true then

local UserInputService = game:GetService("UserInputService")
local ToggleKey = getgenv().delusion.Esp.Key

local FillColor = getgenv().delusion.Esp.Color
local DepthMode = "AlwaysOnTop"
local FillTransparency = 0.5
local OutlineColor = getgenv().delusion.Esp.Outline
local OutlineTransparency = 0

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local connections = {}

local Storage = Instance.new("Folder")
Storage.Parent = CoreGui
Storage.Name = "Highlight_Storage"

local isEnabled = false

local function Highlight(plr)
    local Highlight = Instance.new("Highlight")
    Highlight.Name = plr.Name
    Highlight.FillColor = FillColor
    Highlight.DepthMode = DepthMode
    Highlight.FillTransparency = FillTransparency
    Highlight.OutlineColor = OutlineColor
    Highlight.OutlineTransparency = 0
    Highlight.Parent = Storage
    
    local plrchar = plr.Character
    if plrchar then
        Highlight.Adornee = plrchar
    end

    connections[plr] = plr.CharacterAdded:Connect(function(char)
        Highlight.Adornee = char
    end)
end

local function EnableHighlight()
    isEnabled = true
    for _, player in ipairs(Players:GetPlayers()) do
        Highlight(player)
    end
end

local function DisableHighlight()
    isEnabled = false
    for _, highlight in ipairs(Storage:GetChildren()) do
        highlight:Destroy()
    end
    for _, connection in pairs(connections) do
        connection:Disconnect()
    end
end

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == ToggleKey then
        if isEnabled then
            DisableHighlight()
        else
            EnableHighlight()
        end
    end
end)

Players.PlayerAdded:Connect(function(player)
    if isEnabled then
        Highlight(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    local highlight = Storage:FindFirstChild(player.Name)
    if highlight then
        highlight:Destroy()
    end
    local connection = connections[player]
    if connection then
        connection:Disconnect()
    end
end)


if isEnabled then
    EnableHighlight()
end
end


local delusion = getgenv().delusion -- Reference to the delusion table

-- Function to index delusion values
local function indexDelusion(key)
    if delusion[key] then
        return delusion[key]
    else
        warn("Key not found in delusion:", key)
        return nil
    end
end

if indexDelusion("MouseTp").Enabled == true then 
    local connection

    connection = runService.RenderStepped:Connect(function()
        updateFOV()
        if target ~= nil and target.Character and isKnocked(target) and isKnocked(localPlayer) then
            local isFalling = target.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall
            local hitPart = isFalling and target.Character[indexDelusion("MouseTp").hitPart]
            local horizontalPrediction = isFalling and indexDelusion("MouseTp").HorizontalPrediction
            local verticalPrediction = isFalling and indexDelusion("MouseTp").VerticalPrediction
            local hitPoint = calculatePrediction(hitPart, horizontalPrediction, verticalPrediction)
            local xShake = isFalling and indexDelusion("MouseTp").ShakeAmount.X or 0
            local yShake = isFalling and indexDelusion("MouseTp").ShakeAmount.Y or 0
            local zShake = isFalling and indexDelusion("MouseTp").ShakeAmount.Z or 0
            
            if hitPoint then
                local Main = CFrame.new(camera.CFrame.p, hitPoint)
                camera.CFrame = camera.CFrame:Lerp(Main, indexDelusion("Aimbot").Smoothness.Amount)
            end
        end
    end)

    -- Function to disconnect the connection when needed
    function closeMouseTp()
        if connection then
            connection:Disconnect()
            connection = nil
        end
    end
end




--// CFrame \\--
if getgenv().delusion.Cframe.Enabled then
    repeat wait() until game:IsLoaded()
    local Players = game:GetService('Players')
    local LocalPlayer = Players.LocalPlayer
    repeat wait() until LocalPlayer.Character
    local UserInputService = game:GetService('UserInputService')
    local RunService = game:GetService('RunService')
    local isActive = false -- Changed to false to start inactive

    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.LeftBracket then
            getgenv().delusion.Cframe.Multiplier += 0.01
            print(getgenv().delusion.Cframe.Multiplier)
            wait(0.2)
            while UserInputService:IsKeyDown(Enum.KeyCode.LeftBracket) do
                wait()
                getgenv().delusion.Cframe.Multiplier += 0.01
                print(getgenv().delusion.Cframe.Multiplier)
            end
        elseif input.KeyCode == Enum.KeyCode.RightBracket then
            getgenv().delusion.Cframe.Multiplier -= 0.01
            print(getgenv().delusion.Cframe.Multiplier)
            wait(0.2)
            while UserInputService:IsKeyDown(Enum.KeyCode.RightBracket) do
                wait()
                getgenv().delusion.Cframe.Multiplier -= 0.01
                print(getgenv().delusion.Cframe.Multiplier)
            end
        elseif input.KeyCode == Enum.KeyCode[getgenv().delusion.Cframe.Toggle:upper()] then
            isActive = not isActive
            if isActive then
                while isActive do
                    local character = LocalPlayer.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local humanoidRootPart = character.HumanoidRootPart
                        humanoidRootPart.CFrame = humanoidRootPart.CFrame + character.Humanoid.MoveDirection * getgenv().delusion.Cframe.Multiplier * getgenv().delusion.Cframe.Speed
                    end
                    RunService.Stepped:Wait()
                end
            end
        end
    end)
end

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent then 
    end
end)


game:GetService("RunService").RenderStepped:Connect(function()
    if Plr and Plr.Character then
        if getgenv().delusion.Silent.NearestPart == true and getgenv().delusion.Aimbot.Basic == false then
            getgenv().delusion.Aimbot.Part = tostring(getClosestPartToCursor(Plr))
        elseif getgenv().delusion.Silent.Basic == true and getgenv().delusion.Aimbot.NearestPart == false then
            getgenv().delusion.Aimbot.Part = getgenv().delusion.Aimbot.Part
        end
    end
end)


local function CheckAnti(Plr)
    if Plr.Character.HumanoidRootPart.Velocity.Y < -70 then
        return true
    elseif Plr and (Plr.Character.HumanoidRootPart.Velocity.X > 450 or Plr.Character.HumanoidRootPart.Velocity.X < -35) then
        return true
    elseif Plr and Plr.Character.HumanoidRootPart.Velocity.Y > 60 then
        return true
    elseif Plr and (Plr.Character.HumanoidRootPart.Velocity.Z > 35 or Plr.Character.HumanoidRootPart.Velocity.Z < -35) then
        return true
    else
        return false
    end
end

local function getnamecall()
    if game.PlaceId == 2788229376 or game.PlaceId == 7213786345 or game.PlaceId == 16033173781 or game.PlaceId == 16158576873 then
        return "UpdateMousePosI2" 
    elseif game.PlaceId == 5602055394 or game.PlaceId == 7951883376 then
        return "MousePos"
    elseif game.PlaceId == 9825515356 then 
        return "MousePosUpdate"
    end
end

local namecalltype = getnamecall()

function MainEventLocate()
    for _, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if v.Name == "MainEvent" then
            return v
        end
    end
end

local Locking = false
local Players = game:GetService("Players")
local Client = Players.LocalPlayer
local Plr = nil -- Initialize Plr here
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local Toggle = false

local function OnKeyPress(Input, GameProcessedEvent)
    if Input.KeyCode == getgenv().delusion.Aimbot.Keybind and not GameProcessedEvent then 
        Toggle = not Toggle
    end
end

UserInputService.InputBegan:Connect(OnKeyPress)

UserInputService.InputBegan:Connect(function(keygo, ok)
    if not ok and keygo.KeyCode == getgenv().delusion.Aimbot.Keybind then
        Locking = not Locking
        Plr = Locking and getClosestPlayerToCursor() or nil
    end
end)

function getClosestPlayerToCursor()
    local closestDist = math.huge
    local closestPlr = nil
    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= Client and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local screenPos, cameraVisible = workspace.CurrentCamera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if cameraVisible then
                local distToMouse = (UserInputService:GetMouseLocation() - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                if distToMouse < closestDist then
                    closestPlr = v
                    closestDist = distToMouse
                end
            end
        end
    end
    return closestPlr
end

function getClosestPartToCursor(Player)
    local closestPart, closestDist = nil, math.huge
    if Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character:FindFirstChild("HumanoidRootPart") then
        for _, part in pairs(Player.Character:GetChildren()) do
            if part:IsA("BasePart") then
                local screenPos, cameraVisible = workspace.CurrentCamera:WorldToViewportPoint(part.Position)
                local distToMouse = (UserInputService:GetMouseLocation() - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                if distToMouse < closestDist and table.find(getgenv().delusion.Aimbot.SelectedParts, part.Name) then
                    closestPart = part
                    closestDist = distToMouse
                end
            end
        end
    end
    return closestPart
end

local mainevent = game:GetService("ReplicatedStorage").MainEvent

Client.Character.ChildAdded:Connect(function(child)
    if child:IsA("Tool") and child:FindFirstChild("MaxAmmo") then
        child.Activated:Connect(function()
            if Plr and Plr.Character then
                local Position = Plr.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall 
                    and Plr.Character[getgenv().delusion.Aimbot.TargetPart].Position + Vector3.new(0, getgenv().delusion.Aimbot.JumpOffset, 0) 
                    or Plr.Character[getgenv().delusion.Aimbot.TargetPart].Position
                
                mainevent:FireServer(namecalltype, Position + (Plr.Character.HumanoidRootPart.Velocity * getgenv().delusion.Silent.Prediction))
            end
        end)
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if Plr and Plr.Character then
        local Position = Plr.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall 
            and Plr.Character[getgenv().delusion.Aimbot.TargetPart].Position + Vector3.new(0, getgenv().delusion.Aimbot.JumpOffset, 0) 
            or Plr.Character[getgenv().delusion.Aimbot.TargetPart].Position
        
        local Main = CFrame.new(workspace.CurrentCamera.CFrame.p, Position + (Plr.Character.HumanoidRootPart.Velocity * getgenv().delusion.Aimbot.CamlockPrediction))
        workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(Main, getgenv().delusion.Aimbot.CameraSmoothing, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    end
end)

getgenv().Loaded = true
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Delusion",
        Text = "Updated Table",
        Duration = 0.001
    })
end
