local UI = {}

function UI.Build(Hub)
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local player = Players.LocalPlayer
    local T = Hub.Theme
    local U = Hub.Utils

    local gui = Instance.new("ScreenGui")
    gui.Name = "KritHub"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = player:WaitForChild("PlayerGui")

    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(0, 620, 0, 440)
    shadow.Position = UDim2.new(0.5, -308, 0.5, -218)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.5
    shadow.BorderSizePixel = 0
    shadow.ZIndex = 0
    shadow.Parent = gui
    U.Corner(shadow, UDim.new(0, 16))

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 620, 0, 440)
    main.Position = UDim2.new(0.5, -310, 0.5, -220)
    main.BackgroundColor3 = T.Background
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    main.ZIndex = 1
    main.Parent = gui
    U.Corner(main, UDim.new(0, 14))
    U.Stroke(main, T.Accent, 2)

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 22, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 14, 20)),
    })
    gradient.Rotation = 90
    gradient.Parent = main

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 46)
    header.BackgroundColor3 = T.Panel
    header.BackgroundTransparency = 0.2
    header.BorderSizePixel = 0
    header.ZIndex = 2
    header.Parent = main
    U.Corner(header, UDim.new(0, 14))

    local accentLine = Instance.new("Frame")
    accentLine.Size = UDim2.new(1, 0, 0, 2)
    accentLine.Position = UDim2.new(0, 0, 1, -2)
    accentLine.BackgroundColor3 = T.Accent
    accentLine.BorderSizePixel = 0
    accentLine.ZIndex = 3
    accentLine.Parent = header

    local brand = Instance.new("TextLabel")
    brand.Size = UDim2.new(0, 200, 1, 0)
    brand.Position = UDim2.new(0, 18, 0, 0)
    brand.BackgroundTransparency = 1
    brand.Text = "KRITHUB"
    brand.TextColor3 = T.Accent
    brand.Font = Enum.Font.GothamBold
    brand.TextSize = 20
    brand.TextXAlignment = Enum.TextXAlignment.Left
    brand.ZIndex = 3
    brand.Parent = header

    local version = Instance.new("TextLabel")
    version.Size = UDim2.new(0, 60, 1, 0)
    version.Position = UDim2.new(0, 108, 0, 2)
    version.BackgroundTransparency = 1
    version.Text = "v1.0"
    version.TextColor3 = T.TextDim
    version.Font = Enum.Font.Gotham
    version.TextSize = 12
    version.TextXAlignment = Enum.TextXAlignment.Left
    version.ZIndex = 3
    version.Parent = header

    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 32, 0, 26)
    minBtn.Position = UDim2.new(1, -80, 0, 10)
    minBtn.BackgroundColor3 = T.Item
    minBtn.BorderSizePixel = 0
    minBtn.Text = "—"
    minBtn.TextColor3 = T.Text
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 16
    minBtn.ZIndex = 3
    minBtn.Parent = header
    U.Corner(minBtn, T.CornerSmall)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 32, 0, 26)
    closeBtn.Position = UDim2.new(1, -42, 0, 10)
    closeBtn.BackgroundColor3 = T.Red
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    closeBtn.ZIndex = 3
    closeBtn.Parent = header
    U.Corner(closeBtn, T.CornerSmall)

    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 150, 1, -66)
    sidebar.Position = UDim2.new(0, 10, 0, 56)
    sidebar.BackgroundColor3 = T.Panel
    sidebar.BorderSizePixel = 0
    sidebar.ZIndex = 2
    sidebar.Parent = main
    U.Corner(sidebar, UDim.new(0, 10))

    local sidebarList = Instance.new("UIListLayout")
    sidebarList.Padding = UDim.new(0, 6)
    sidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarList.Parent = sidebar
    U.Padding(sidebar, 8)

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -170, 1, -66)
    content.Position = UDim2.new(0, 160, 0, 56)
    content.BackgroundColor3 = T.Settings
    content.BorderSizePixel = 0
    content.ZIndex = 2
    content.Parent = main
    U.Corner(content, UDim.new(0, 10))

    local contentScroll = Instance.new("ScrollingFrame")
    contentScroll.Size = UDim2.new(1, -16, 1, -16)
    contentScroll.Position = UDim2.new(0, 8, 0, 8)
    contentScroll.BackgroundTransparency = 1
    contentScroll.BorderSizePixel = 0
    contentScroll.ScrollBarThickness = 4
    contentScroll.ScrollBarImageColor3 = T.Accent
    contentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    contentScroll.ZIndex = 3
    contentScroll.Parent = content

    local contentList = Instance.new("UIListLayout")
    contentList.Padding = UDim.new(0, 8)
    contentList.SortOrder = Enum.SortOrder.LayoutOrder
    contentList.Parent = contentScroll

    local function makeTab(name)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 38)
        btn.BackgroundColor3 = T.Item
        btn.BorderSizePixel = 0
        btn.Text = name
        btn.TextColor3 = T.TextDim
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 14
        btn.LayoutOrder = #Hub.State.Tabs + 1
        btn.ZIndex = 3
        btn.Parent = sidebar
        U.Corner(btn, T.CornerSmall)

        local tab = { Name = name, Btn = btn, Modules = {} }
        Hub.State.RegisterTab(name, tab)

        btn.MouseButton1Click:Connect(function()
            for n, t in pairs(Hub.State.Tabs) do
                if t == tab then
                    t.Btn.BackgroundColor3 = T.Accent
                    t.Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    t.Btn.BackgroundColor3 = T.Item
                    t.Btn.TextColor3 = T.TextDim
                end
            end
            Hub.State.CurrentTab = name
            for _, m in pairs(tab.Modules) do
                m.Frame.Visible = true
            end
            for n, t in pairs(Hub.State.Tabs) do
                if t ~= tab then
                    for _, m in pairs(t.Modules) do
                        m.Frame.Visible = false
                    end
                end
            end
        end)

        btn.MouseEnter:Connect(function()
            if Hub.State.CurrentTab ~= name then
                TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = T.ItemHover}):Play()
            end
        end)
        btn.MouseLeave:Connect(function()
            if Hub.State.CurrentTab ~= name then
                TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = T.Item}):Play()
            end
        end)

        return tab
    end

    local function makeModule(tab, name)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -6, 0, 40)
        frame.BackgroundColor3 = T.Item
        frame.BorderSizePixel = 0
        frame.LayoutOrder = #tab.Modules + 1
        frame.ZIndex = 3
        frame.Parent = contentScroll
        U.Corner(frame, T.CornerSmall)
        frame.ClipsDescendants = true
        frame.AutomaticSize = Enum.AutomaticSize.Y

        local head = Instance.new("Frame")
        head.Size = UDim2.new(1, 0, 0, 40)
        head.BackgroundTransparency = 1
        head.ZIndex = 4
        head.Parent = frame

        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 12, 0, 12)
        dot.Position = UDim2.new(0, 14, 0.5, -6)
        dot.BackgroundColor3 = T.Red
        dot.BorderSizePixel = 0
        dot.ZIndex = 5
        dot.Parent = head
        U.Corner(dot, UDim.new(1, 0))

        local dotStroke = U.Stroke(dot, T.Red, 0)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -140, 1, 0)
        label.Position = UDim2.new(0, 34, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = T.Text
        label.Font = Enum.Font.GothamSemibold
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 5
        label.Parent = head

        local expand = Instance.new("TextButton")
        expand.Size = UDim2.new(0, 26, 0, 26)
        expand.Position = UDim2.new(1, -62, 0.5, -13)
        expand.BackgroundColor3 = T.Panel
        expand.BorderSizePixel = 0
        expand.Text = "v"
        expand.TextColor3 = T.Text
        expand.Font = Enum.Font.GothamBold
        expand.TextSize = 14
        expand.ZIndex = 5
        expand.Parent = head
        U.Corner(expand, T.CornerSmall)

        local bind = Instance.new("TextButton")
        bind.Size = UDim2.new(0, 26, 0, 26)
        bind.Position = UDim2.new(1, -32, 0.5, -13)
        bind.BackgroundColor3 = T.Panel
        bind.BorderSizePixel = 0
        bind.Text = "+"
        bind.TextColor3 = T.Text
        bind.Font = Enum.Font.GothamBold
        bind.TextSize = 14
        bind.ZIndex = 5
        bind.Parent = head
        U.Corner(bind, T.CornerSmall)

        local settings = Instance.new("Frame")
        settings.Size = UDim2.new(1, -16, 0, 0)
        settings.Position = UDim2.new(0, 8, 0, 44)
        settings.BackgroundTransparency = 1
        settings.ZIndex = 4
        settings.Parent = frame
        settings.AutomaticSize = Enum.AutomaticSize.Y

        local settingsList = Instance.new("UIListLayout")
        settingsList.Padding = UDim.new(0, 4)
        settingsList.SortOrder = Enum.SortOrder.LayoutOrder
        settingsList.Parent = settings

        local mod = {
            Name = name,
            Tab = tab,
            Frame = frame,
            Head = head,
            Dot = dot,
            DotStroke = dotStroke,
            Settings = settings,
            SettingsList = settingsList,
            Elements = {},
            Enabled = false,
            Open = false,
        }

        dot.MouseEnter:Connect(function() end)

        local dotClick = Instance.new("TextButton")
        dotClick.Size = UDim2.new(0, 26, 0, 26)
        dotClick.Position = UDim2.new(0, 7, 0.5, -13)
        dotClick.BackgroundTransparency = 1
        dotClick.Text = ""
        dotClick.ZIndex = 10
        dotClick.Parent = head
        dotClick.MouseButton1Click:Connect(function()
            mod.Enabled = not mod.Enabled
            local c = mod.Enabled and T.Green or T.Red
            dot.BackgroundColor3 = c
            if mod.OnToggle then mod.OnToggle(mod.Enabled) end
        end)

        expand.MouseButton1Click:Connect(function()
            mod.Open = not mod.Open
            expand.Text = mod.Open and "^" or "v"
            if mod.Open then
                settings.Visible = true
                TweenService:Create(settings, TweenInfo.new(0.2), {}):Play()
            else
                settings.Visible = false
            end
        end)

        local listeningBind = false
        bind.MouseButton1Click:Connect(function()
            listeningBind = true
            bind.Text = "..."
        end)

        UserInputService.InputBegan:Connect(function(input, gpe)
            if listeningBind and input.UserInputType == Enum.UserInputType.Keyboard then
                bind.Text = input.KeyCode.Name
                listeningBind = false
                if mod.OnBind then mod.OnBind(input.KeyCode) end
            end
        end)

        settings.Visible = false

        table.insert(tab.Modules, mod)
        Hub.State.RegisterModule(name, mod)
        return mod
    end

    local function makeToggle(module, text, default, callback)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 28)
        row.BackgroundColor3 = T.Panel
        row.BorderSizePixel = 0
        row.LayoutOrder = #module.Elements + 1
        row.ZIndex = 5
        row.Parent = module.Settings
        U.Corner(row, UDim.new(0, 6))

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -50, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = T.Text
        label.Font = Enum.Font.Gotham
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 6
        label.Parent = row

        local tog = Instance.new("TextButton")
        tog.Size = UDim2.new(0, 34, 0, 18)
        tog.Position = UDim2.new(1, -44, 0.5, -9)
        tog.BackgroundColor3 = default and T.Green or Color3.fromRGB(60, 60, 75)
        tog.BorderSizePixel = 0
        tog.Text = ""
        tog.ZIndex = 6
        tog.Parent = row
        U.Corner(tog, UDim.new(1, 0))

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 14, 0, 14)
        knob.Position = UDim2.new(0, 2, 0.5, -7)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knob.BorderSizePixel = 0
        knob.ZIndex = 7
        knob.Parent = tog
        U.Corner(knob, UDim.new(1, 0))

        local state = default
        local function refresh()
            local target = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            TweenService:Create(knob, TweenInfo.new(0.15), {Position = target}):Play()
            TweenService:Create(tog, TweenInfo.new(0.15), {BackgroundColor3 = state and T.Green or Color3.fromRGB(60, 60, 75)}):Play()
        end

        tog.MouseButton1Click:Connect(function()
            state = not state
            refresh()
            if callback then callback(state) end
        end)

        local el = { Frame = row, Value = default }
        table.insert(module.Elements, el)
        return el
    end

    local function makeSlider(module, text, min, max, default, callback)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 42)
        row.BackgroundColor3 = T.Panel
        row.BorderSizePixel = 0
        row.LayoutOrder = #module.Elements + 1
        row.ZIndex = 5
        row.Parent = module.Settings
        U.Corner(row, UDim.new(0, 6))

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0, 150, 0, 18)
        label.Position = UDim2.new(0, 10, 0, 4)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = T.Text
        label.Font = Enum.Font.Gotham
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 6
        label.Parent = row

        local valTxt = Instance.new("TextLabel")
        valTxt.Size = UDim2.new(0, 60, 0, 18)
        valTxt.Position = UDim2.new(1, -70, 0, 4)
        valTxt.BackgroundTransparency = 1
        valTxt.Text = tostring(default)
        valTxt.TextColor3 = T.Accent
        valTxt.Font = Enum.Font.GothamBold
        valTxt.TextSize = 13
        valTxt.TextXAlignment = Enum.TextXAlignment.Right
        valTxt.ZIndex = 6
        valTxt.Parent = row

        local barBg = Instance.new("Frame")
        barBg.Size = UDim2.new(1, -20, 0, 6)
        barBg.Position = UDim2.new(0, 10, 0, 28)
        barBg.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
        barBg.BorderSizePixel = 0
        barBg.ZIndex = 6
        barBg.Parent = row
        U.Corner(barBg, UDim.new(1, 0))

        local barFill = Instance.new("Frame")
        barFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        barFill.BackgroundColor3 = T.Accent
        barFill.BorderSizePixel = 0
        barFill.ZIndex = 7
        barFill.Parent = barBg
        U.Corner(barFill, UDim.new(1, 0))

        local dragging = false
        local state = default

        local function setFromX(mouseX)
            local absPos = barBg.AbsolutePosition.X
            local absSize = barBg.AbsoluteSize.X
            local frac = math.clamp((mouseX - absPos) / absSize, 0, 1)
            state = min + frac * (max - min)
            barFill.Size = UDim2.new(frac, 0, 1, 0)
            valTxt.Text = tostring(math.floor(state))
            if callback then callback(state) end
        end

        local clickZone = Instance.new("TextButton")
        clickZone.Size = UDim2.new(1, 0, 0, 20)
        clickZone.Position = UDim2.new(0, 0, 0, 21)
        clickZone.BackgroundTransparency = 1
        clickZone.Text = ""
        clickZone.ZIndex = 10
        clickZone.Parent = row

        clickZone.MouseButton1Down:Connect(function()
            dragging = true
            local m = UserInputService:GetMouseLocation()
            setFromX(m.X)
        end)

        clickZone.MouseEnter:Connect(function() end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local m = UserInputService:GetMouseLocation()
                setFromX(m.X)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)

        local el = { Frame = row, Value = default }
        table.insert(module.Elements, el)
        return el
    end

    UI.MakeTab = makeTab
    UI.MakeModule = makeModule
    UI.MakeToggle = makeToggle
    UI.MakeSlider = makeSlider
    UI.Gui = gui
    UI.Main = main

    local combatTab = makeTab("Combat")
    local aim = makeModule(combatTab, "Aimbot")
    aim.OnToggle = function(v)
        if Hub.Features.Aimbot then
            if v then Hub.Features.Aimbot.Enable() else Hub.Features.Aimbot.Disable() end
        end
    end
    makeToggle(aim, "Wall Check", false, function(v)
        if Hub.Features.Aimbot then Hub.Features.Aimbot.WallCheck = v end
    end)
    makeToggle(aim, "Friend Check", true, function(v)
        if Hub.Features.Aimbot then Hub.Features.Aimbot.FriendCheck = v end
    end)
    makeSlider(aim, "FOV", 20, 800, 300, function(v)
        if Hub.Features.Aimbot then Hub.Features.Aimbot.FOV = v end
    end)
    makeSlider(aim, "Smoothness", 5, 100, 30, function(v)
        if Hub.Features.Aimbot then Hub.Features.Aimbot.Speed = v / 100 end
    end)

    local visualsTab = makeTab("Visuals")
    local esp = makeModule(visualsTab, "ESP")
    esp.OnToggle = function(v)
        if Hub.Features.ESP then
            if v then Hub.Features.ESP.Enable() else Hub.Features.ESP.Disable() end
        end
    end
    makeToggle(esp, "Box", true, function(v) if Hub.Features.ESP then Hub.Features.ESP.Box = v end end)
    makeToggle(esp, "Name", true, function(v) if Hub.Features.ESP then Hub.Features.ESP.Name = v end end)
    makeToggle(esp, "Health", true, function(v) if Hub.Features.ESP then Hub.Features.ESP.Health = v end end)
    makeToggle(esp, "Distance", true, function(v) if Hub.Features.ESP then Hub.Features.ESP.Distance = v end end)
    makeToggle(esp, "Line", false, function(v) if Hub.Features.ESP then Hub.Features.ESP.Line = v end end)
    makeSlider(esp, "Max Distance", 250, 5000, 2000, function(v)
        if Hub.Features.ESP then Hub.Features.ESP.MaxDist = v end
    end)

    for n, t in pairs(Hub.State.Tabs) do
        if t == combatTab then
            t.Btn.BackgroundColor3 = T.Accent
            t.Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            t.Btn.BackgroundColor3 = T.Item
            t.Btn.TextColor3 = T.TextDim
        end
    end
    for _, m in pairs(visualsTab.Modules) do
        m.Frame.Visible = false
    end
    Hub.State.CurrentTab = "Combat"

    closeBtn.MouseButton1Click:Connect(function()
        gui.Enabled = false
    end)

    minBtn.MouseButton1Click:Connect(function()
        if main.Size.Y.Offset > 46 then
            TweenService:Create(main, TweenInfo.new(0.2), {Size = UDim2.new(0, 620, 0, 46)}):Play()
        else
            TweenService:Create(main, TweenInfo.new(0.2), {Size = UDim2.new(0, 620, 0, 440)}):Play()
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.K then
            gui.Enabled = not gui.Enabled
        end
    end)

    print("[KritHub] GUI built")
end

return UI