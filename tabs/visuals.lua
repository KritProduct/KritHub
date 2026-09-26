return function(Hub)
    local Tab = Hub.Tabs.Create(Hub, "Visuals")

    local ESPMod = Hub.Module.Create(Hub, Tab, "ESP")
    Hub.Elements.Toggle(Hub, ESPMod, "Enabled", false, function(v)
        if v then Hub.Features.ESP.Enable() else Hub.Features.ESP.Disable() end
    end)
    Hub.Elements.Toggle(Hub, ESPMod, "Box", true, function(v) Hub.Features.ESP.Box = v end)
    Hub.Elements.Toggle(Hub, ESPMod, "Name", true, function(v) Hub.Features.ESP.Name = v end)
    Hub.Elements.Toggle(Hub, ESPMod, "Health", true, function(v) Hub.Features.ESP.Health = v end)
    Hub.Elements.Toggle(Hub, ESPMod, "Distance", true, function(v) Hub.Features.ESP.Distance = v end)
    Hub.Elements.Toggle(Hub, ESPMod, "Line", false, function(v) Hub.Features.ESP.Line = v end)
    Hub.Elements.Toggle(Hub, ESPMod, "Dot", false, function(v) Hub.Features.ESP.Dot = v end)
    Hub.Elements.Toggle(Hub, ESPMod, "Team Only", false, function(v) Hub.Features.ESP.TeamOnly = v end)
    Hub.Elements.Slider(Hub, ESPMod, "Max Distance", 250, 5000, 2000, function(v) Hub.Features.ESP.MaxDist = v end)
    Hub.Elements.ColorPicker(Hub, ESPMod, "Enemy Color", Color3.fromRGB(255, 60, 60), function(c) Hub.Features.ESP.EnemyColor = c end)
    Hub.Elements.ColorPicker(Hub, ESPMod, "Friend Color", Color3.fromRGB(60, 255, 60), function(c) Hub.Features.ESP.FriendColor = c end)
end
