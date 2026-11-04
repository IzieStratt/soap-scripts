local Players = game:GetService("Players")

for _, player in pairs(Players:GetPlayers()) do
	if player.Character then
		for _, part in pairs(player.Character:GetChildren()) do
			if part:IsA("BasePart") then
				part.BrickColor = BrickColor.new("Bright Blue")
			end
		end
	end
end