-- Delta Mini Hub
-- Fly Toggle Version

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer

------------------------------------------------
-- GUI (Small Size)
------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "TsubasaHub"
gui.ResetOnSpawn = false
gui.Parent = Player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,180,0,220) -- 小さめ
frame.Position = UDim2.new(0.05,0,0.25,0)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0,10)

------------------------------------------------
-- Title
------------------------------------------------

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "Tsubasa Hub"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16

------------------------------------------------
-- Button Maker
------------------------------------------------

local function MakeBtn(text, y, func)
    local btn = Instance.new("TextButton", frame)

    btn.Size = UDim2.new(0,150,0,28)
    btn.Position = UDim2.new(0,15,0,y)

    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.TextColor3 = Color3.new(1,1,1)

    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.BorderSizePixel = 0

    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0,6)

    btn.MouseButton1Click:Connect(func)

    return btn
end

------------------------------------------------
-- Fly System (Toggle)
------------------------------------------------

local flying = false
local bv, bg
local flySpeed = 50

local function StartFly()
    local char = Player.Character
    if not char then return end

    local hrp = char:WaitForChild("HumanoidRootPart")

    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e4,9e4,9e4)
    bv.Velocity = Vector3.zero
    bv.Parent = hrp

    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(9e4,9e4,9e4)
    bg.CFrame = hrp.CFrame
    bg.Parent = hrp

    RunService:BindToRenderStep("Fly", 200, function()
        if not flying then return end

        local cam = workspace.CurrentCamera
        bv.Velocity = cam.CFrame.LookVector * flySpeed
        bg.CFrame = cam.CFrame
    end)
end

local function StopFly()
    flying = false

    RunService:UnbindFromRenderStep("Fly")

    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
end

------------------------------------------------
-- Buttons
------------------------------------------------

local flyBtn
flyBtn = MakeBtn("Fly : OFF", 40, function()

    flying = not flying

    if flying then
        flyBtn.Text = "Fly : ON"
        StartFly()
    else
        flyBtn.Text = "Fly : OFF"
        StopFly()
    end

end)

MakeBtn("Speed", 80, function()
    local hum = Player.Character:FindFirstChild("Humanoid")
    if hum then
        hum.WalkSpeed = 80
    end
end)

MakeBtn("Jump", 120, function()
    local hum = Player.Character:FindFirstChild("Humanoid")
    if hum then
        hum.JumpPower = 150
    end
end)

MakeBtn("Close", 170, function()
    gui:Destroy()
end)
