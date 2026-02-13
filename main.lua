-- Tsubasa Hub Ultimate FULL (Key + Toggle + All Features)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer

------------------------------------------------
-- CONFIG
------------------------------------------------
local KEY = "tubasa82"
local TOGGLE_KEY = Enum.KeyCode.K

------------------------------------------------
-- KEY GUI
------------------------------------------------
local keyGui = Instance.new("ScreenGui", Player.PlayerGui)
keyGui.ResetOnSpawn = false

local keyFrame = Instance.new("Frame", keyGui)
keyFrame.Size = UDim2.new(0,260,0,160)
keyFrame.Position = UDim2.new(0.5,-130,0.5,-80)
keyFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
keyFrame.Active = true
keyFrame.Draggable = true
Instance.new("UICorner", keyFrame)

local keyTitle = Instance.new("TextLabel", keyFrame)
keyTitle.Size = UDim2.new(1,0,0,30)
keyTitle.BackgroundTransparency = 1
keyTitle.Text = "Tsubasa Hub Login"
keyTitle.TextColor3 = Color3.new(1,1,1)
keyTitle.TextSize = 16
keyTitle.Font = Enum.Font.SourceSansBold

local keyBox = Instance.new("TextBox", keyFrame)
keyBox.Size = UDim2.new(0,210,0,32)
keyBox.Position = UDim2.new(0.5,-105,0,45)
keyBox.PlaceholderText = "Enter Key"
keyBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
keyBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", keyBox)

local keyStatus = Instance.new("TextLabel", keyFrame)
keyStatus.Size = UDim2.new(1,0,0,20)
keyStatus.Position = UDim2.new(0,0,0,82)
keyStatus.BackgroundTransparency = 1
keyStatus.TextColor3 = Color3.fromRGB(255,80,80)
keyStatus.TextSize = 12

local keyBtn = Instance.new("TextButton", keyFrame)
keyBtn.Size = UDim2.new(0,120,0,28)
keyBtn.Position = UDim2.new(0.5,-60,0,110)
keyBtn.Text = "LOGIN"
keyBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
keyBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", keyBtn)

------------------------------------------------
-- MAIN GUI
------------------------------------------------
local gui = Instance.new("ScreenGui", Player.PlayerGui)
gui.Name = "TsubasaHub"
gui.Enabled = false
gui.ResetOnSpawn = false

------------------------------------------------
-- LOGIN
------------------------------------------------
local logged = false

keyBtn.MouseButton1Click:Connect(function()

	if keyBox.Text == KEY then
		logged = true
		keyGui:Destroy()
		gui.Enabled = true
	else
		keyStatus.Text = "Wrong Key!"
		keyBox.Text = ""
	end
end)

------------------------------------------------
-- TOGGLE (K)
------------------------------------------------
local menuOpen = true

UIS.InputBegan:Connect(function(input,gp)

	if gp then return end
	if not logged then return end

	if input.KeyCode == TOGGLE_KEY then
		menuOpen = not menuOpen
		gui.Enabled = menuOpen
	end
end)

------------------------------------------------
-- MAIN FRAME
------------------------------------------------
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
-- BUTTON MAKER
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
-- FLY
------------------------------------------------
local flying=false
local flySpeed=65
local dir={F=false,B=false,L=false,R=false,U=false,D=false}
local bv,bg

local controller=Instance.new("Frame",gui)
controller.Size=UDim2.new(0,200,0,160)
controller.Position=UDim2.new(0.25,0,0.58,0)
controller.BackgroundTransparency=1
controller.Visible=false

local function Pad(t,x,y,f)

	local b=Instance.new("TextButton",controller)
	b.Size=UDim2.new(0,40,0,40)
	b.Position=UDim2.new(0,x,0,y)
	b.Text=t
	b.TextSize=22
	b.BackgroundColor3=Color3.fromRGB(70,70,70)
	b.TextColor3=Color3.new(1,1,1)
	Instance.new("UICorner",b)

	b.MouseButton1Down:Connect(function()dir[f]=true end)
	b.MouseButton1Up:Connect(function()dir[f]=false end)
end

Pad("↑",60,0,"F")
Pad("↓",60,80,"B")
Pad("←",10,40,"L")
Pad("→",110,40,"R")
Pad("⤴",160,10,"U")
Pad("⤵",160,90,"D")

local function StartFly()

	local c=Player.Character
	if not c then return end

	local hrp=c:WaitForChild("HumanoidRootPart")

	bv=Instance.new("BodyVelocity",hrp)
	bv.MaxForce=Vector3.new(1e5,1e5,1e5)

	bg=Instance.new("BodyGyro",hrp)
	bg.MaxTorque=Vector3.new(1e5,1e5,1e5)
	bg.P=9e4

	RunService:BindToRenderStep("Fly",200,function()

		if not flying then return end

		local cam=workspace.CurrentCamera
		local v=Vector3.zero

		if dir.F then v+=cam.CFrame.LookVector end
		if dir.B then v-=cam.CFrame.LookVector end
		if dir.L then v-=cam.CFrame.RightVector end
		if dir.R then v+=cam.CFrame.RightVector end
		if dir.U then v+=cam.CFrame.UpVector end
		if dir.D then v-=cam.CFrame.UpVector end

		if v.Magnitude>0 then v=v.Unit*flySpeed end

		bv.Velocity=v
		bg.CFrame=cam.CFrame
	end)

	controller.Visible=true
end

local function StopFly()

	flying=false
	RunService:UnbindFromRenderStep("Fly")

	if bv then bv:Destroy() end
	if bg then bg:Destroy() end

	controller.Visible=false
end

------------------------------------------------
-- NOCLIP
------------------------------------------------
local noclip=false
local noclipConn

local function SetNoClip(on)

	local c=Player.Character
	if not c then return end

	if on then

		noclipConn=RunService.Stepped:Connect(function()

			for _,v in pairs(c:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide=false
				end
			end
		end)

	else

		if noclipConn then noclipConn:Disconnect() end

		for _,v in pairs(c:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide=true
			end
		end
	end
end

------------------------------------------------
-- SPEED
------------------------------------------------
local speedOn=false
local normal=16
local fast=80

------------------------------------------------
-- CLONE CAM
------------------------------------------------
local cloneOn=false
local cloneChar=nil
local followConn=nil
local oldCam=nil

local function SetClone(on)

	local cam=workspace.CurrentCamera
	local c=Player.Character
	if not c then return end

	if on then

		oldCam=cam.CameraSubject

		cloneChar=c:Clone()
		cloneChar.Parent=workspace

		for _,v in pairs(cloneChar:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Transparency=1
				v.Anchored=true
				v.CanCollide=false
			end
		end

		cam.CameraSubject=cloneChar.HumanoidRootPart

		followConn=RunService.RenderStepped:Connect(function()

			if cloneOn and c and cloneChar then
				cloneChar.HumanoidRootPart.CFrame=
					c.HumanoidRootPart.CFrame
			end
		end)

	else

		if oldCam then cam.CameraSubject=oldCam end
		if followConn then followConn:Disconnect() end
		if cloneChar then cloneChar:Destroy() end
	end
end

------------------------------------------------
-- ESP
------------------------------------------------
local espOn=false
local espCache={}

local function AddESP(p)

	if p==Player or espCache[p] then return end

	local function Apply(char)

		if not espOn then return end

		local h=Instance.new("Highlight")
		h.FillColor=Color3.fromRGB(255,80,80)
		h.OutlineColor=Color3.new(1,1,1)
		h.Adornee=char
		h.Parent=char

		espCache[p]=h
	end

	if p.Character then Apply(p.Character) end
	p.CharacterAdded:Connect(Apply)
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

------------------------------------------------
-- TELEPORT
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

	local scroll=Instance.new("ScrollingFrame",tpFrame)
	scroll.Size=UDim2.new(1,-10,1,-10)
	scroll.Position=UDim2.new(0,5,0,5)
	scroll.BackgroundTransparency=1

	local layout=Instance.new("UIListLayout",scroll)

	for _,p in pairs(Players:GetPlayers()) do

		if p~=Player then

			local b=Instance.new("TextButton",scroll)
			b.Size=UDim2.new(1,0,0,28)
			b.Text=p.Name
			b.BackgroundColor3=Color3.fromRGB(65,65,65)
			b.TextColor3=Color3.new(1,1,1)
			Instance.new("UICorner",b)

			b.MouseButton1Click:Connect(function()

				if Player.Character and p.Character then
					Player.Character.HumanoidRootPart.CFrame=
						p.Character.HumanoidRootPart.CFrame
				end
			end)
		end
	end
end

------------------------------------------------
-- BUTTONS
------------------------------------------------
local flyBtn=MakeBtn("Fly : OFF",35,function()

	flying=not flying

	if flying then
		flyBtn.Text="Fly : ON"
		StartFly()
	else
		flyBtn.Text="Fly : OFF"
		StopFly()
	end
end)

local nocBtn=MakeBtn("NoClip : OFF",70,function()

	noclip=not noclip
	nocBtn.Text="NoClip : "..(noclip and "ON" or "OFF")

	SetNoClip(noclip)
end)

local speedBtn=MakeBtn("Speed : OFF",105,function()

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
	if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

local cloneBtn=MakeBtn("CloneCam : OFF",175,function()

	cloneOn=not cloneOn
	cloneBtn.Text="CloneCam : "..(cloneOn and "ON" or "OFF")
	SetClone(cloneOn)
end)

MakeBtn("Teleport",210,function()
	ToggleTP()
end)

local espBtn=MakeBtn("ESP : OFF",245,function()

	espOn=not espOn
	espBtn.Text="ESP : "..(espOn and "ON" or "OFF")

	SetESP(espOn)
end)

MakeBtn("Close",300,function()

	StopFly()
	SetNoClip(false)
	SetClone(false)
	SetESP(false)

	gui.Enabled=false
end)
