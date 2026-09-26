return function(Hub)
    local Tab = Hub.Tabs.Create(Hub, "Combat")

    local AimMod = Hub.Module.Create(Hub, Tab, "Aimbot")
    Hub.Elements.Toggle(Hub, AimMod, "Enabled", false, function(v)
        if v then Hub.Features.Aimbot.Enable() else Hub.Features.Aimbot.Disable() end
    end)
    Hub.Elements.Slider(Hub, AimMod, "FOV", 20, 800, 300, function(v) Hub.Features.Aimbot.FOV = v end)
    Hub.Elements.Slider(Hub, AimMod, "Smoothness", 0.05, 1, 0.3, function(v) Hub.Features.Aimbot.Speed = v end)
    Hub.Elements.Dropdown(Hub, AimMod, "Target Part", {"Head", "Torso", "Legs"}, "Head", function(v) Hub.Features.Aimbot.TargetPart = v end)
    Hub.Elements.Toggle(Hub, AimMod, "Wall Check", false, function(v) Hub.Features.Aimbot.WallCheck = v end)
    Hub.Elements.Toggle(Hub, AimMod, "Friend Check", true, function(v) Hub.Features.Aimbot.FriendCheck = v end)
end
