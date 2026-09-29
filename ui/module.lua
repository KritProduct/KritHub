local Module = {}

function Module.Create(Hub, W, tab, name)
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local T = Hub.Theme
    local U = Hub.Utils

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -6, 0, 38)
    frame.BackgroundColor3 = T.Item
    frame.BorderSizePixel = 0
    frame.LayoutOrder = #tab.Modules + 1
    frame.ZIndex = 3
    frame.ClipsDescendants = true
    frame.Parent = W.ContentScroll
    U.Corner(frame, UDim.new(0, 2))

    local stroke = Instance.new("UIStroke")
    stroke.Color = T.Border
    stroke.Thickness = 1
    stroke.Parent = frame

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 2, 1, 0)
    accentBar.Position = UDim2.new(0, 0, 0, 0)
    accentBar.BackgroundColor3 = T.Accent
    accentBar.BorderSizePixel = 0
    accentBar.ZIndex = 5
    accentBar.Visible = false
    accentBar.Parent = frame

    local head = Instance.new("Frame")
    head.Size = UDim2.new(1, 0, 0, 38)
    head.BackgroundTransparency = 1
    head.ZIndex = 4
    head.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -140, 1, 0)
    label.Position = UDim2.new(0, 42, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = string.upper(name)
    label.TextColor3 = T.TextDim
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 5
    label.Parent = head

    local switcher = Instance.new("Frame")
    switcher.Size = UDim2.new(0, 28, 0, 14)
    switcher.Position = UDim2.new(0, 14, 0.5, -7)
    switcher.BackgroundColor3 = Color3.fromRGB(21, 21, 26)
    switcher.BorderSizePixel = 0
    switcher.ZIndex = 5
    switcher.Parent = head
    U.Corner(switcher, UDim.new(0, 1))

    local switcherStroke = Instance.new("UIStroke")
    switcherStroke.Color = T.Border2
    switcherStroke.Thickness = 1
    switcherStroke.Parent = switcher

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 10, 0, 10)
    knob.Position = UDim2.new(0, 1, 0.5, -5)
    knob.BackgroundColor3 = Color3.fromRGB(58, 58, 68)
    knob.BorderSizePixel = 0
    knob.ZIndex = 6
    knob.Parent = switcher
    U.Corner(knob, UDim.new(0, 1))

    local expand = Instance.new("TextButton")
    expand.Size = UDim2.new(0, 22, 0, 22)
    expand.Position = UDim2.new(1, -56, 0.5, -11)
    expand.BackgroundColor3 = T.Panel
    expand.BorderSizePixel = 0
    expand.Text = "▾"
    expand.TextColor3 = T.TextDim
    expand.Font = Enum.Font.GothamBold
    expand.TextSize = 12
    expand.ZIndex = 5
    expand.AutoButtonColor = false
    expand.Parent = head
    U.Corner(expand, UDim.new(0, 2))

    local expandStroke = Instance.new("UIStroke")
    expandStroke.Color = T.Border2
    expandStroke.Thickness = 1
    expandStroke.Parent = expand

    local bind = Instance.new("TextButton")
    bind.Size = UDim2.new(0, 22, 0, 22)
    bind.Position = UDim2.new(1, -30, 0.5, -11)
    bind.BackgroundColor3 = T.Panel
    bind.BorderSizePixel = 0
    bind.Text = "+"
    bind.TextColor3 = T.TextDim
    bind.Font = Enum.Font.GothamBold
    bind.TextSize = 12
    bind.ZIndex = 5
    bind.AutoButtonColor = false
    bind.Parent = head
    U.Corner(bind, UDim.new(0, 2))

    local bindStroke = Instance.new("UIStroke")
    bindStroke.Color = T.Border2
    bindStroke.Thickness = 1
    bindStroke.Parent = bind

    local settings = Instance.new("ScrollingFrame")
    settings.Size = UDim2.new(1, -16, 0, 0)
    settings.Position = UDim2.new(0, 8, 0, 40)
    settings.BackgroundTransparency = 1
    settings.BorderSizePixel = 0
    settings.ScrollBarThickness = 4
    settings.ScrollBarImageColor3 = T.Accent
    settings.ScrollBarImageTransparency = 0
    settings.CanvasSize = UDim2.new(0, 0, 0, 0)
    settings.AutomaticCanvasSize = Enum.AutomaticSize.Y
    settings.ScrollingDirection = Enum.ScrollingDirection.Y
    settings.ElasticBehavior = Enum.ElasticBehavior.Always
    settings.ClipsDescendants = true
    settings.ZIndex = 4
    settings.Visible = false
    settings.Parent = frame

    local settingsList = Instance.new("UIListLayout")
    settingsList.Padding = UDim.new(0, 0)
    settingsList.SortOrder = Enum.SortOrder.LayoutOrder
    settingsList.Parent = settings

    local mod = {
        Name = name,
        Tab = tab,
        Frame = frame,
        Head = head,
        AccentBar = accentBar,
        Switcher = switcher,
        Knob = knob,
        Label = label,
        Settings = settings,
        SettingsList = settingsList,
        Elements = {},
        ElementsByName = {},
        Enabled = false,
        Open = false,
        Bind = nil,
        Listening = false,
    }

    local clickZone = Instance.new("TextButton")
    clickZone.Size = UDim2.new(0, 34, 1, 0)
    clickZone.Position = UDim2.new(0, 8, 0, 0)
    clickZone.BackgroundTransparency = 1
    clickZone.Text = ""
    clickZone.ZIndex = 10
    clickZone.AutoButtonColor = false
    clickZone.Parent = head

    local function setEnabled(v, silent)
        mod.Enabled = v
        local c = v and T.Accent or Color3.fromRGB(21, 21, 26)

        if v then
            TweenService:Create(switcher, TweenInfo.new(0.15), {BackgroundColor3 = T.AccentDim}):Play()
            TweenService:Create(switcherStroke, TweenInfo.new(0.15), {Color = T.Accent}):Play()
            TweenService:Create(knob, TweenInfo.new(0.15), {Position = UDim2.new(0, 15, 0.5, -5), BackgroundColor3 = T.Accent}):Play()
            TweenService:Create(label, TweenInfo.new(0.15), {TextColor3 = T.TextHi}):Play()
            accentBar.Visible = true
        else
            TweenService:Create(switcher, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(21, 21, 26)}):Play()
            TweenService:Create(switcherStroke, TweenInfo.new(0.15), {Color = T.Border2}):Play()
            TweenService:Create(knob, TweenInfo.new(0.15), {Position = UDim2.new(0, 1, 0.5, -5), BackgroundColor3 = Color3.fromRGB(58, 58, 68)}):Play()
            TweenService:Create(label, TweenInfo.new(0.15), {TextColor3 = T.TextDim}):Play()
            accentBar.Visible = false
        end

        if not silent and mod.OnToggle then mod.OnToggle(v) end
    end

    mod.SetEnabled = setEnabled

    clickZone.MouseButton1Click:Connect(function()
        setEnabled(not mod.Enabled)
    end)

    frame.MouseEnter:Connect(function()
        TweenService:Create(frame, TweenInfo.new(0.12), {BackgroundColor3 = T.ItemHover}):Play()
    end)
    frame.MouseLeave:Connect(function()
        TweenService:Create(frame, TweenInfo.new(0.12), {BackgroundColor3 = T.Item}):Play()
    end)

    expand.MouseEnter:Connect(function()
        TweenService:Create(expand, TweenInfo.new(0.12), {BackgroundColor3 = T.AccentDim, TextColor3 = T.Accent}):Play()
    end)
    expand.MouseLeave:Connect(function()
        TweenService:Create(expand, TweenInfo.new(0.12), {BackgroundColor3 = T.Panel, TextColor3 = T.TextDim}):Play()
    end)
    bind.MouseEnter:Connect(function()
        if not mod.Listening then
            TweenService:Create(bind, TweenInfo.new(0.12), {BackgroundColor3 = T.AccentDim, TextColor3 = T.Accent}):Play()
        end
    end)
    bind.MouseLeave:Connect(function()
        if not mod.Listening then
            TweenService:Create(bind, TweenInfo.new(0.12), {BackgroundColor3 = T.Panel, TextColor3 = T.TextDim}):Play()
        end
    end)

    expand.MouseButton1Click:Connect(function()
        mod.Open = not mod.Open

        local settingsHeight = 0
        for _, el in ipairs(mod.Elements) do
            settingsHeight = settingsHeight + el.Frame.Size.Y.Offset + 1
        end

        local maxSettingsHeight = 250
        local targetHeight = 38
        if mod.Open then
            local visibleHeight = math.min(settingsHeight, maxSettingsHeight)
            targetHeight = 38 + visibleHeight + 8
        end

        TweenService:Create(frame, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, -6, 0, targetHeight)
        }):Play()

        if mod.Open then
            settings.Visible = true
            settings.Size = UDim2.new(1, -16, 0, math.min(settingsHeight, maxSettingsHeight))
            for i, el in ipairs(mod.Elements) do
                el.Frame.Visible = true
                el.Frame.BackgroundTransparency = 1
                local targetY = (i - 1) * (el.Frame.Size.Y.Offset + 1)
                el.Frame.Position = UDim2.new(0, 0, 0, targetY + 10)
                TweenService:Create(el.Frame, TweenInfo.new(0.25 + i * 0.03, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    BackgroundTransparency = 0,
                    Position = UDim2.new(0, 0, 0, targetY),
                }):Play()
            end
            TweenService:Create(expand, TweenInfo.new(0.25), {Rotation = 180}):Play()
        else
            for i, el in ipairs(mod.Elements) do
                local targetY = (i - 1) * (el.Frame.Size.Y.Offset + 1) + 10
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
            TweenService:Create(expand, TweenInfo.new(0.25), {Rotation = 0}):Play()
        end

        task.delay(0.4, function()
            if W.RecalcCanvas then W.RecalcCanvas() end
        end)
    end)

    local function startListening()
        mod.Listening = true
        bind.Text = "..."
        bind.BackgroundColor3 = T.AccentDim
        bind.TextColor3 = T.Accent
    end

    local function stopListening(keyName, keyCode)
        mod.Listening = false
        mod.Bind = keyCode
        bind.Text = keyName
        bind.BackgroundColor3 = T.Panel
        bind.TextColor3 = T.TextDim
    end

    local function cancelListening()
        mod.Listening = false
        mod.Bind = nil
        bind.Text = "+"
        bind.BackgroundColor3 = T.Panel
        bind.TextColor3 = T.TextDim
    end

    function mod.SetBindDisplay(keyName)
        bind.Text = keyName
    end

    bind.MouseButton1Click:Connect(function()
        if mod.Listening then
            cancelListening()
        else
            startListening()
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if mod.Listening then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == Enum.KeyCode.Unknown then return end
                if input.KeyCode == Enum.KeyCode.Escape
                   or input.KeyCode == Enum.KeyCode.Delete
                   or input.KeyCode == Enum.KeyCode.Space then
                    cancelListening()
                    return
                end
                stopListening(input.KeyCode.Name, input.KeyCode)
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                local m = UserInputService:GetMouseLocation()
                local abs = bind.AbsolutePosition
                local absSize = bind.AbsoluteSize
                if m.X >= abs.X and m.X <= abs.X + absSize.X and m.Y >= abs.Y and m.Y <= abs.Y + absSize.Y then
                    return
                end
                stopListening("LMB", "LMB")
            elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                stopListening("RMB", "RMB")
            end
            return
        end

        if mod.Bind == nil then return end
        if gpe then return end

        if typeof(mod.Bind) == "EnumItem" then
            if input.KeyCode == mod.Bind then
                setEnabled(not mod.Enabled)
            end
        elseif mod.Bind == "LMB" then
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                setEnabled(not mod.Enabled)
            end
        elseif mod.Bind == "RMB" then
            if input.UserInputType == Enum.UserInputType.MouseButton2 then
                setEnabled(not mod.Enabled)
            end
        end
    end)

    function mod.RegisterElement(el)
        table.insert(mod.Elements, el)
        if el.Name then
            mod.ElementsByName[el.Name] = el
        end
    end

    function mod.GetElement(name)
        return mod.ElementsByName[name]
    end

    table.insert(tab.Modules, mod)
    Hub.State.RegisterModule(name, mod)

    if tab.SetCount then
        tab.SetCount(#tab.Modules)
    end

    return mod
end

return Module