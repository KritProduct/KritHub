local Tabs = {}

function Tabs.Create(Hub, W)
    local TweenService = game:GetService("TweenService")
    local T = Hub.Theme
    local U = Hub.Utils

    local TabsM = {}
    TabsM.List = {}

    function TabsM.Create(name)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 36)
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

        local txt = Instance.new("TextLabel")
        txt.Size = UDim2.new(1, -34, 1, 0)
        txt.Position = UDim2.new(0, 14, 0, 0)
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
        countLabel.Position = UDim2.new(1, -22, 0, 0)
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
                    m.Frame.Visible = false
                end
            end

            for _, m in pairs(tab.Modules) do
                m.Frame.Visible = true
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