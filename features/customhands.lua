return function(Hub)
    local RunService = game:GetService("RunService")

    local CustomHands = {}
    CustomHands.Enabled = false
    CustomHands.PositionX = 0.2
    CustomHands.PositionY = -0.155
    CustomHands.PositionZ = 0.075
    CustomHands.VisualMode = "None"
    CustomHands.Target = "ArmsWeapon"
    CustomHands.NeonColor = Color3.fromRGB(0, 150, 255)
    CustomHands.GlassTransparency = 0.4
    CustomHands.HighlightColor = Color3.fromRGB(0, 150, 255)

    local originalStats = nil
    local modifiedParts = {}
    local activeHighlights = {}

    local function isArmsPart(part)
        local p = part.Parent
        while p do
            if p:IsA("Model") and (p.Name:lower():find("arms") or p.Name:lower():find("viewmodel")) then
                return true
            end
            p = p.Parent
        end
        return false
    end

    local function isWeaponPart(part)
        local p = part.Parent
        while p do
            if p:IsA("Model") and p.Name:lower():find("weapon") then
                return true
            end
            p = p.Parent
        end
        return false
    end

    local function shouldAffect(part)
        if CustomHands.Target == "Arms" then return isArmsPart(part) end
        if CustomHands.Target == "Weapon" then return isWeaponPart(part) end
        return isArmsPart(part) or isWeaponPart(part)
    end

    local function restoreParts()
        for part, info in pairs(modifiedParts) do
            pcall(function()
                if part and part.Parent then
                    part.Material = info.Material
                    part.Color = info.Color
                    part.Transparency = info.Transparency
                end
            end)
        end
        modifiedParts = {}
    end

    local function destroyHighlights()
        for _, h in pairs(activeHighlights) do
            pcall(function() h:Destroy() end)
        end
        activeHighlights = {}
    end

    local function restorePosition()
        if not originalStats then return end
        pcall(function()
            local cam = workspace.CurrentCamera
            if not cam then return end
            for _, child in ipairs(cam:GetChildren()) do
                if child:IsA("Model") then
                    local stats = child:FindFirstChild("Stats")
                    if stats then
                        local def = stats:FindFirstChild("Default")
                        if def and def:IsA("Vector3Value") then
                            def.Value = originalStats
                        end
                    end
                end
            end
        end)
    end

    RunService.RenderStepped:Connect(function()
        pcall(function()
            local cam = workspace.CurrentCamera
            if not cam then return end

            if CustomHands.Enabled then
                for _, child in ipairs(cam:GetChildren()) do
                    if child:IsA("Model") then
                        local stats = child:FindFirstChild("Stats")
                        if stats then
                            local def = stats:FindFirstChild("Default")
                            if def and def:IsA("Vector3Value") then
                                if not originalStats then originalStats = def.Value end
                                def.Value = Vector3.new(
                                    CustomHands.PositionX,
                                    CustomHands.PositionY,
                                    CustomHands.PositionZ
                                )
                            end
                        end
                    end
                end
            end

            if CustomHands.VisualMode == "None" then
                if next(modifiedParts) then restoreParts() end
                if next(activeHighlights) then destroyHighlights() end
                return
            end

            if not CustomHands.Enabled then
                if next(modifiedParts) then restoreParts() end
                if next(activeHighlights) then destroyHighlights() end
                return
            end

            local color = CustomHands.NeonColor
            if CustomHands.VisualMode == "Rainbow" then
                color = Color3.fromHSV((tick() % 5) / 5, 1, 1)
            end

            for _, child in ipairs(cam:GetChildren()) do
                if child:IsA("Model") then
                    for _, part in ipairs(child:GetDescendants()) do
                        if part:IsA("BasePart") and shouldAffect(part) then
                            if CustomHands.VisualMode == "Highlight" then
                                local h = part:FindFirstChild("KritHandsHighlight")
                                if not h then
                                    h = Instance.new("Highlight")
                                    h.Name = "KritHandsHighlight"
                                    h.Adornee = part
                                    h.Parent = part
                                    h.FillTransparency = 0
                                    h.OutlineTransparency = 1
                                    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                    table.insert(activeHighlights, h)
                                end
                                h.FillColor = color
                            else
                                local h = part:FindFirstChild("KritHandsHighlight")
                                if h then h:Destroy() end
                                if not modifiedParts[part] then
                                    modifiedParts[part] = {
                                        Material = part.Material,
                                        Color = part.Color,
                                        Transparency = part.Transparency,
                                    }
                                end
                                if CustomHands.VisualMode == "Neon" or CustomHands.VisualMode == "Rainbow" then
                                    part.Material = Enum.Material.Neon
                                    part.Color = color
                                    part.Transparency = 0
                                elseif CustomHands.VisualMode == "Transparency" then
                                    part.Transparency = CustomHands.GlassTransparency
                                end
                            end
                        end
                    end
                end
            end
        end)
    end)

    function CustomHands.Enable() CustomHands.Enabled = true end
    function CustomHands.Disable()
        CustomHands.Enabled = false
        restoreParts()
        destroyHighlights()
        restorePosition()
    end
    function CustomHands.SetPos(x, y, z)
        CustomHands.PositionX = x
        CustomHands.PositionY = y
        CustomHands.PositionZ = z
    end
    function CustomHands.SetMode(m) CustomHands.VisualMode = m end
    function CustomHands.SetTarget(t) CustomHands.Target = t end
    function CustomHands.SetNeonColor(c) CustomHands.NeonColor = c end
    function CustomHands.SetGlassTransparency(v) CustomHands.GlassTransparency = v end
    function CustomHands.SetHighlightColor(c) CustomHands.HighlightColor = c end

    return CustomHands
end