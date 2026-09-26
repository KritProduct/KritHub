return function(Hub)
    local Tab = Hub.Tabs.Create(Hub, "Combat")

    local aim = Hub.Module.Create(Hub, Tab, "Aimbot")
    Hub.Elements.Toggle(Hub, aim, "Enabled", false, function(v)
        if v then Hub.Features.Aimbot.Enable() else Hub.Features.Aimbot.Disable() end
    end)
    Hub.Elements.Slider(Hub, aim, "FOV", 20, 800, 300, function(v) Hub.Features.Aimbot.FOV = v end)
    Hub.Elements.Slider(Hub, aim, "Smoothness", 5, 100, 30, function(v) Hub.Features.Aimbot.Speed = v / 100 end)
    Hub.Elements.Toggle(Hub, aim, "Wall Check", false, function(v) Hub.Features.Aimbot.WallCheck = v end)
    Hub.Elements.Toggle(Hub, aim, "Friend Check", true, function(v) Hub.Features.Aimbot.FriendCheck = v end)
end