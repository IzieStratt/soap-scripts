-- ServerScriptService > Script
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")

-- ===== Config =====
local TEMPLATE_NAME = "Body"       -- model in ServerStorage to clone
local COLS, ROWS = 48, 36          -- grid resolution (cols * rows bodies)
local SPACING = 4                  -- studs between bodies
local FPS = 12                     -- playback frames per second
local ORIGIN = Vector3.new(0, 20, 0)   -- bottom-left corner of the grid
local TARGET_USER = "izie"
local HOVER_HEIGHT = 40            -- how far above the grid izie hovers
local HIDDEN_Y = -500              -- "off" bodies are parked far below

-- ===== Frame source =====
-- Returns a 2D table: frame[row][col] = true (body up) or false (body hidden).
-- Replace this with your own frames: e.g. a ModuleScript that returns
-- pre-generated bitmaps, one per frame, sized COLS x ROWS.
local FRAME_COUNT = 120
local function getFrame(i)
        local frame = {}
        local t = i / FRAME_COUNT
        local cx = COLS / 2 + math.sin(t * math.pi * 2) * (COLS / 4)
        local cy = ROWS / 2 + math.cos(t * math.pi * 2) * (ROWS / 4)
        for r = 1, ROWS do
                frame[r] = {}
                for c = 1, COLS do
                        local dx, dy = c - cx, r - cy
                        frame[r][c] = (dx * dx + dy * dy) < 40
                end
        end
        return frame
end

-- ===== Build the grid =====
local template = ServerStorage:WaitForChild(TEMPLATE_NAME)
local bodies = {}  -- bodies[r][c] = Model
local gridWidth = (COLS - 1) * SPACING
local gridHeight = (ROWS - 1) * SPACING

local bodiesFolder = Instance.new("Folder")
bodiesFolder.Name = "BadAppleBodies"
bodiesFolder.Parent = workspace

for r = 1, ROWS do
        bodies[r] = {}
        for c = 1, COLS do
                local body = template:Clone()
                body.Name = ("Body_%d_%d"):format(r, c)
                -- Freeze the body so it doesn't fall or wander.
                for _, part in ipairs(body:GetDescendants()) do
                        if part:IsA("BasePart") then
                                part.Anchored = true
                                part.CanCollide = false
                        end
                end
                local pos = ORIGIN + Vector3.new((c - 1) * SPACING, (r - 1) * SPACING, 0)
                body:PivotTo(CFrame.new(pos))
                body.Parent = bodiesFolder
                bodies[r][c] = body
        end
end

local gridCenter = ORIGIN + Vector3.new(gridWidth / 2, gridHeight / 2, 0)

-- ===== Move izie above the grid =====
local function moveIzieAbove()
        local player = Players:FindFirstChild(TARGET_USER)
        if not player then
                warn(("Player '%s' not found in server"):format(TARGET_USER))
                return
        end
        local function place(char)
                local hrp = char:WaitForChild("HumanoidRootPart", 10)
                if hrp then
                        char:PivotTo(CFrame.new(gridCenter + Vector3.new(0, HOVER_HEIGHT, 0)))
                        hrp.Anchored = true -- keep izie hovering in place to watch
                end
        end
        if player.Character then place(player.Character) end
        player.CharacterAdded:Connect(place)
end
moveIzieAbove()

-- ===== Playback =====
-- Only move bodies whose state changed, to keep the update cheap.
local lastFrame = {}
for r = 1, ROWS do lastFrame[r] = {} end

local frameIndex = 0
local accumulator = 0
local frameTime = 1 / FPS

RunService.Heartbeat:Connect(function(dt)
        accumulator += dt
        if accumulator < frameTime then return end
        accumulator -= frameTime

        frameIndex = (frameIndex % FRAME_COUNT) + 1
        local frame = getFrame(frameIndex)

        for r = 1, ROWS do
                for c = 1, COLS do
                        local on = frame[r][c]
                        if on ~= lastFrame[r][c] then
                                lastFrame[r][c] = on
                                local body = bodies[r][c]
                                local y = (r - 1) * SPACING
                                local x = (c - 1) * SPACING
                                local targetY = on and y or HIDDEN_Y
                                body:PivotTo(CFrame.new(ORIGIN + Vector3.new(x, targetY, 0)))
                        end
                end
        end
end)