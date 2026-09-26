return function(Hub)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local LocalPlayer = Players.LocalPlayer
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local Mouse = LocalPlayer:GetMouse()

    local TriggerBot = {}
    TriggerBot.Enabled = false
    TriggerBot.NoFriendDamage = true
    TriggerBot.WallCheck = true
    TriggerBot.TargetMode = "Head"
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

    local function IsPartAllowed(part)
        if not part then return false end

        if TriggerBot.TargetMode == "Head" then
            return part.Name == "Head"
        elseif TriggerBot.TargetMode == "Torso" then
            return part.Name == "UpperTorso" or part.Name == "Torso" or part.Name == "LowerTorso"
        else
            return part.Name == "Head" or part.Name == "UpperTorso" or part.Name == "Torso" or part.Name == "LowerTorso"
        end
    end

    local function FindTargetUnderCrosshair()
        local target = Mouse.Target
        if not target then return nil end

        local ch = target:FindFirstAncestorOfClass("Model")
        if not ch then return nil end

        local folder = GetFolder()
        if not folder then return nil end
        if not ch:IsDescendantOf(folder) then return nil end

        if ch == LocalPlayer.Character then return nil end
        if not IsAlive(ch) then return nil end

        if not IsPartAllowed(target) then return nil end

        if TriggerBot.NoFriendDamage then
            local myTeam = GetMyTeam()
            if myTeam then
                local theirTeam = GetTeam(ch)
                if theirTeam == myTeam then return nil end
            end
        end

        if not IsVisible(ch) then return nil end

        return ch
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

        local target = FindTargetUnderCrosshair()
        if target then
            lastShot = tick()
            Fire()
        end
    end)

    function TriggerBot.Enable() TriggerBot.Enabled = true end
    function TriggerBot.Disable() TriggerBot.Enabled = false end

    return TriggerBot
end