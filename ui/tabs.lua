local Tabs = {}

function Tabs.Create(Hub, W)
    local TweenService = game:GetService("TweenService")
    local T = Hub.Theme
    local U = Hub.Utils

    local TabsM = {}
    TabsM.List = {}

    function TabsM.Create(name)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 38)
        btn.BackgroundColor3 = T.Item
        btn.BorderSizePixel = 0
        btn.Text = name
        btn.TextColor3 = T.TextDim
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 14
        btn.LayoutOrder = #TabsM.List + 1
        btn.ZIndex = 3
        btn.AutoButtonColor = false
        btn.Parent = W.Sidebar
        U.Corner(btn, UDim.new(0, 8))

        local btnStroke = U.Stroke(btn, T.Accent, 0)
        btnStroke.Transparency = 1

        local tab = { Name = name, Btn = btn, Stroke = btnStroke, Modules = {} }
        Hub.State.RegisterTab(name, tab)

        local function selectThis(animated)
            for _, t in pairs(Hub.State.Tabs) do
                if t == tab then
                    if animated then
                        TweenService:Create(t.Btn, TweenInfo.new(0.25), {BackgroundColor3 = T.Accent, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                        t.Stroke.Thickness = 2
                        TweenService:Create(t.Stroke, TweenInfo.new(0.35), {Transparency = 0}):Play()
                    else
                        t.Btn.BackgroundColor3 = T.Accent
                        t.Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                        t.Stroke.Thickness = 2
                        t.Stroke.Transparency = 0
                    end
                else
                    if animated then
                        TweenService:Create(t.Btn, TweenInfo.new(0.25), {BackgroundColor3 = T.Item, TextColor3 = T.TextDim}):Play()
                        TweenService:Create(t.Stroke, TweenInfo.new(0.25), {Transparency = 1}):Play()
                    else
                        t.Btn.BackgroundColor3 = T.Item
                        t.Btn.TextColor3 = T.TextDim
                        t.Stroke.Transparency = 1
                    end
                end
            end

            Hub.State.CurrentTab = name

            local prev = Hub.State.PrevTab
            if prev and prev ~= tab then
                for _, m in pairs(prev.Modules) do
                    if animated then
                        local fade = TweenService:Create(m.Frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
                        fade:Play()
                        TweenService:Create(m.Frame, TweenInfo.new(0.2), {Position = UDim2.new(m.Frame.Position.X.Scale, m.Frame.Position.X.Offset - 20, m.Frame.Position.Y.Scale, m.Frame.Position.Y.Offset)}):Play()
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
                    m.Frame.Position = UDim2.new(0, 20, 0, m.Frame.Position.Y.Offset)
                    TweenService:Create(m.Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 0,
                        Position = UDim2.new(0, 0, 0, m.Frame.Position.Y.Offset),
                    }):Play()
                else
                    m.Frame.BackgroundTransparency = 0
                end
            end

            Hub.State.PrevTab = tab

            task.delay(0.35, function()
                if W.RecalcCanvas then W.RecalcCanvas() end
            end)
        end

        btn.MouseButton1Click:Connect(function() selectThis(true) end)
        btn.MouseEnter:Connect(function()
            if Hub.State.CurrentTab ~= name then
                TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = T.ItemHover}):Play()
            end
        end)
        btn.MouseLeave:Connect(function()
            if Hub.State.CurrentTab ~= name then
                TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = T.Item}):Play()
            end
        end)

        tab.Select = selectThis

        table.insert(TabsM.List, tab)
        return tab
    end

    return TabsM
end

return Tabs