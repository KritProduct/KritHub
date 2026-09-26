local Module = {}

function Module.Create(Hub, W, tab, name)
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local T = Hub.Theme
    local U = Hub.Utils

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -6, 0, 40)
    frame.BackgroundColor3 = T.Item
    frame.BorderSizePixel = 0
    frame.LayoutOrder = #tab.Modules + 1
    frame.ZIndex = 3
    frame.ClipsDescendants = true
    frame.Parent = W.ContentScroll
    U.Corner(frame, UDim.new(0, 10))

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
    U.Corner(expand, UDim.new(0, 6))

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
    U.Corner(bind, UDim.new(0, 6))

    local settings = Instance.new("ScrollingFrame")
    settings.Size = UDim2.new(1, -16, 0, 0)
    settings.Position = UDim2.new(0, 8, 0, 44)
    settings.BackgroundTransparency = 1
    settings.BorderSizePixel = 0
    settings.ScrollBarThickness = 4
    settings.ScrollBarImageColor3 = T.Accent
    settings.CanvasSize = UDim2.new(0, 0, 0, 0)
    settings.AutomaticCanvasSize = Enum.AutomaticSize.Y
    settings.ScrollingDirection = Enum.ScrollingDirection.Y
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
        Bind = nil,
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
            targetHeight = 40 + 8 + #mod.Elements * 32 + 8
        end

        TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, -6, 0, targetHeight)
        }):Play()

        if mod.Open then
            settings.Visible = true
            settings.Size = UDim2.new(1, -16, 0, targetHeight - 52)
            for i, el in ipairs(mod.Elements) do
                el.Frame.Visible = true
                el.Frame.BackgroundTransparency = 1
                local targetY = (i - 1) * (el.Frame.Size.Y.Offset + 4)
                el.Frame.Position = UDim2.new(0, 0, 0, targetY + 12)
                TweenService:Create(el.Frame, TweenInfo.new(0.3 + i * 0.04, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    BackgroundTransparency = 0,
                    Position = UDim2.new(0, 0, 0, targetY),
                }):Play()
            end
            TweenService:Create(expand, TweenInfo.new(0.3), {Rotation = 180}):Play()
        else
            for i, el in ipairs(mod.Elements) do
                local targetY = (i - 1) * (el.Frame.Size.Y.Offset + 4) + 12
                TweenService:Create(el.Frame, TweenInfo.new(0.18), {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, targetY),
                }):Play()
            end
            task.delay(0.2, function()
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
        W.Pulse(bind)
        bind.Text = "..."
        TweenService:Create(bind, TweenInfo.new(0.15), {BackgroundColor3 = T.Accent}):Play()
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if not listeningBind then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            bind.Text = input.KeyCode.Name
            listeningBind = false
            mod.Bind = input.KeyCode
            W.Pulse(bind)
            TweenService:Create(bind, TweenInfo.new(0.2), {BackgroundColor3 = T.Green}):Play()
            task.delay(0.4, function()
                TweenService:Create(bind, TweenInfo.new(0.3), {BackgroundColor3 = T.Panel}):Play()
            end)
            if mod.OnBind then mod.OnBind(input.KeyCode) end
        elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
            bind.Text = "LMB"
            listeningBind = false
            mod.Bind = "LMB"
            W.Pulse(bind)
            TweenService:Create(bind, TweenInfo.new(0.2), {BackgroundColor3 = T.Green}):Play()
            task.delay(0.4, function()
                TweenService:Create(bind, TweenInfo.new(0.3), {BackgroundColor3 = T.Panel}):Play()
            end)
        end
    end)

    settings.Visible = false

    table.insert(tab.Modules, mod)
    Hub.State.RegisterModule(name, mod)
    return mod
end

return Module