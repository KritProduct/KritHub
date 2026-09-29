local ConfigWindow = {}

function ConfigWindow.Create(Hub, mainWindow)
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local T = Hub.Theme
    local U = Hub.Utils
    local Config = Hub.Features.Config

    local CW = {}
    CW.Rows = {}
    CW.Visible = false

    CW.Main = Instance.new("Frame")
    CW.Main.Name = "KritHubConfigsFrame"
    CW.Main.Size = UDim2.new(0, 320, 0, 480)
    CW.Main.Position = UDim2.new(0, 20, 0.5, -240)
    CW.Main.BackgroundColor3 = T.Background
    CW.Main.BorderSizePixel = 0
    CW.Main.Active = true
    CW.Main.ClipsDescendants = true
    CW.Main.Visible = false
    CW.Main.ZIndex = 100
    CW.Main.Parent = mainWindow.Gui
    U.Corner(CW.Main, UDim.new(0, 3))

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = T.Border2
    mainStroke.Thickness = 1
    mainStroke.Parent = CW.Main

    local topLine = Instance.new("Frame")
    topLine.Size = UDim2.new(1, 0, 0, 2)
    topLine.Position = UDim2.new(0, 0, 0, 0)
    topLine.BackgroundColor3 = T.Accent
    topLine.BorderSizePixel = 0
    topLine.ZIndex = 10
    topLine.Parent = CW.Main

    local topLineGrad = Instance.new("UIGradient")
    topLineGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.2, 0),
        NumberSequenceKeypoint.new(0.8, 0),
        NumberSequenceKeypoint.new(1, 1),
    })
    topLineGrad.Parent = topLine

    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 44)
    header.BackgroundColor3 = T.Background
    header.BorderSizePixel = 0
    header.ZIndex = 2
    header.Parent = CW.Main

    local headerGrad = Instance.new("UIGradient")
    headerGrad.Color = ColorSequence.new(Color3.fromRGB(15, 15, 20), Color3.fromRGB(10, 10, 14))
    headerGrad.Rotation = 90
    headerGrad.Parent = header

    local headerLine = Instance.new("Frame")
    headerLine.Size = UDim2.new(1, 0, 0, 1)
    headerLine.Position = UDim2.new(0, 0, 1, -1)
    headerLine.BackgroundColor3 = T.Border
    headerLine.BorderSizePixel = 0
    headerLine.ZIndex = 3
    headerLine.Parent = header

    local headerLogo = Instance.new("Frame")
    headerLogo.Size = UDim2.new(0, 16, 0, 16)
    headerLogo.Position = UDim2.new(0, 16, 0.5, -8)
    headerLogo.BackgroundTransparency = 1
    headerLogo.ZIndex = 4
    headerLogo.Parent = header

    local hlDiamond = Instance.new("Frame")
    hlDiamond.Size = UDim2.new(1, 0, 1, 0)
    hlDiamond.BackgroundColor3 = T.Background
    hlDiamond.BorderSizePixel = 0
    hlDiamond.Rotation = 45
    hlDiamond.ZIndex = 4
    hlDiamond.Parent = headerLogo

    local hlStroke = Instance.new("UIStroke")
    hlStroke.Color = T.Accent
    hlStroke.Thickness = 2
    hlStroke.Parent = hlDiamond

    local hlDot = Instance.new("Frame")
    hlDot.Size = UDim2.new(0, 4, 0, 4)
    hlDot.Position = UDim2.new(0.5, -2, 0.5, -2)
    hlDot.BackgroundColor3 = T.Accent
    hlDot.BorderSizePixel = 0
    hlDot.ZIndex = 5
    hlDot.Parent = headerLogo

    local headerTitle = Instance.new("TextLabel")
    headerTitle.Size = UDim2.new(1, -100, 1, 0)
    headerTitle.Position = UDim2.new(0, 44, 0, 0)
    headerTitle.BackgroundTransparency = 1
    headerTitle.Text = "CONFIGS"
    headerTitle.TextColor3 = T.TextHi
    headerTitle.Font = Enum.Font.GothamBold
    headerTitle.TextSize = 14
    headerTitle.TextXAlignment = Enum.TextXAlignment.Left
    headerTitle.ZIndex = 4
    headerTitle.Parent = header

    local addBtn = Instance.new("TextButton")
    addBtn.Name = "AddButton"
    addBtn.Size = UDim2.new(0, 28, 0, 28)
    addBtn.Position = UDim2.new(1, -42, 0, 8)
    addBtn.BackgroundColor3 = T.Panel
    addBtn.BorderSizePixel = 0
    addBtn.Text = "+"
    addBtn.TextColor3 = T.Accent
    addBtn.Font = Enum.Font.GothamBold
    addBtn.TextSize = 18
    addBtn.ZIndex = 4
    addBtn.AutoButtonColor = false
    addBtn.Parent = header
    U.Corner(addBtn, UDim.new(0, 2))

    local addStroke = Instance.new("UIStroke")
    addStroke.Color = T.AccentDim
    addStroke.Thickness = 1
    addStroke.Parent = addBtn

    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(1, -74, 0, 8)
    closeBtn.BackgroundColor3 = T.Panel
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "X"
    closeBtn.TextColor3 = T.TextDim
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 12
    closeBtn.ZIndex = 4
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = header
    U.Corner(closeBtn, UDim.new(0, 2))

    local closeStroke = Instance.new("UIStroke")
    closeStroke.Color = T.Border2
    closeStroke.Thickness = 1
    closeStroke.Parent = closeBtn

    local dragging = false
    local dragStart = nil
    local startPos = nil

    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = UserInputService:GetMouseLocation()
            startPos = CW.Main.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local m = UserInputService:GetMouseLocation()
            local delta = m - dragStart
            CW.Main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    addBtn.MouseEnter:Connect(function()
        TweenService:Create(addBtn, TweenInfo.new(0.12), {BackgroundColor3 = T.AccentDim}):Play()
        TweenService:Create(addBtn, TweenInfo.new(0.12), {TextColor3 = T.AccentHi}):Play()
        TweenService:Create(addStroke, TweenInfo.new(0.12), {Color = T.Accent}):Play()
    end)
    addBtn.MouseLeave:Connect(function()
        TweenService:Create(addBtn, TweenInfo.new(0.12), {BackgroundColor3 = T.Panel}):Play()
        TweenService:Create(addBtn, TweenInfo.new(0.12), {TextColor3 = T.Accent}):Play()
        TweenService:Create(addStroke, TweenInfo.new(0.12), {Color = T.AccentDim}):Play()
    end)

    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.12), {BackgroundColor3 = T.Red}):Play()
        TweenService:Create(closeBtn, TweenInfo.new(0.12), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        TweenService:Create(closeStroke, TweenInfo.new(0.12), {Color = T.Red}):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.12), {BackgroundColor3 = T.Panel}):Play()
        TweenService:Create(closeBtn, TweenInfo.new(0.12), {TextColor3 = T.TextDim}):Play()
        TweenService:Create(closeStroke, TweenInfo.new(0.12), {Color = T.Border2}):Play()
    end)

    local sectionTitle = Instance.new("TextLabel")
    sectionTitle.Size = UDim2.new(1, -24, 0, 16)
    sectionTitle.Position = UDim2.new(0, 12, 0, 54)
    sectionTitle.BackgroundTransparency = 1
    sectionTitle.Text = "SAVED CONFIGS"
    sectionTitle.TextColor3 = T.TextMuted
    sectionTitle.Font = Enum.Font.Code
    sectionTitle.TextSize = 10
    sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    sectionTitle.ZIndex = 3
    sectionTitle.Parent = CW.Main

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -16, 1, -82)
    scroll.Position = UDim2.new(0, 8, 0, 74)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = T.Border2
    scroll.ScrollBarImageTransparency = 0
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.ScrollingDirection = Enum.ScrollingDirection.Y
    scroll.ElasticBehavior = Enum.ElasticBehavior.Always
    scroll.ZIndex = 3
    scroll.Parent = CW.Main

    local scrollList = Instance.new("UIListLayout")
    scrollList.Padding = UDim.new(0, 4)
    scrollList.SortOrder = Enum.SortOrder.LayoutOrder
    scrollList.Parent = scroll

    local function clearRows()
        for _, row in ipairs(CW.Rows) do
            if row.Frame then row.Frame:Destroy() end
        end
        CW.Rows = {}
    end

    local function clearAll()
        for _, child in ipairs(scroll:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextLabel") then
                child:Destroy()
            end
        end
    end

    local function makeRow(name)
        local row = Instance.new("Frame")
        row.Name = "Row_" .. name
        row.Size = UDim2.new(1, -6, 0, 36)
        row.BackgroundColor3 = T.Item
        row.BorderSizePixel = 0
        row.LayoutOrder = #CW.Rows + 1
        row.ZIndex = 4
        row.Parent = scroll
        U.Corner(row, UDim.new(0, 2))

        local rowStroke = Instance.new("UIStroke")
        rowStroke.Color = T.Border
        rowStroke.Thickness = 1
        rowStroke.Parent = row

        local accentBar = Instance.new("Frame")
        accentBar.Size = UDim2.new(0, 2, 1, 0)
        accentBar.Position = UDim2.new(0, 0, 0, 0)
        accentBar.BackgroundColor3 = T.Accent
        accentBar.BorderSizePixel = 0
        accentBar.ZIndex = 5
        accentBar.Visible = false
        accentBar.Parent = row

        local icon = Instance.new("Frame")
        icon.Size = UDim2.new(0, 12, 0, 12)
        icon.Position = UDim2.new(0, 14, 0.5, -6)
        icon.BackgroundColor3 = T.Border2
        icon.BorderSizePixel = 0
        icon.ZIndex = 5
        icon.Parent = row
        U.Corner(icon, UDim.new(0, 1))

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -100, 1, 0)
        label.Position = UDim2.new(0, 34, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = T.Text
        label.Font = Enum.Font.GothamSemibold
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextTruncate = Enum.TextTruncate.AtEnd
        label.ZIndex = 5
        label.Parent = row

        local loadBtn = Instance.new("TextButton")
        loadBtn.Name = "LoadButton"
        loadBtn.Size = UDim2.new(0, 26, 0, 22)
        loadBtn.Position = UDim2.new(1, -62, 0.5, -11)
        loadBtn.BackgroundColor3 = T.Panel
        loadBtn.BorderSizePixel = 0
        loadBtn.Text = "L"
        loadBtn.TextColor3 = T.Accent
        loadBtn.Font = Enum.Font.Code
        loadBtn.TextSize = 12
        loadBtn.ZIndex = 5
        loadBtn.AutoButtonColor = false
        loadBtn.Parent = row
        U.Corner(loadBtn, UDim.new(0, 2))

        local loadStroke = Instance.new("UIStroke")
        loadStroke.Color = T.AccentDim
        loadStroke.Thickness = 1
        loadStroke.Parent = loadBtn

        local delBtn = Instance.new("TextButton")
        delBtn.Name = "DeleteButton"
        delBtn.Size = UDim2.new(0, 26, 0, 22)
        delBtn.Position = UDim2.new(1, -32, 0.5, -11)
        delBtn.BackgroundColor3 = T.Panel
        delBtn.BorderSizePixel = 0
        delBtn.Text = "X"
        delBtn.TextColor3 = T.TextDim
        delBtn.Font = Enum.Font.Code
        delBtn.TextSize = 12
        delBtn.ZIndex = 5
        delBtn.AutoButtonColor = false
        delBtn.Parent = row
        U.Corner(delBtn, UDim.new(0, 2))

        local delStroke = Instance.new("UIStroke")
        delStroke.Color = T.Border2
        delStroke.Thickness = 1
        delStroke.Parent = delBtn

        loadBtn.MouseButton1Click:Connect(function()
            if Config then Config.Load(name) end
        end)

        delBtn.MouseButton1Click:Connect(function()
            if Config then
                Config.Delete(name)
                CW.Refresh()
            end
        end)

        row.MouseEnter:Connect(function()
            TweenService:Create(row, TweenInfo.new(0.12), {BackgroundColor3 = T.ItemHover}):Play()
            TweenService:Create(rowStroke, TweenInfo.new(0.12), {Color = T.Border2}):Play()
            accentBar.Visible = true
            icon.BackgroundColor3 = T.Accent
        end)
        row.MouseLeave:Connect(function()
            TweenService:Create(row, TweenInfo.new(0.12), {BackgroundColor3 = T.Item}):Play()
            TweenService:Create(rowStroke, TweenInfo.new(0.12), {Color = T.Border}):Play()
            accentBar.Visible = false
            icon.BackgroundColor3 = T.Border2
        end)

        loadBtn.MouseEnter:Connect(function()
            TweenService:Create(loadBtn, TweenInfo.new(0.12), {BackgroundColor3 = T.AccentDim}):Play()
            TweenService:Create(loadStroke, TweenInfo.new(0.12), {Color = T.Accent}):Play()
        end)
        loadBtn.MouseLeave:Connect(function()
            TweenService:Create(loadBtn, TweenInfo.new(0.12), {BackgroundColor3 = T.Panel}):Play()
            TweenService:Create(loadStroke, TweenInfo.new(0.12), {Color = T.AccentDim}):Play()
        end)

        delBtn.MouseEnter:Connect(function()
            TweenService:Create(delBtn, TweenInfo.new(0.12), {BackgroundColor3 = T.Red}):Play()
            TweenService:Create(delBtn, TweenInfo.new(0.12), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(delStroke, TweenInfo.new(0.12), {Color = T.Red}):Play()
        end)
        delBtn.MouseLeave:Connect(function()
            TweenService:Create(delBtn, TweenInfo.new(0.12), {BackgroundColor3 = T.Panel}):Play()
            TweenService:Create(delBtn, TweenInfo.new(0.12), {TextColor3 = T.TextDim}):Play()
            TweenService:Create(delStroke, TweenInfo.new(0.12), {Color = T.Border2}):Play()
        end)

        table.insert(CW.Rows, { Frame = row, Name = name })
    end

    function CW.Refresh()
        clearAll()

        if not Config then
            local err = Instance.new("TextLabel")
            err.Size = UDim2.new(1, -6, 0, 40)
            err.BackgroundColor3 = T.Item
            err.BorderSizePixel = 0
            err.Text = "CONFIG MODULE NOT LOADED"
            err.TextColor3 = T.Red
            err.Font = Enum.Font.Code
            err.TextSize = 11
            err.LayoutOrder = 1
            err.ZIndex = 4
            err.Parent = scroll
            U.Corner(err, UDim.new(0, 2))
            return
        end

        if not Config.HasApi() then
            local err = Instance.new("TextLabel")
            err.Size = UDim2.new(1, -6, 0, 40)
            err.BackgroundColor3 = T.Item
            err.BorderSizePixel = 0
            err.Text = "FILE API NOT SUPPORTED"
            err.TextColor3 = T.Red
            err.Font = Enum.Font.Code
            err.TextSize = 11
            err.LayoutOrder = 1
            err.ZIndex = 4
            err.Parent = scroll
            U.Corner(err, UDim.new(0, 2))
            return
        end

        local list_ = Config.List()

        if #list_ == 0 then
            local empty = Instance.new("TextLabel")
            empty.Size = UDim2.new(1, -6, 0, 60)
            empty.BackgroundColor3 = T.Item
            empty.BorderSizePixel = 0
            empty.Text = "NO CONFIGS\nPRESS + TO CREATE"
            empty.TextColor3 = T.TextMuted
            empty.Font = Enum.Font.Code
            empty.TextSize = 11
            empty.LayoutOrder = 1
            empty.ZIndex = 4
            empty.Parent = scroll
            U.Corner(empty, UDim.new(0, 2))
            return
        end

        for _, name in ipairs(list_) do
            makeRow(name)
        end
    end

    addBtn.MouseButton1Click:Connect(function()
        if Config and Config.Save then
            Config.Save()
            CW.Refresh()
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        CW.Hide()
    end)

    function CW.Toggle()
        CW.Main.Visible = not CW.Main.Visible
        CW.Visible = CW.Main.Visible
        if CW.Visible then
            CW.Refresh()
        end
    end

    function CW.Show()
        CW.Main.Visible = true
        CW.Visible = true
        CW.Refresh()
    end

    function CW.Hide()
        CW.Main.Visible = false
        CW.Visible = false
    end

    CW.Refresh()

    return CW
end

return ConfigWindow