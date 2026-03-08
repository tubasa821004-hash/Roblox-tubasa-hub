local player = game.Players.LocalPlayer
local noclip = false

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
	if input.KeyCode == Enum.KeyCode.N then
		noclip = not noclip
	end
end)

game:GetService("RunService").Stepped:Connect(function()
	if noclip and player.Character then
		for _, part in pairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)
