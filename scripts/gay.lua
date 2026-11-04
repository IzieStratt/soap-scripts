local Players = game:GetService("Players")
while true do
	for _, player in pairs(Players:GetPlayers()) do
		if player.Character then
			local hue = (tick() + player.UserId % 10) % 5 / 5
			for _, part in pairs(player.Character:GetChildren()) do
				if part:IsA("BasePart") then
					part.Color = Color3.fromHSV(hue, 1, 1)
				end
			end
		end
	end
	wait(0.1)
end