return function(Hub)
    local Tab = Hub.Tabs.Create(Hub, "Visuals")

    local esp = Hub.Module.Create(Hub, Tab, "ESP")
    Hub.Elements.Toggle(Hub, esp, "Enabled", false, function(v)
        if v then Hub.Features.ESP.Enable() else Hub.Features.ESP.Disable() end
    end)
    Hub.Elements.Toggle(Hub, esp, "Box", true, function(v) Hub.Features.ESP.Box = v end)
    Hub.Elements.Toggle(Hub, esp, "Name", true, function(v) Hub.Features.ESP.Name = v end)
    Hub.Elements.Toggle(Hub, esp, "Health", true, function(v) Hub.Features.ESP.Health = v end)
    Hub.Elements.Toggle(Hub, esp, "Distance", true, function(v) Hub.Features.ESP.Distance = v end)
    Hub.Elements.Toggle(Hub, esp, "Line", false, function(v) Hub.Features.ESP.Line = v end)
    Hub.Elements.Slider(Hub, esp, "Max Distance", 250, 5000, 2000, function(v) Hub.Features.ESP.MaxDist = v end)
end