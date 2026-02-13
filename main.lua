-- Tsubasa Hub Delta Stable + ESP & AutoFollow

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- GUI
local gui = Instance.new("ScreenGui",Player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

local frame = Instance.new("Frame",gui)
frame.Size = UDim2.new(0,220,0,320)
frame.Position = UDim2.new(0.05,0,0.25,0)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner",frame)

local title = Instance.new("TextLabel",frame)
title.Size = UDim2.new(1,0,0,28)
title.Text = "Tsubasa Hub"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

-- Button Maker
local y = 35
local function MakeBtn(text,func)
    local b = Instance.new("TextButton",frame)
    b.Size = UDim2.new(0,180,0,30)
    b.Position = UDim2.new(0,20,0,y)
    y = y + 38
    b.Text = text
    b.TextSize = 13
    b.BackgroundColor3 = Color3.fromRGB(70,70,70)
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner",b)
    b.MouseButton1Click:Connect(func)
    return b
end

------------------------------------------------
-- FLY
------------------------------------------------
local flying=false
local flyConn
local flySpeed=60

local function StartFly()
    local char = Player.Character
    if not char then return end
    local hrp = char:WaitForChild("HumanoidRootPart")
    local bv = Instance.new("BodyVelocity")
    bv.Name = "FlyBV"
    bv.MaxForce = Vector3.new(9e9,9e9,9e9)
    bv.Parent = hrp
    flyConn = RunService.RenderStepped:Connect(function()
        if not flying then return end
        bv.Velocity = Camera.CFrame.LookVector * flySpeed
    end)
end

local function StopFly()
    flying=false
    if flyConn then flyConn:Disconnect() end
    local char = Player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local bv = char.HumanoidRootPart:FindFirstChild("FlyBV")
        if bv then bv:Destroy() end
    end
end

------------------------------------------------
-- ESP + 名前
------------------------------------------------
local espOn=false
local espCache={}

local function AddESP(p)
    if p==Player then return end
    local function apply(char)
        if not espOn then return end
        if espCache[p] then return end
        local h = Instance.new("Highlight",char)
        h.FillColor = Color3.fromRGB(255,80,80)
        h.OutlineColor = Color3.new(1,1,1)
        h.Adornee = char

        local bill = Instance.new("BillboardGui",char)
        bill.Size = UDim2.new(0,120,0,28)
        bill.StudsOffset = Vector3.new(0,3,0)
        bill.AlwaysOnTop = true

        local t = Instance.new("TextLabel",bill)
        t.Size = UDim2.new(1,0,1,0)
        t.BackgroundTransparency = 1
        t.Text = p.Name
        t.TextScaled = true
        t.TextColor3 = Color3.new(1,1,1)

        espCache[p] = {h,bill}
    end
    if p.Character then apply(p.Character) end
    p.CharacterAdded:Connect(apply)
end

local function SetESP(on)
    espOn = on
    if on then
        for _,p in pairs(Players:GetPlayers()) do AddESP(p) end
    else
        for _,v in pairs(espCache) do
            if v[1] then v[1]:Destroy() end
            if v[2] then v[2]:Destroy() end
        end
        espCache={}
    end
end

------------------------------------------------
-- TELEPORT + AUTO FOLLOW
------------------------------------------------
local tpFrame
local followTarget=nil
local followConn=nil
local followOn=false
local FOLLOW_DISTANCE=4

local function StartFollow(p)
    StopFollow()
    followTarget=p
    followOn=true
    followConn = RunService.RenderStepped:Connect(function()
        if not followOn then return end
        if not followTarget then return end
        local myChar = Player.Character
        local tgtChar = followTarget.Character
        if not myChar or not tgtChar then return end
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        local tgtHRP = tgtChar:FindFirstChild("HumanoidRootPart")
        if not myHRP or not tgtHRP then return end
        myHRP.CFrame = myHRP.CFrame:Lerp(tgtHRP.CFrame*CFrame.new(0,0,-FOLLOW_DISTANCE),0.25)
    end)
end

local function StopFollow()
    followOn=false
    followTarget=nil
    if followConn then followConn:Disconnect() followConn=nil end
end

local function OpenTP()
    if tpFrame then tpFrame:Destroy() end
    tpFrame = Instance.new("Frame",gui)
    tpFrame.Size = UDim2.new(0,220,0,260)
    tpFrame.Position = UDim2.new(0.4,0,0.2,0)
    tpFrame.BackgroundColor3 = Color3.fromRGB(45,45,45)
    tpFrame.Active=true
    tpFrame.Draggable=true
    Instance.new("UICorner",tpFrame)

    local close = Instance.new("TextButton",tpFrame)
    close.Size = UDim2.new(0,45,0,22)
    close.Position = UDim2.new(1,-50,0,5)
    close.Text="X"
    close.BackgroundColor3=Color3.fromRGB(150,60,60)
    close.TextColor3=Color3.new(1,1,1)
    Instance.new("UICorner",close)
    close.MouseButton1Click:Connect(function()
        tpFrame:Destroy()
        tpFrame=nil
    end)

    local scroll = Instance.new("ScrollingFrame",tpFrame)
    scroll.Size=UDim2.new(1,-10,1,-35)
    scroll.Position = UDim2.new(0,5,0,30)
    scroll.BackgroundTransparency=1
    local layout = Instance.new("UIListLayout",scroll)
    layout.Padding=UDim.new(0,5)

    for _,p in pairs(Players:GetPlayers()) do
        if p~=Player then
            local b = Instance.new("TextButton",scroll)
            b.Size = UDim2.new(1,0,0,28)
            b.Text = p.Name
            b.TextSize = 13
            b.BackgroundColor3 = Color3.fromRGB(70,70,70)
            b.TextColor3 = Color3.new(1,1,1)
            Instance.new("UICorner",b)

            -- Tap = Teleport, LongPress = Follow
            b.MouseButton1Click:Connect(function()
                if Player.Character and p.Character then
                    Player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
                end
            end)

            -- Delta / Mobile long press detection
            local holding=false
            local holdTime=0
            b.InputBegan:Connect(function(input)
                if input.UserInputType==Enum.UserInputType.Touch then
                    holding=true
                    holdTime=0
                end
            end)
            b.InputEnded:Connect(function(input)
                if input.UserInputType==Enum.UserInputType.Touch then
                    holding=false
                    holdTime=0
                end
            end)
            RunService.RenderStepped:Connect(function(dt)
                if holding then
                    holdTime=holdTime+dt
                    if holdTime>=0.5 then
                        holding=false
                        holdTime=0
                        StartFollow(p)
                    end
                end
            end)
        end
    end
end

------------------------------------------------
-- BUTTONS
------------------------------------------------
local flyBtn = MakeBtn("Fly : OFF",function()
    flying=not flying
    if flying then
        flyBtn.Text="Fly : ON"
        StartFly()
    else
        flyBtn.Text="Fly : OFF"
        StopFly()
    end
end)

MakeBtn("Jump",function()
    local h = Player.Character and Player.Character:FindFirstChild("Humanoid")
    if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

MakeBtn("Teleport",function() OpenTP() end)

local espBtn = MakeBtn("ESP : OFF",function()
    espOn=not espOn
    espBtn.Text="ESP : "..(espOn and "ON" or "OFF")
    SetESP(espOn)
end)

MakeBtn("Stop Follow",function() StopFollow() end)

MakeBtn("Close",function() gui:Destroy() end)
