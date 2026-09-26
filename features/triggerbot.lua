return function(Hub)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local LocalPlayer = Players.LocalPlayer
    local VirtualInputManager = game:GetService("VirtualInputManager")

    local TriggerBot = {}
    TriggerBot.Enabled = false
    TriggerBot.NoFriendDamage = true
    TriggerBot.WallCheck = true
    TriggerBot.TargetMode = "Head"
    TriggerBot.PixelThreshold = 30
    TriggerBot.ShotDelay = 100

    local lastShot = 0

    local function GetFolder()
        return workspace:FindFirstChild("Characters")
    end

    local function IsAlive(ch)
        if ch:GetAttribute("Dead") == true then return false end
        local hp = ch:GetAttribute("Health")
        if hp and hp <= 0 then return false end
        return ch:FindFirstChild("Head") ~= nil
    end

    local function GetTeam(ch)
        local n = ch:GetAttribute("CharacterName")
        if not n then return nil end
        if n == "Anarchist" or n == "Terrorist" or n == "Rebel" then return "T" end
        if n == "IDF" or n == "SEAL" or n == "SAS" or n == "Counter-Terrorist" then return "CT" end
        return nil
    end

    local function GetMyTeam()
        local me = LocalPlayer.Character
        if not me then return nil end
        return GetTeam(me)
    end

    local function IsVisible(targetCh)
        if not TriggerBot.WallCheck then return true end

        local char = LocalPlayer.Character
        if not char then return false end
        local cam = workspace.CurrentCamera
        if not cam then return false end

        local head = targetCh:FindFirstChild("Head")
        local torso = targetCh:FindFirstChild("UpperTorso") or targetCh:FindFirstChild("Torso")
        if not head then return false end

        local ignore = {char}

        local folder = GetFolder()
        if folder then
            for _, other in ipairs(folder:GetChildren()) do
                if other:IsA("Model") then
                    if other == targetCh then
                        for _, d in ipairs(other:GetDescendants()) do
                            if d ~= head and d ~= torso then
                                table.insert(ignore, d)
                            end
                        end
                    else
                        table.insert(ignore, other)
                    end
                end
            end
        end

        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = ignore
        params.IgnoreWater = true

        local origin = cam.CFrame.Position

        if head then
            local ray = workspace:Raycast(origin, head.Position - origin, params)
            if ray == nil or ray.Instance == head then return true end
        end

        if torso then
            local ray = workspace:Raycast(origin, torso.Position - origin, params)
            if ray == nil or ray.Instance == torso then return true end
        end

        return false
    end

    local function GetPartsToCheck(ch)
        local list = {}
        if TriggerBot.TargetMode == "Head" then
            local h = ch:FindFirstChild("Head")
            if h then table.insert(list, h) end
        elseif TriggerBot.TargetMode == "Torso" then
            local t = ch:FindFirstChild("UpperTorso") or ch:FindFirstChild("Torso")
            if t then table.insert(list, t) end
        else
            local h = ch:FindFirstChild("Head")
            local t = ch:FindFirstChild("UpperTorso") or ch:FindFirstChild("Torso")
            if h then table.insert(list, h) end
            if t then table.insert(list, t) end
        end
        return list
    end

    local function FindTarget()
        local cam = workspace.CurrentCamera
        if not cam then return nil end

        local mouse = UserInputService:GetMouseLocation()
        local folder = GetFolder()
        if not folder then return nil end

        local myTeam = GetMyTeam()

        for _, ch in ipairs(folder:GetChildren()) do
            if ch:IsA("Model") and ch ~= LocalPlayer.Character and IsAlive(ch) then
                local isFriend = false
                if TriggerBot.NoFriendDamage and myTeam then
                    local t = GetTeam(ch)
                    if t == myTeam then isFriend = true end
                end

                if not isFriend then
                    local parts = GetPartsToCheck(ch)
                    for _, part in ipairs(parts) do
                        local sp, onScreen = cam:WorldToViewportPoint(part.Position)
                        if onScreen then
                            local dx = math.abs(sp.X - mouse.X)
                            local dy = math.abs(sp.Y - mouse.Y)
                            if dx < TriggerBot.PixelThreshold and dy < TriggerBot.PixelThreshold then
                                if IsVisible(ch) then
                                    return ch
                                end
                            end
                        end
                    end
                end
            end
        end
        return nil
    end

    local function Fire()
        if mousemoverel then mousemoverel(0, 0) end
        if mouse1click then mouse1click() end
        if VirtualInputManager then
            pcall(function()
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                task.wait(0.01)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end)
        end
    end

    RunService.RenderStepped:Connect(function()
        if not TriggerBot.Enabled then return end
        if tick() - lastShot < (TriggerBot.ShotDelay / 1000) then return end

        local target = FindTarget()
        if target then
            lastShot = tick()
            Fire()
        end
    end)

    function TriggerBot.Enable() TriggerBot.Enabled = true end
    function TriggerBot.Disable() TriggerBot.Enabled = false end

    return TriggerBot
end