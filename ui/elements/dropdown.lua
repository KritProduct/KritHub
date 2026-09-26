return function(Hub, W, module, text, options, default, callback)
    local TweenService = game:GetService("TweenService")
    local T = Hub.Theme
    local U = Hub.Utils

    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -8, 0, 28)
    row.BackgroundColor3 = T.Panel
    row.BorderSizePixel = 0
    row.LayoutOrder = #module.Elements + 1
    row.ZIndex = 5
    row.Parent = module.Settings
    U.Corner(row, UDim.new(0, 8))

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 150, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = T.Text
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 6
    label.Parent = row

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 110, 0, 22)
    btn.Position = UDim2.new(1, -120, 0.5, -11)
    btn.BackgroundColor3 = T.Settings
    btn.BorderSizePixel = 0
    btn.Text = tostring(default)
    btn.TextColor3 = T.Accent
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.ZIndex = 6
    btn.AutoButtonColor = false
    btn.Parent = row
    U.Corner(btn, UDim.new(0, 6))

    local index = 1
    for i, opt in ipairs(options) do
        if opt == default then index = i end
    end

    local state = options[index]

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = T.ItemHover}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = T.Settings}):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        index = index % #options + 1
        state = options[index]
        btn.Text = tostring(state)
        if callback then callback(state) end
    end)

    row.MouseEnter:Connect(function()
        TweenService:Create(row, TweenInfo.new(0.15), {BackgroundColor3 = T.ItemHover}):Play()
    end)
    row.MouseLeave:Connect(function()
        TweenService:Create(row, TweenInfo.new(0.15), {BackgroundColor3 = T.Panel}):Play()
    end)

    local el = { Frame = row, Value = default, Options = options }
    table.insert(module.Elements, el)
    return el
end