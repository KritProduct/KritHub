return function(Hub)
    local RunService = game:GetService("RunService")
    local Camera = workspace.CurrentCamera

    local WeaponChams = {}
    WeaponChams.Enabled = false
    WeaponChams.Mode = "Glass"
    WeaponChams.Color = Color3.fromRGB(0, 150, 255)
    WeaponChams.Transparency = 0.4
    WeaponChams.Reflectance = 1.0

    local activeHighlights = {}
    local modifiedParts = {}

    local function restoreParts()
        for part, info in pairs(modifiedParts) do
            pcall(function()
                if part and part.Parent then
                    part.Material = info.Material
                    part.Color = info.Color
                    part.Transparency = info.Transparency
                    part.Reflectance = info.Reflectance
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

    local function getWeaponModel()
        local cam = workspace.CurrentCamera
        if not cam then return nil end
        for _, child in ipairs(cam:GetChildren()) do
            if child:IsA("Model") and child.Name ~= "Viewmodel" and not child.Name:lower():find("light") then
                local w = child:FindFirstChild("Weapon") or child
                if w:IsA("Model") and w.Name ~= "Viewmodel" and not w.Name:lower():find("light") then
                    return w
                end
            end
        end
        return nil
    end

    local function applyToPart(part)
        if not modifiedParts[part] then
            modifiedParts[part] = {
                Material = part.Material,
                Color = part.Color,
                Transparency = part.Transparency,
                Reflectance = part.Reflectance,
            }
        end

        if WeaponChams.Mode == "Glass" then
            part.Material = Enum.Material.Glass
            part.Color = WeaponChams.Color
            part.Transparency = WeaponChams.Transparency
        elseif WeaponChams.Mode == "ForceField" then
            part.Material = Enum.Material.ForceField
            part.Color = WeaponChams.Color
            part.Transparency = 0
        elseif WeaponChams.Mode == "Neon" then
            part.Material = Enum.Material.Neon
            part.Color = WeaponChams.Color
            part.Transparency = 0
        elseif WeaponChams.Mode == "Metal" then
            part.Material = Enum.Material.Metal
            part.Color = WeaponChams.Color
            part.Transparency = 0
            part.Reflectance = WeaponChams.Reflectance
        end
    end

    RunService.RenderStepped:Connect(function()
        pcall(function()
            if not WeaponChams.Enabled then
                if next(modifiedParts) then restoreParts() end
                if next(activeHighlights) then destroyHighlights() end
                return
            end

            local weaponModel = getWeaponModel()
            if not weaponModel then return end

            if WeaponChams.Mode == "Highlight" then
                restoreParts()
                local current = {}
                for _, part in ipairs(weaponModel:GetDescendants()) do
                    if part:IsA("BasePart") then
                        current[part] = true
                        local h = part:FindFirstChild("KritWeaponChamsHighlight")
                        if not h then
                            h = Instance.new("Highlight")
                            h.Name = "KritWeaponChamsHighlight"
                            h.Adornee = part
                            h.Parent = part
                            h.FillTransparency = WeaponChams.Transparency
                            h.OutlineTransparency = 1
                            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            table.insert(activeHighlights, h)
                        end
                        h.FillColor = WeaponChams.Color
                    end
                end
                for i = #activeHighlights, 1, -1 do
                    local h = activeHighlights[i]
                    if not h or not h.Parent or not current[h.Adornee] then
                        if h then h:Destroy() end
                        table.remove(activeHighlights, i)
                    end
                end
            else
                if next(activeHighlights) then destroyHighlights() end
                for _, part in ipairs(weaponModel:GetDescendants()) do
                    if part:IsA("BasePart") then
                        applyToPart(part)
                    end
                end
            end
        end)
    end)

    function WeaponChams.Enable() WeaponChams.Enabled = true end
    function WeaponChams.Disable()
        WeaponChams.Enabled = false
        restoreParts()
        destroyHighlights()
    end
    function WeaponChams.SetMode(m) WeaponChams.Mode = m end
    function WeaponChams.SetColor(c) WeaponChams.Color = c end
    function WeaponChams.SetTransparency(v) WeaponChams.Transparency = v end
    function WeaponChams.SetReflectance(v) WeaponChams.Reflectance = v end

    return WeaponChams
end