return function(Hub)
    local Lighting = game:GetService("Lighting")

    local OutdoorColor = {}
    OutdoorColor.Enabled = false
    OutdoorColor.Ambient = Color3.fromRGB(127, 127, 127)
    OutdoorColor.OutdoorAmbient = Color3.fromRGB(127, 127, 127)

    local original = {
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
    }

    function OutdoorColor.Enable()
        OutdoorColor.Enabled = true
        Lighting.Ambient = OutdoorColor.Ambient
        Lighting.OutdoorAmbient = OutdoorColor.OutdoorAmbient
    end

    function OutdoorColor.Disable()
        OutdoorColor.Enabled = false
        Lighting.Ambient = original.Ambient
        Lighting.OutdoorAmbient = original.OutdoorAmbient
    end

    function OutdoorColor.SetAmbient(c)
        OutdoorColor.Ambient = c
        if OutdoorColor.Enabled then Lighting.Ambient = c end
    end

    function OutdoorColor.SetOutdoor(c)
        OutdoorColor.OutdoorAmbient = c
        if OutdoorColor.Enabled then Lighting.OutdoorAmbient = c end
    end

    task.spawn(function()
        while true do
            task.wait(0.5)
            if OutdoorColor.Enabled then
                Lighting.Ambient = OutdoorColor.Ambient
                Lighting.OutdoorAmbient = OutdoorColor.OutdoorAmbient
            end
        end
    end)

    return OutdoorColor
end