local Tabs = {}

Tabs.List = {}
Tabs.Buttons = {}
Tabs.Active = nil

function Tabs.Create(Hub, name)
    local tab = {
        Name = name,
        Modules = {},
    }
    table.insert(Tabs.List, tab)
    Hub.State.RegisterTab(name, tab)
    Tabs.DrawButton(Hub, tab)
    if not Tabs.Active then
        Tabs.Select(Hub, name)
    end
    return tab
end

function Tabs.DrawButton(Hub, tab)
    local T = Hub.Theme
    local W = Hub.State.Window
    local index = #Tabs.Buttons
    local y = W.Pos.Y + 70 + index * 40

    local btn = Drawing.new("Square")
    btn.Size = Vector2.new(140, 32)
    btn.Position = Vector2.new(W.Pos.X + 15, y)
    btn.Color = T.Panel
    btn.Filled = true
    btn.Visible = true

    local txt = Drawing.new("Text")
    txt.Text = tab.Name
    txt.Size = 14
    txt.Center = true
    txt.Outline = true
    txt.Color = T.TextDim
    txt.Position = Vector2.new(W.Pos.X + 85, y + 9)
    txt.Visible = true

    table.insert(Tabs.Buttons, { Tab = tab, Btn = btn, Txt = txt })
end

function Tabs.Select(Hub, name)
    Tabs.Active = name
    local T = Hub.Theme
    for _, entry in ipairs(Tabs.Buttons) do
        if entry.Tab.Name == name then
            entry.Btn.Color = T.Accent
            entry.Txt.Color = Color3.fromRGB(255, 255, 255)
        else
            entry.Btn.Color = T.Panel
            entry.Txt.Color = T.TextDim
        end
    end
    Hub.State.CurrentTab = name
end

return Tabs
