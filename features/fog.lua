return function(Hub)
    local Lighting = game:GetService("Lighting")
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

    function Fog.Enable()
        Fog.Enabled = true
        atm.Density = Fog.Density
        atm.Offset = Fog.Offset
        atm.Color = Fog.Color
        atm.Decay = Fog.Decay
        atm.Glare = Fog.Glare
        atm.Haze = Fog.Haze
    end

    function Fog.Disable()
        Fog.Enabled = false
        atm.Density = original.Density
        atm.Offset = original.Offset
        atm.Color = original.Color
        atm.Decay = original.Decay
        atm.Glare = original.Glare
        atm.Haze = original.Haze
        if created then
            atm:Destroy()
        end
    end

    function Fog.SetDensity(v)
        Fog.Density = v
        if Fog.Enabled then atm.Density = v end
    end

    function Fog.SetOffset(v)
        Fog.Offset = v
        if Fog.Enabled then atm.Offset = v end
    end

    function Fog.SetColor(c)
        Fog.Color = c
        if Fog.Enabled then atm.Color = c end
    end

    function Fog.SetDecay(c)
        Fog.Decay = c
        if Fog.Enabled then atm.Decay = c end
    end

    function Fog.SetGlare(v)
        Fog.Glare = v
        if Fog.Enabled then atm.Glare = v end
    end

    function Fog.SetHaze(v)
        Fog.Haze = v
        if Fog.Enabled then atm.Haze = v end
    end

    return Fog
end