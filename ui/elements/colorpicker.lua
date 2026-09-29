return function(Hub, W, module, text, default, callback)
    local TweenService = game:GetService("TweenService")
    local T = Hub.Theme
    local U = Hub.Utils

    local palette = {
        Color3.fromRGB(245, 166, 35),
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(224, 62, 62),
        Color3.fromRGB(74, 222, 128),
        Color3.fromRGB(59, 130, 246),
        Color3.fromRGB(176, 107, 255),
        Color3.fromRGB(255, 184, 77),
        Color3.fromRGB(140, 140, 150),
    }

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
    label.Size = UDim2.new(1, -220, 1, 0)
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

    local state = default
    local swatches = {}

    for i, col in ipairs(palette) do
        local sw = Instance.new("TextButton")
        sw.Size = UDim2.new(0, 14, 0, 14)
        sw.Position = UDim2.new(1, -18 - (i - 1) * 18, 0.5, -7)
        sw.BackgroundColor3 = col
        sw.BorderSizePixel = 0
        sw.Text = ""
        sw.ZIndex = 6
        sw.AutoButtonColor = false
        sw.Parent = row
        U.Corner(sw, UDim.new(0, 1))

        if col == state then
            sw.Size = UDim2.new(0, 16, 0, 16)
            sw.Position = UDim2.new(1, -19 - (i - 1) * 18, 0.5, -8)
        end

        sw.MouseEnter:Connect(function()
            TweenService:Create(sw, TweenInfo.new(0.12), {Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(1, -20 - (i - 1) * 18, 0.5, -9)}):Play()
        end)
        sw.MouseLeave:Connect(function()
            TweenService:Create(sw, TweenInfo.new(0.12), {Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(1, -18 - (i - 1) * 18, 0.5, -7)}):Play()
        end)

        sw.MouseButton1Click:Connect(function()
            state = col
            if callback then callback(col) end
        end)

        table.insert(swatches, { Btn = sw, Color = col })
    end

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
        Type = "colorpicker",
    }

    function el.Set(c, silent)
        state = c
        el.Value = c
        if not silent and callback then callback(c) end
    end

    function el.Get()
        return state
    end

    module.RegisterElement(el)
    return el
end