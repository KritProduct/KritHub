return function(Hub)
    local Xray = {}
    Xray.Enabled = false
    Xray.Transparency = 0.5
    Xray.OnlyWalls = true

    local modified = {}

    local function isWall(inst)
        if not inst:IsA("BasePart") then return false end
        if inst.Parent == workspace then return true end
        if inst:FindFirstAncestorOfClass("Model") then
            local model = inst:FindFirstAncestorOfClass("Model")
            if model == workspace then return true end
            if model:FindFirstChildOfClass("Humanoid") then return false end
        end
        if inst:FindFirstChildOfClass("Humanoid") then return false end
        if inst:FindFirstAncestorOfClass("Accessory") then return false end
        if inst.Name == "Head" or inst.Name == "UpperTorso" or inst.Name == "LowerTorso" then
            if inst:FindFirstAncestorOfClass("Model") and inst:FindFirstAncestorOfClass("Model").Parent == workspace then
                return false
            end
        end
        return true
    end

    local function apply()
        for _, inst in ipairs(workspace:GetDescendants()) do
            if isWall(inst) then
                if not modified[inst] then
                    modified[inst] = inst.Transparency
                end
                inst.Transparency = Xray.Transparency
            end
        end
    end

    local function restore()
        for inst, t in pairs(modified) do
            if inst and inst.Parent then
                inst.Transparency = t
            end
        end
        modified = {}
    end

    function Xray.Enable()
        Xray.Enabled = true
        apply()
    end

    function Xray.Disable()
        Xray.Enabled = false
        restore()
    end

    function Xray.Refresh()
        if Xray.Enabled then
            apply()
        end
    end

    function Xray.SetTransparency(v)
        Xray.Transparency = v
        if Xray.Enabled then
            for inst, _ in pairs(modified) do
                if inst and inst.Parent then
                    inst.Transparency = v
                end
            end
        end
    end

    return Xray
end