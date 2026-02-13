-- Tsubasa Hub Mobile + PC Compatible

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

------------------------------------------------
-- CONFIG
------------------------------------------------
local KEY = "tubasa82"
local TOGGLE_KEY = Enum.KeyCode.K
local FLY_SPEED = 60

------------------------------------------------
-- LOGIN GUI
------------------------------------------------
local keyGui = Instance.new("ScreenGui", Player.PlayerGui)

local keyFrame = Instance.new("Frame", keyGui)
keyFrame.Size = UDim2.new(0,260,0,170)
keyFrame.Position = UDim2.new(0.5,-130,0.5,-85)
keyFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
keyFrame.Active = true
keyFrame.Draggable = true
Instance.new("UICorner",keyFrame)

local keyTitle = Instance.new("TextLabel", keyFrame)
keyTitle.Size = UDim2.new(1,0,0,30)
keyTitle.Text = "Tsubasa Hub Login"
keyTitle.TextColor3 = Color3.new(1,1,1)
keyTitle.BackgroundTransparency = 1

local keyBox = Instance.new("TextBox", keyFrame)
keyBox.Size = UDim2.new(0,220,0,34)
keyBox.Position = UDim2.new(0.5,-110,0,45)
keyBox.PlaceholderText = "Enter Key"
keyBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
keyBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",keyBox)

local keyStatus = Instance.new("TextLabel", keyFrame)
keyStatus.Size = UDim2.new(1,0,0,20)
keyStatus.Position = UDim2.new(0,0,0,85)
keyStatus.BackgroundTransparency = 1
keyStatus.TextColor3 = Color3.fromRGB(255,90,90)

local keyBtn = Instance.new("TextButton", keyFrame)
keyBtn.Size = UDim2.new(0,140,0,32)
keyBtn.Position = UDim2.new(0.5,-70,0,110)
keyBtn.Text = "LOGIN"
keyBtn.BackgroundColor3 = Color3.fromRGB(90,90,90)
keyBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",keyBtn)

------------------------------------------------
-- MAIN GUI
------------------------------------------------
local gui = Instance.new("ScreenGui", Player.PlayerGui)
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
	end
end)

------------------------------------------------
-- TOGGLE (PC ONLY)
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
frame.Size = UDim2.new(0,220,0,340)
frame.Position = UDim2.new(0.05,0,0.2,0)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner",frame)

local title = Instance.new("TextLabel",frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "Tsubasa Hub"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

------------------------------------------------
-- BUTTON MAKER
------------------------------------------------
local y = 40

local function MakeBtn(text,func)

	local b = Instance.new("TextButton",frame)
	b.Size = UDim2.new(0,180,0,34)
	b.Position = UDim2.new(0,20,0,y)
	y = y + 42

	b.Text = text
	b.TextSize = 14
	b.BackgroundColor3 = Color3.fromRGB(70,70,70)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner",b)

	b.MouseButton1Click:Connect(func)
	return b
end

------------------------------------------------
-- MOBILE FLY SYSTEM
------------------------------------------------
local flying = false
local flyConn
local moveDir = Vector3.zero

-- Detect thumbstick / touch move
UIS.TouchMoved:Connect(function(input)

	if flying then
		local delta = input.Delta
		moveDir = Vector3.new(delta.X, -delta.Y, 0)
	end
end)

local function StartFly()

	local char = Player.Character
	if not char then return end

	local hrp = char:WaitForChild("HumanoidRootPart")

	local bv = Instance.new("BodyVelocity",hrp)
	bv.Name = "FlyBV"
	bv.MaxForce = Vector3.new(1e9,1e9,1e9)

	flyConn = RunService.RenderStepped:Connect(function()

		if not flying then return end

		local cam = Camera.CFrame

		local dir =
			cam.RightVector * (moveDir.X/20) +
			cam.LookVector * (moveDir.Y/20)

		bv.Velocity = dir * FLY_SPEED
	end)
end

local function StopFly()

	flying = false
	moveDir = Vector3.zero

	if flyConn then flyConn:Disconnect() end

	local char = Player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		local hrp = char.HumanoidRootPart
		local bv = hrp:FindFirstChild("FlyBV")
		if bv then bv:Destroy() end
	end
end

------------------------------------------------
-- ESP
------------------------------------------------
local espOn = false
local espCache = {}

local function ApplyESP(p)

	if p == Player then return end

	local function add(char)

		if not espOn then return end

		if espCache[p] then return end

		local h = Instance.new("Highlight",char)
		h.FillColor = Color3.fromRGB(255,80,80)
		h.OutlineColor = Color3.new(1,1,1)
		h.Adornee = char

		local bill = Instance.new("BillboardGui",char)
		bill.Size = UDim2.new(0,110,0,28)
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
			if v[1] then v[1]:Destroy() end
			if v[2] then v[2]:Destroy() end
		end
		espCache = {}
	end
end

------------------------------------------------
-- TELEPORT
------------------------------------------------
local tpFrame

local function OpenTP()

	if tpFrame then tpFrame:Destroy() end

	tpFrame = Instance.new("Frame",gui)
	tpFrame.Size = UDim2.new(0,220,0,280)
	tpFrame.Position = UDim2.new(0.4,0,0.2,0)
	tpFrame.BackgroundColor3 = Color3.fromRGB(45,45,45)
	tpFrame.Active = true
	tpFrame.Draggable = true
	Instance.new("UICorner",tpFrame)

	local close = Instance.new("TextButton",tpFrame)
	close.Size = UDim2.new(0,60,0,26)
	close.Position = UDim2.new(1,-65,0,6)
	close.Text = "X"
	close.BackgroundColor3 = Color3.fromRGB(160,70,70)
	close.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner",close)

	close.MouseButton1Click:Connect(function()
		tpFrame:Destroy()
		tpFrame = nil
	end)

	local scroll = Instance.new("ScrollingFrame",tpFrame)
	scroll.Size = UDim2.new(1,-10,1,-40)
	scroll.Position = UDim2.new(0,5,0,35)
	scroll.BackgroundTransparency = 1

	local layout = Instance.new("UIListLayout",scroll)

	for _,p in pairs(Players:GetPlayers()) do

		if p ~= Player then

			local b = Instance.new("TextButton",scroll)
			b.Size = UDim2.new(1,0,0,32)
			b.Text = p.Name
			b.TextSize = 14
			b.BackgroundColor3 = Color3.fromRGB(70,70,70)
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
	OpenTP()
end)

local espBtn = MakeBtn("ESP : OFF",function()

	espOn = not espOn
	espBtn.Text = "ESP : "..(espOn and "ON" or "OFF")
	SetESP(espOn)
end)

MakeBtn("Close",function()
	gui.Enabled = false
end)
