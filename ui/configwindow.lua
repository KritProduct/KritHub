local ConfigWindow = {}

function ConfigWindow.Create(Hub, mainWindow)
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local T = Hub.Theme
    local U = Hub.Utils
    local Config = Hub.Features.Config

    local CW = {}
    CW.Rows = {}
    CW.Visible = false
    CW.Width = 220
    CW.Height = 360

    CW.Gui = Instance.new("ScreenGui")
    CW.Gui.Name = "KritHubConfigs"
    CW.Gui.ResetOnSpawn = false
    CW.Gui.IgnoreGuiInset = true
    CW.Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    CW.Gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

    CW.Main = Instance.new("Frame")
    CW.Main.Size = UDim2.new(0, CW.Width, 0, CW.Height)
    CW.Main.Position = UDim2.new(0, 660, 0.5, -180)
    CW.Main.BackgroundColor3 = T.Background
    CW.Main.BorderSizePixel = 0
    CW.Main.Active = true
    CW.Main.ClipsDescendants = true
    CW.Main.Visible = false
    CW.Main.Parent = CW.Gui
    U.Corner(CW.Main, UDim.new(0, 14))

    local stroke = U.Stroke(CW.Main, T.Accent, 2)

    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 34)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 14, 20)),
    })
    grad.Rotation = 90
    grad.Parent = CW.Main

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundColor3 = T.Panel
    header.BackgroundTransparency = 0.15
    header.BorderSizePixel = 0
    header.ZIndex = 2
    header.Parent = CW.Main
    U.Corner(header, UDim.new(0, 14))

    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1, 0, 0, 14)
    headerFix.Position = UDim2.new(0, 0, 1, -14)
    headerFix.BackgroundColor3 = T.Panel
    headerFix.BackgroundTransparency = 0.15
    headerFix.BorderSizePixel = 0
    headerFix.ZIndex = 2
    headerFix.Parent = header

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -80, 1, 0)
    title.Position = UDim2.new(0, 16, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "CONFIGS"
    title.TextColor3 = T.Accent
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 3
    title.Parent = header

    local addBtn = Instance.new("TextButton")
    addBtn.Size = UDim2.new(0, 26, 0, 26)
    addBtn.Position = UDim2.new(1, -36, 0, 7)
    addBtn.BackgroundColor3 = T.Green
    addBtn.BorderSizePixel = 0
    addBtn.Text = "+"
    addBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    addBtn.Font = Enum.Font.GothamBold
    addBtn.TextSize = 16
    addBtn.ZIndex = 3
    addBtn.AutoButtonColor = false
    addBtn.Parent = header
    U.Corner(addBtn, UDim.new(0, 6))

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -16, 1, -56)
    scroll.Position = UDim2.new(0, 8, 0, 48)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 5
    scroll.ScrollBarImageColor3 = T.Accent
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
        row.BackgroundColor3 = T.Item
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
        label.TextColor3 = T.Text
        label.Font = Enum.Font.GothamSemibold
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextTruncate = Enum.TextTruncate.AtEnd
        label.ZIndex = 5
        label.Parent = row

        local loadBtn = Instance.new("TextButton")
        loadBtn.Size = UDim2.new(0, 26, 0, 24)
        loadBtn.Position = UDim2.new(1, -58, 0.5, -12)
        loadBtn.BackgroundColor3 = T.Accent
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
        delBtn.BackgroundColor3 = T.Red
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
            Config.Load(name)
        end)

        delBtn.MouseButton1Click:Connect(function()
            Config.Delete(name)
            CW.Refresh()
        end)

        row.MouseEnter:Connect(function()
            TweenService:Create(row, TweenInfo.new(0.15), {BackgroundColor3 = T.ItemHover}):Play()
        end)
        row.MouseLeave:Connect(function()
            TweenService:Create(row, TweenInfo.new(0.15), {BackgroundColor3 = T.Item}):Play()
        end)

        table.insert(CW.Rows, { Frame = row, Name = name })
    end

    function CW.Refresh()
        clearRows()

        if not Config then return end

        if not Config.HasApi() then
            local err = Instance.new("TextLabel")
            err.Size = UDim2.new(1, -6, 0, 40)
            err.BackgroundColor3 = T.Item
            err.BorderSizePixel = 0
            err.Text = "File API not supported"
            err.TextColor3 = T.Red
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
            empty.BackgroundColor3 = T.Item
            empty.BorderSizePixel = 0
            empty.Text = "No configs. Press + to save"
            empty.TextColor3 = T.TextDim
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

    function CW.Toggle()
        CW.Visible = not CW.Visible
        CW.Main.Visible = CW.Visible
        if CW.Visible then
            CW.Refresh()
        end
    end

    function CW.Show()
        CW.Visible = true
        CW.Main.Visible = true
        CW.Refresh()
    end

    function CW.Hide()
        CW.Visible = false
        CW.Main.Visible = false
    end

    CW.Refresh()

    return CW
end

return ConfigWindow