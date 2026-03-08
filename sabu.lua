local player = game.Players.LocalPlayer
local noclip = false

-- GUI作成
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0,150,0,50)
button.Position = UDim2.new(0,20,0,100)
button.Text = "Noclip: OFF"
button.Parent = gui

-- ボタン押したら切り替え
button.MouseButton1Click:Connect(function()
	noclip = not noclip
	
	if noclip then
		button.Text = "Noclip: ON"
	else
		button.Text = "Noclip: OFF"
	end
end)

-- 当たり判定処理
game:GetService("RunService").Stepped:Connect(function()
	if noclip and player.Character then
		for _, part in pairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)
