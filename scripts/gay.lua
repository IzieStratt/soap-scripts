local Players = game:GetService("Players")

for _, player is pairs(Players:GetPlayers()) do
	if player.Character then
		for _, part in pairs(player.Character:GetChildren())