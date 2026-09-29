local UI = {}

function UI.Build(Hub)
    local Players = game:GetService("Players")
    local T = Hub.Theme
    local U = Hub.Utils

    local Window = Hub.UI.Window
    local Tabs = Hub.UI.Tabs
    local Module = Hub.UI.Module
    local Toggle = Hub.UI.Elements.Toggle
    local Slider = Hub.UI.Elements.Slider
    local ColorPicker = Hub.UI.Elements.ColorPicker
    local Dropdown = Hub.UI.Elements.Dropdown
    local Button = Hub.UI.Elements.Button

    local pg = Players.LocalPlayer:WaitForChild("PlayerGui")
    for _, g in ipairs(pg:GetChildren()) do
        if g.Name == "KritHub" then g:Destroy() end
    end

    local W = Window.Create(Hub)

    local cfgBtn = Instance.new("TextButton")
    cfgBtn.Name = "CfgButton"
    cfgBtn.Size = UDim2.new(0, 50, 0, 28)
    cfgBtn.Position = UDim2.new(1, -134, 0, 9)
    cfgBtn.BackgroundColor3 = T.Panel
    cfgBtn.BorderSizePixel = 0
    cfgBtn.Text = "CFG"
    cfgBtn.TextColor3 = T.Accent
    cfgBtn.Font = Enum.Font.GothamBold
    cfgBtn.TextSize = 11
    cfgBtn.ZIndex = 10
    cfgBtn.AutoButtonColor = false
    cfgBtn.Parent = W.Header
    U.Corner(cfgBtn, UDim.new(0, 2))

    local cfgStroke = Instance.new("UIStroke")
    cfgStroke.Color = T.AccentDim
    cfgStroke.Thickness = 1
    cfgStroke.Parent = cfgBtn

    local ConfigWindow = Hub.UI.ConfigWindow
    local cw = nil
    if ConfigWindow then
        cw = ConfigWindow.Create(Hub, W)
        Hub.UI.ConfigsRef = cw
    end

    cfgBtn.MouseButton1Click:Connect(function()
        if cw then cw.Toggle() end
    end)
    cfgBtn.MouseEnter:Connect(function()
        cfgStroke.Color = T.Accent
    end)
    cfgBtn.MouseLeave:Connect(function()
        cfgStroke.Color = T.AccentDim
    end)

    local TabsM = Tabs.Create(Hub, W)
    Hub.State.TabsMaster = TabsM

    local combatTab = TabsM.Create("Combat")

    local aim = Module.Create(Hub, W, combatTab, "Aimbot")
    aim.OnToggle = function(v)
        if Hub.Features.Aimbot then
            if v then Hub.Features.Aimbot.Enable() else Hub.Features.Aimbot.Disable() end
        end
    end
    Toggle(Hub, W, aim, "Draw FOV Circle", false, function(v)
        if Hub.Features.Aimbot then Hub.Features.Aimbot.DrawFOV = v end
    end)
    Toggle(Hub, W, aim, "Wall Check", false, function(v)
        if Hub.Features.Aimbot then Hub.Features.Aimbot.WallCheck = v end
    end)
    Toggle(Hub, W, aim, "Ignore Teammates", true, function(v)
        if Hub.Features.Aimbot then Hub.Features.Aimbot.FriendCheck = v end
    end)
    Dropdown(Hub, W, aim, "Target Part", {"Head", "Torso", "Legs"}, "Head", function(v)
        if Hub.Features.Aimbot then Hub.Features.Aimbot.TargetPart = v end
    end)
    Slider(Hub, W, aim, "Field of View", 20, 800, 300, function(v)
        if Hub.Features.Aimbot then Hub.Features.Aimbot.FOV = v end
    end)
    Slider(Hub, W, aim, "Aim Smoothness", 5, 100, 30, function(v)
        if Hub.Features.Aimbot then Hub.Features.Aimbot.Speed = v / 100 end
    end)

    local trig = Module.Create(Hub, W, combatTab, "Trigger Bot")
    trig.OnToggle = function(v)
        if Hub.Features.TriggerBot then
            if v then Hub.Features.TriggerBot.Enable() else Hub.Features.TriggerBot.Disable() end
        end
    end
    Toggle(Hub, W, trig, "No Friend Damage", true, function(v)
        if Hub.Features.TriggerBot then Hub.Features.TriggerBot.NoFriendDamage = v end
    end)
    Toggle(Hub, W, trig, "Wall Check", true, function(v)
        if Hub.Features.TriggerBot then Hub.Features.TriggerBot.WallCheck = v end
    end)
    Dropdown(Hub, W, trig, "Target Mode", {"Head", "Torso", "Both"}, "Head", function(v)
        if Hub.Features.TriggerBot then Hub.Features.TriggerBot.TargetMode = v end
    end)
    Slider(Hub, W, trig, "Shot Delay", 0, 500, 100, function(v)
        if Hub.Features.TriggerBot then Hub.Features.TriggerBot.ShotDelay = v end
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

    local chams = Module.Create(Hub, W, visualsTab, "Chams")
    chams.OnToggle = function(v)
        if Hub.Features.VisualsPlayers then
            if v then Hub.Features.VisualsPlayers.EnableChams() else Hub.Features.VisualsPlayers.DisableChams() end
        end
    end
    Toggle(Hub, W, chams, "Through Walls", true, function(v)
        if Hub.Features.VisualsPlayers then Hub.Features.VisualsPlayers.ChamsThroughWalls = v end
    end)
    Slider(Hub, W, chams, "Fill Opacity", 0, 100, 50, function(v)
        if Hub.Features.VisualsPlayers then Hub.Features.VisualsPlayers.ChamsFillTransparency = 1 - (v / 100) end
    end)

    local skel = Module.Create(Hub, W, visualsTab, "Skeleton ESP")
    skel.OnToggle = function(v)
        if Hub.Features.VisualsPlayers then
            if v then Hub.Features.VisualsPlayers.EnableSkeleton() else Hub.Features.VisualsPlayers.DisableSkeleton() end
        end
    end
    Toggle(Hub, W, skel, "Through Walls", true, function(v)
        if Hub.Features.VisualsPlayers then Hub.Features.VisualsPlayers.SkeletonThroughWalls = v end
    end)

    local xray = Module.Create(Hub, W, visualsTab, "Xray")
    xray.OnToggle = function(v)
        if Hub.Features.Xray then
            if v then Hub.Features.Xray.Enable() else Hub.Features.Xray.Disable() end
        end
    end
    Slider(Hub, W, xray, "Transparency", 10, 100, 50, function(v)
        if Hub.Features.Xray then Hub.Features.Xray.SetTransparency(v / 100) end
    end)
    Button(Hub, W, xray, "Refresh Walls", function()
        if Hub.Features.Xray then Hub.Features.Xray.Refresh() end
    end)

    local afMod = Module.Create(Hub, W, visualsTab, "Anti Flash")
    afMod.OnToggle = function(v)
        if Hub.Features.AntiFlash then
            if v then Hub.Features.AntiFlash.Enable() else Hub.Features.AntiFlash.Disable() end
        end
    end

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

    local skinsTab = TabsM.Create("Skins")
    local SkinChangerUI = Hub.UI.SkinChangerUI
    if SkinChangerUI then
        local scUI = SkinChangerUI.Build(Hub, W, skinsTab)
        Hub.UI.SkinChangerRef = scUI
        scUI.SetVisible(false)
    end

    local hudTab = TabsM.Create("HUD")

    local wmMod = Module.Create(Hub, W, hudTab, "Watermark")
    wmMod.OnToggle = function(v)
        if Hub.Features.Watermark then
            if v then Hub.Features.Watermark.Enable() else Hub.Features.Watermark.Disable() end
        end
    end
    Toggle(Hub, W, wmMod, "Show FPS", true, function(v) if Hub.Features.Watermark then Hub.Features.Watermark.ShowFPS = v end end)
    Toggle(Hub, W, wmMod, "Show Ping", true, function(v) if Hub.Features.Watermark then Hub.Features.Watermark.ShowPing = v end end)
    Toggle(Hub, W, wmMod, "Show Username", true, function(v) if Hub.Features.Watermark then Hub.Features.Watermark.ShowUsername = v end end)
    Toggle(Hub, W, wmMod, "Show Time", true, function(v) if Hub.Features.Watermark then Hub.Features.Watermark.ShowTime = v end end)

    local miscTab = TabsM.Create("Misc")

    local rejoinMod = Module.Create(Hub, W, miscTab, "Rejoin")
    Button(Hub, W, rejoinMod, "Rejoin Now", function()
        if Hub.Features.Rejoin then Hub.Features.Rejoin.DoRejoin() end
    end)

    local afkMod = Module.Create(Hub, W, miscTab, "Anti AFK")
    afkMod.OnToggle = function(v)
        if Hub.Features.AntiAFK then
            if v then Hub.Features.AntiAFK.Enable() else Hub.Features.AntiAFK.Disable() end
        end
    end
    Slider(Hub, W, afkMod, "Interval (sec)", 1, 20, 5, function(v)
        if Hub.Features.AntiAFK then Hub.Features.AntiAFK.Interval = v end
    end)
    Toggle(Hub, W, afkMod, "Rotate Head", true, function(v)
        if Hub.Features.AntiAFK then Hub.Features.AntiAFK.DoRotate = v end
    end)
    Toggle(Hub, W, afkMod, "Jump", false, function(v)
        if Hub.Features.AntiAFK then Hub.Features.AntiAFK.DoJump = v end
    end)
    Toggle(Hub, W, afkMod, "Click", true, function(v)
        if Hub.Features.AntiAFK then Hub.Features.AntiAFK.DoClick = v end
    end)

    local spacer = Instance.new("Frame")
    spacer.Name = "ScrollSpacer"
    spacer.Size = UDim2.new(1, -6, 0, 60)
    spacer.BackgroundTransparency = 1
    spacer.BorderSizePixel = 0
    spacer.LayoutOrder = 999999
    spacer.ZIndex = 3
    spacer.Parent = W.ContentScroll

    combatTab.Select(false)
    for _, m in pairs(visualsTab.Modules) do m.Frame.Visible = false end
    for _, m in pairs(hudTab.Modules) do m.Frame.Visible = false end
    for _, m in pairs(miscTab.Modules) do m.Frame.Visible = false end
    Hub.State.PrevTab = combatTab

    W.FadeIn()

    print("[KritHub] GUI rebuilt with CS2 style")
end

return UI