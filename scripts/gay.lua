local Players = game:GetService("Players")

local colors = {
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(255, 127, 0),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 255, 255),
        Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(255, 0, 255),
}

local step = 0

while true do
        step += 1
        for index, part in pairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") and Players:GetPlayerFromCharacter(part.Parent) then
                        part.Color = colors[(step + index) % #colors + 1]
                end
        end
        wait(0.05)
end