-- Tsubasa Hub - All In One Pro (Delta)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")

local Player = Players.LocalPlayer

------------------------------------------------
-- Anti Detect / Anti AFK
------------------------------------------------
Player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

------------------------------------------------
-- GUI Base
------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "TsubasaHub"
gui.ResetOnSpawn = false
gui.Parent = Player:WaitForChild("PlayerGui")

------------------------------------------------
-- Main Frame
------------------------------------------------
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,190,0,280)
frame.Position = UDim2.new(0.05,0,0.2,0)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.Active = true
frame.Draggable = true
frame.BorderSizePixel = 0

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "Tsubasa Hub"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 16
title.Font = Enum.Font.SourceSansBold

------------------------------------------------
-- Button Maker
------------------------------------------------
local function MakeBtn(text,y,func)

    local b = Instance.new("TextButton",frame)

    b.Size = UDim2.new(0,160,0,28)
    b.Position = UDim2.new(0,15,0,y)

    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(60,60,60)
    b.TextColor3 = Color3.new(1,1,1)
    b.TextSize = 14
    b.BorderSizePixel = 0

    Instance.new("UICorner",b).CornerRadius = UDim.new(0,6)

    b.MouseButton1Click:Connect(func)

    return b
end

------------------------------------------------
-- Fly System
------------------------------------------------
local flying = false
local speedFly = 70

local keys = {
    W=false,A=false,S=false,D=false,
    Up=false,Down=false
}

local bv,bg

local function StartFly()

    local char = Player.Character
    if not char then return end
    local hrp = char:WaitForChild("HumanoidRootPart")

    bv = Instance.new("BodyVelocity",hrp)
    bv.MaxForce = Vector3.new(1e5,1e5,1e5)

    bg = Instance.new("BodyGyro",hrp)
    bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
    bg.P = 9e4

    RunService:BindToRenderStep("ProFly",200,function()

        if not flying then return end

        local cam = workspace.CurrentCamera
        local move = Vector3.zero

        if keys.W then move += cam.CFrame.LookVector end
        if keys.S then move -= cam.CFrame.LookVector end
        if keys.A then move -= cam.CFrame.RightVector end
        if keys.D then move += cam.CFrame.RightVector end
        if keys.Up then move += cam.CFrame.UpVector end
        if keys.Down then move -= cam.CFrame.UpVector end

        if move.Magnitude > 0 then
            move = move.Unit * speedFly
        end

        bv.Velocity = move
        bg.CFrame = cam.CFrame
    end)
end

local function StopFly()

    flying = false
    RunService:UnbindFromRenderStep("ProFly")

    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
end

------------------------------------------------
-- PC Input
------------------------------------------------
UIS.InputBegan:Connect(function(i,g)
    if g then return end

    if i.KeyCode==Enum.KeyCode.W then keys.W=true end
    if i.KeyCode==Enum.KeyCode.A then keys.A=true end
    if i.KeyCode==Enum.KeyCode.S then keys.S=true end
    if i.KeyCode==Enum.KeyCode.D then keys.D=true end
    if i.KeyCode==Enum.KeyCode.Space then keys.Up=true end
    if i.KeyCode==Enum.KeyCode.LeftControl then keys.Down=true end
end)

UIS.InputEnded:Connect(function(i)

    if i.KeyCode==Enum.KeyCode.W then keys.W=false end
    if i.KeyCode==Enum.KeyCode.A then keys.A=false end
    if i.KeyCode==Enum.KeyCode.S then keys.S=false end
    if i.KeyCode==Enum.KeyCode.D then keys.D=false end
    if i.KeyCode==Enum.KeyCode.Space then keys.Up=false end
    if i.KeyCode==Enum.KeyCode.LeftControl then keys.Down=false end
end)

------------------------------------------------
-- Mobile Panel
------------------------------------------------
if UIS.TouchEnabled then

    local pad = Instance.new("Frame",gui)
    pad.Size = UDim2.new(0,120,0,120)
    pad.Position = UDim2.new(0.05,0,0.7,0)
    pad.BackgroundColor3 = Color3.fromRGB(50,50,50)
    pad.BackgroundTransparency = 0.3
    Instance.new("UICorner",pad).CornerRadius = UDim.new(1,0)

    local stick = Instance.new("Frame",pad)
    stick.Size = UDim2.new(0,40,0,40)
    stick.Position = UDim2.new(0.5,-20,0.5,-20)
    stick.BackgroundColor3 = Color3.fromRGB(200,200,200)
    Instance.new("UICorner",stick).CornerRadius = UDim.new(1,0)

    local drag=false

    pad.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.Touch then
            drag=true
        end
    end)

    pad.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.Touch then
            drag=false
            stick.Position=UDim2.new(0.5,-20,0.5,-20)
            keys.W=false keys.A=false keys.S=false keys.D=false
        end
    end)

    pad.InputChanged:Connect(function(i)

        if drag and i.UserInputType==Enum.UserInputType.Touch then

            local pos=(i.Position-pad.AbsolutePosition)/pad.AbsoluteSize
            local x=math.clamp(pos.X*2-1,-1,1)
            local z=math.clamp(-(pos.Y*2-1),-1,1)

            stick.Position=UDim2.new(pos.X,-20,pos.Y,-20)

            keys.W = z>0.3
            keys.S = z<-0.3
            keys.D = x>0.3
            keys.A = x<-0.3
        end
    end)

    local function MakeUD(text,y,val)

        local b=Instance.new("TextButton",gui)
        b.Size=UDim2.new(0,50,0,50)
        b.Position=UDim2.new(0.85,-60,y,0)
        b.Text=text
        b.TextSize=28

        b.MouseButton1Down:Connect(function()
            if val==1 then keys.Up=true else keys.Down=true end
        end)

        b.MouseButton1Up:Connect(function()
            if val==1 then keys.Up=false else keys.Down=false end
        end)
    end

    MakeUD("↑",0.6,1)
    MakeUD("↓",0.75,-1)
end

------------------------------------------------
-- ESP
------------------------------------------------
local espOn=false
local espFolder=Instance.new("Folder",gui)

local function ClearESP()
    espFolder:ClearAllChildren()
end

local function ApplyESP()

    ClearESP()

    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=Player and plr.Character then

            local h=Instance.new("Highlight")
            h.Adornee=plr.Character
            h.FillColor=Color3.fromRGB(255,60,60)
            h.FillTransparency=0.5
            h.Parent=espFolder
        end
    end
end

------------------------------------------------
-- Buttons
------------------------------------------------
local flyBtn
flyBtn = MakeBtn("Fly : OFF",40,function()

    flying=not flying

    if flying then
        flyBtn.Text="Fly : ON"
        StartFly()
    else
        flyBtn.Text="Fly : OFF"
        StopFly()
    end
end)

local espBtn
espBtn = MakeBtn("ESP : OFF",80,function()

    espOn=not espOn

    if espOn then
        espBtn.Text="ESP : ON"
        ApplyESP()
    else
        espBtn.Text="ESP : OFF"
        ClearESP()
    end
end)

MakeBtn("Speed",120,function()
    local hum=Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed=80 end
end)

MakeBtn("Jump",160,function()
    local hum=Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

MakeBtn("Close",210,function()
    StopFly()
    ClearESP()
    gui:Destroy()
end)
