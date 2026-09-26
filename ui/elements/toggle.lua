return function(Hub, W, module, text, default, callback)
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