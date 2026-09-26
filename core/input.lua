local Input = {}

Input.Dragging = false
Input.DragStart = nil
Input.GuiStart = nil
Input.ListeningKeybind = nil

function Input.Init(Hub)
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")

    UserInputService.InputBegan:Connect(function(input, gpe)
        if input.KeyCode == Enum.KeyCode.F1 then
            Hub.State.GUIVisible = not Hub.State.GUIVisible
            Hub.Window.SetVisible(Hub.State.GUIVisible)
            return
        end

        if Input.ListeningKeybind then
            local el = Input.ListeningKeybind
            el.Set(input.KeyCode.Name)
            Input.ListeningKeybind = nil
            return
        end

        if input.KeyCode == Enum.KeyCode.E and Hub.Features and Hub.Features.Aimbot then
            Hub.Features.Aimbot.Enabled = not Hub.Features.Aimbot.Enabled
        end
    end)

    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        local m = UserInputService:GetMouseLocation()
        local W = Hub.State.Window

        if not Hub.State.GUIVisible then return end

        if m.X >= W.Pos.X and m.X <= W.Pos.X + W.Size.X
           and m.Y >= W.Pos.Y and m.Y <= W.Pos.Y + 40 then
            Input.Dragging = true
            Input.DragStart = m
            Input.GuiStart = W.Pos
            return
        end

        if Hub.State.Tabs and Hub.State.Tabs.Buttons then
            for _, entry in ipairs(Hub.State.Tabs.Buttons) do
                local b = entry.Btn
                if m.X >= b.Position.X and m.X <= b.Position.X + b.Size.X
                   and m.Y >= b.Position.Y and m.Y <= b.Position.Y + b.Size.Y then
                    Hub.Tabs.Select(Hub, entry.Tab.Name)
                    return
                end
            end
        end

        local currentTab = Hub.State.Tabs[Hub.State.CurrentTab]
        if currentTab then
            for _, mod in ipairs(currentTab.Modules) do
                for _, el in ipairs(mod.Elements) do
                    if el.Pos and el.Radius and not el.Listening then
                        local dx = m.X - el.Pos.X
                        local dy = m.Y - el.Pos.Y
                        if dx * dx + dy * dy <= el.Radius * el.Radius then
                            if el.Set then el.Set(not el.Value) end
                            return
                        end
                    end

                    if el.Btn then
                        if m.X >= el.Btn.Pos.X and m.X <= el.Btn.Pos.X + el.Btn.Size.X
                           and m.Y >= el.Btn.Pos.Y and m.Y <= el.Btn.Pos.Y + el.Btn.Size.Y then
                            if el.StartListen then
                                el.StartListen()
                                Input.ListeningKeybind = el
                            elseif el.Cycle then
                                el.Cycle()
                            elseif el.Click then
                                el.Click()
                            end
                            return
                        end
                    end

                    if el.Swatches then
                        for _, s in ipairs(el.Swatches) do
                            local b = s.Btn
                            if m.X >= b.Position.X and m.X <= b.Position.X + b.Size.X
                               and m.Y >= b.Position.Y and m.Y <= b.Position.Y + b.Size.Y then
                                el.Set(s.Color)
                                return
                            end
                        end
                    end
                end

                if mod.Draw then
                    local d = mod.Draw
                    if m.X >= d.Dot.Position.X - 8 and m.X <= d.Dot.Position.X + 8
                       and m.Y >= d.Dot.Position.Y - 8 and m.Y <= d.Dot.Position.Y + 8 then
                        mod.Toggle()
                        return
                    end

                    if m.X >= d.Expand.Position.X and m.X <= d.Expand.Position.X + d.Expand.Size.X
                       and m.Y >= d.Expand.Position.Y and m.Y <= d.Expand.Position.Y + d.Expand.Size.Y then
                        mod.Open = not mod.Open
                        d.ExpandTxt.Text = mod.Open and "^" or "v"
                        for _, el in ipairs(mod.Elements) do
                            if el.SetVisible then el.SetVisible(mod.Open) end
                        end
                        return
                    end
                end
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Input.Dragging = false
        end
    end)

    RunService.RenderStepped:Connect(function()
        if Input.Dragging then
            local m = UserInputService:GetMouseLocation()
            local d = m - Input.DragStart
            local newPos = Input.GuiStart + d
            Hub.State.Window.Pos = newPos
            Hub.Window.Pos = newPos
            Hub.Window.Update()
        end
    end)
end

return Input
