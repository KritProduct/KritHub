return function(Hub)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer

    local ThirdPerson = {}
    ThirdPerson.Enabled = false
    ThirdPerson.Distance = 10

    local originalMode = nil
    local originalMin = nil
    local originalMax = nil
    local hooked = false

    local function apply()
        if not ThirdPerson.Enabled then return end
        pcall(function()
            LocalPlayer.CameraMode = Enum.CameraMode.Classic
            LocalPlayer.CameraMinZoomDistance = ThirdPerson.Distance
            LocalPlayer.CameraMaxZoomDistance = ThirdPerson.Distance
        end)
    end

    local function installHook()
        if hooked then return end
        if not getrawmetatable or not setreadonly then return end

        local mt = getrawmetatable(game)
        if not mt or not mt.__newindex then return end

        local old = mt.__newindex
        setreadonly(mt, false)
        mt.__newindex = newcclosure(function(self, key, value)
            if self == LocalPlayer and ThirdPerson.Enabled then
                if key == "CameraMode" then
                    return old(self, key, Enum.CameraMode.Classic)
                elseif key == "CameraMaxZoomDistance" then
                    return old(self, key, ThirdPerson.Distance)
                elseif key == "CameraMinZoomDistance" then
                    return old(self, key, ThirdPerson.Distance)
                end
            end
            return old(self, key, value)
        end)
        setreadonly(mt, true)
        hooked = true
    end

    RunService.RenderStepped:Connect(function()
        if ThirdPerson.Enabled then
            pcall(apply)
        end
    end)

    function ThirdPerson.Enable()
        if originalMode == nil then
            originalMode = LocalPlayer.CameraMode
            originalMin = LocalPlayer.CameraMinZoomDistance
            originalMax = LocalPlayer.CameraMaxZoomDistance
        end
        ThirdPerson.Enabled = true
        installHook()
        apply()
    end

    function ThirdPerson.Disable()
        ThirdPerson.Enabled = false
        pcall(function()
            if originalMode then LocalPlayer.CameraMode = originalMode end
            if originalMin then LocalPlayer.CameraMinZoomDistance = originalMin end
            if originalMax then LocalPlayer.CameraMaxZoomDistance = originalMax end
        end)
    end

    function ThirdPerson.SetDistance(d)
        ThirdPerson.Distance = math.clamp(d, 3, 50)
        if ThirdPerson.Enabled then apply() end
    end

    return ThirdPerson
end