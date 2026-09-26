return function(Hub, W, module, text, default, callback)
    local TweenService = game:GetService("TweenService")
    local T = Hub.Theme
    local U = Hub.Utils

    local palette = {
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(200, 200, 200),
        Color3.fromRGB(150, 150, 150),
        Color3.fromRGB(100, 100, 100),
        Color3.fromRGB(50, 50, 50),
        Color3.fromRGB(255, 200, 150),
        Color3.fromRGB(150, 200, 255),
    }

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

    local state = default

    for i, col in ipairs(palette) do
        local sw = Instance.new("TextButton")
        sw.Size = UDim2.new(0, 16, 0, 16)
        sw.Position = UDim2.new(1, -20 - (i - 1) * 20, 0.5, -8)
        sw.BackgroundColor3 = col
        sw.BorderSizePixel = 0
        sw.Text = ""
        sw.ZIndex = 6
        sw.AutoButtonColor = false
        sw.Parent = row
        U.Corner(sw, UDim.new(1, 0))

        sw.MouseEnter:Connect(function()
            TweenService:Create(sw, TweenInfo.new(0.15), {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -22 - (i - 1) * 20, 0.5, -10)}):Play()
        end)
        sw.MouseLeave:Connect(function()
            TweenService:Create(sw, TweenInfo.new(0.15), {Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(1, -20 - (i - 1) * 20, 0.5, -8)}):Play()
        end)

        sw.MouseButton1Click:Connect(function()
            state = col
            if callback then callback(col) end
        end)
    end

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