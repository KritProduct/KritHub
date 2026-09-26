local UI = {}

function UI.Build(Hub)
    local Players = game:GetService("Players")

    local Window = Hub.UI.Window
    local Tabs = Hub.UI.Tabs
    local Module = Hub.UI.Module
    local Toggle = Hub.UI.Elements.Toggle
    local Slider = Hub.UI.Elements.Slider
    local ColorPicker = Hub.UI.Elements.ColorPicker

    local pg = Players.LocalPlayer:WaitForChild("PlayerGui")
    for _, g in ipairs(pg:GetChildren()) do
        if g.Name == "KritHub" then g:Destroy() end
    end

    local W = Window.Create(Hub)

    local TabsM = Tabs.Create(Hub, W)
    Hub.State.TabsMaster = TabsM

    local combatTab = TabsM.Create("Combat")
    local aim = Module.Create(Hub, W, combatTab, "Aimbot")
    aim.OnToggle = function(v)
        if Hub.Features.Aimbot then
            if v then Hub.Features.Aimbot.Enable() else Hub.Features.Aimbot.Disable() end
        end
    end
    Toggle(Hub, W, aim, "Wall Check", false, function(v)
        if Hub.Features.Aimbot then Hub.Features.Aimbot.WallCheck = v end
    end)
    Toggle(Hub, W, aim, "Ignore Teammates", true, function(v)
        if Hub.Features.Aimbot then Hub.Features.Aimbot.FriendCheck = v end
    end)
    Slider(Hub, W, aim, "Field of View", 20, 800, 300, function(v)
        if Hub.Features.Aimbot then Hub.Features.Aimbot.FOV = v end
    end)
    Slider(Hub, W, aim, "Aim Smoothness", 5, 100, 30, function(v)
        if Hub.Features.Aimbot then Hub.Features.Aimbot.Speed = v / 100 end
    end)

    local visualsTab = TabsM.Create("Visuals")

    local esp = Module.Create(Hub, W, visualsTab, "Player ESP")
    esp.OnToggle = function(v)
        if Hub.Features.ESP then
            if v then Hub.Features.ESP.Enable() else Hub.Features.ESP.Disable() end
        end
    end
    Toggle(Hub, W, esp, "Show Box", true, function(v) if Hub.Features.ESP then Hub.Features.ESP.Box = v end end)
    Toggle(Hub, W, esp, "Show Name", true, function(v) if Hub.Features.ESP then Hub.Features.ESP.Name = v end end)
    Toggle(Hub, W, esp, "Show Health", true, function(v) if Hub.Features.ESP then Hub.Features.ESP.Health = v end end)
    Toggle(Hub, W, esp, "Show Distance", true, function(v) if Hub.Features.ESP then Hub.Features.ESP.Distance = v end end)
    Toggle(Hub, W, esp, "Tracer Line", false, function(v) if Hub.Features.ESP then Hub.Features.ESP.Line = v end end)
    Slider(Hub, W, esp, "Render Distance", 250, 5000, 2000, function(v)
        if Hub.Features.ESP then Hub.Features.ESP.MaxDist = v end
    end)

    local timeMod = Module.Create(Hub, W, visualsTab, "Time Changer")
    timeMod.OnToggle = function(v)
        if Hub.Features.TimeChanger then
            if v then Hub.Features.TimeChanger.Enable() else Hub.Features.TimeChanger.Disable() end
        end
    end
    Slider(Hub, W, timeMod, "Time (Hours)", 0, 24, 14, function(v)
        if Hub.Features.TimeChanger then Hub.Features.TimeChanger.Set(v) end
    end)

    local fogMod = Module.Create(Hub, W, visualsTab, "Fog")
    fogMod.OnToggle = function(v)
        if Hub.Features.Fog then
            if v then Hub.Features.Fog.Enable() else Hub.Features.Fog.Disable() end
        end
    end
    Slider(Hub, W, fogMod, "Density", 0, 100, 50, function(v)
        if Hub.Features.Fog then Hub.Features.Fog.SetDensity(v / 100) end
    end)
    Slider(Hub, W, fogMod, "Haze", 0, 100, 30, function(v)
        if Hub.Features.Fog then Hub.Features.Fog.SetHaze(v / 10) end
    end)
    Slider(Hub, W, fogMod, "Glare", 0, 100, 0, function(v)
        if Hub.Features.Fog then Hub.Features.Fog.SetGlare(v / 100) end
    end)
    Slider(Hub, W, fogMod, "Offset", 0, 100, 0, function(v)
        if Hub.Features.Fog then Hub.Features.Fog.SetOffset(v / 100) end
    end)
    ColorPicker(Hub, W, fogMod, "Color", Color3.fromRGB(200, 200, 200), function(c)
        if Hub.Features.Fog then Hub.Features.Fog.SetColor(c) end
    end)
    ColorPicker(Hub, W, fogMod, "Decay", Color3.fromRGB(106, 112, 125), function(c)
        if Hub.Features.Fog then Hub.Features.Fog.SetDecay(c) end
    end)

    local ccMod = Module.Create(Hub, W, visualsTab, "Color Correction")
    ccMod.OnToggle = function(v)
        if Hub.Features.ColorCorrection then
            if v then Hub.Features.ColorCorrection.Enable() else Hub.Features.ColorCorrection.Disable() end
        end
    end
    Slider(Hub, W, ccMod, "Brightness", 0, 200, 100, function(v)
        if Hub.Features.ColorCorrection then Hub.Features.ColorCorrection.SetBrightness((v - 100) / 100) end
    end)
    Slider(Hub, W, ccMod, "Contrast", 0, 200, 100, function(v)
        if Hub.Features.ColorCorrection then Hub.Features.ColorCorrection.SetContrast((v - 100) / 100) end
    end)
    Slider(Hub, W, ccMod, "Saturation", 0, 200, 100, function(v)
        if Hub.Features.ColorCorrection then Hub.Features.ColorCorrection.SetSaturation((v - 100) / 100) end
    end)
    ColorPicker(Hub, W, ccMod, "Tint", Color3.fromRGB(255, 255, 255), function(c)
        if Hub.Features.ColorCorrection then Hub.Features.ColorCorrection.SetTint(c) end
    end)

    local afMod = Module.Create(Hub, W, visualsTab, "Anti Flash")
    afMod.OnToggle = function(v)
        if Hub.Features.AntiFlash then
            if v then Hub.Features.AntiFlash.Enable() else Hub.Features.AntiFlash.Disable() end
        end
    end
    Toggle(Hub, W, afMod, "Hide Overlay", true, function(v)
        if Hub.Features.AntiFlash then Hub.Features.AntiFlash.HideOverlay = v end
    end)
    Toggle(Hub, W, afMod, "Hide Screenshot", true, function(v)
        if Hub.Features.AntiFlash then Hub.Features.AntiFlash.HideScreenshot = v end
    end)

    local afMod = Module.Create(Hub, W, visualsTab, "Anti Flash")
    afMod.OnToggle = function(v)
        if Hub.Features.AntiFlash then
            if v then Hub.Features.AntiFlash.Enable() else Hub.Features.AntiFlash.Disable() end
        end
    end
    Toggle(Hub, W, afMod, "Hide Overlay", true, function(v)
        if Hub.Features.AntiFlash then Hub.Features.AntiFlash.HideOverlay = v end
    end)
    Toggle(Hub, W, afMod, "Hide Screenshot", true, function(v)
        if Hub.Features.AntiFlash then Hub.Features.AntiFlash.HideScreenshot = v end
    end)

    combatTab.Select(false)
    for _, m in pairs(visualsTab.Modules) do
        m.Frame.Visible = false
    end
    Hub.State.PrevTab = combatTab

    W.FadeIn()

    print("[KritHub] GUI built")
end

return UI