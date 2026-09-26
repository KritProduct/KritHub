return function(Hub)
    local Lighting = game:GetService("Lighting")
    local Atmosphere = {}

    local atm = Lighting:FindFirstChildOfClass("Atmosphere")
    local created = false

    if not atm then
        atm = Instance.new("Atmosphere")
        atm.Parent = Lighting
        created = true
    end

    Atmosphere.Enabled = false
    Atmosphere.Density = atm.Density
    Atmosphere.Offset = atm.Offset
    Atmosphere.Color = atm.Color
    Atmosphere.Decay = atm.Decay
    Atmosphere.Glare = atm.Glare
    Atmosphere.Haze = atm.Haze

    local originalDensity = atm.Density
    local originalOffset = atm.Offset
    local originalColor = atm.Color
    local originalDecay = atm.Decay
    local originalGlare = atm.Glare
    local originalHaze = atm.Haze

    function Atmosphere.Enable()
        Atmosphere.Enabled = true
        atm.Density = Atmosphere.Density
        atm.Offset = Atmosphere.Offset
        atm.Color = Atmosphere.Color
        atm.Decay = Atmosphere.Decay
        atm.Glare = Atmosphere.Glare
        atm.Haze = Atmosphere.Haze
    end

    function Atmosphere.Disable()
        Atmosphere.Enabled = false
        atm.Density = originalDensity
        atm.Offset = originalOffset
        atm.Color = originalColor
        atm.Decay = originalDecay
        atm.Glare = originalGlare
        atm.Haze = originalHaze
        if created then
            atm:Destroy()
        end
    end

    function Atmosphere.SetDensity(v)
        Atmosphere.Density = v
        if Atmosphere.Enabled then atm.Density = v end
    end

    function Atmosphere.SetOffset(v)
        Atmosphere.Offset = v
        if Atmosphere.Enabled then atm.Offset = v end
    end

    function Atmosphere.SetColor(c)
        Atmosphere.Color = c
        if Atmosphere.Enabled then atm.Color = c end
    end

    function Atmosphere.SetDecay(c)
        Atmosphere.Decay = c
        if Atmosphere.Enabled then atm.Decay = c end
    end

    function Atmosphere.SetGlare(v)
        Atmosphere.Glare = v
        if Atmosphere.Enabled then atm.Glare = v end
    end

    function Atmosphere.SetHaze(v)
        Atmosphere.Haze = v
        if Atmosphere.Enabled then atm.Haze = v end
    end

    return Atmosphere
end