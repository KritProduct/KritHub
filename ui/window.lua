local Window = {}

function Window.Create(Hub)
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local player = Players.LocalPlayer
    local T = Hub.Theme
    local U = Hub.Utils

    local W = {}
    W.Hub = Hub

    W.Gui = Instance.new("ScreenGui")
    W.Gui.Name = "KritHub"
    W.Gui.ResetOnSpawn = false
    W.Gui.IgnoreGuiInset = true
    W.Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    W.Gui.Parent = player:WaitForChild("PlayerGui")

    W.Main = Instance.new("Frame")
    W.Main.Size = UDim2.new(0, 620, 0, 440)
    W.Main.Position = UDim2.new(0.5, -310, 0.5, -220)
    W.Main.BackgroundColor3 = T.Background
    W.Main.BorderSizePixel = 0
    W.Main.Active = true
    W.Main.ClipsDescendants = true
    W.Main.Parent = W.Gui
    U.Corner(W.Main, UDim.new(0, 16))

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 34)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 14, 20)),
    })
    gradient.Rotation = 90
    gradient.Parent = W.Main

    W.Stroke = U.Stroke(W.Main, T.Accent, 2)

    W.Header = Instance.new("Frame")
    W.Header.Size = UDim2.new(1, 0, 0, 48)
    W.Header.BackgroundColor3 = T.Panel
    W.Header.BackgroundTransparency = 0.15
    W.Header.BorderSizePixel = 0
    W.Header.ZIndex = 2
    W.Header.Parent = W.Main
    U.Corner(W.Header, UDim.new(0, 16))

    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1, 0, 0, 16)
    headerFix.Position = UDim2.new(0, 0, 1, -16)
    headerFix.BackgroundColor3 = T.Panel
    headerFix.BackgroundTransparency = 0.15
    headerFix.BorderSizePixel = 0
    headerFix.ZIndex = 2
    headerFix.Parent = W.Header

    local accentLine = Instance.new("Frame")
    accentLine.Size = UDim2.new(1, 0, 0, 2)
    accentLine.Position = UDim2.new(0, 0, 1, -2)
    accentLine.BackgroundColor3 = T.Accent
    accentLine.BorderSizePixel = 0
    accentLine.ZIndex = 3
    accentLine.Parent = W.Header

    local dragHandle = Instance.new("TextButton")
    dragHandle.Size = UDim2.new(1, -200, 1, 0)
    dragHandle.BackgroundTransparency = 1
    dragHandle.Text = ""
    dragHandle.ZIndex = 3
    dragHandle.AutoButtonColor = false
    dragHandle.Parent = W.Header

    W.Brand = Instance.new("TextLabel")
    W.Brand.Size = UDim2.new(0, 220, 1, 0)
    W.Brand.Position = UDim2.new(0, 22, 0, 0)
    W.Brand.BackgroundTransparency = 1
    W.Brand.Text = "KRITHUB"
    W.Brand.TextColor3 = T.Accent
    W.Brand.Font = Enum.Font.GothamBold
    W.Brand.TextSize = 22
    W.Brand.TextXAlignment = Enum.TextXAlignment.Left
    W.Brand.ZIndex = 4
    W.Brand.Parent = W.Header

    W.Version = Instance.new("TextLabel")
    W.Version.Size = UDim2.new(0, 80, 1, 0)
    W.Version.Position = UDim2.new(0, 118, 0, 3)
    W.Version.BackgroundTransparency = 1
    W.Version.Text = "v1.0"
    W.Version.TextColor3 = T.TextDim
    W.Version.Font = Enum.Font.Gotham
    W.Version.TextSize = 12
    W.Version.TextXAlignment = Enum.TextXAlignment.Left
    W.Version.ZIndex = 4
    W.Version.Parent = W.Header

    W.MinBtn = Instance.new("TextButton")
    W.MinBtn.Size = UDim2.new(0, 32, 0, 26)
    W.MinBtn.Position = UDim2.new(1, -80, 0, 11)
    W.MinBtn.BackgroundColor3 = T.Item
    W.MinBtn.BorderSizePixel = 0
    W.MinBtn.Text = "—"
    W.MinBtn.TextColor3 = T.Text
    W.MinBtn.Font = Enum.Font.GothamBold
    W.MinBtn.TextSize = 16
    W.MinBtn.ZIndex = 4
    W.MinBtn.AutoButtonColor = false
    W.MinBtn.Parent = W.Header
    U.Corner(W.MinBtn, UDim.new(0, 8))

    W.CloseBtn = Instance.new("TextButton")
    W.CloseBtn.Size = UDim2.new(0, 32, 0, 26)
    W.CloseBtn.Position = UDim2.new(1, -42, 0, 11)
    W.CloseBtn.BackgroundColor3 = T.Red
    W.CloseBtn.BorderSizePixel = 0
    W.CloseBtn.Text = "X"
    W.CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    W.CloseBtn.Font = Enum.Font.GothamBold
    W.CloseBtn.TextSize = 14
    W.CloseBtn.ZIndex = 4
    W.CloseBtn.AutoButtonColor = false
    W.CloseBtn.Parent = W.Header
    U.Corner(W.CloseBtn, UDim.new(0, 8))

    W.Sidebar = Instance.new("Frame")
    W.Sidebar.Size = UDim2.new(0, 150, 1, -70)
    W.Sidebar.Position = UDim2.new(0, 10, 0, 60)
    W.Sidebar.BackgroundColor3 = T.Panel
    W.Sidebar.BackgroundTransparency = 0.15
    W.Sidebar.BorderSizePixel = 0
    W.Sidebar.ZIndex = 2
    W.Sidebar.Parent = W.Main
    U.Corner(W.Sidebar, UDim.new(0, 12))

    local sidebarList = Instance.new("UIListLayout")
    sidebarList.Padding = UDim.new(0, 6)
    sidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarList.Parent = W.Sidebar
    U.Padding(W.Sidebar, 8)

    W.Content = Instance.new("Frame")
    W.Content.Size = UDim2.new(1, -170, 1, -70)
    W.Content.Position = UDim2.new(0, 160, 0, 60)
    W.Content.BackgroundColor3 = T.Settings
    W.Content.BackgroundTransparency = 0.15
    W.Content.BorderSizePixel = 0
    W.Content.ClipsDescendants = true
    W.Content.ZIndex = 2
    W.Content.Parent = W.Main
    U.Corner(W.Content, UDim.new(0, 12))

    W.ContentScroll = Instance.new("ScrollingFrame")
    W.ContentScroll.Size = UDim2.new(1, -16, 1, -16)
    W.ContentScroll.Position = UDim2.new(0, 8, 0, 8)
    W.ContentScroll.BackgroundTransparency = 1
    W.ContentScroll.BorderSizePixel = 0
    W.ContentScroll.ScrollBarThickness = 5
    W.ContentScroll.ScrollBarImageColor3 = T.Accent
    W.ContentScroll.ScrollBarImageTransparency = 0
    W.ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    W.ContentScroll.AutomaticCanvasSize = Enum.AutomaticSize.None
    W.ContentScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    W.ContentScroll.ElasticBehavior = Enum.ElasticBehavior.Always
    W.ContentScroll.ZIndex = 3
    W.ContentScroll.Parent = W.Content

    local contentList = Instance.new("UIListLayout")
    contentList.Padding = UDim.new(0, 8)
    contentList.SortOrder = Enum.SortOrder.LayoutOrder
    contentList.Parent = W.ContentScroll

    W.ContentList = contentList

    local dragging = false
    local dragStart = nil
    local startPos = nil

    dragHandle.MouseButton1Down:Connect(function()
        dragging = true
        dragStart = UserInputService:GetMouseLocation()
        startPos = W.Main.Position
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local m = UserInputService:GetMouseLocation()
            local delta = m - dragStart
            W.Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    W.MinBtn.MouseEnter:Connect(function()
        TweenService:Create(W.MinBtn, TweenInfo.new(0.15), {BackgroundColor3 = T.ItemHover}):Play()
    end)
    W.MinBtn.MouseLeave:Connect(function()
        TweenService:Create(W.MinBtn, TweenInfo.new(0.15), {BackgroundColor3 = T.Item}):Play()
    end)
    W.CloseBtn.MouseEnter:Connect(function()
        TweenService:Create(W.CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(255, 80, 95)}):Play()
    end)
    W.CloseBtn.MouseLeave:Connect(function()
        TweenService:Create(W.CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = T.Red}):Play()
    end)

    function W.Pulse(btn)
        if not btn:GetAttribute("OrigSize") then
            btn:SetAttribute("OrigSize", btn.Size)
        end
        local orig = btn:GetAttribute("OrigSize")
        local small = UDim2.new(0, orig.X.Offset - 3, 0, orig.Y.Offset - 3)
        local big = UDim2.new(0, orig.X.Offset + 1, 0, orig.Y.Offset + 1)
        TweenService:Create(btn, TweenInfo.new(0.07), {Size = small}):Play()
        task.delay(0.07, function()
            TweenService:Create(btn, TweenInfo.new(0.12), {Size = big}):Play()
            task.delay(0.12, function()
                TweenService:Create(btn, TweenInfo.new(0.1), {Size = orig}):Play()
            end)
        end)
    end

    function W.RecalcCanvas()
        local scroll = W.ContentScroll
        if not scroll then return end

        local total = 0
        local count = 0
        local padding = 8

        for _, child in ipairs(scroll:GetChildren()) do
            if child:IsA("GuiObject") and child.Visible then
                total = total + child.Size.Y.Offset
                count = count + 1
            end
        end

        if count > 1 then
            total = total + padding * (count - 1)
        end

        total = total + padding * 2

        scroll.CanvasSize = UDim2.new(0, 0, 0, total)
    end

    function W.FadeIn()
        W.Main.BackgroundTransparency = 1
        W.Header.BackgroundTransparency = 1
        headerFix.BackgroundTransparency = 1
        W.Sidebar.BackgroundTransparency = 1
        W.Content.BackgroundTransparency = 1
        W.Stroke.Transparency = 1
        W.Main.Size = UDim2.new(0, 560, 0, 400)
        W.Main.Position = UDim2.new(0.5, -280, 0.5, -200)

        TweenService:Create(W.Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 620, 0, 440),
            Position = UDim2.new(0.5, -310, 0.5, -220),
            BackgroundTransparency = 0,
        }):Play()
        TweenService:Create(W.Header, TweenInfo.new(0.4), {BackgroundTransparency = 0.15}):Play()
        TweenService:Create(headerFix, TweenInfo.new(0.4), {BackgroundTransparency = 0.15}):Play()
        TweenService:Create(W.Sidebar, TweenInfo.new(0.4), {BackgroundTransparency = 0.15}):Play()
        TweenService:Create(W.Content, TweenInfo.new(0.4), {BackgroundTransparency = 0.15}):Play()
        TweenService:Create(W.Stroke, TweenInfo.new(0.4), {Transparency = 0}):Play()
    end

    W.CloseBtn.MouseButton1Click:Connect(function()
        W.Pulse(W.CloseBtn)
        task.wait(0.1)
        W.Gui.Enabled = false
    end)

    W.MinBtn.MouseButton1Click:Connect(function()
        W.Pulse(W.MinBtn)
        if W.Main.Size.Y.Offset > 48 then
            TweenService:Create(W.Main, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 620, 0, 48)
            }):Play()
        else
            TweenService:Create(W.Main, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 620, 0, 440)
            }):Play()
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.K then
            W.Gui.Enabled = not W.Gui.Enabled
        end
    end)

    return W
end

return Window