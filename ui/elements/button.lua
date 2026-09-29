return function(Hub, W, module, text, callback)
    local TweenService = game:GetService("TweenService")
    local T = Hub.Theme
    local U = Hub.Utils

    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 34)
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

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -28, 0, 24)
    btn.Position = UDim2.new(0, 14, 0.5, -12)
    btn.BackgroundColor3 = T.Accent
    btn.BackgroundTransparency = 0.85
    btn.BorderSizePixel = 0
    btn.Text = string.upper(text)
    btn.TextColor3 = T.Accent
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.ZIndex = 6
    btn.AutoButtonColor = false
    btn.Parent = row
    U.Corner(btn, UDim.new(0, 2))

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = T.AccentDim
    btnStroke.Thickness = 1
    btnStroke.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundTransparency = 0.6, TextColor3 = T.TextHi}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.12), {Color = T.Accent}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundTransparency = 0.85, TextColor3 = T.Accent}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.12), {Color = T.AccentDim}):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)

    local el = {
        Frame = row,
        Name = text,
        Value = nil,
        Type = "button",
    }

    module.RegisterElement(el)
    return el
end