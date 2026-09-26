local Window = {}

Window.Objects = {}
Window.Pos = Vector2.new(100, 100)
Window.Size = Vector2.new(620, 460)
Window.Visible = true
Window.Minimized = false
Window.Dragging = false
Window.DragOffset = Vector2.new(0, 0)
Window.Tabs = {}
Window.ActiveTab = nil

local function new(class, props)
    local o = Drawing.new(class)
    for k, v in pairs(props) do o[k] = v end
    o.Visible = true
    table.insert(Window.Objects, o)
    return o
end

function Window.Init(Hub)
    local T = Hub.Theme

    Window.Bg = new("Square", {
        Size = Window.Size,
        Position = Window.Pos,
        Color = T.Background,
        Filled = true,
    })

    Window.BgInner = new("Square", {
        Size = Window.Size - Vector2.new(4, 4),
        Position = Window.Pos + Vector2.new(2, 2),
        Color = T.Panel,
        Filled = true,
    })

    Window.Border = new("Square", {
        Size = Window.Size,
        Position = Window.Pos,
        Color = T.Accent,
        Thickness = 2,
        Filled = false,
    })

    Window.Header = new("Square", {
        Size = Vector2.new(Window.Size.X, 40),
        Position = Window.Pos,
        Color = T.Panel,
        Filled = true,
    })

    Window.AccentLine = new("Square", {
        Size = Vector2.new(Window.Size.X, 3),
        Position = Window.Pos + Vector2.new(0, 40),
        Color = T.Accent,
        Filled = true,
    })

    Window.Title = new("Text", {
        Text = "KRITHUB",
        Size = 18,
        Center = false,
        Outline = true,
        Color = T.Accent,
        Position = Window.Pos + Vector2.new(18, 12),
    })

    Window.Sub = new("Text", {
        Text = "v1.0",
        Size = 12,
        Center = false,
        Outline = true,
        Color = T.TextDim,
        Position = Window.Pos + Vector2.new(110, 18),
    })

    Window.MinBtn = new("Square", {
        Size = Vector2.new(26, 22),
        Position = Window.Pos + Vector2.new(Window.Size.X - 66, 10),
        Color = Color3.fromRGB(50, 50, 65),
        Filled = true,
    })

    Window.MinTxt = new("Text", {
        Text = "_",
        Size = 16,
        Center = true,
        Outline = true,
        Color = T.Text,
        Position = Window.Pos + Vector2.new(Window.Size.X - 53, 11),
    })

    Window.CloseBtn = new("Square", {
        Size = Vector2.new(26, 22),
        Position = Window.Pos + Vector2.new(Window.Size.X - 34, 10),
        Color = T.Red,
        Filled = true,
    })

    Window.CloseTxt = new("Text", {
        Text = "X",
        Size = 14,
        Center = true,
        Outline = true,
        Color = Color3.fromRGB(255, 255, 255),
        Position = Window.Pos + Vector2.new(Window.Size.X - 21, 13),
    })

    Window.Sidebar = new("Square", {
        Size = Vector2.new(140, Window.Size.Y - 60),
        Position = Window.Pos + Vector2.new(10, 50),
        Color = T.Item,
        Filled = true,
    })

    Window.SidebarLine = new("Square", {
        Size = Vector2.new(2, Window.Size.Y - 60),
        Position = Window.Pos + Vector2.new(150, 50),
        Color = Color3.fromRGB(40, 40, 55),
        Filled = true,
    })

    Window.Content = new("Square", {
        Size = Vector2.new(Window.Size.X - 170, Window.Size.Y - 60),
        Position = Window.Pos + Vector2.new(160, 50),
        Color = T.Settings,
        Filled = true,
    })

    Hub.State.Window = Window
    return Window
end

function Window.Update()
    local p = Window.Pos
    local s = Window.Size

    Window.Bg.Position = p
    Window.Bg.Size = s

    Window.BgInner.Position = p + Vector2.new(2, 2)
    Window.BgInner.Size = s - Vector2.new(4, 4)

    Window.Border.Position = p
    Window.Border.Size = s

    Window.Header.Position = p
    Window.Header.Size = Vector2.new(s.X, 40)

    Window.AccentLine.Position = p + Vector2.new(0, 40)

    Window.Title.Position = p + Vector2.new(18, 12)
    Window.Sub.Position = p + Vector2.new(112, 18)

    Window.MinBtn.Position = p + Vector2.new(s.X - 66, 10)
    Window.MinTxt.Position = p + Vector2.new(s.X - 53, 11)

    Window.CloseBtn.Position = p + Vector2.new(s.X - 34, 10)
    Window.CloseTxt.Position = p + Vector2.new(s.X - 21, 13)

    Window.Sidebar.Position = p + Vector2.new(10, 50)
    Window.Sidebar.Size = Vector2.new(140, s.Y - 60)

    Window.SidebarLine.Position = p + Vector2.new(150, 50)
    Window.SidebarLine.Size = Vector2.new(2, s.Y - 60)

    Window.Content.Position = p + Vector2.new(160, 50)
    Window.Content.Size = Vector2.new(s.X - 170, s.Y - 60)

    if Hub.State and Hub.State.Tabs then
        for _, tab in pairs(Hub.State.Tabs) do
            if tab.UpdatePositions then tab.UpdatePositions() end
        end
    end
end

function Window.SetVisible(v)
    Window.Visible = v
    for _, o in ipairs(Window.Objects) do o.Visible = v end
    if not v then
        for _, tab in pairs(Window.Tabs) do
            if tab.Hide then tab.Hide() end
        end
    elseif Window.ActiveTab and Window.ActiveTab.Show then
        Window.ActiveTab.Show()
    end
end

return Window