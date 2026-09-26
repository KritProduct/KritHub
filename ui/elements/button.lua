return function(Hub, W, module, text, callback)
    local TweenService = game:GetService("TweenService")
    local T = Hub.Theme
    local U = Hub.Utils

    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -8, 0, 28)
    row.BackgroundColor3 = T.Accent
    row.BorderSizePixel = 0
    row.LayoutOrder = #module.Elements + 1
    row.ZIndex = 5
    row.Parent = module.Settings
    U.Corner(row, UDim.new(0, 8))

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.ZIndex = 6
    label.Parent = row

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 10
    btn.AutoButtonColor = false
    btn.Parent = row

    row.MouseEnter:Connect(function()
        TweenService:Create(row, TweenInfo.new(0.15), {BackgroundColor3 = T.ItemHover}):Play()
    end)
    row.MouseLeave:Connect(function()
        TweenService:Create(row, TweenInfo.new(0.15), {BackgroundColor3 = T.Accent}):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)

    local el = { Frame = row, Value = nil }
    table.insert(module.Elements, el)
    return el
end