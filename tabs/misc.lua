return function(Hub)
    local Tab = Hub.Tabs.Create(Hub, "Misc")

    local ThemeMod = Hub.Module.Create(Hub, Tab, "Theme")
    Hub.Elements.ColorPicker(Hub, ThemeMod, "Accent", Hub.Theme.Accent, function(c)
        Hub.Theme.SetAccent(c)
    end)

    local WatermarkMod = Hub.Module.Create(Hub, Tab, "Watermark")
    Hub.Elements.Toggle(Hub, WatermarkMod, "Enabled", true, function(v) end)
end
