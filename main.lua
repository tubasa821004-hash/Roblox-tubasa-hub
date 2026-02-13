-- Tsubasa Hub Stable Edition (Fly / ESP / TP Fixed)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer

------------------------------------------------
-- CONFIG
------------------------------------------------
local KEY = "tubasa82"
local TOGGLE_KEY = Enum.KeyCode.K
local FLY_SPEED = 70

------------------------------------------------
-- KEY GUI
------------------------------------------------
local keyGui = Instance.new("ScreenGui", Player.PlayerGui)

local keyFrame = Instance.new("Frame", keyGui)
keyFrame.Size = UDim2.new(0,240,0,150)
keyFrame.Position = UDim2.new(0.5,-120,0.5,-75)
keyFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
keyFrame.Active = true
keyFrame.Draggable = true
Instance.new("UICorner", keyFrame)

local keyTitle = Instance.new("TextLabel", keyFrame)
keyTitle.Size = UDim2.new(1,0,0,30)
keyTitle.Text = "Tsubasa Hub Login"
keyTitle.BackgroundTransparency = 1
keyTitle.TextColor3 = Color3.new(1,1,1)

local keyBox = Instance.new("TextBox", keyFrame)
keyBox.Size = UDim2.new(0,200,0,30)
keyBox.Position = UDim2.new(0.5,-100,0,45)
keyBox.PlaceholderText = "Enter Key"
keyBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
keyBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", keyBox)

local keyStatus = Instance.new("TextLabel", keyFrame)
keyStatus.Size = UDim2.new(1,0,0,20)
keyStatus.Position = UDim2.new(0,0,0,80)
keyStatus.BackgroundTransparency = 1
keyStatus.TextColor3 = Color3.fromRGB(255,80,80)

local keyBtn = Instance.new("TextButton", keyFrame)
keyBtn.Size = UDim2.new(0,120,0,28)
keyBtn.Position = UDim2.new(0.5,-60,0,105)
keyBtn.Text = "LOGIN"
keyBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
keyBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", keyBtn)

------------------------------------------------
-- MAIN GUI
------------------------------------------------
local gui = Instance.new("ScreenGui", Player.PlayerGui)
gui.Enabled = false

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
local open = true

UIS.InputBegan:Connect(function(input,gp)

	if gp then return end
	if not logged then return end

	if input.KeyCode == TOGGLE_KEY then
		open = not open
		gui.Enabled = open
	end
end)

------------------------------------------------
-- MAIN FRAME
------------------------------------------------
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,200,0,320)
frame.Position = UDim2.new(0.05,0,0.25,0)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner",frame)

local title = Instance.new("TextLabel",frame)
title.Size = UDim2.new(1,0,0,28)
title.Text = "Tsubasa Hub"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)

------------------------------------------------
-- BUTTON MAKER
------------------------------------------------
local y = 35

local function MakeBtn(text,func)

	local b = Instance.new("TextButton",frame)
	b.Size = UDim2.new(0,160,0,28)
	b.Position = UDim2.new(0,20,0,y)
	y = y + 35

	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(60,60,60)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner",b)

	b.MouseButton1Click:Connect(func)
	return b
end

------------------------------------------------
-- FLY (FULL CONTROL)
------------------------------------------------
local flying = false
local bv,bg
local keys = {W=false,S=false,A=false,D=false,Q=false,E=false}

UIS.InputBegan:Connect(function(i,gp)
	if gp then return end

	if keys[i.KeyCode] ~= nil then
		keys[i.KeyCode] = true
	end
end)

UIS.InputEnded:Connect(function(i)
	if keys[i.KeyCode] ~= nil then
		keys[i.KeyCode] = false
	end
end)

local function StartFly()

	local c = Player.Character
	if not c then return end

	local hrp = c:WaitForChild("HumanoidRootPart")

	bv = Instance.new("BodyVelocity",hrp)
	bv.MaxForce = Vector3.new(9e9,9e9,9e9)

	bg = Instance.new("BodyGyro",hrp)
	bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
	bg.P = 9e4

	RunService:BindToRenderStep("Fly",201,function()

		if not flying then return end

		local cam = workspace.CurrentCamera
		local v = Vector3.zero

		if keys.W then v += cam.CFrame.LookVector end
		if keys.S then v -= cam.CFrame.LookVector end
		if keys.A then v -= cam.CFrame.RightVector end
		if keys.D then v += cam.CFrame.RightVector end
		if keys.E then v += cam.CFrame.UpVector end
		if keys.Q then v -= cam.CFrame.UpVector end

		if v.Magnitude > 0 then
			v = v.Unit * FLY_SPEED
		end

		bv.Velocity = v
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
-- ESP (STABLE)
------------------------------------------------
local espOn = false
local espCache = {}

local function ApplyESP(p)

	if p == Player then return end

	local function add(char)

		if not espOn then return end

		if espCache[p] then return end

		local h = Instance.new("Highlight")
		h.FillColor = Color3.fromRGB(255,70,70)
		h.OutlineColor = Color3.new(1,1,1)
		h.Adornee = char
		h.Parent = char

		local bill = Instance.new("BillboardGui",char)
		bill.Size = UDim2.new(0,100,0,25)
		bill.StudsOffset = Vector3.new(0,3,0)
		bill.AlwaysOnTop = true

		local t = Instance.new("TextLabel",bill)
		t.Size = UDim2.new(1,0,1,0)
		t.BackgroundTransparency = 1
		t.Text = p.Name
		t.TextColor3 = Color3.new(1,1,1)
		t.TextScaled = true

		espCache[p] = {h,bill}
	end

	if p.Character then add(p.Character) end
	p.CharacterAdded:Connect(add)
end

local function SetESP(on)

	espOn = on

	if on then
		for _,p in pairs(Players:GetPlayers()) do
			ApplyESP(p)
		end
	else
		for _,v in pairs(espCache) do
			if v then
				if v[1] then v[1]:Destroy() end
				if v[2] then v[2]:Destroy() end
			end
		end
		espCache = {}
	end
end

------------------------------------------------
-- TELEPORT (TOGGLE)
------------------------------------------------
local tpFrame
local tpOpen = false

local function ToggleTP()

	tpOpen = not tpOpen

	if not tpOpen then
		if tpFrame then tpFrame:Destroy() end
		return
	end

	if tpFrame then tpFrame:Destroy() end

	tpFrame = Instance.new("Frame",gui)
	tpFrame.Size = UDim2.new(0,200,0,260)
	tpFrame.Position = UDim2.new(0.4,0,0.25,0)
	tpFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
	tpFrame.Active = true
	tpFrame.Draggable = true
	Instance.new("UICorner",tpFrame)

	local close = Instance.new("TextButton",tpFrame)
	close.Size = UDim2.new(0,60,0,24)
	close.Position = UDim2.new(1,-65,0,5)
	close.Text = "X"
	close.BackgroundColor3 = Color3.fromRGB(150,60,60)
	close.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner",close)

	close.MouseButton1Click:Connect(function()
		ToggleTP()
	end)

	local scroll = Instance.new("ScrollingFrame",tpFrame)
	scroll.Size = UDim2.new(1,-10,1,-35)
	scroll.Position = UDim2.new(0,5,0,30)
	scroll.BackgroundTransparency = 1

	local layout = Instance.new("UIListLayout",scroll)

	for _,p in pairs(Players:GetPlayers()) do

		if p ~= Player then

			local b = Instance.new("TextButton",scroll)
			b.Size = UDim2.new(1,0,0,28)
			b.Text = p.Name
			b.BackgroundColor3 = Color3.fromRGB(65,65,65)
			b.TextColor3 = Color3.new(1,1,1)
			Instance.new("UICorner",b)

			b.MouseButton1Click:Connect(function()

				if Player.Character and p.Character then

					Player.Character.HumanoidRootPart.CFrame =
						p.Character.HumanoidRootPart.CFrame
				end
			end)
		end
	end
end

------------------------------------------------
-- BUTTONS
------------------------------------------------
local flyBtn = MakeBtn("Fly : OFF",function()

	flying = not flying

	if flying then
		flyBtn.Text = "Fly : ON"
		StartFly()
	else
		flyBtn.Text = "Fly : OFF"
		StopFly()
	end
end)

MakeBtn("Jump",function()

	local h = Player.Character and Player.Character:FindFirstChild("Humanoid")
	if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

MakeBtn("Teleport",function()
	ToggleTP()
end)

local espBtn = MakeBtn("ESP : OFF",function()

	espOn = not espOn
	espBtn.Text = "ESP : "..(espOn and "ON" or "OFF")
	SetESP(espOn)
end)

MakeBtn("Close",function()
	gui.Enabled = false
end)
