return function(Hub)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local LocalPlayer = Players.LocalPlayer

    local TriggerBot = {}
    TriggerBot.Enabled = false
    TriggerBot.Teammates = false
    TriggerBot.WallCheck = false
    TriggerBot.MouseButton = "RMB"
    TriggerBot.TargetPart = "Head"
    TriggerBot.Delay = 50

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

    local function GetTargetPart(ch)
        if TriggerBot.TargetPart == "Head" then
            return ch:FindFirstChild("Head")
        elseif TriggerBot.TargetPart == "Torso" then
            return ch:FindFirstChild("UpperTorso") or ch:FindFirstChild("Torso") or ch:FindFirstChild("HumanoidRootPart")
        elseif TriggerBot.TargetPart == "Legs" then
            return ch:FindFirstChild("LeftUpperLeg") or ch:FindFirstChild("RightUpperLeg") or ch:FindFirstChild("LowerTorso")
        end
        return ch:FindFirstChild("Head")
    end

    local function IsVisible(ch, targetPart)
        if not TriggerBot.WallCheck then return true end

        local char = LocalPlayer.Character
        if not char then return false end
        local cam = workspace.CurrentCamera
        if not cam then return false end
        local head = ch:FindFirstChild("Head")
        if not head then return false end

        local ignore = {char}
        local folder = GetFolder()
        if folder then
            for _, other in ipairs(folder:GetChildren()) do
                if other:IsA("Model") then
                    for _, d in ipairs(other:GetDescendants()) do
                        if d ~= head then
                            table.insert(ignore, d)
                        end
                    end
                end
            end
        end

        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = ignore
        params.IgnoreWater = true

        local origin = cam.CFrame.Position
        local dir = head.Position - origin
        local ray = workspace:Raycast(origin, dir, params)

        if ray == nil then return true end
        if ray.Instance == head then return true end
        return false
    end

    local function IsCursorOnTarget()
        local cam = workspace.CurrentCamera
        if not cam then return nil end
        local mouse = UserInputService:GetMouseLocation()
        local folder = GetFolder()
        if not folder then return nil end

        local myTeam = GetMyTeam()

        for _, ch in ipairs(folder:GetChildren()) do
            if ch:IsA("Model") and ch ~= LocalPlayer.Character and IsAlive(ch) then
                local isFriend = false
                if myTeam then
                    local t = GetTeam(ch)
                    if t == myTeam then isFriend = true end
                end

                if (not isFriend) or TriggerBot.Teammates then
                    local part = GetTargetPart(ch)
                    if part then
                        local sp, onScreen = cam:WorldToViewportPoint(part.Position)
                        if onScreen then
                            if math.abs(sp.X - mouse.X) < 15 and math.abs(sp.Y - mouse.Y) < 15 then
                                if IsVisible(ch, part) then
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

    RunService.RenderStepped:Connect(function()
        if not TriggerBot.Enabled then return end

        local isHeld = false
        if TriggerBot.MouseButton == "LMB" then
            isHeld = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
        elseif TriggerBot.MouseButton == "RMB" then
            isHeld = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        end

        if not isHeld then return end

        if tick() - lastShot < (TriggerBot.Delay / 1000) then return end

        local target = IsCursorOnTarget()
        if target then
            lastShot = tick()
            if mousemoverel then
                mousemoverel(0, 0)
            end
            if mouse1click then mouse1click()
            elseif mouse1press and mouse1release then
                mouse1press() mouse1release()
            end
        end
    end)

    function TriggerBot.Enable() TriggerBot.Enabled = true end
    function TriggerBot.Disable() TriggerBot.Enabled = false end

    return TriggerBot
end