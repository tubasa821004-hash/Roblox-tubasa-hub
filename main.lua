-- Tsubasa Hub Ultimate (Delta / Mobile)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

------------------------------------------------
-- GUI
------------------------------------------------

local gui = Instance.new("ScreenGui",Player.PlayerGui)
gui.Name="TsubasaHub"
gui.ResetOnSpawn=false

local frame = Instance.new("Frame",gui)
frame.Size=UDim2.new(0,190,0,400)
frame.Position=UDim2.new(0.05,0,0.2,0)
frame.BackgroundColor3=Color3.fromRGB(35,35,35)
frame.Active=true
frame.Draggable=true
Instance.new("UICorner",frame)

local title = Instance.new("TextLabel",frame)
title.Size=UDim2.new(1,0,0,30)
title.Text="Tsubasa Hub"
title.BackgroundTransparency=1
title.TextColor3=Color3.new(1,1,1)
title.Font=Enum.Font.SourceSansBold
title.TextSize=15

------------------------------------------------
-- Button Maker
------------------------------------------------

local function MakeBtn(txt,y,func)

	local b=Instance.new("TextButton",frame)
	b.Size=UDim2.new(0,160,0,28)
	b.Position=UDim2.new(0,15,0,y)
	b.Text=txt
	b.TextSize=13
	b.BackgroundColor3=Color3.fromRGB(60,60,60)
	b.TextColor3=Color3.new(1,1,1)
	b.BorderSizePixel=0
	Instance.new("UICorner",b)

	b.MouseButton1Click:Connect(func)

	return b
end

------------------------------------------------
-- Fly
------------------------------------------------

local flying=false
local flySpeed=70
local bv,bg

local dir={F=false,B=false,L=false,R=false,U=false,D=false}

UIS.InputBegan:Connect(function(i,g)
	if g then return end

	if i.KeyCode==Enum.KeyCode.W then dir.F=true end
	if i.KeyCode==Enum.KeyCode.S then dir.B=true end
	if i.KeyCode==Enum.KeyCode.A then dir.L=true end
	if i.KeyCode==Enum.KeyCode.D then dir.R=true end
	if i.KeyCode==Enum.KeyCode.Space then dir.U=true end
	if i.KeyCode==Enum.KeyCode.LeftControl then dir.D=true end
end)

UIS.InputEnded:Connect(function(i)
	if i.KeyCode==Enum.KeyCode.W then dir.F=false end
	if i.KeyCode==Enum.KeyCode.S then dir.B=false end
	if i.KeyCode==Enum.KeyCode.A then dir.L=false end
	if i.KeyCode==Enum.KeyCode.D then dir.R=false end
	if i.KeyCode==Enum.KeyCode.Space then dir.U=false end
	if i.KeyCode==Enum.KeyCode.LeftControl then dir.D=false end
end)

local function StartFly()

	local char=Player.Character
	if not char then return end

	local hrp=char:WaitForChild("HumanoidRootPart")

	bv=Instance.new("BodyVelocity",hrp)
	bv.MaxForce=Vector3.new(1e5,1e5,1e5)

	bg=Instance.new("BodyGyro",hrp)
	bg.MaxTorque=Vector3.new(1e5,1e5,1e5)
	bg.P=9e4

	RunService:BindToRenderStep("Fly",200,function()

		if not flying then return end

		local v=Vector3.zero

		if dir.F then v+=Camera.CFrame.LookVector end
		if dir.B then v-=Camera.CFrame.LookVector end
		if dir.L then v-=Camera.CFrame.RightVector end
		if dir.R then v+=Camera.CFrame.RightVector end
		if dir.U then v+=Camera.CFrame.UpVector end
		if dir.D then v-=Camera.CFrame.UpVector end

		if v.Magnitude>0 then
			v=v.Unit*flySpeed
		end

		bv.Velocity=v
		bg.CFrame=Camera.CFrame
	end)
end

local function StopFly()

	flying=false
	RunService:UnbindFromRenderStep("Fly")

	if bv then bv:Destroy() end
	if bg then bg:Destroy() end
end

------------------------------------------------
-- Jump
------------------------------------------------

local function Jump()
	local h=Player.Character and Player.Character:FindFirstChild("Humanoid")
	if h then
		h:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end

------------------------------------------------
-- ESP (Name)
------------------------------------------------

local espOn=false
local espCache={}

local function AddESP(plr)

	if plr==Player then return end
	if espCache[plr] then return end

	local function Apply(char)

		if not espOn then return end

		local bill=Instance.new("BillboardGui",char)
		bill.Size=UDim2.new(0,100,0,30)
		bill.AlwaysOnTop=true
		bill.Name="ESP"

		local txt=Instance.new("TextLabel",bill)
		txt.Size=UDim2.new(1,0,1,0)
		txt.BackgroundTransparency=1
		txt.Text=plr.Name
		txt.TextColor3=Color3.new(1,0,0)
		txt.TextScaled=true

		bill.Parent=char.Head

		espCache[plr]=bill
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

------------------------------------------------
-- Teleport Menu
------------------------------------------------

local tpFrame=nil

local function ToggleTP()

	if tpFrame then
		tpFrame:Destroy()
		tpFrame=nil
		return
	end

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
	scroll.CanvasSize=UDim2.new(0,0,0,0)
	scroll.BackgroundTransparency=1

	local layout=Instance.new("UIListLayout",scroll)

	for _,p in pairs(Players:GetPlayers()) do

		if p~=Player then

			local b=Instance.new("TextButton",scroll)
			b.Size=UDim2.new(1,-5,0,28)
			b.Text=p.Name
			b.BackgroundColor3=Color3.fromRGB(70,70,70)
			b.TextColor3=Color3.new(1,1,1)
			Instance.new("UICorner",b)

			b.MouseButton1Click:Connect(function()

				if Player.Character and p.Character then

					local a=Player.Character:FindFirstChild("HumanoidRootPart")
					local t=p.Character:FindFirstChild("HumanoidRootPart")

					if a and t then
						a.CFrame=t.CFrame*CFrame.new(0,0,2)
					end
				end
			end)
		end
	end

	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		scroll.CanvasSize=UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+5)
	end)
end

------------------------------------------------
-- Follow (Circle)
------------------------------------------------

local followOn=false
local followTarget=nil
local followConn=nil
local angle=0

local function StartFollow(plr)

	if followConn then followConn:Disconnect() end

	followTarget=plr
	followOn=true
	angle=0

	followConn=RunService.RenderStepped:Connect(function(dt)

		if not followOn then return end
		if not Player.Character then return end
		if not followTarget then return end
		if not followTarget.Character then return end

		local my=Player.Character:FindFirstChild("HumanoidRootPart")
		local tg=followTarget.Character:FindFirstChild("HumanoidRootPart")

		if my and tg then

			angle += dt*2

			local r=5
			local x=math.cos(angle)*r
			local z=math.sin(angle)*r

			my.CFrame =
				tg.CFrame * CFrame.new(x,0,z)
		end
	end)
end

local function StopFollow()

	followOn=false
	followTarget=nil

	if followConn then
		followConn:Disconnect()
		followConn=nil
	end
end

------------------------------------------------
-- Follow Menu
------------------------------------------------

local function OpenFollowMenu()

	local f=Instance.new("Frame",gui)
	f.Size=UDim2.new(0,200,0,250)
	f.Position=UDim2.new(0.45,0,0.3,0)
	f.BackgroundColor3=Color3.fromRGB(40,40,40)
	f.Active=true
	f.Draggable=true
	Instance.new("UICorner",f)

	local scroll=Instance.new("ScrollingFrame",f)
	scroll.Size=UDim2.new(1,-10,1,-10)
	scroll.Position=UDim2.new(0,5,0,5)
	scroll.BackgroundTransparency=1

	local layout=Instance.new("UIListLayout",scroll)

	for _,p in pairs(Players:GetPlayers()) do

		if p~=Player then

			local b=Instance.new("TextButton",scroll)
			b.Size=UDim2.new(1,-5,0,28)
			b.Text=p.Name
			b.BackgroundColor3=Color3.fromRGB(70,70,70)
			b.TextColor3=Color3.new(1,1,1)
			Instance.new("UICorner",b)

			b.MouseButton1Click:Connect(function()
				StartFollow(p)
				f:Destroy()
			end)
		end
	end
end

------------------------------------------------
-- Buttons
------------------------------------------------

local flyBtn
flyBtn=MakeBtn("Fly : OFF",40,function()

	flying=not flying

	if flying then
		flyBtn.Text="Fly : ON"
		StartFly()
	else
		flyBtn.Text="Fly : OFF"
		StopFly()
	end
end)

MakeBtn("Jump",75,function()
	Jump()
end)

MakeBtn("Teleport",110,function()
	ToggleTP()
end)

local espBtn
espBtn=MakeBtn("ESP : OFF",145,function()

	espOn=not espOn
	espBtn.Text="ESP : "..(espOn and "ON" or "OFF")

	SetESP(espOn)
end)

MakeBtn("Follow Player",180,function()
	OpenFollowMenu()
end)

MakeBtn("Follow OFF",215,function()
	StopFollow()
end)

MakeBtn("Close",260,function()

	StopFly()
	StopFollow()
	SetESP(false)

	gui:Destroy()
end)
