return function(Hub)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer

    local SilentAim = {}
    SilentAim.Enabled = false
    SilentAim.Wallbang = false
    SilentAim.UseFovCircle = false
    SilentAim.FovRadius = 50
    SilentAim.FovColor = Color3.fromRGB(255, 0, 0)
    SilentAim.HitPart = "Head"
    SilentAim.TeamCheck = true
    SilentAim.Target = nil
    SilentAim.PriorityTargetName = nil

    local RANDOM_PARTS = {
        "Head", "UpperTorso", "LowerTorso", "HumanoidRootPart",
        "LeftUpperArm", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg",
    }

    local FovCircle = Drawing.new("Circle")
    FovCircle.Thickness = 1
    FovCircle.Filled = false
    FovCircle.NumSides = 128
    FovCircle.Visible = false

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

    local function PickRandomPart(ch)
        local shuffled = {}
        for i = 1, #RANDOM_PARTS do shuffled[i] = RANDOM_PARTS[i] end
        for i = #shuffled, 2, -1 do
            local j = math.random(i)
            shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
        end
        for _, name in ipairs(shuffled) do
            local p = ch:FindFirstChild(name)
            if p then return p end
        end
        return ch:FindFirstChild("Head")
    end

    local function GetHitPart(ch)
        if SilentAim.HitPart == "Random" then
            return PickRandomPart(ch)
        end
        return ch:FindFirstChild(SilentAim.HitPart)
            or ch:FindFirstChild("Head")
            or ch:FindFirstChild("HumanoidRootPart")
    end

    local function IsVisible(ch, targetPart)
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
                    if other == ch then
                        for _, d in ipairs(other:GetDescendants()) do
                            if d ~= head and d ~= targetPart then
                                table.insert(ignore, d)
                            end
                        end
                    else
                        table.insert(ignore, other)
                    end
                end
            end
        end

        local origin = cam.CFrame.Position
        local targetPos = targetPart and targetPart.Position or head.Position

        for i = 1, 20 do
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances = ignore
            params.IgnoreWater = true

            local dir = targetPos - origin
            local ray = workspace:Raycast(origin, dir, params)

            if ray == nil then return true end
            if ray.Instance == head then return true end
            if ray.Instance == targetPart then return true end

            local inst = ray.Instance
            if inst:IsA("BasePart") then
                if inst.CanCollide == true or inst.Transparency < 1 then return false end
            end

            table.insert(ignore, inst)
        end

        return true
    end

    local function IsPartInFov(cam, part)
        if not part then return false end
        local sp, onScreen = cam:WorldToViewportPoint(part.Position)
        if not onScreen then return false end
        local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
        local dist = (Vector2.new(sp.X, sp.Y) - center).Magnitude
        local maxRadius = SilentAim.UseFovCircle and SilentAim.FovRadius or math.huge
        return dist <= maxRadius
    end

    local function GetPriorityPart(cam)
        if not SilentAim.PriorityTargetName or SilentAim.PriorityTargetName == "" then return nil end
        local plr = Players:FindFirstChild(SilentAim.PriorityTargetName)
        if not plr then return nil end
        local ch = plr.Character
        if not ch or not IsAlive(ch) then return nil end
        if ch == LocalPlayer.Character then return nil end

        if SilentAim.TeamCheck then
            local myTeam = GetMyTeam()
            if myTeam then
                local t = GetTeam(ch)
                if t == myTeam then return nil end
            end
        end

        local part = GetHitPart(ch)
        if not part then return nil end

        if not IsPartInFov(cam, part) then return nil end

        if not SilentAim.Wallbang and not IsVisible(ch, part) then return nil end

        return part
    end

    local function FindTarget()
        local cam = workspace.CurrentCamera
        if not cam then return nil end

        local folder = GetFolder()
        if not folder then return nil end

        local priority = GetPriorityPart(cam)
        if priority then return priority end

        local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
        local maxRadius = SilentAim.UseFovCircle and SilentAim.FovRadius or math.huge
        local myTeam = GetMyTeam()
        local best, bestDist = nil, math.huge

        for _, ch in ipairs(folder:GetChildren()) do
            if ch:IsA("Model") and ch ~= LocalPlayer.Character and IsAlive(ch) then
                local isFriend = false
                if SilentAim.TeamCheck and myTeam then
                    local t = GetTeam(ch)
                    if t == myTeam then isFriend = true end
                end
                if not isFriend then
                    local part = GetHitPart(ch)
                    if part then
                        local sp, onScreen = cam:WorldToViewportPoint(part.Position)
                        if onScreen then
                            local dist = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                            if dist <= maxRadius and dist < bestDist then
                                if SilentAim.Wallbang or IsVisible(ch, part) then
                                    best = part
                                    bestDist = dist
                                end
                            end
                        end
                    end
                end
            end
        end

        return best
    end

    RunService.RenderStepped:Connect(function()
        pcall(function()
            SilentAim.Target = FindTarget()
        end)

        local cam = workspace.CurrentCamera
        if SilentAim.Enabled and SilentAim.UseFovCircle and cam then
            FovCircle.Position = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
            FovCircle.Radius = SilentAim.FovRadius
            FovCircle.Color = SilentAim.FovColor
            FovCircle.Visible = true
        else
            FovCircle.Visible = false
        end
    end)

    local ShootSignal = Hub.ShootSignal
    if ShootSignal then
        ShootSignal.Subscribe(function(hitData, bullet)
            if not SilentAim.Enabled then return end
            local target = SilentAim.Target
            if not target or not target.Parent then return end
            pcall(function()
                hitData.Instance = target
                hitData.Position = target.Position
            end)
        end)
    end

    task.spawn(function()
        for i = 1, 10 do
            if Hub.ShootSignal and Hub.ShootSignal.Install() then
                return
            end
            task.wait(1)
        end
        warn("[SilentAim] ShootSignal not installed")
    end)

    function SilentAim.Enable() SilentAim.Enabled = true end
    function SilentAim.Disable() SilentAim.Enabled = false end
    function SilentAim.SetPriority(name)
        SilentAim.PriorityTargetName = name
    end

    return SilentAim
end