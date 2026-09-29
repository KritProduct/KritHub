return function(Hub, W, module, text, options, default, callback)
    local TweenService = game:GetService("TweenService")
    local T = Hub.Theme
    local U = Hub.Utils

    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 32)
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
    label.Size = UDim2.new(1, -120, 1, 0)
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

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 20)
    btn.Position = UDim2.new(1, -110, 0.5, -10)
    btn.BackgroundColor3 = T.Panel
    btn.BorderSizePixel = 0
    btn.Text = string.upper(tostring(default))
    btn.TextColor3 = T.Accent
    btn.Font = Enum.Font.Code
    btn.TextSize = 11
    btn.ZIndex = 6
    btn.AutoButtonColor = false
    btn.Parent = row
    U.Corner(btn, UDim.new(0, 1))

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = T.Border2
    btnStroke.Thickness = 1
    btnStroke.Parent = btn

    local index = 1
    for i, opt in ipairs(options) do
        if opt == default then index = i end
    end

    local state = options[index] or default

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = T.ItemHover}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.12), {Color = T.Accent}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = T.Panel}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.12), {Color = T.Border2}):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        index = index % #options + 1
        state = options[index]
        btn.Text = string.upper(tostring(state))
        if callback then callback(state) end
    end)

    row.MouseEnter:Connect(function()
        TweenService:Create(label, TweenInfo.new(0.12), {TextColor3 = T.Text}):Play()
    end)
    row.MouseLeave:Connect(function()
        TweenService:Create(label, TweenInfo.new(0.12), {TextColor3 = T.TextDim}):Play()
    end)

    local el = {
        Frame = row,
        Name = text,
        Value = state,
        Options = options,
        Type = "dropdown",
    }

    function el.Set(v, silent)
        for i, opt in ipairs(options) do
            if opt == v then
                index = i
                state = v
                btn.Text = string.upper(tostring(v))
                if not silent and callback then callback(v) end
                return
            end
        end
    end

    function el.Get()
        return state
    end

    module.RegisterElement(el)
    return el
end