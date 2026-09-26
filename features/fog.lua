return function(Hub)
    local Lighting = game:GetService("Lighting")
    local RunService = game:GetService("RunService")
    local Fog = {}

    local atm = Lighting:FindFirstChildOfClass("Atmosphere")
    local created = false
    if not atm then
        atm = Instance.new("Atmosphere")
        atm.Parent = Lighting
        created = true
    end

    local original = {
        Density = atm.Density,
        Offset = atm.Offset,
        Color = atm.Color,
        Decay = atm.Decay,
        Glare = atm.Glare,
        Haze = atm.Haze,
    }

    Fog.Enabled = false
    Fog.Density = 0.5
    Fog.Offset = 0
    Fog.Color = Color3.fromRGB(200, 200, 200)
    Fog.Decay = Color3.fromRGB(106, 112, 125)
    Fog.Glare = 0
    Fog.Haze = 3

    local heartbeatConn = nil
    local propConns = {}

    local function enforce()
        if not Fog.Enabled then return end
        if atm.Parent == nil then return end

        if math.abs(atm.Density - Fog.Density) > 0.01 then atm.Density = Fog.Density end
        if math.abs(atm.Offset - Fog.Offset) > 0.01 then atm.Offset = Fog.Offset end
        if atm.Color ~= Fog.Color then atm.Color = Fog.Color end
        if atm.Decay ~= Fog.Decay then atm.Decay = Fog.Decay end
        if math.abs(atm.Glare - Fog.Glare) > 0.01 then atm.Glare = Fog.Glare end
        if math.abs(atm.Haze - Fog.Haze) > 0.01 then atm.Haze = Fog.Haze end
    end

    local function hookProps()
        for _, prop in ipairs({"Density", "Offset", "Color", "Decay", "Glare", "Haze"}) do
            table.insert(propConns, atm:GetPropertyChangedSignal(prop):Connect(function()
                if Fog.Enabled then
                    task.defer(enforce)
                end
            end))
        end
    end

    local function unhookProps()
        for _, c in ipairs(propConns) do c:Disconnect() end
        propConns = {}
    end

    function Fog.Enable()
        if atm.Parent == nil then
            atm = Lighting:FindFirstChildOfClass("Atmosphere")
            if not atm then
                atm = Instance.new("Atmosphere")
                atm.Parent = Lighting
                created = true
            end
            hookProps()
        end

        Fog.Enabled = true
        atm.Density = Fog.Density
        atm.Offset = Fog.Offset
        atm.Color = Fog.Color
        atm.Decay = Fog.Decay
        atm.Glare = Fog.Glare
        atm.Haze = Fog.Haze

        hookProps()

        if not heartbeatConn then
            heartbeatConn = RunService.Heartbeat:Connect(enforce)
        end
    end

    function Fog.Disable()
        Fog.Enabled = false
        unhookProps()
        if heartbeatConn then heartbeatConn:Disconnect() heartbeatConn = nil end

        if atm and atm.Parent then
            atm.Density = original.Density
            atm.Offset = original.Offset
            atm.Color = original.Color
            atm.Decay = original.Decay
            atm.Glare = original.Glare
            atm.Haze = original.Haze
        end

        if created and atm then
            atm:Destroy()
            atm = nil
        end
    end

    function Fog.SetDensity(v)
        Fog.Density = v
        if Fog.Enabled and atm then atm.Density = v end
    end

    function Fog.SetOffset(v)
        Fog.Offset = v
        if Fog.Enabled and atm then atm.Offset = v end
    end

    function Fog.SetColor(c)
        Fog.Color = c
        if Fog.Enabled and atm then atm.Color = c end
    end

    function Fog.SetDecay(c)
        Fog.Decay = c
        if Fog.Enabled and atm then atm.Decay = c end
    end

    function Fog.SetGlare(v)
        Fog.Glare = v
        if Fog.Enabled and atm then atm.Glare = v end
    end

    function Fog.SetHaze(v)
        Fog.Haze = v
        if Fog.Enabled and atm then atm.Haze = v end
    end

    return Fog
end