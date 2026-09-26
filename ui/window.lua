local Window = {}

Window.Frame = nil
Window.Border = nil
Window.Title = nil
Window.MinBtn = nil
Window.MinTxt = nil
Window.CloseBtn = nil
Window.CloseTxt = nil
Window.Settings = nil

Window.Pos = Vector2.new(100, 100)
Window.Size = Vector2.new(760, 560)

function Window.SetPos(hub, x, y)
    Window.Pos = Vector2.new(x, y)
    Window.Update()
end

function Window.Update()
    local T = Window.Theme
    if not T then return end
    Window.Frame.Position = Window.Pos
    Window.Frame.Size = Window.Size
    Window.Frame.Color = T.Background
    Window.Border.Position = Window.Pos
    Window.Border.Size = Window.Size
    Window.Border.Color = T.Accent
    Window.Title.Position = Window.Pos + Vector2.new(20, 16)
    Window.Title.Color = T.Text
    Window.MinBtn.Position = Window.Pos + Vector2.new(Window.Size.X - 90, 12)
    Window.MinTxt.Position = Window.Pos + Vector2.new(Window.Size.X - 80, 18)
    Window.CloseBtn.Position = Window.Pos + Vector2.new(Window.Size.X - 50, 12)
    Window.CloseTxt.Position = Window.Pos + Vector2.new(Window.Size.X - 43, 18)
end

function Window.Init(Hub)
    local T = Hub.Theme
    Window.Theme = T

    Window.Frame = Drawing.new("Square")
    Window.Frame.Size = Window.Size
    Window.Frame.Position = Window.Pos
    Window.Frame.Color = T.Background
    Window.Frame.Filled = true
    Window.Frame.Visible = true

    Window.Border = Drawing.new("Square")
    Window.Border.Size = Window.Size
    Window.Border.Position = Window.Pos
    Window.Border.Color = T.Accent
    Window.Border.Thickness = 1
    Window.Border.Filled = false
    Window.Border.Visible = true

    Window.Title = Drawing.new("Text")
    Window.Title.Text = "KRITHUB"
    Window.Title.Size = 18
    Window.Title.Center = false
    Window.Title.Outline = true
    Window.Title.Color = T.Text
    Window.Title.Position = Window.Pos + Vector2.new(20, 16)
    Window.Title.Visible = true

    Window.MinBtn = Drawing.new("Square")
    Window.MinBtn.Size = Vector2.new(30, 22)
    Window.MinBtn.Position = Window.Pos + Vector2.new(Window.Size.X - 90, 12)
    Window.MinBtn.Color = Color3.fromRGB(60, 60, 80)
    Window.MinBtn.Filled = true
    Window.MinBtn.Visible = true

    Window.MinTxt = Drawing.new("Text")
    Window.MinTxt.Text = "_"
    Window.MinTxt.Size = 14
    Window.MinTxt.Center = true
    Window.MinTxt.Outline = true
    Window.MinTxt.Color = T.Text
    Window.MinTxt.Position = Window.Pos + Vector2.new(Window.Size.X - 80, 18)
    Window.MinTxt.Visible = true

    Window.CloseBtn = Drawing.new("Square")
    Window.CloseBtn.Size = Vector2.new(30, 22)
    Window.CloseBtn.Position = Window.Pos + Vector2.new(Window.Size.X - 50, 12)
    Window.CloseBtn.Color = T.Red
    Window.CloseBtn.Filled = true
    Window.CloseBtn.Visible = true

    Window.CloseTxt = Drawing.new("Text")
    Window.CloseTxt.Text = "X"
    Window.CloseTxt.Size = 14
    Window.CloseTxt.Center = true
    Window.CloseTxt.Outline = true
    Window.CloseTxt.Color = T.Text
    Window.CloseTxt.Position = Window.Pos + Vector2.new(Window.Size.X - 43, 18)
    Window.CloseTxt.Visible = true

    Hub.State.Window = Window
    return Window
end

function Window.SetVisible(v)
    Window.Frame.Visible = v
    Window.Border.Visible = v
    Window.Title.Visible = v
    Window.MinBtn.Visible = v
    Window.MinTxt.Visible = v
    Window.CloseBtn.Visible = v
    Window.CloseTxt.Visible = v
end

return Window
