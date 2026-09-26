return function(Hub, W, module, text, min, max, default, callback)
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local T = Hub.Theme
    local U = Hub.Utils

    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -8, 0, 44)
    row.BackgroundColor3 = T.Panel
    row.BorderSizePixel = 0
    row.LayoutOrder = #module.Elements + 1
    row.ZIndex = 5
    row.Parent = module.Settings
    U.Corner(row, UDim.new(0, 8))

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