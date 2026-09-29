return function(Hub, W, module, text, default, callback)
    local TweenService = game:GetService("TweenService")
    local T = Hub.Theme
    local U = Hub.Utils

    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 30)
    row.BackgroundColor3 = T.Settings
    row.BackgroundTransparency = 1
    row.BorderSizePixel = 0
    row.LayoutOrder = #module.Elements + 1
    row.ZIndex = 5
    row.Parent = module.Settings

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 1, 0)
    line.BackgroundColor3 = T.Border
    line.BorderSizePixel = 0
    line.ZIndex = 5
    line.Parent = row

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = string.upper(text)
    label.TextColor3 = T.TextDim
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 6
    label.Parent = row

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 3, 0, 3)
    dot.Position = UDim2.new(0, 6, 0.5, -1)
    dot.BackgroundColor3 = T.Accent
    dot.BorderSizePixel = 0
    dot.BackgroundTransparency = 0.5
    dot.ZIndex = 6
    dot.Parent = row

    local switcher = Instance.new("Frame")
    switcher.Size = UDim2.new(0, 28, 0, 14)
    switcher.Position = UDim2.new(1, -40, 0.5, -7)
    switcher.BackgroundColor3 = Color3.fromRGB(21, 21, 26)
    switcher.BorderSizePixel = 0
    switcher.ZIndex = 6
    switcher.Parent = row
    U.Corner(switcher, UDim.new(0, 1))

    local switcherStroke = Instance.new("UIStroke")
    switcherStroke.Color = T.Border2
    switcherStroke.Thickness = 1
    switcherStroke.Parent = switcher

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 10, 0, 10)
    knob.Position = default and UDim2.new(0, 15, 0.5, -5) or UDim2.new(0, 1, 0.5, -5)
    knob.BackgroundColor3 = default and T.Accent or Color3.fromRGB(58, 58, 68)
    knob.BorderSizePixel = 0
    knob.ZIndex = 7
    knob.Parent = switcher
    U.Corner(knob, UDim.new(0, 1))

    local state = default

    local function refresh(silent)
        if state then
            TweenService:Create(switcher, TweenInfo.new(0.15), {BackgroundColor3 = T.AccentDim}):Play()
            TweenService:Create(switcherStroke, TweenInfo.new(0.15), {Color = T.Accent}):Play()
            TweenService:Create(knob, TweenInfo.new(0.15), {Position = UDim2.new(0, 15, 0.5, -5), BackgroundColor3 = T.Accent}):Play()
            TweenService:Create(label, TweenInfo.new(0.15), {TextColor3 = T.Text}):Play()
        else
            TweenService:Create(switcher, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(21, 21, 26)}):Play()
            TweenService:Create(switcherStroke, TweenInfo.new(0.15), {Color = T.Border2}):Play()
            TweenService:Create(knob, TweenInfo.new(0.15), {Position = UDim2.new(0, 1, 0.5, -5), BackgroundColor3 = Color3.fromRGB(58, 58, 68)}):Play()
            TweenService:Create(label, TweenInfo.new(0.15), {TextColor3 = T.TextDim}):Play()
        end
        if not silent and callback then callback(state) end
    end

    local click = Instance.new("TextButton")
    click.Size = UDim2.new(1, 0, 1, 0)
    click.BackgroundTransparency = 1
    click.Text = ""
    click.ZIndex = 10
    click.AutoButtonColor = false
    click.Parent = row

    click.MouseButton1Click:Connect(function()
        state = not state
        refresh(false)
    end)

    row.MouseEnter:Connect(function()
        TweenService:Create(label, TweenInfo.new(0.12), {TextColor3 = T.Text}):Play()
    end)
    row.MouseLeave:Connect(function()
        if not state then
            TweenService:Create(label, TweenInfo.new(0.12), {TextColor3 = T.TextDim}):Play()
        end
    end)

    local el = {
        Frame = row,
        Name = text,
        Value = default,
        Type = "toggle",
    }

    function el.Set(v, silent)
        state = v
        el.Value = v
        refresh(silent)
    end

    function el.Get()
        return state
    end

    module.RegisterElement(el)
    return el
end