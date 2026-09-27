return function(Hub)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera

    local Visuals = {}
    Visuals.ChamsEnabled = false
    Visuals.ChamsThroughWalls = true
    Visuals.ChamsColorEnemy = Color3.fromRGB(255, 60, 60)
    Visuals.ChamsColorFriend = Color3.fromRGB(60, 255, 60)
    Visuals.ChamsFillTransparency = 0.5
    Visuals.ChamsOutlineTransparency = 0

    Visuals.SkeletonEnabled = false
    Visuals.SkeletonThroughWalls = true
    Visuals.SkeletonColor = Color3.fromRGB(255, 255, 255)

    local chamsCache = {}
    local skeletonCache = {}
    local lastChamsRebuild = 0
    local CHAMS_REBUILD_INTERVAL = 1.0

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

    local function DestroyHighlight(ch)
        local h = chamsCache[ch]
        if h then
            pcall(function() h:Destroy() end)
        end
        chamsCache[ch] = nil
    end

    local function CreateHighlight(ch, color)
        local h = Instance.new("Highlight")
        h.Name = "KritChams"
        h.FillColor = color
        h.FillTransparency = Visuals.ChamsFillTransparency
        h.OutlineColor = color
        h.OutlineTransparency = Visuals.ChamsOutlineTransparency
        h.DepthMode = Visuals.ChamsThroughWalls and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
        h.Adornee = ch
        h.Parent = ch
        chamsCache[ch] = h
        return h
    end

    local function RebuildAllChams()
        local folder = GetFolder()
        if not folder then return end

        local myChar = LocalPlayer.Character
        local myTeam = GetMyTeam()

        local validChars = {}

        for _, ch in ipairs(folder:GetChildren()) do
            if ch:IsA("Model") and ch ~= myChar and IsAlive(ch) then
                validChars[ch] = true

                local isFriend = false
                if myTeam then
                    local t = GetTeam(ch)
                    if t == myTeam then isFriend = true end
                end

                local color = isFriend and Visuals.ChamsColorFriend or Visuals.ChamsColorEnemy

                DestroyHighlight(ch)

                local ok = pcall(function()
                    CreateHighlight(ch, color)
                end)
            end
        end

        for ch, _ in pairs(chamsCache) do
            if not validChars[ch] or not ch.Parent then
                DestroyHighlight(ch)
            end
        end
    end

    local function ClearAllChams()
        for ch, _ in pairs(chamsCache) do
            DestroyHighlight(ch)
        end
    end

    local SKELETON_CONNECTIONS = {
        {"Head", "UpperTorso"},
        {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"},
        {"UpperTorso", "RightUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"},
        {"RightUpperArm", "RightLowerArm"},
        {"LeftLowerArm", "LeftHand"},
        {"RightLowerArm", "RightHand"},
        {"LowerTorso", "LeftUpperLeg"},
        {"LowerTorso", "RightUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"},
        {"RightUpperLeg", "RightLowerLeg"},
        {"LeftLowerLeg", "LeftFoot"},
        {"RightLowerLeg", "RightFoot"},
    }

    local SKELETON_CONNECTIONS_R6 = {
        {"Head", "Torso"},
        {"Torso", "Left Arm"},
        {"Torso", "Right Arm"},
        {"Torso", "Left Leg"},
        {"Torso", "Right Leg"},
    }

    local function CreateSkeleton(ch)
        local isR15 = ch:FindFirstChild("UpperTorso") ~= nil
        local pairs_ = isR15 and SKELETON_CONNECTIONS or SKELETON_CONNECTIONS_R6
        local lines = {}

        for i = 1, #pairs_ do
            local line = Drawing.new("Line")
            line.Thickness = 1
            line.Color = Visuals.SkeletonColor
            line.Transparency = 1
            line.Visible = false
            table.insert(lines, line)
        end

        skeletonCache[ch] = { Lines = lines, Pairs = pairs_, IsR15 = isR15 }
        return skeletonCache[ch]
    end

    local function RemoveSkeleton(ch)
        local data = skeletonCache[ch]
        if not data then return end
        for _, l in ipairs(data.Lines) do
            pcall(function() l:Remove() end)
        end
        skeletonCache[ch] = nil
    end

    local function UpdateSkeleton()
        local folder = GetFolder()
        if not folder then return end

        local myChar = LocalPlayer.Character

        if not Visuals.SkeletonEnabled then
            for ch, _ in pairs(skeletonCache) do
                RemoveSkeleton(ch)
            end
            return
        end

        local validChars = {}

        for _, ch in ipairs(folder:GetChildren()) do
            if ch:IsA("Model") and ch ~= myChar then
                validChars[ch] = true

                local alive = IsAlive(ch)
                local data = skeletonCache[ch]

                if not alive then
                    if data then
                        for _, l in ipairs(data.Lines) do l.Visible = false end
                    end
                else
                    local isR15 = ch:FindFirstChild("UpperTorso") ~= nil

                    if not data or data.IsR15 ~= isR15 then
                        if data then RemoveSkeleton(ch) end
                        data = CreateSkeleton(ch)
                    end

                    local anyOnScreen = false
                    local projected = {}

                    for i, pair in ipairs(data.Pairs) do
                        local p1 = ch:FindFirstChild(pair[1])
                        local p2 = ch:FindFirstChild(pair[2])
                        if p1 and p2 then
                            local s1, o1 = Camera:WorldToViewportPoint(p1.Position)
                            local s2, o2 = Camera:WorldToViewportPoint(p2.Position)
                            projected[i] = { s1, o1, s2, o2 }
                            if o1 or o2 then anyOnScreen = true end
                        end
                    end

                    local visible = Visuals.SkeletonThroughWalls or anyOnScreen

                    for i, pair in ipairs(data.Pairs) do
                        local line = data.Lines[i]
                        local pr = projected[i]
                        if pr and visible then
                            local s1, o1, s2, o2 = pr[1], pr[2], pr[3], pr[4]
                            if o1 and o2 then
                                line.From = Vector2.new(s1.X, s1.Y)
                                line.To = Vector2.new(s2.X, s2.Y)
                                line.Color = Visuals.SkeletonColor
                                line.Visible = true
                            else
                                line.Visible = false
                            end
                        else
                            if line then line.Visible = false end
                        end
                    end
                end
            end
        end

        for ch, data in pairs(skeletonCache) do
            if not validChars[ch] or not ch.Parent then
                RemoveSkeleton(ch)
            end
        end
    end

    RunService.RenderStepped:Connect(function()
        if Visuals.ChamsEnabled then
            local now = tick()
            if now - lastChamsRebuild >= CHAMS_REBUILD_INTERVAL then
                lastChamsRebuild = now
                pcall(RebuildAllChams)
            end
        end
    end)

    RunService.RenderStepped:Connect(function()
        pcall(UpdateSkeleton)
    end)

    function Visuals.EnableChams()
        Visuals.ChamsEnabled = true
        lastChamsRebuild = 0
        pcall(RebuildAllChams)
    end

    function Visuals.DisableChams()
        Visuals.ChamsEnabled = false
        ClearAllChams()
    end

    function Visuals.EnableSkeleton() Visuals.SkeletonEnabled = true end

    function Visuals.DisableSkeleton()
        Visuals.SkeletonEnabled = false
        for ch, _ in pairs(skeletonCache) do
            RemoveSkeleton(ch)
        end
    end

    function Visuals.RebuildChams()
        if Visuals.ChamsEnabled then
            lastChamsRebuild = 0
            pcall(RebuildAllChams)
        end
    end

    return Visuals
end