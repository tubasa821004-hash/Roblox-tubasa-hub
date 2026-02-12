-- Tsubasa Hub - Fixed Edition (Delta/Mobile)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer

------------------------------------------------
-- GUI
------------------------------------------------
local gui = Instance.new("ScreenGui", Player.PlayerGui)
gui.Name="TsubasaHub"
gui.ResetOnSpawn=false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,185,0,350)
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
-- Fly + Controller
------------------------------------------------
local flying=false
local flySpeed=65

local dir={F=false,B=false,L=false,R=false,U=false,D=false}
local bv,bg

-- Controller (上に移動済み)
local controller=Instance.new("Frame",gui)
controller.Size=UDim2.new(0,220,0,140)
controller.Position=UDim2.new(0.25,0,0.6,0) -- ← 上に変更
controller.BackgroundTransparency=1
controller.Visible=false

local function Pad(txt,x,y,key)

    local b=Instance.new("TextButton",controller)
    b.Size=UDim2.new(0,40,0,40)
    b.Position=UDim2.new(0,x,0,y)
    b.Text=txt
    b.TextSize=22
    b.BackgroundColor3=Color3.fromRGB(70,70,70)
    b.TextColor3=Color3.new(1,1,1)
    b.BorderSizePixel=0
    Instance.new("UICorner",b)

    b.MouseButton1Down:Connect(function()
        dir[key]=true
    end)

    b.MouseButton1Up:Connect(function()
        dir[key]=false
    end)
end

Pad("↑",50,0,"F")
Pad("↓",50,80,"B")
Pad("←",0,40,"L")
Pad("→",100,40,"R")
Pad("⤴",160,10,"U")
Pad("⤵",160,70,"D")

local function StartFly()

    local char=Player.Character
    if not char then return end
    local hrp=char:WaitForChild("HumanoidRootPart")

    bv=Instance.new("BodyVelocity",hrp)
    bv.MaxForce=Vector3.new(1e5,1e5,1e5)

    bg=Instance.new("BodyGyro",hrp)
    bg.MaxTorque=Vector3.new(1e5,1e5,1e5)
    bg.P=9e4

    RunService:BindToRenderStep("FlyMove",200,function()

        if not flying then return end

        local cam=workspace.CurrentCamera
        local v=Vector3.zero

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

    if UIS.TouchEnabled then
        controller.Visible=true
    end
end

local function StopFly()

    flying=false
    RunService:UnbindFromRenderStep("FlyMove")

    if bv then bv:Destroy() end
    if bg then bg:Destroy() end

    controller.Visible=false
end

------------------------------------------------
-- Invisible (強化版)
------------------------------------------------
local invisible=false
local saved={}

local function SetInvisible(on)

    local char=Player.Character
    if not char then return end

    if on then

        saved={}

        for _,v in pairs(char:GetDescendants()) do

            if v:IsA("BasePart") then
                saved[v]={v.Transparency,v.CanCollide}
                v.Transparency=1
                v.CanCollide=false
            end

            if v:IsA("Decal") then
                saved[v]=v.Transparency
                v.Transparency=1
            end
        end

    else

        for p,val in pairs(saved) do

            if p and p.Parent then

                if typeof(val)=="table" then
                    p.Transparency=val[1]
                    p.CanCollide=val[2]
                else
                    p.Transparency=val
                end
            end
        end

        saved={}
    end
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

        if noclipConn then
            noclipConn:Disconnect()
        end

        for _,v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide=true
            end
        end
    end
end

------------------------------------------------
-- ESP
------------------------------------------------
local esp=false
local espFolder=Instance.new("Folder",gui)

local function SetESP(on)

    espFolder:ClearAllChildren()

    if on then

        for _,p in pairs(Players:GetPlayers()) do

            if p~=Player and p.Character then

                local h=Instance.new("Highlight",espFolder)
                h.Adornee=p.Character
                h.FillColor=Color3.fromRGB(255,60,60)
                h.FillTransparency=0.5
            end
        end
    end
end

------------------------------------------------
-- Speed Toggle
------------------------------------------------
local speed=false
local normalSpeed=16
local fastSpeed=80

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

local invBtn
invBtn=MakeBtn("Invisible : OFF",70,function()

    invisible=not invisible
    invBtn.Text="Invisible : "..(invisible and "ON" or "OFF")

    SetInvisible(invisible)
end)

local nocBtn
nocBtn=MakeBtn("NoClip : OFF",105,function()

    noclip=not noclip
    nocBtn.Text="NoClip : "..(noclip and "ON" or "OFF")

    SetNoClip(noclip)
end)

local espBtn
espBtn=MakeBtn("ESP : OFF",140,function()

    esp=not esp
    espBtn.Text="ESP : "..(esp and "ON" or "OFF")

    SetESP(esp)
end)

local speedBtn
speedBtn=MakeBtn("Speed : OFF",175,function()

    speed=not speed

    local h=Player.Character and Player.Character:FindFirstChild("Humanoid")

    if h then
        if speed then
            h.WalkSpeed=fastSpeed
            speedBtn.Text="Speed : ON"
        else
            h.WalkSpeed=normalSpeed
            speedBtn.Text="Speed : OFF"
        end
    end
end)

MakeBtn("Jump",210,function()

    local h=Player.Character and Player.Character:FindFirstChild("Humanoid")

    if h then
        h:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

MakeBtn("Close",260,function()

    StopFly()
    SetInvisible(false)
    SetNoClip(false)
    SetESP(false)

    gui:Destroy()
end)
