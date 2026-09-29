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
    W.Main.Size = UDim2.new(0, 780, 0, 520)
    W.Main.Position = UDim2.new(0.5, -390, 0.5, -260)
    W.Main.BackgroundColor3 = T.Background
    W.Main.BorderSizePixel = 0
    W.Main.Active = true
    W.Main.ClipsDescendants = true
    W.Main.Parent = W.Gui
    U.Corner(W.Main, UDim.new(0, 3))

    W.Stroke = U.Stroke(W.Main, T.Border2, 1)

    local topLine = Instance.new("Frame")
    topLine.Name = "TopAccentLine"
    topLine.Size = UDim2.new(1, 0, 0, 2)
    topLine.Position = UDim2.new(0, 0, 0, 0)
    topLine.BackgroundColor3 = T.Accent
    topLine.BorderSizePixel = 0
    topLine.ZIndex = 10
    topLine.Parent = W.Main

    local topLineGrad = Instance.new("UIGradient")
    topLineGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.2, 0),
        NumberSequenceKeypoint.new(0.8, 0),
        NumberSequenceKeypoint.new(1, 1),
    })
    topLineGrad.Parent = topLine

    W.Header = Instance.new("Frame")
    W.Header.Size = UDim2.new(1, 0, 0, 48)
    W.Header.BackgroundColor3 = T.Background
    W.Header.BorderSizePixel = 0
    W.Header.ZIndex = 2
    W.Header.Parent = W.Main

    local headerGrad = Instance.new("UIGradient")
    headerGrad.Color = ColorSequence.new(Color3.fromRGB(15, 15, 20), Color3.fromRGB(10, 10, 14))
    headerGrad.Rotation = 90
    headerGrad.Parent = W.Header

    local headerLine = Instance.new("Frame")
    headerLine.Size = UDim2.new(1, 0, 0, 1)
    headerLine.Position = UDim2.new(0, 0, 1, -1)
    headerLine.BackgroundColor3 = T.Border
    headerLine.BorderSizePixel = 0
    headerLine.ZIndex = 3
    headerLine.Parent = W.Header

    local dragHandle = Instance.new("TextButton")
    dragHandle.Size = UDim2.new(1, -260, 1, 0)
    dragHandle.BackgroundTransparency = 1
    dragHandle.Text = ""
    dragHandle.ZIndex = 3
    dragHandle.AutoButtonColor = false
    dragHandle.Parent = W.Header

    local logo = Instance.new("Frame")
    logo.Size = UDim2.new(0, 22, 0, 22)
    logo.Position = UDim2.new(0, 18, 0.5, -11)
    logo.BackgroundTransparency = 1
    logo.ZIndex = 4
    logo.Parent = W.Header

    local logoDiamond = Instance.new("Frame")
    logoDiamond.Size = UDim2.new(1, 0, 1, 0)
    logoDiamond.BackgroundColor3 = T.Background
    logoDiamond.BorderSizePixel = 0
    logoDiamond.Rotation = 45
    logoDiamond.ZIndex = 4
    logoDiamond.Parent = logo

    local logoStroke = Instance.new("UIStroke")
    logoStroke.Color = T.Accent
    logoStroke.Thickness = 2
    logoStroke.Parent = logoDiamond

    local logoDot = Instance.new("Frame")
    logoDot.Size = UDim2.new(0, 6, 0, 6)
    logoDot.Position = UDim2.new(0.5, -3, 0.5, -3)
    logoDot.BackgroundColor3 = T.Accent
    logoDot.BorderSizePixel = 0
    logoDot.ZIndex = 5
    logoDot.Parent = logo

    local brandLeft = Instance.new("TextLabel")
    brandLeft.Size = UDim2.new(0, 60, 1, 0)
    brandLeft.Position = UDim2.new(0, 52, 0, 0)
    brandLeft.BackgroundTransparency = 1
    brandLeft.Text = "KRIT"
    brandLeft.TextColor3 = T.TextHi
    brandLeft.Font = Enum.Font.GothamBold
    brandLeft.TextSize = 17
    brandLeft.TextXAlignment = Enum.TextXAlignment.Left
    brandLeft.ZIndex = 4
    brandLeft.Parent = W.Header

    local brandRight = Instance.new("TextLabel")
    brandRight.Size = UDim2.new(0, 60, 1, 0)
    brandRight.Position = UDim2.new(0, 90, 0, 0)
    brandRight.BackgroundTransparency = 1
    brandRight.Text = "HUB"
    brandRight.TextColor3 = T.Accent
    brandRight.Font = Enum.Font.GothamBold
    brandRight.TextSize = 17
    brandRight.TextXAlignment = Enum.TextXAlignment.Left
    brandRight.ZIndex = 4
    brandRight.Parent = W.Header

    local version = Instance.new("TextLabel")
    version.Size = UDim2.new(0, 60, 1, 0)
    version.Position = UDim2.new(0, 134, 0, 3)
    version.BackgroundTransparency = 1
    version.Text = "v1.0"
    version.TextColor3 = T.TextMuted
    version.Font = Enum.Font.Code
    version.TextSize = 11
    version.TextXAlignment = Enum.TextXAlignment.Left
    version.ZIndex = 4
    version.Parent = W.Header

    W.MinBtn = Instance.new("TextButton")
    W.MinBtn.Name = "MinButton"
    W.MinBtn.Size = UDim2.new(0, 28, 0, 28)
    W.MinBtn.Position = UDim2.new(1, -98, 0, 10)
    W.MinBtn.BackgroundColor3 = T.Panel
    W.MinBtn.BorderSizePixel = 0
    W.MinBtn.Text = "-"
    W.MinBtn.TextColor3 = T.TextDim
    W.MinBtn.Font = Enum.Font.GothamBold
    W.MinBtn.TextSize = 18
    W.MinBtn.ZIndex = 4
    W.MinBtn.AutoButtonColor = false
    W.MinBtn.Parent = W.Header
    U.Corner(W.MinBtn, UDim.new(0, 2))

    local minStroke = Instance.new("UIStroke")
    minStroke.Color = T.Border2
    minStroke.Thickness = 1
    minStroke.Parent = W.MinBtn

    W.CloseBtn = Instance.new("TextButton")
    W.CloseBtn.Name = "CloseButton"
    W.CloseBtn.Size = UDim2.new(0, 28, 0, 28)
    W.CloseBtn.Position = UDim2.new(1, -66, 0, 10)
    W.CloseBtn.BackgroundColor3 = T.Panel
    W.CloseBtn.BorderSizePixel = 0
    W.CloseBtn.Text = "X"
    W.CloseBtn.TextColor3 = T.TextDim
    W.CloseBtn.Font = Enum.Font.GothamBold
    W.CloseBtn.TextSize = 14
    W.CloseBtn.ZIndex = 4
    W.CloseBtn.AutoButtonColor = false
    W.CloseBtn.Parent = W.Header
    U.Corner(W.CloseBtn, UDim.new(0, 2))

    local closeStroke = Instance.new("UIStroke")
    closeStroke.Color = T.Border2
    closeStroke.Thickness = 1
    closeStroke.Parent = W.CloseBtn

    W.Sidebar = Instance.new("Frame")
    W.Sidebar.Size = UDim2.new(0, 140, 1, -48)
    W.Sidebar.Position = UDim2.new(0, 0, 0, 48)
    W.Sidebar.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
    W.Sidebar.BorderSizePixel = 0
    W.Sidebar.ZIndex = 2
    W.Sidebar.Parent = W.Main

    local sidebarList = Instance.new("UIListLayout")
    sidebarList.Padding = UDim.new(0, 1)
    sidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarList.Parent = W.Sidebar

    local sidebarPadding = Instance.new("UIPadding")
    sidebarPadding.PaddingTop = UDim.new(0, 6)
    sidebarPadding.PaddingBottom = UDim.new(0, 6)
    sidebarPadding.PaddingLeft = UDim.new(0, 6)
    sidebarPadding.PaddingRight = UDim.new(0, 6)
    sidebarPadding.Parent = W.Sidebar

    local sidebarDivider = Instance.new("Frame")
    sidebarDivider.Size = UDim2.new(0, 1, 1, 0)
    sidebarDivider.Position = UDim2.new(1, -1, 0, 0)
    sidebarDivider.BackgroundColor3 = T.Border
    sidebarDivider.BorderSizePixel = 0
    sidebarDivider.ZIndex = 5
    sidebarDivider.Parent = W.Sidebar.Parent

    W.Content = Instance.new("Frame")
    W.Content.Size = UDim2.new(1, -140, 1, -48)
    W.Content.Position = UDim2.new(0, 140, 0, 48)
    W.Content.BackgroundColor3 = T.Settings
    W.Content.BorderSizePixel = 0
    W.Content.ClipsDescendants = true
    W.Content.ZIndex = 2
    W.Content.Parent = W.Main

    W.ContentScroll = Instance.new("ScrollingFrame")
    W.ContentScroll.Size = UDim2.new(1, -20, 1, -20)
    W.ContentScroll.Position = UDim2.new(0, 10, 0, 10)
    W.ContentScroll.BackgroundTransparency = 1
    W.ContentScroll.BorderSizePixel = 0
    W.ContentScroll.ScrollBarThickness = 5
    W.ContentScroll.ScrollBarImageColor3 = T.Border2
    W.ContentScroll.ScrollBarImageTransparency = 0
    W.ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    W.ContentScroll.AutomaticCanvasSize = Enum.AutomaticSize.None
    W.ContentScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    W.ContentScroll.ElasticBehavior = Enum.ElasticBehavior.Always
    W.ContentScroll.ZIndex = 3
    W.ContentScroll.Parent = W.Content

    local contentList = Instance.new("UIListLayout")
    contentList.Padding = UDim.new(0, 6)
    contentList.SortOrder = Enum.SortOrder.LayoutOrder
    contentList.Parent = W.ContentScroll

    W.ContentList = contentList

    Hub.State.Window = W

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
        TweenService:Create(W.MinBtn, TweenInfo.new(0.12), {BackgroundColor3 = T.ItemHover}):Play()
        TweenService:Create(W.MinBtn, TweenInfo.new(0.12), {TextColor3 = T.Accent}):Play()
    end)
    W.MinBtn.MouseLeave:Connect(function()
        TweenService:Create(W.MinBtn, TweenInfo.new(0.12), {BackgroundColor3 = T.Panel}):Play()
        TweenService:Create(W.MinBtn, TweenInfo.new(0.12), {TextColor3 = T.TextDim}):Play()
    end)
    W.CloseBtn.MouseEnter:Connect(function()
        TweenService:Create(W.CloseBtn, TweenInfo.new(0.12), {BackgroundColor3 = T.Red}):Play()
        TweenService:Create(W.CloseBtn, TweenInfo.new(0.12), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
    W.CloseBtn.MouseLeave:Connect(function()
        TweenService:Create(W.CloseBtn, TweenInfo.new(0.12), {BackgroundColor3 = T.Panel}):Play()
        TweenService:Create(W.CloseBtn, TweenInfo.new(0.12), {TextColor3 = T.TextDim}):Play()
    end)

    function W.Pulse(btn)
        if not btn:GetAttribute("OrigSize") then
            btn:SetAttribute("OrigSize", btn.Size)
        end
        local orig = btn:GetAttribute("OrigSize")
        local small = UDim2.new(0, orig.X.Offset - 2, 0, orig.Y.Offset - 2)
        TweenService:Create(btn, TweenInfo.new(0.06), {Size = small}):Play()
        task.delay(0.06, function()
            TweenService:Create(btn, TweenInfo.new(0.12), {Size = orig}):Play()
        end)
    end

    function W.RecalcCanvas()
        local scroll = W.ContentScroll
        if not scroll then return end

        local total = 0
        local count = 0
        local padding = 6

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
        W.Sidebar.BackgroundTransparency = 1
        W.Content.BackgroundTransparency = 1
        W.Stroke.Transparency = 1
        W.Main.Size = UDim2.new(0, 720, 0, 480)
        W.Main.Position = UDim2.new(0.5, -360, 0.5, -240)

        TweenService:Create(W.Main, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 780, 0, 520),
            Position = UDim2.new(0.5, -390, 0.5, -260),
            BackgroundTransparency = 0,
        }):Play()
        TweenService:Create(W.Header, TweenInfo.new(0.35), {BackgroundTransparency = 0}):Play()
        TweenService:Create(W.Sidebar, TweenInfo.new(0.35), {BackgroundTransparency = 0}):Play()
        TweenService:Create(W.Content, TweenInfo.new(0.35), {BackgroundTransparency = 0}):Play()
        TweenService:Create(W.Stroke, TweenInfo.new(0.35), {Transparency = 0}):Play()
    end

    W.CloseBtn.MouseButton1Click:Connect(function()
        W.Pulse(W.CloseBtn)
        task.wait(0.08)
        W.Gui.Enabled = false
    end)

    W.MinBtn.MouseButton1Click:Connect(function()
        W.Pulse(W.MinBtn)
        if W.Main.Size.Y.Offset > 48 then
            TweenService:Create(W.Main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 780, 0, 48)
            }):Play()
        else
            TweenService:Create(W.Main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 780, 0, 520)
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