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
    CW.Visible = true
    CW.Width = 240
    CW.Height = 420

    CW.Gui = Instance.new("ScreenGui")
    CW.Gui.Name = "KritHubConfigs"
    CW.Gui.ResetOnSpawn = false
    CW.Gui.IgnoreGuiInset = true
    CW.Gui.DisplayOrder = 999
    CW.Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    CW.Gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

    CW.Main = Instance.new("Frame")
    CW.Main.Name = "ConfigFrame"
    CW.Main.Size = UDim2.new(0, CW.Width, 0, CW.Height)
    CW.Main.Position = UDim2.new(0, 20, 0.5, -CW.Height / 2)
    CW.Main.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    CW.Main.BorderSizePixel = 0
    CW.Main.Active = true
    CW.Main.ClipsDescendants = true
    CW.Main.Visible = true
    CW.Main.Parent = CW.Gui
    U.Corner(CW.Main, UDim.new(0, 14))

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 100, 200)
    stroke.Thickness = 2
    stroke.Parent = CW.Main

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 42)
    header.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    header.BorderSizePixel = 0
    header.ZIndex = 2
    header.Parent = CW.Main
    U.Corner(header, UDim.new(0, 14))

    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1, 0, 0, 14)
    headerFix.Position = UDim2.new(0, 0, 1, -14)
    headerFix.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    headerFix.BorderSizePixel = 0
    headerFix.ZIndex = 2
    headerFix.Parent = header

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -70, 1, 0)
    title.Position = UDim2.new(0, 16, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "CONFIGS"
    title.TextColor3 = Color3.fromRGB(255, 100, 200)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 3
    title.Parent = header

    local addBtn = Instance.new("TextButton")
    addBtn.Size = UDim2.new(0, 26, 0, 26)
    addBtn.Position = UDim2.new(1, -36, 0, 8)
    addBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
    addBtn.BorderSizePixel = 0
    addBtn.Text = "+"
    addBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    addBtn.Font = Enum.Font.GothamBold
    addBtn.TextSize = 16
    addBtn.ZIndex = 3
    addBtn.AutoButtonColor = false
    addBtn.Parent = header
    U.Corner(addBtn, UDim.new(0, 6))

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 26, 0, 26)
    closeBtn.Position = UDim2.new(1, -66, 0, 8)
    closeBtn.BackgroundColor3 = Color3.fromRGB(230, 57, 70)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 12
    closeBtn.ZIndex = 3
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = header
    U.Corner(closeBtn, UDim.new(0, 6))

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -16, 1, -58)
    scroll.Position = UDim2.new(0, 8, 0, 50)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 5
    scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 100, 200)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.ScrollingDirection = Enum.ScrollingDirection.Y
    scroll.ZIndex = 3
    scroll.Parent = CW.Main

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 6)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Parent = scroll

    local function clearRows()
        for _, row in ipairs(CW.Rows) do
            row.Frame:Destroy()
        end
        CW.Rows = {}
    end

    local function makeRow(name)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -6, 0, 34)
        row.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
        row.BorderSizePixel = 0
        row.LayoutOrder = #CW.Rows + 1
        row.ZIndex = 4
        row.Parent = scroll
        U.Corner(row, UDim.new(0, 8))

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -70, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.fromRGB(235, 235, 245)
        label.Font = Enum.Font.GothamSemibold
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextTruncate = Enum.TextTruncate.AtEnd
        label.ZIndex = 5
        label.Parent = row

        local loadBtn = Instance.new("TextButton")
        loadBtn.Size = UDim2.new(0, 26, 0, 24)
        loadBtn.Position = UDim2.new(1, -58, 0.5, -12)
        loadBtn.BackgroundColor3 = Color3.fromRGB(77, 141, 255)
        loadBtn.BorderSizePixel = 0
        loadBtn.Text = "L"
        loadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        loadBtn.Font = Enum.Font.GothamBold
        loadBtn.TextSize = 12
        loadBtn.ZIndex = 5
        loadBtn.AutoButtonColor = false
        loadBtn.Parent = row
        U.Corner(loadBtn, UDim.new(0, 6))

        local delBtn = Instance.new("TextButton")
        delBtn.Size = UDim2.new(0, 26, 0, 24)
        delBtn.Position = UDim2.new(1, -30, 0.5, -12)
        delBtn.BackgroundColor3 = Color3.fromRGB(230, 57, 70)
        delBtn.BorderSizePixel = 0
        delBtn.Text = "X"
        delBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        delBtn.Font = Enum.Font.GothamBold
        delBtn.TextSize = 12
        delBtn.ZIndex = 5
        delBtn.AutoButtonColor = false
        delBtn.Parent = row
        U.Corner(delBtn, UDim.new(0, 6))

        loadBtn.MouseButton1Click:Connect(function()
            if Config then Config.Load(name) end
        end)

        delBtn.MouseButton1Click:Connect(function()
            if Config then
                Config.Delete(name)
                CW.Refresh()
            end
        end)

        table.insert(CW.Rows, { Frame = row, Name = name })
    end

    function CW.Refresh()
        clearRows()

        if not Config then
            local err = Instance.new("TextLabel")
            err.Size = UDim2.new(1, -6, 0, 40)
            err.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
            err.BorderSizePixel = 0
            err.Text = "Config module not loaded"
            err.TextColor3 = Color3.fromRGB(230, 57, 70)
            err.Font = Enum.Font.Gotham
            err.TextSize = 12
            err.LayoutOrder = 1
            err.ZIndex = 4
            err.Parent = scroll
            U.Corner(err, UDim.new(0, 8))
            return
        end

        if not Config.HasApi() then
            local err = Instance.new("TextLabel")
            err.Size = UDim2.new(1, -6, 0, 40)
            err.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
            err.BorderSizePixel = 0
            err.Text = "File API not supported by executor"
            err.TextColor3 = Color3.fromRGB(230, 57, 70)
            err.Font = Enum.Font.Gotham
            err.TextSize = 12
            err.LayoutOrder = 1
            err.ZIndex = 4
            err.Parent = scroll
            U.Corner(err, UDim.new(0, 8))
            return
        end

        local list_ = Config.List()

        if #list_ == 0 then
            local empty = Instance.new("TextLabel")
            empty.Size = UDim2.new(1, -6, 0, 40)
            empty.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
            empty.BorderSizePixel = 0
            empty.Text = "No configs. Press + to save"
            empty.TextColor3 = Color3.fromRGB(140, 140, 160)
            empty.Font = Enum.Font.Gotham
            empty.TextSize = 12
            empty.LayoutOrder = 1
            empty.ZIndex = 4
            empty.Parent = scroll
            U.Corner(empty, UDim.new(0, 8))
            return
        end

        for _, name in ipairs(list_) do
            makeRow(name)
        end
    end

    addBtn.MouseButton1Click:Connect(function()
        local name = "config_" .. os.date("%H%M%S")
        if Config and Config.Save then
            Config.Save(name)
            CW.Refresh()
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        CW.Main.Visible = false
    end)

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

    function CW.Toggle()
        CW.Main.Visible = not CW.Main.Visible
        if CW.Main.Visible then CW.Refresh() end
    end

    function CW.Show()
        CW.Main.Visible = true
        CW.Refresh()
    end

    function CW.Hide()
        CW.Main.Visible = false
    end

    CW.Refresh()

    print("[KritHub] config window CREATED and VISIBLE at:", CW.Main.Position)

    return CW
end

return ConfigWindow