return function(Hub)
    local RunService = game:GetService("RunService")

    local CustomFOV = {}
    CustomFOV.Enabled = false
    CustomFOV.Value = 90

    local original = nil

    local function enforce()
        local cam = workspace.CurrentCamera
        if not cam then return end
        if math.abs(cam.FieldOfView - CustomFOV.Value) > 0.01 then
            cam.FieldOfView = CustomFOV.Value
        end
    end

    RunService.RenderStepped:Connect(function()
        if not CustomFOV.Enabled then return end
        pcall(enforce)
    end)

    function CustomFOV.Enable()
        local cam = workspace.CurrentCamera
        if cam and original == nil then
            original = cam.FieldOfView
        end
        CustomFOV.Enabled = true
        enforce()
    end

    function CustomFOV.Disable()
        CustomFOV.Enabled = false
        if original ~= nil then
            local cam = workspace.CurrentCamera
            if cam then cam.FieldOfView = original end
            original = nil
        end
    end

    function CustomFOV.Set(v)
        CustomFOV.Value = v
        if CustomFOV.Enabled then enforce() end
    end

    return CustomFOV
end