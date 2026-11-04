-- ServerScriptService > Script (run from the server)
-- Stops every other Script/LocalScript in the game by destroying it.
-- Destroying a script halts it; disabling alone would leave running connections alive.

local KEEP = script  -- this script stays so it can finish the cleanup

local containers = {
        workspace,
        game:GetService("ServerScriptService"),
        game:GetService("ServerStorage"),
        game:GetService("ReplicatedStorage"),
        game:GetService("StarterPlayer"),
        game:GetService("StarterGui"),
        game:GetService("StarterPack"),
        game:GetService("Lighting"),
        game:GetService("ReplicatedFirst"),
        game:GetService("Teams"),
        game:GetService("SoundService"),
}

local killed = 0
for _, container in ipairs(containers) do
        for _, inst in ipairs(container:GetDescendants()) do
                if (inst:IsA("Script") or inst:IsA("LocalScript") or inst:IsA("ModuleScript")) and inst ~= KEEP then
                        if inst:IsA("ModuleScript") then
                                -- Modules aren't running code by themselves; skip them so requires don't break.
                                continue
                        end
                        inst.Disabled = true
                        inst:Destroy()
                        killed += 1
                end
        end
end

-- Stop any Bad Apple body playback too, if it's still running.
local folder = workspace:FindFirstChild("BadAppleBodies")
if folder then folder:Destroy() end

print(("Killed %d scripts"):format(killed))
--KEEP:Destroy()