local Players = game:GetService("Players")

for _, player in pairs(Players:GetPlayers()) do
	if player.Character then
		for _, part in pairs(player.Character:GetChildren()) do
			local hue = (tick() + player.UserId % 10) % 5 / 5
			if part:IsA("BasePart") then
				part.Color = Color3.fromHSV(hue, 1, 1)
			end
		end
	end
end