return function(Hub, W, module, text, min, max, default, callback)
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local T = Hub.Theme
    local U = Hub.Utils

    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 46)
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
    label.Size = UDim2.new(1, -80, 0, 20)
    label.Position = UDim2.new(0, 14, 0, 6)
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
    dot.Position = UDim2.new(0, 6, 0, 14)
    dot.BackgroundColor3 = T.Accent
    dot.BorderSizePixel = 0
    dot.BackgroundTransparency = 0.5
    dot.ZIndex = 6
    dot.Parent = row

    local valLabel = Instance.new("TextLabel")
    valLabel.Size = UDim2.new(0, 70, 0, 20)
    valLabel.Position = UDim2.new(1, -80, 0, 6)
    valLabel.BackgroundTransparency = 1
    valLabel.Text = tostring(default)
    valLabel.TextColor3 = T.Accent
    valLabel.Font = Enum.Font.Code
    valLabel.TextSize = 12
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    valLabel.ZIndex = 6
    valLabel.Parent = row

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -28, 0, 4)
    track.Position = UDim2.new(0, 14, 0, 34)
    track.BackgroundColor3 = T.Border
    track.BorderSizePixel = 0
    track.ZIndex = 6
    track.Parent = row

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = T.Accent
    fill.BorderSizePixel = 0
    fill.ZIndex = 7
    fill.Parent = track

    local thumb = Instance.new("Frame")
    thumb.Size = UDim2.new(0, 12, 0, 12)
    thumb.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
    thumb.BackgroundColor3 = T.Accent
    thumb.BorderSizePixel = 0
    thumb.ZIndex = 8
    thumb.Parent = track
    U.Corner(thumb, UDim.new(0, 1))

    local thumbStroke = Instance.new("UIStroke")
    thumbStroke.Color = T.Background
    thumbStroke.Thickness = 2
    thumbStroke.Parent = thumb

    local dragging = false
    local state = default

    local function setFromX(mx, silent)
        local absPos = track.AbsolutePosition.X
        local absSize = track.AbsoluteSize.X
        local frac = math.clamp((mx - absPos) / absSize, 0, 1)
        state = min + frac * (max - min)

        fill.Size = UDim2.new(frac, 0, 1, 0)
        thumb.Position = UDim2.new(frac, -6, 0.5, -6)
        valLabel.Text = tostring(math.floor(state))

        if not silent and callback then callback(state) end
    end

    local clickZone = Instance.new("TextButton")
    clickZone.Size = UDim2.new(1, 0, 0, 18)
    clickZone.Position = UDim2.new(0, 0, 0, 28)
    clickZone.BackgroundTransparency = 1
    clickZone.Text = ""
    clickZone.ZIndex = 10
    clickZone.AutoButtonColor = false
    clickZone.Parent = row

    clickZone.MouseButton1Down:Connect(function()
        dragging = true
        local m = UserInputService:GetMouseLocation()
        setFromX(m.X, false)
    end)

    row.MouseEnter:Connect(function()
        TweenService:Create(label, TweenInfo.new(0.12), {TextColor3 = T.Text}):Play()
    end)
    row.MouseLeave:Connect(function()
        TweenService:Create(label, TweenInfo.new(0.12), {TextColor3 = T.TextDim}):Play()
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
        end
    end)

    local el = {
        Frame = row,
        Name = text,
        Value = default,
        Min = min,
        Max = max,
        Type = "slider",
    }

    function el.Set(v, silent)
        state = math.clamp(v, min, max)
        el.Value = state
        local frac = (state - min) / (max - min)
        fill.Size = UDim2.new(frac, 0, 1, 0)
        thumb.Position = UDim2.new(frac, -6, 0.5, -6)
        valLabel.Text = tostring(math.floor(state))
        if not silent and callback then callback(state) end
    end

    function el.Get()
        return state
    end

    module.RegisterElement(el)
    return el
end