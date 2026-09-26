local Tabs = {}

Tabs.List = {}

function Tabs.Create(Hub, name)
    local W = Hub.State.Window
    local T = Hub.Theme

    local tab = {
        Name = name,
        Modules = {},
        Btn = nil,
        Txt = nil,
        Hub = Hub,
    }

    local index = #Tabs.List
    local y = W.Pos.Y + 60 + index * 42

    tab.Btn = Drawing.new("Square")
    tab.Btn.Size = Vector2.new(124, 34)
    tab.Btn.Position = Vector2.new(W.Pos.X + 18, y)
    tab.Btn.Color = T.Item
    tab.Btn.Filled = true
    tab.Btn.Visible = false

    tab.Txt = Drawing.new("Text")
    tab.Txt.Text = name
    tab.Txt.Size = 14
    tab.Txt.Center = true
    tab.Txt.Outline = true
    tab.Txt.Color = T.TextDim
    tab.Txt.Position = Vector2.new(W.Pos.X + 80, y + 9)
    tab.Txt.Visible = false

    tab.UpdatePositions = function()
        local i = 0
        for _, t in ipairs(Tabs.List) do
            i = i + 1
            if t == tab then break end
        end
        local yy = W.Pos.Y + 60 + (i - 1) * 42
        tab.Btn.Position = Vector2.new(W.Pos.X + 18, yy)
        tab.Txt.Position = Vector2.new(W.Pos.X + 80, yy + 9)

        for _, mod in ipairs(tab.Modules) do
            if mod.UpdatePositions then mod.UpdatePositions() end
        end
    end

    tab.SetActive = function(active)
        if active then
            tab.Btn.Color = T.Accent
            tab.Txt.Color = Color3.fromRGB(255, 255, 255)
        else
            tab.Btn.Color = T.Item
            tab.Txt.Color = T.TextDim
        end
    end

    tab.Show = function()
        tab.Btn.Visible = true
        tab.Txt.Visible = true
        for _, mod in ipairs(tab.Modules) do
            if mod.Show then mod.Show() end
        end
    end

    tab.Hide = function()
        tab.Btn.Visible = false
        tab.Txt.Visible = false
        for _, mod in ipairs(tab.Modules) do
            if mod.Hide then mod.Hide() end
        end
    end

    tab.UpdatePositions()

    table.insert(Tabs.List, tab)
    Hub.State.RegisterTab(name, tab)

    if not W.ActiveTab then
        W.ActiveTab = tab
    end

    return tab
end

function Tabs.Select(Hub, name)
    local W = Hub.State.Window
    for _, tab in ipairs(Tabs.List) do
        if tab.Name == name then
            W.ActiveTab = tab
        end
    end
    for _, tab in ipairs(Tabs.List) do
        tab.SetActive(tab == W.ActiveTab)
    end
    Hub.State.CurrentTab = name
    W.SetVisible(true)
end

return Tabs