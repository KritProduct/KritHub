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

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 620, 0, 440)
    main.Position = UDim2.new(0.5, -310, 0.5, -220)
    main.BackgroundColor3 = T.Background
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    main.ClipsDescendants = true
    main.Parent = gui
    U.Corner(main, UDim.new(0, 14))

    local mainGradient = Instance.new("UIGradient")
    mainGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 34)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 14, 20)),
    })
    mainGradient.Rotation = 90
    mainGradient.Parent = main

    local mainStroke = U.Stroke(main, T.Accent, 2)

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 46)
    header.BackgroundColor3 = T.Panel
    header.BackgroundTransparency = 0.15
    header.BorderSizePixel = 0
    header.ZIndex = 2
    header.Parent = main

    local accentLine = Instance.new("Frame")
    accentLine.Size = UDim2.new(1, 0, 0, 2)
    accentLine.Position = UDim2.new(0, 0, 1, -2)
    accentLine.BackgroundColor3 = T.Accent
    accentLine.BorderSizePixel = 0
    accentLine.ZIndex = 3
    accentLine.Parent = header

    local brand = Instance.new("TextLabel")
    brand.Size = UDim2.new(0, 220, 1, 0)
    brand.Position = UDim2.new(0, 22, 0, 0)
    brand.BackgroundTransparency = 1
    brand.Text = "KRITHUB"
    brand.TextColor3 = T.Accent
    brand.Font = Enum.Font.GothamBold
    brand.TextSize = 22
    brand.TextXAlignment = Enum.TextXAlignment.Left
    brand.ZIndex = 3
    brand.Parent = header

    local version = Instance.new("TextLabel")
    version.Size = UDim2.new(0, 80, 1, 0)
    version.Position = UDim2.new(0, 118, 0, 3)
    version.BackgroundTransparency = 1
    version.Text = "v1.0"
    version.TextColor3 = T.TextDim
    version.Font = Enum.Font.Gotham
    version.TextSize = 12
    version.TextXAlignment = Enum.TextXAlignment.Left
    version.ZIndex = 3
    version.Parent = header

    local function pulse(btn)
        local orig = btn.Size
        local small = UDim2.new(0, orig.X.Offset - 3, 0, orig.Y.Offset - 3)
        local big = UDim2.new(0, orig.X.Offset + 1, 0, orig.Y.Offset + 1)
        TweenService:Create(btn, TweenInfo.new(0.07), {Size = small}):Play()
        task.delay(0.07, function()
            TweenService:Create(btn, TweenInfo.new(0.1), {Size = big}):Play()
            task.delay(0.1, function()
                TweenService:Create(btn, TweenInfo.new(0.1), {Size = orig}):Play()
            end)
        end)
    end

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
    minBtn.AutoButtonColor = false
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
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = header
    U.Corner(closeBtn, T.CornerSmall)

    minBtn.MouseEnter:Connect(function()
        TweenService:Create(minBtn, TweenInfo.new(0.15), {BackgroundColor3 = T.ItemHover}):Play()
    end)
    minBtn.MouseLeave:Connect(function()
        TweenService:Create(minBtn, TweenInfo.new(0.15), {BackgroundColor3 = T.Item}):Play()
    end)
    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(255, 80, 95)}):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = T.Red}):Play()
    end)

    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 150, 1, -66)
    sidebar.Position = UDim2.new(0, 10, 0, 56)
    sidebar.BackgroundColor3 = T.Panel
    sidebar.BackgroundTransparency = 0.15
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
    content.BackgroundTransparency = 0.15
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

    local function fadeIn()
        main.BackgroundTransparency = 1
        header.BackgroundTransparency = 1
        sidebar.BackgroundTransparency = 1
        content.BackgroundTransparency = 1
        mainStroke.Transparency = 1
        main.Size = UDim2.new(0, 560, 0, 400)
        main.Position = UDim2.new(0.5, -280, 0.5, -200)

        TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 620, 0, 440),
            Position = UDim2.new(0.5, -310, 0.5, -220),
            BackgroundTransparency = 0,
        }):Play()
        TweenService:Create(header, TweenInfo.new(0.4), {BackgroundTransparency = 0.15}):Play()
        TweenService:Create(sidebar, TweenInfo.new(0.4), {BackgroundTransparency = 0.15}):Play()
        TweenService:Create(content, TweenInfo.new(0.4), {BackgroundTransparency = 0.15}):Play()
        TweenService:Create(mainStroke, TweenInfo.new(0.4), {Transparency = 0}):Play()
    end

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
        btn.AutoButtonColor = false
        btn.Parent = sidebar
        U.Corner(btn, T.CornerSmall)

        local btnStroke = U.Stroke(btn, T.Accent, 0)
        btnStroke.Transparency = 1

        local tab = { Name = name, Btn = btn, Stroke = btnStroke, Modules = {} }
        Hub.State.RegisterTab(name, tab)

        local function selectThis(animated)
            for n, t in pairs(Hub.State.Tabs) do
                if t == tab then
                    if animated then
                        TweenService:Create(t.Btn, TweenInfo.new(0.25), {BackgroundColor3 = T.Accent, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                        t.Stroke.Thickness = 2
                        TweenService:Create(t.Stroke, TweenInfo.new(0.35), {Transparency = 0}):Play()
                    else
                        t.Btn.BackgroundColor3 = T.Accent
                        t.Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                        t.Stroke.Thickness = 2
                        t.Stroke.Transparency = 0
                    end
                else
                    if animated then
                        TweenService:Create(t.Btn, TweenInfo.new(0.25), {BackgroundColor3 = T.Item, TextColor3 = T.TextDim}):Play()
                        TweenService:Create(t.Stroke, TweenInfo.new(0.25), {Transparency = 1}):Play()
                    else
                        t.Btn.BackgroundColor3 = T.Item
                        t.Btn.TextColor3 = T.TextDim
                        t.Stroke.Transparency = 1
                    end
                end
            end

            Hub.State.CurrentTab = name

            local prev = Hub.State.PrevTab
            if prev and prev ~= tab then
                for _, m in pairs(prev.Modules) do
                    if animated then
                        local fade = TweenService:Create(m.Frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
                        fade:Play()
                        TweenService:Create(m.Frame, TweenInfo.new(0.2), {Position = UDim2.new(m.Frame.Position.X.Scale, m.Frame.Position.X.Offset - 20, m.Frame.Position.Y.Scale, m.Frame.Position.Y.Offset)}):Play()
                        fade.Completed:Connect(function()
                            m.Frame.Visible = false
                            m.Frame.Position = UDim2.new(0, 0, 0, m.Frame.Position.Y.Offset)
                        end)
                    else
                        m.Frame.Visible = false
                    end
                end
            end

            for _, m in pairs(tab.Modules) do
                m.Frame.Visible = true
                if animated then
                    m.Frame.BackgroundTransparency = 1
                    m.Frame.Position = UDim2.new(0, 20, 0, m.Frame.Position.Y.Offset)
                    TweenService:Create(m.Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0, Position = UDim2.new(0, 0, 0, m.Frame.Position.Y.Offset)}):Play()
                else
                    m.Frame.BackgroundTransparency = 0
                end
            end

            Hub.State.PrevTab = tab
        end

        btn.MouseButton1Click:Connect(function() selectThis(true) end)
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

        tab.Select = selectThis
        return tab
    end

    local function makeModule(tab, name)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -6, 0, 40)
        frame.BackgroundColor3 = T.Item
        frame.BorderSizePixel = 0
        frame.LayoutOrder = #tab.Modules + 1
        frame.ZIndex = 3
        frame.ClipsDescendants = true
        frame.Parent = contentScroll
        U.Corner(frame, T.CornerSmall)

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

        local dotGlow = Instance.new("Frame")
        dotGlow.Size = UDim2.new(0, 22, 0, 22)
        dotGlow.Position = UDim2.new(0, 9, 0.5, -11)
        dotGlow.BackgroundColor3 = T.Red
        dotGlow.BackgroundTransparency = 1
        dotGlow.BorderSizePixel = 0
        dotGlow.ZIndex = 4
        dotGlow.Parent = head
        U.Corner(dotGlow, UDim.new(1, 0))

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
        expand.AutoButtonColor = false
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
        bind.AutoButtonColor = false
        bind.Parent = head
        U.Corner(bind, T.CornerSmall)

        local settings = Instance.new("Frame")
        settings.Size = UDim2.new(1, -16, 0, 0)
        settings.Position = UDim2.new(0, 8, 0, 44)
        settings.BackgroundTransparency = 1
        settings.ZIndex = 4
        settings.Parent = frame

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
            DotGlow = dotGlow,
            Settings = settings,
            SettingsList = settingsList,
            Elements = {},
            Enabled = false,
            Open = false,
        }

        local dotClick = Instance.new("TextButton")
        dotClick.Size = UDim2.new(0, 26, 0, 26)
        dotClick.Position = UDim2.new(0, 7, 0.5, -13)
        dotClick.BackgroundTransparency = 1
        dotClick.Text = ""
        dotClick.ZIndex = 10
        dotClick.AutoButtonColor = false
        dotClick.Parent = head

        dotClick.MouseButton1Click:Connect(function()
            mod.Enabled = not mod.Enabled
            local c = mod.Enabled and T.Green or T.Red
            TweenService:Create(dot, TweenInfo.new(0.2), {BackgroundColor3 = c}):Play()
            TweenService:Create(dotGlow, TweenInfo.new(0.2), {BackgroundColor3 = c}):Play()

            dotGlow.BackgroundTransparency = 0.3
            TweenService:Create(dotGlow, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()

            dot.Size = UDim2.new(0, 12, 0, 12)
            TweenService:Create(dot, TweenInfo.new(0.15), {Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, 12, 0.5, -8)}):Play()
            task.delay(0.15, function()
                TweenService:Create(dot, TweenInfo.new(0.2), {Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(0, 14, 0.5, -6)}):Play()
            end)

            if mod.OnToggle then mod.OnToggle(mod.Enabled) end
        end)

        frame.MouseEnter:Connect(function()
            TweenService:Create(frame, TweenInfo.new(0.15), {BackgroundColor3 = T.ItemHover}):Play()
        end)
        frame.MouseLeave:Connect(function()
            TweenService:Create(frame, TweenInfo.new(0.15), {BackgroundColor3 = T.Item}):Play()
        end)

        expand.MouseEnter:Connect(function()
            TweenService:Create(expand, TweenInfo.new(0.15), {BackgroundColor3 = T.Accent}):Play()
        end)
        expand.MouseLeave:Connect(function()
            TweenService:Create(expand, TweenInfo.new(0.15), {BackgroundColor3 = T.Panel}):Play()
        end)
        bind.MouseEnter:Connect(function()
            TweenService:Create(bind, TweenInfo.new(0.15), {BackgroundColor3 = T.Accent}):Play()
        end)
        bind.MouseLeave:Connect(function()
            TweenService:Create(bind, TweenInfo.new(0.15), {BackgroundColor3 = T.Panel}):Play()
        end)

        expand.MouseButton1Click:Connect(function()
            mod.Open = not mod.Open

            local targetHeight = 40
            if mod.Open then
                targetHeight = 40 + 8 + #mod.Elements * 32 + 4
            end

            local info = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            TweenService:Create(frame, info, {Size = UDim2.new(1, -6, 0, targetHeight)}):Play()

            if mod.Open then
                settings.Visible = true
                for i, el in ipairs(mod.Elements) do
                    el.Frame.Visible = true
                    el.Frame.BackgroundTransparency = 1
                    local targetY = (i - 1) * (el.Frame.Size.Y.Offset + 4)
                    el.Frame.Position = UDim2.new(0, 0, 0, targetY + 10)
                    TweenService:Create(el.Frame, TweenInfo.new(0.25 + i * 0.03, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 0,
                        Position = UDim2.new(0, 0, 0, targetY),
                    }):Play()
                end
                TweenService:Create(expand, TweenInfo.new(0.3), {Rotation = 180}):Play()
            else
                for i, el in ipairs(mod.Elements) do
                    local targetY = (i - 1) * (el.Frame.Size.Y.Offset + 4) + 10
                    TweenService:Create(el.Frame, TweenInfo.new(0.15), {
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 0, 0, targetY),
                    }):Play()
                end
                task.delay(0.18, function()
                    settings.Visible = false
                    for _, el in ipairs(mod.Elements) do
                        el.Frame.Visible = false
                    end
                end)
                TweenService:Create(expand, TweenInfo.new(0.3), {Rotation = 0}):Play()
            end
            expand.Text = mod.Open and "^" or "v"
        end)

        local listeningBind = false
        bind.MouseButton1Click:Connect(function()
            listeningBind = true
            pulse(bind)
            bind.Text = "..."
            TweenService:Create(bind, TweenInfo.new(0.15), {BackgroundColor3 = T.Accent}):Play()
        end)

        UserInputService.InputBegan:Connect(function(input, gpe)
            if listeningBind and input.UserInputType == Enum.UserInputType.Keyboard then
                bind.Text = input.KeyCode.Name
                listeningBind = false
                pulse(bind)
                TweenService:Create(bind, TweenInfo.new(0.2), {BackgroundColor3 = T.Green}):Play()
                task.delay(0.4, function()
                    TweenService:Create(bind, TweenInfo.new(0.3), {BackgroundColor3 = T.Panel}):Play()
                end)
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
        tog.AutoButtonColor = false
        tog.Parent = row
        U.Corner(tog, UDim.new(1, 0))

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 14, 0, 14)
        knob.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knob.BorderSizePixel = 0
        knob.ZIndex = 7
        knob.Parent = tog
        U.Corner(knob, UDim.new(1, 0))

        local state = default
        local function refresh()
            local target = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            local color = state and T.Green or Color3.fromRGB(60, 60, 75)
            TweenService:Create(knob, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = target}):Play()
            TweenService:Create(tog, TweenInfo.new(0.22), {BackgroundColor3 = color}):Play()
        end

        tog.MouseButton1Click:Connect(function()
            state = not state
            refresh()
            if callback then callback(state) end
        end)

        row.MouseEnter:Connect(function()
            TweenService:Create(row, TweenInfo.new(0.15), {BackgroundColor3 = T.ItemHover}):Play()
        end)
        row.MouseLeave:Connect(function()
            TweenService:Create(row, TweenInfo.new(0.15), {BackgroundColor3 = T.Panel}):Play()
        end)

        local el = { Frame = row, Value = default }
        table.insert(module.Elements, el)
        return el
    end

    local function makeSlider(module, text, min, max, default, callback)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 44)
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

        local glow = Instance.new("Frame")
        glow.Size = UDim2.new(0, 16, 0, 16)
        glow.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
        glow.BackgroundColor3 = T.Accent
        glow.BackgroundTransparency = 0.6
        glow.BorderSizePixel = 0
        glow.ZIndex = 6
        glow.Parent = barBg
        U.Corner(glow, UDim.new(1, 0))

        local dragging = false
        local state = default

        local function setFromX(mouseX, animated)
            local absPos = barBg.AbsolutePosition.X
            local absSize = barBg.AbsoluteSize.X
            local frac = math.clamp((mouseX - absPos) / absSize, 0, 1)
            state = min + frac * (max - min)
            local sizeTarget = UDim2.new(frac, 0, 1, 0)
            local glowTarget = UDim2.new(frac, -8, 0.5, -8)
            if animated then
                TweenService:Create(barFill, TweenInfo.new(0.1), {Size = sizeTarget}):Play()
                TweenService:Create(glow, TweenInfo.new(0.1), {Position = glowTarget}):Play()
            else
                barFill.Size = sizeTarget
                glow.Position = glowTarget
            end
            valTxt.Text = tostring(math.floor(state))
            if callback then callback(state) end
        end

        local clickZone = Instance.new("TextButton")
        clickZone.Size = UDim2.new(1, 0, 0, 22)
        clickZone.Position = UDim2.new(0, 0, 0, 20)
        clickZone.BackgroundTransparency = 1
        clickZone.Text = ""
        clickZone.ZIndex = 10
        clickZone.AutoButtonColor = false
        clickZone.Parent = row

        clickZone.MouseButton1Down:Connect(function()
            dragging = true
            glow.BackgroundTransparency = 0.3
            local m = UserInputService:GetMouseLocation()
            setFromX(m.X, true)
        end)

        row.MouseEnter:Connect(function()
            TweenService:Create(row, TweenInfo.new(0.15), {BackgroundColor3 = T.ItemHover}):Play()
        end)
        row.MouseLeave:Connect(function()
            TweenService:Create(row, TweenInfo.new(0.15), {BackgroundColor3 = T.Panel}):Play()
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local m = UserInputService:GetMouseLocation()
                setFromX(m.X, false)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
                TweenService:Create(glow, TweenInfo.new(0.3), {BackgroundTransparency = 0.6}):Play()
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
    makeToggle(aim, "Ignore Teammates", true, function(v)
        if Hub.Features.Aimbot then Hub.Features.Aimbot.FriendCheck = v end
    end)
    makeSlider(aim, "Field of View", 20, 800, 300, function(v)
        if Hub.Features.Aimbot then Hub.Features.Aimbot.FOV = v end
    end)
    makeSlider(aim, "Aim Smoothness", 5, 100, 30, function(v)
        if Hub.Features.Aimbot then Hub.Features.Aimbot.Speed = v / 100 end
    end)

    local visualsTab = makeTab("Visuals")
    local esp = makeModule(visualsTab, "Player ESP")
    esp.OnToggle = function(v)
        if Hub.Features.ESP then
            if v then Hub.Features.ESP.Enable() else Hub.Features.ESP.Disable() end
        end
    end
    makeToggle(esp, "Show Box", true, function(v) if Hub.Features.ESP then Hub.Features.ESP.Box = v end end)
    makeToggle(esp, "Show Name", true, function(v) if Hub.Features.ESP then Hub.Features.ESP.Name = v end end)
    makeToggle(esp, "Show Health", true, function(v) if Hub.Features.ESP then Hub.Features.ESP.Health = v end end)
    makeToggle(esp, "Show Distance", true, function(v) if Hub.Features.ESP then Hub.Features.ESP.Distance = v end end)
    makeToggle(esp, "Tracer Line", false, function(v) if Hub.Features.ESP then Hub.Features.ESP.Line = v end end)
    makeSlider(esp, "Render Distance", 250, 5000, 2000, function(v)
        if Hub.Features.ESP then Hub.Features.ESP.MaxDist = v end
    end)

    combatTab.Select(false)
    for _, m in pairs(visualsTab.Modules) do
        m.Frame.Visible = false
    end
    Hub.State.PrevTab = combatTab

    closeBtn.MouseButton1Click:Connect(function()
        pulse(closeBtn)
        task.wait(0.1)
        gui.Enabled = false
    end)

    minBtn.MouseButton1Click:Connect(function()
        pulse(minBtn)
        if main.Size.Y.Offset > 46 then
            TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 620, 0, 46)
            }):Play()
        else
            TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 620, 0, 440)
            }):Play()
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.K then
            gui.Enabled = not gui.Enabled
        end
    end)

    fadeIn()

    print("[KritHub] GUI built")
end

return UI