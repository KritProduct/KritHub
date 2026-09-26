return function(Hub)
    local Lighting = game:GetService("Lighting")
    local Fog = {}

    Fog.Enabled = false
    Fog.Start = 100
    Fog.End = 1000
    Fog.Color = Color3.fromRGB(200, 200, 200)

    local originalStart = Lighting.FogStart
    local originalEnd = Lighting.FogEnd
    local originalColor = Lighting.FogColor

    function Fog.Enable()
        Fog.Enabled = true
        Lighting.FogStart = Fog.Start
        Lighting.FogEnd = Fog.End
        Lighting.FogColor = Fog.Color
    end

    function Fog.Disable()
        Fog.Enabled = false
        Lighting.FogStart = originalStart
        Lighting.FogEnd = originalEnd
        Lighting.FogColor = originalColor
    end

    function Fog.SetStart(v)
        Fog.Start = v
        if Fog.Enabled then Lighting.FogStart = v end
    end

    function Fog.SetEnd(v)
        Fog.End = v
        if Fog.Enabled then Lighting.FogEnd = v end
    end

    function Fog.SetColor(c)
        Fog.Color = c
        if Fog.Enabled then Lighting.FogColor = c end
    end

    return Fog
end