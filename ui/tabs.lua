local Tabs = {}

function Tabs.Create(Hub, W)
    local TweenService = game:GetService("TweenService")
    local T = Hub.Theme
    local U = Hub.Utils

    local TabsM = {}
    TabsM.List = {}

    local tabIcons = {
        Combat = "M12 2v4M12 18v4M4.93 4.93l2.83 2.83M16.24 16.24l2.83 2.83M2 12h4M18 12h4M4.93 19.07l2.83-2.83M16.24 7.76l2.83-2.83",
        Visuals = "M12 4C7 4 3 8 2 12c1 4 5 8 10 8s9-4 10-8c-1-4-5-8-10-8zm0 12a4 4 0 110-8 4 4 0 010 8z",
        Skins = "M4 7l8-4 8 4v10l-8 4-8-4V7z",
        HUD = "M2 5h20v12H2V5zm6 16h8M12 17v4",
        Misc = "M12 12a3 3 0 100-6 3 3 0 000 6zm0 0v6M6 9H3M21 9h-3",
    }

    function TabsM.Create(name)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 38)
        btn.BackgroundColor3 = T.Background
        btn.BackgroundTransparency = 1
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.LayoutOrder = #TabsM.List + 1
        btn.ZIndex = 3
        btn.AutoButtonColor = false
        btn.Parent = W.Sidebar

        local accentBar = Instance.new("Frame")
        accentBar.Size = UDim2.new(0, 2, 0, 0)
        accentBar.Position = UDim2.new(0, 0, 0.5, 0)
        accentBar.AnchorPoint = Vector2.new(0, 0.5)
        accentBar.BackgroundColor3 = T.Accent
        accentBar.BorderSizePixel = 0
        accentBar.ZIndex = 4
        accentBar.Parent = btn

        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.new(0, 16, 0, 16)
        icon.Position = UDim2.new(0, 14, 0.5, -8)
        icon.BackgroundTransparency = 1
        icon.Image = ""
        icon.ImageColor3 = T.TextDim
        icon.ZIndex = 4
        icon.Parent = btn

        local iconSvg = Instance.new("Frame")
        iconSvg.Size = UDim2.new(0, 3, 0, 3)
        iconSvg.Position = UDim2.new(0, 20, 0.5, -1)
        iconSvg.BackgroundColor3 = T.TextDim
        iconSvg.BorderSizePixel = 0
        iconSvg.ZIndex = 4
        iconSvg.Parent = btn

        local txt = Instance.new("TextLabel")
        txt.Size = UDim2.new(1, -40, 1, 0)
        txt.Position = UDim2.new(0, 32, 0, 0)
        txt.BackgroundTransparency = 1
        txt.Text = string.upper(name)
        txt.TextColor3 = T.TextDim
        txt.Font = Enum.Font.GothamSemibold
        txt.TextSize = 12
        txt.TextXAlignment = Enum.TextXAlignment.Left
        txt.ZIndex = 4
        txt.Parent = btn

        local countLabel = Instance.new("TextLabel")
        countLabel.Size = UDim2.new(0, 20, 1, 0)
        countLabel.Position = UDim2.new(1, -24, 0, 0)
        countLabel.BackgroundTransparency = 1
        countLabel.Text = "0"
        countLabel.TextColor3 = T.TextMuted
        countLabel.Font = Enum.Font.Code
        countLabel.TextSize = 11
        countLabel.TextXAlignment = Enum.TextXAlignment.Right
        countLabel.ZIndex = 4
        countLabel.Parent = btn

        local tab = { Name = name, Btn = btn, AccentBar = accentBar, Txt = txt, Count = countLabel, Modules = {} }
        Hub.State.RegisterTab(name, tab)

        local function selectThis(animated)
            for _, t in pairs(Hub.State.Tabs) do
                if t == tab then
                    if animated then
                        TweenService:Create(t.Btn, TweenInfo.new(0.15), {BackgroundColor3 = T.Accent, BackgroundTransparency = 0.9}):Play()
                        TweenService:Create(t.Txt, TweenInfo.new(0.15), {TextColor3 = T.Accent}):Play()
                        TweenService:Create(t.AccentBar, TweenInfo.new(0.2), {Size = UDim2.new(0, 2, 0, 22)}):Play()
                        TweenService:Create(t.Count, TweenInfo.new(0.15), {TextColor3 = T.Accent}):Play()
                    else
                        t.Btn.BackgroundColor3 = T.Accent
                        t.Btn.BackgroundTransparency = 0.9
                        t.Txt.TextColor3 = T.Accent
                        t.AccentBar.Size = UDim2.new(0, 2, 0, 22)
                        t.Count.TextColor3 = T.Accent
                    end
                else
                    if animated then
                        TweenService:Create(t.Btn, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
                        TweenService:Create(t.Txt, TweenInfo.new(0.15), {TextColor3 = T.TextDim}):Play()
                        TweenService:Create(t.AccentBar, TweenInfo.new(0.15), {Size = UDim2.new(0, 2, 0, 0)}):Play()
                        TweenService:Create(t.Count, TweenInfo.new(0.15), {TextColor3 = T.TextMuted}):Play()
                    else
                        t.Btn.BackgroundTransparency = 1
                        t.Txt.TextColor3 = T.TextDim
                        t.AccentBar.Size = UDim2.new(0, 2, 0, 0)
                        t.Count.TextColor3 = T.TextMuted
                    end
                end
            end

            Hub.State.CurrentTab = name

            local prev = Hub.State.PrevTab
            if prev and prev ~= tab then
                for _, m in pairs(prev.Modules) do
                    if animated then
                        local fade = TweenService:Create(m.Frame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
                        fade:Play()
                        TweenService:Create(m.Frame, TweenInfo.new(0.15), {Position = UDim2.new(m.Frame.Position.X.Scale, m.Frame.Position.X.Offset - 15, m.Frame.Position.Y.Scale, m.Frame.Position.Y.Offset)}):Play()
                        fade.Completed:Connect(function()
                            m.Frame.Visible = false
                            m.Frame.Position = UDim2.new(0, 0, 0, m.Frame.Position.Y.Offset)
                        end)
                    else
                        m.Frame.Visible = false
                    end
                end
            end

            for _, m in pairs(tab.Modules) do
                m.Frame.Visible = true
                if animated then
                    m.Frame.BackgroundTransparency = 1
                    m.Frame.Position = UDim2.new(0, 15, 0, m.Frame.Position.Y.Offset)
                    TweenService:Create(m.Frame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 0,
                        Position = UDim2.new(0, 0, 0, m.Frame.Position.Y.Offset),
                    }):Play()
                else
                    m.Frame.BackgroundTransparency = 0
                end
            end

            if Hub.UI.SkinChangerRef then
                Hub.UI.SkinChangerRef.SetVisible(name == "Skins")
            end

            Hub.State.PrevTab = tab
        end

        btn.MouseButton1Click:Connect(function() selectThis(true) end)
        btn.MouseEnter:Connect(function()
            if Hub.State.CurrentTab ~= name then
                TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.97}):Play()
                TweenService:Create(txt, TweenInfo.new(0.12), {TextColor3 = T.Text}):Play()
            end
        end)
        btn.MouseLeave:Connect(function()
            if Hub.State.CurrentTab ~= name then
                TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundTransparency = 1}):Play()
                TweenService:Create(txt, TweenInfo.new(0.12), {TextColor3 = T.TextDim}):Play()
            end
        end)

        tab.Select = selectThis

        function tab.SetCount(n)
            countLabel.Text = tostring(n)
        end

        table.insert(TabsM.List, tab)
        return tab
    end

    return TabsM
end

return Tabs