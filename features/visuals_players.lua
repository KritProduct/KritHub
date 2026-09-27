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

    local function EnsureHighlight(ch)
        local h = chamsCache[ch]

        if h and (h.Parent ~= ch or h.Parent == nil) then
            pcall(function() h:Destroy() end)
            h = nil
            chamsCache[ch] = nil
        end

        if not h then
            h = Instance.new("Highlight")
            h.Name = "KritChams"
            h.FillColor = Visuals.ChamsColorEnemy
            h.FillTransparency = Visuals.ChamsFillTransparency
            h.OutlineColor = Visuals.ChamsColorEnemy
            h.OutlineTransparency = Visuals.ChamsOutlineTransparency
            h.DepthMode = Visuals.ChamsThroughWalls and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
            h.Adornee = ch
            h.Parent = ch
            chamsCache[ch] = h
        end

        return h
    end

    local function RemoveHighlight(ch)
        local h = chamsCache[ch]
        if h then
            pcall(function() h:Destroy() end)
        end
        chamsCache[ch] = nil
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

    local function UpdateChams()
        local folder = GetFolder()
        if not folder then return end

        local myChar = LocalPlayer.Character

        if not Visuals.ChamsEnabled then
            for ch, _ in pairs(chamsCache) do
                RemoveHighlight(ch)
            end
            return
        end

        local myTeam = GetMyTeam()
        local validChars = {}

        for _, ch in ipairs(folder:GetChildren()) do
            if ch:IsA("Model") and ch ~= myChar then
                validChars[ch] = true

                local alive = IsAlive(ch)

                local isFriend = false
                if myTeam then
                    local t = GetTeam(ch)
                    if t == myTeam then isFriend = true end
                end

                local color = isFriend and Visuals.ChamsColorFriend or Visuals.ChamsColorEnemy

                local ok = pcall(function()
                    local h = EnsureHighlight(ch)
                    if not alive then
                        h.Enabled = false
                        return
                    end
                    if h.FillColor ~= color then h.FillColor = color end
                    if h.OutlineColor ~= color then h.OutlineColor = color end
                    if h.FillTransparency ~= Visuals.ChamsFillTransparency then
                        h.FillTransparency = Visuals.ChamsFillTransparency
                    end
                    if h.OutlineTransparency ~= Visuals.ChamsOutlineTransparency then
                        h.OutlineTransparency = Visuals.ChamsOutlineTransparency
                    end
                    local targetDepth = Visuals.ChamsThroughWalls and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
                    if h.DepthMode ~= targetDepth then h.DepthMode = targetDepth end
                    if h.Adornee ~= ch then h.Adornee = ch end
                    if not h.Enabled then h.Enabled = true end
                end)
            end
        end

        for ch, _ in pairs(chamsCache) do
            if not validChars[ch] or not ch.Parent then
                RemoveHighlight(ch)
            end
        end
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
                        for _, l in ipairs(data.Lines) do
                            l.Visible = false
                        end
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
        pcall(UpdateChams)
    end)

    RunService.RenderStepped:Connect(function()
        pcall(UpdateSkeleton)
    end)

    function Visuals.EnableChams() Visuals.ChamsEnabled = true end
    function Visuals.DisableChams()
        Visuals.ChamsEnabled = false
        for ch, _ in pairs(chamsCache) do
            RemoveHighlight(ch)
        end
    end

    function Visuals.EnableSkeleton() Visuals.SkeletonEnabled = true end
    function Visuals.DisableSkeleton()
        Visuals.SkeletonEnabled = false
        for ch, _ in pairs(skeletonCache) do
            RemoveSkeleton(ch)
        end
    end

    return Visuals
end