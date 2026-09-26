return function(Hub)
    local Tab = Hub.Tabs.Create(Hub, "Movement")
    Hub.Elements.Button(Hub, Tab.Modules[1] or Hub.Module.Create(Hub, Tab, "Placeholder"), "Coming soon", function() end)
end
