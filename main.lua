-- Tsubasa Hub Ultimate Full Pack (Delta/Mobile)

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
frame.Size = UDim2.new(0,185,0,360)
frame.Position = UDim2.new(0.05,0,0.22,0)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.Active = true
frame.Draggable = true
frame.BorderSizePixel = 0
Instance.new("UICorner",frame)

local title = Instance.new("TextLabel",frame)
title.Size = UDim2.new(1,0,0,28)
title.BackgroundTransparency = 1
title.Text = "Tsubasa Hub"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 15
title.Font = Enum.Font.SourceSansBold

------------------------------------------------
-- Button Maker
------------------------------------------------
local function MakeBtn(text,y,func)

    local b = Instance.new("TextButton",frame)
    b.Size = UDim2.new(0,155,0,26)
    b.Position = UDim2.new(0,15,0,y)
    b.Text = text
    b.TextSize = 13
    b.BackgroundColor3 = Color3.fromRGB(60,60,60)
    b.TextColor3 = Color3.new(1,1,1)
    b.BorderSizePixel = 0
    Instance.new("UICorner",b)

    b.MouseButton1Click:Connect(func)
    return b
end

------------------------------------------------
-- Fly System
------------------------------------------------
local flying = false
local flySpeed = 65

local dir = {F=false,B=false,L=false,R=false,U=false,D=false}

local bv,bg

------------------------------------------------
-- Fly Controller
------------------------------------------------
local controller = Instance.new("Frame",gui)
controller.Size = UDim2.new(0,200,0,160)
controller.Position = UDim2.new(0.25,0,0.58,0)
controller.BackgroundTransparency = 1
controller.Visible = false

local function MakePad(txt,x,y,flag)

    local b = Instance.new("TextButton",controller)
    b.Size = UDim2.new(0,40,0,40)
    b.Position = UDim2.new(0,x,0,y)
    b.Text = txt
    b.TextSize = 22
    b.BackgroundColor3 = Color3.fromRGB(70,70,70)
    b.TextColor3 = Color3.new(1,1,1)
    b.BorderSizePixel = 0
    Instance.new("UICorner",b)

    b.MouseButton1Down:Connect(function()
        dir[flag]=true
    end)

    b.MouseButton1Up:Connect(function()
        dir[flag]=false
    end)

    return b
end

-- Move
MakePad("↑",60,0,"F")
MakePad("↓",60,80,"B")
MakePad("←",10,40,"L")
MakePad("→",110,40,"R")

-- Up / Down
MakePad("⤴",160,10,"U")
MakePad("⤵",160,90,"D")

------------------------------------------------
-- Fly Logic
------------------------------------------------
local function StartFly()

    local char = Player.Character
    if not char then return end

    local hrp = char:WaitForChild("HumanoidRootPart")

    bv = Instance.new("BodyVelocity",hrp)
    bv.MaxForce = Vector3.new(1e5,1e5,1e5)

    bg = Instance.new("BodyGyro",hrp)
    bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
    bg.P = 9e4

    RunService:BindToRenderStep("FlyMove",200,function()

        if not flying then return end

        local cam = workspace.CurrentCamera
        local v = Vector3.zero

        if dir.F then v+=cam.CFrame.LookVector end
        if dir.B then v-=cam.CFrame.LookVector end
        if dir.L then v-=cam.CFrame.RightVector end
        if dir.R then v+=cam.CFrame.RightVector end
        if dir.U then v+=cam.CFrame.UpVector end
        if dir.D then v-=cam.CFrame.UpVector end

        if v.Magnitude>0 then
            v=v.Unit*flySpeed
        end

        bv.Velocity=v
        bg.CFrame=cam.CFrame
    end)

    controller.Visible=true
end

local function StopFly()

    flying=false
    RunService:UnbindFromRenderStep("FlyMove")

    if bv then bv:Destroy() end
    if bg then bg:Destroy() end

    controller.Visible=false
end

------------------------------------------------
-- NoClip
------------------------------------------------
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

------------------------------------------------
-- Speed
------------------------------------------------
local speedOn=false
local normal=16
local fast=80

------------------------------------------------
-- Clone Camera (Follow)
------------------------------------------------
local cloneOn=false
local cloneChar=nil
local followConn=nil
local oldCam=nil

local function SetCloneCam(on)

    local cam=workspace.CurrentCamera
    local char=Player.Character
    if not char then return end

    if on then

        if cloneChar then return end

        oldCam=cam.CameraSubject

        cloneChar=char:Clone()
        cloneChar.Name="FollowClone"
        cloneChar.Parent=workspace

        for _,v in pairs(cloneChar:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Transparency=1
                v.CanCollide=false
                v.Anchored=true
            elseif v:IsA("Decal") then
                v.Transparency=1
            end
        end

        local hrp=cloneChar:FindFirstChild("HumanoidRootPart")
        if hrp then
            cam.CameraSubject=hrp
        end

        followConn=RunService.RenderStepped:Connect(function()

            if not cloneOn then return end

            if Player.Character and cloneChar and
               Player.Character:FindFirstChild("HumanoidRootPart") and
               cloneChar:FindFirstChild("HumanoidRootPart") then

                cloneChar.HumanoidRootPart.CFrame =
                    Player.Character.HumanoidRootPart.CFrame
            end
        end)

    else

        if oldCam then
            cam.CameraSubject=oldCam
        end

        if followConn then
            followConn:Disconnect()
            followConn=nil
        end

        if cloneChar then
            cloneChar:Destroy()
            cloneChar=nil
        end
    end
end

------------------------------------------------
-- ESP System
------------------------------------------------
local espOn=false
local espCache={}

local function AddESP(plr)

    if plr==Player then return end
    if espCache[plr] then return end

    local function Apply(char)

        if not espOn then return end
        if not char then return end

        local hl=Instance.new("Highlight")
        hl.FillColor=Color3.fromRGB(255,80,80)
        hl.OutlineColor=Color3.new(1,1,1)
        hl.FillTransparency=0.5
        hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
        hl.Adornee=char
        hl.Parent=char

        espCache[plr]=hl
    end

    if plr.Character then
        Apply(plr.Character)
    end

    plr.CharacterAdded:Connect(Apply)
end

local function SetESP(on)

    espOn=on

    if on then
        for _,p in pairs(Players:GetPlayers()) do
            AddESP(p)
        end
    else
        for _,v in pairs(espCache) do
            if v then v:Destroy() end
        end
        espCache={}
    end
end

Players.PlayerAdded:Connect(function(p)
    if espOn then AddESP(p) end
end)

Players.PlayerRemoving:Connect(function(p)
    if espCache[p] then
        espCache[p]:Destroy()
        espCache[p]=nil
    end
end)

------------------------------------------------
-- Teleport Menu
------------------------------------------------
local tpFrame=nil
local tpOpen=false

local function ToggleTP()

    tpOpen=not tpOpen

    if not tpOpen then
        if tpFrame then tpFrame:Destroy() end
        return
    end

    if tpFrame then tpFrame:Destroy() end

    tpFrame=Instance.new("Frame",gui)
    tpFrame.Size=UDim2.new(0,200,0,250)
    tpFrame.Position=UDim2.new(0.4,0,0.25,0)
    tpFrame.BackgroundColor3=Color3.fromRGB(40,40,40)
    tpFrame.Active=true
    tpFrame.Draggable=true
    Instance.new("UICorner",tpFrame)

    local t=Instance.new("TextLabel",tpFrame)
    t.Size=UDim2.new(1,0,0,30)
    t.BackgroundTransparency=1
    t.Text="Teleport Players"
    t.TextColor3=Color3.new(1,1,1)
    t.TextSize=14

    local scroll=Instance.new("ScrollingFrame",tpFrame)
    scroll.Size=UDim2.new(1,-10,1,-40)
    scroll.Position=UDim2.new(0,5,0,35)
    scroll.CanvasSize=UDim2.new(0,0,0,0)
    scroll.BackgroundTransparency=1

    local layout=Instance.new("UIListLayout",scroll)
    layout.Padding=UDim.new(0,5)

    for _,p in pairs(Players:GetPlayers()) do

        if p~=Player then

            local b=Instance.new("TextButton",scroll)
            b.Size=UDim2.new(1,-5,0,28)
            b.Text=p.Name
            b.TextSize=13
            b.BackgroundColor3=Color3.fromRGB(65,65,65)
            b.TextColor3=Color3.new(1,1,1)
            Instance.new("UICorner",b)

            b.MouseButton1Click:Connect(function()

                if Player.Character and p.Character and
                   Player.Character:FindFirstChild("HumanoidRootPart") and
                   p.Character:FindFirstChild("HumanoidRootPart") then

                    Player.Character.HumanoidRootPart.CFrame =
                        p.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,2)
                end
            end)
        end
    end

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize=UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+5)
    end)
end

------------------------------------------------
-- Buttons
------------------------------------------------
local flyBtn
flyBtn=MakeBtn("Fly : OFF",35,function()

    flying=not flying

    if flying then
        flyBtn.Text="Fly : ON"
        StartFly()
    else
        flyBtn.Text="Fly : OFF"
        StopFly()
    end
end)

local nocBtn
nocBtn=MakeBtn("NoClip : OFF",70,function()

    noclip=not noclip
    nocBtn.Text="NoClip : "..(noclip and "ON" or "OFF")

    SetNoClip(noclip)
end)

local speedBtn
speedBtn=MakeBtn("Speed : OFF",105,function()

    speedOn=not speedOn

    local h=Player.Character and Player.Character:FindFirstChild("Humanoid")

    if h then
        if speedOn then
            h.WalkSpeed=fast
            speedBtn.Text="Speed : ON"
        else
            h.WalkSpeed=normal
            speedBtn.Text="Speed : OFF"
        end
    end
end)

MakeBtn("Jump",140,function()

    local h=Player.Character and Player.Character:FindFirstChild("Humanoid")

    if h then
        h:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

local cloneBtn
cloneBtn=MakeBtn("CloneCam : OFF",175,function()

    cloneOn=not cloneOn

    if cloneOn then
        cloneBtn.Text="CloneCam : ON"
        SetCloneCam(true)
    else
        cloneBtn.Text="CloneCam : OFF"
        SetCloneCam(false)
    end
end)

local tpBtn
tpBtn=MakeBtn("Teleport",210,function()
    ToggleTP()
end)

local espBtn
espBtn=MakeBtn("ESP : OFF",245,function()

    espOn=not espOn
    espBtn.Text="ESP : "..(espOn and "ON" or "OFF")

    SetESP(espOn)
end)

MakeBtn("Close",285,function()

    StopFly()
    SetNoClip(false)
    SetCloneCam(false)
    SetESP(false)

    gui:Destroy()
end)
