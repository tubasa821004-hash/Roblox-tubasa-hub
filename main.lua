-- Tsubasa Hub - Joystick Fly Edition (Delta/Mobile)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer

------------------------------------------------
-- GUI
------------------------------------------------
local gui = Instance.new("ScreenGui", Player.PlayerGui)
gui.Name = "TsubasaHub"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,185,0,300)
frame.Position = UDim2.new(0.05,0,0.22,0)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,28)
title.BackgroundTransparency = 1
title.Text = "Tsubasa Hub"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 15

------------------------------------------------
-- Button Maker
------------------------------------------------
local function MakeBtn(text,y,func)

    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0,155,0,26)
    b.Position = UDim2.new(0,15,0,y)
    b.Text = text
    b.TextSize = 13
    b.BackgroundColor3 = Color3.fromRGB(60,60,60)
    b.TextColor3 = Color3.new(1,1,1)
    b.BorderSizePixel = 0
    Instance.new("UICorner", b)

    b.MouseButton1Click:Connect(func)
    return b
end

------------------------------------------------
-- Fly System
------------------------------------------------
local flying = false
local flySpeed = 65

local moveVec = Vector2.zero
local up = false
local down = false

local bv,bg

------------------------------------------------
-- Joystick UI
------------------------------------------------
local joyBase = Instance.new("Frame", gui)
joyBase.Size = UDim2.new(0,120,0,120)
joyBase.Position = UDim2.new(0.05,0,0.6,0)
joyBase.BackgroundColor3 = Color3.fromRGB(60,60,60)
joyBase.BackgroundTransparency = 0.3
joyBase.Visible = false
Instance.new("UICorner", joyBase).CornerRadius = UDim.new(1,0)

local joyStick = Instance.new("Frame", joyBase)
joyStick.Size = UDim2.new(0,40,0,40)
joyStick.Position = UDim2.new(0.5,-20,0.5,-20)
joyStick.BackgroundColor3 = Color3.fromRGB(200,200,200)
Instance.new("UICorner", joyStick).CornerRadius = UDim.new(1,0)

------------------------------------------------
-- Up / Down Buttons
------------------------------------------------
local function MakeUD(text,y,flag)

    local b = Instance.new("TextButton", gui)
    b.Size = UDim2.new(0,50,0,50)
    b.Position = UDim2.new(0.85,-55,y,0)
    b.Text = text
    b.TextSize = 28
    b.BackgroundColor3 = Color3.fromRGB(60,60,60)
    b.TextColor3 = Color3.new(1,1,1)
    b.Visible = false
    Instance.new("UICorner", b)

    b.MouseButton1Down:Connect(function()
        if flag=="up" then up=true else down=true end
    end)

    b.MouseButton1Up:Connect(function()
        if flag=="up" then up=false else down=false end
    end)

    return b
end

local upBtn = MakeUD("⬆",0.55,"up")
local downBtn = MakeUD("⬇",0.7,"down")

------------------------------------------------
-- Joystick Control
------------------------------------------------
local dragging = false

joyBase.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch then
        dragging = true
    end
end)

joyBase.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        joyStick.Position = UDim2.new(0.5,-20,0.5,-20)
        moveVec = Vector2.zero
    end
end)

joyBase.InputChanged:Connect(function(i)

    if dragging and i.UserInputType == Enum.UserInputType.Touch then

        local pos = (i.Position - joyBase.AbsolutePosition)
        local center = joyBase.AbsoluteSize/2

        local offset = pos - center
        local radius = joyBase.AbsoluteSize.X/2

        offset = Vector2.new(
            math.clamp(offset.X,-radius,radius),
            math.clamp(offset.Y,-radius,radius)
        )

        joyStick.Position = UDim2.new(
            0.5, offset.X-20,
            0.5, offset.Y-20
        )

        moveVec = offset / radius
    end
end)

------------------------------------------------
-- Fly Logic
------------------------------------------------
local function StartFly()

    local char = Player.Character
    if not char then return end

    local hrp = char:WaitForChild("HumanoidRootPart")

    bv = Instance.new("BodyVelocity", hrp)
    bv.MaxForce = Vector3.new(1e5,1e5,1e5)

    bg = Instance.new("BodyGyro", hrp)
    bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
    bg.P = 9e4

    RunService:BindToRenderStep("FlyMove",200,function()

        if not flying then return end

        local cam = workspace.CurrentCamera
        local v = Vector3.zero

        v += cam.CFrame.LookVector * -moveVec.Y
        v += cam.CFrame.RightVector * moveVec.X

        if up then v += cam.CFrame.UpVector end
        if down then v -= cam.CFrame.UpVector end

        if v.Magnitude > 0 then
            v = v.Unit * flySpeed
        end

        bv.Velocity = v
        bg.CFrame = cam.CFrame
    end)

    if UIS.TouchEnabled then
        joyBase.Visible = true
        upBtn.Visible = true
        downBtn.Visible = true
    end
end

local function StopFly()

    flying = false
    RunService:UnbindFromRenderStep("FlyMove")

    if bv then bv:Destroy() end
    if bg then bg:Destroy() end

    joyBase.Visible = false
    upBtn.Visible = false
    downBtn.Visible = false
end

------------------------------------------------
-- Other Systems
------------------------------------------------
-- NoClip
local noclip=false
local noclipConn

local function SetNoClip(on)

    local char=Player.Character
    if not char then return end

    if on then

        noclipConn=RunService.Stepped:Connect(function()
            for _,v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide=false
                end
            end
        end)

    else

        if noclipConn then noclipConn:Disconnect() end

        for _,v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide=true
            end
        end
    end
end

-- Speed
local speed=false
local normal=16
local fast=80

------------------------------------------------
-- Buttons
------------------------------------------------
local flyBtn
flyBtn = MakeBtn("Fly : OFF",35,function()

    flying = not flying

    if flying then
        flyBtn.Text="Fly : ON"
        StartFly()
    else
        flyBtn.Text="Fly : OFF"
        StopFly()
    end
end)

local nocBtn
nocBtn = MakeBtn("NoClip : OFF",70,function()

    noclip = not noclip
    nocBtn.Text="NoClip : "..(noclip and "ON" or "OFF")

    SetNoClip(noclip)
end)

local speedBtn
speedBtn = MakeBtn("Speed : OFF",105,function()

    speed = not speed

    local h = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")

    if h then
        if speed then
            h.WalkSpeed = fast
            speedBtn.Text="Speed : ON"
        else
            h.WalkSpeed = normal
            speedBtn.Text="Speed : OFF"
        end
    end
end)

MakeBtn("Jump",140,function()

    local h = Player.Character and Player.Character:FindFirstChild("Humanoid")

    if h then
        h:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

MakeBtn("Close",190,function()

    StopFly()
    SetNoClip(false)
    gui:Destroy()
end)
