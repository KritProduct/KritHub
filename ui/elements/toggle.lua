return function(Hub, module, label, default, callback)
    local T = Hub.Theme
    local W = Hub.State.Window

    local el = {
        Value = default,
        Visible = true,
    }

    local y = module.Y + 44 + #module.Elements * 30

    local bg = Drawing.new("Square")
    bg.Size = Vector2.new(520, 26)
    bg.Position = Vector2.new(W.Pos.X + 190, y)
    bg.Color = T.Settings
    bg.Filled = true
    bg.Visible = true

    local txt = Drawing.new("Text")
    txt.Text = label
    txt.Size = 13
    txt.Outline = true
    txt.Color = T.Text
    txt.Position = Vector2.new(W.Pos.X + 200, y + 5)
    txt.Visible = true

    local dot = Drawing.new("Circle")
    dot.Radius = 6
    dot.Filled = true
    dot.Position = Vector2.new(W.Pos.X + 690, y + 13)
    dot.Color = default and T.Green or T.Red
    dot.Visible = true

    el.SetVisible = function(v)
        bg.Visible = v
        txt.Visible = v
        dot.Visible = v
    end

    el.Set = function(v)
        el.Value = v
        dot.Color = v and T.Green or T.Red
        if callback then callback(v) end
    end

    el.Pos = Vector2.new(W.Pos.X + 690, y + 13)
    el.Radius = 6

    table.insert(module.Elements, el)
    return el
end
