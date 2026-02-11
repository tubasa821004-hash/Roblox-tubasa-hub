-- Simple All In One Hub
-- By You

local Player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- GUI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
ScreenGui.Parent = game.CoreGui

Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0,300,0,400)
Frame.Position = UDim2.new(0.05,0,0.2,0)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Active = true
Frame.Draggable = true

-- Create Button
function MakeButton(text,posY,func)
    local btn = Instance.new("TextButton",Frame)
    btn.Size = UDim2.new(0,260,0,40)
    btn.Position = UDim2.new(0,20,0,posY)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.TextColor3 = Color3.new(1,1,1)

    btn.MouseButton1Click:Connect(func)
end

--------------------------------
-- Variables
--------------------------------

local Flying = false
local SpeedOn = false
local God = false

--------------------------------
-- Fly
--------------------------------

function Fly()
    local char = Player.Character
    local hrp = char:WaitForChild("HumanoidRootPart")

    local bv = Instance.new("BodyVelocity",hrp)
    local bg = Instance.new("BodyGyro",hrp)

    bv.MaxForce = Vector3.new(1e5,1e5,1e5)
    bg.MaxTorque = Vector3.new(1e5,1e5,1e5)

    Flying = true

    RunService.RenderStepped:Connect(function()
        if not Flying then
            bv:Destroy()
            bg:Destroy()
            return
        end

        bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 60
        bg.CFrame = workspace.CurrentCamera.CFrame
    end)
end

--------------------------------
-- Speed
--------------------------------

function ToggleSpeed()
    SpeedOn = not SpeedOn

    if SpeedOn then
        Player.Character.Humanoid.WalkSpeed = 80
    else
        Player.Character.Humanoid.WalkSpeed = 16
    end
end

--------------------------------
-- Fling
--------------------------------

function FlingAll()
    local hrp = Player.Character.HumanoidRootPart

    for i,v in pairs(game.Players:GetPlayers()) do
        if v ~= Player then
            local thrp = v.Character:FindFirstChild("HumanoidRootPart")
            if thrp then
                hrp.CFrame = thrp.CFrame
                hrp.Velocity = Vector3.new(9999,9999,9999)
                wait(0.2)
            end
        end
    end
end

--------------------------------
-- ESP
--------------------------------

function ESP()
    for i,v in pairs(game.Players:GetPlayers()) do
        if v ~= Player then
            local box = Instance.new("BoxHandleAdornment")
            box.Size = v.Character.HumanoidRootPart.Size
            box.Adornee = v.Character.HumanoidRootPart
            box.AlwaysOnTop = true
            box.ZIndex = 5
            box.Color3 = Color3.new(1,0,0)
            box.Transparency = 0.4
            box.Parent = v.Character
        end
    end
end

--------------------------------
-- AutoFarm (Example)
--------------------------------

function AutoFarm()
    while true do
        wait(1)

        for i,v in pairs(workspace:GetDescendants()) do
            if v.Name == "Coin" then
                Player.Character.HumanoidRootPart.CFrame = v.CFrame
            end
        end
    end
end

--------------------------------
-- Teleport
--------------------------------

function TeleportRandom()
    local map = workspace:GetDescendants()

    for i,v in pairs(map) do
        if v:IsA("SpawnLocation") then
            Player.Character.HumanoidRootPart.CFrame = v.CFrame
            break
        end
    end
end

--------------------------------
-- GodMode
--------------------------------

function GodMode()
    God = not God

    if God then
        Player.Character.Humanoid.MaxHealth = math.huge
        Player.Character.Humanoid.Health = math.huge
    else
        Player.Character.Humanoid.MaxHealth = 100
        Player.Character.Humanoid.Health = 100
    end
end

--------------------------------
-- Buttons
--------------------------------

MakeButton("Fly",20,Fly)
MakeButton("Speed",70,ToggleSpeed)
MakeButton("Fling All",120,FlingAll)
MakeButton("ESP",170,ESP)
MakeButton("AutoFarm",220,AutoFarm)
MakeButton("Teleport",270,TeleportRandom)
MakeButton("GodMode",320,GodMode)
MakeButton("Close",370,function()
    ScreenGui:Destroy()
end)
