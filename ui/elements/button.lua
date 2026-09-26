return function(Hub, module, label, callback)
    local T = Hub.Theme
    local W = Hub.State.Window

    local el = {
        Visible = true,
    }

    local y = module.Y + 44 + #module.Elements * 30

    local btn = Drawing.new("Square")
    btn.Size = Vector2.new(520, 26)
    btn.Position = Vector2.new(W.Pos.X + 190, y)
    btn.Color = Color3.fromRGB(60, 60, 80)
    btn.Filled = true
    btn.Visible = true

    local txt = Drawing.new("Text")
    txt.Text = label
    txt.Size = 13
    txt.Center = true
    txt.Outline = true
    txt.Color = T.Text
    txt.Position = Vector2.new(W.Pos.X + 450, y + 5)
    txt.Visible = true

    el.SetVisible = function(v)
        btn.Visible = v
        txt.Visible = v
    end

    el.Btn = { Pos = Vector2.new(W.Pos.X + 190, y), Size = Vector2.new(520, 26) }

    el.Click = function()
        if callback then callback() end
    end

    table.insert(module.Elements, el)
    return el
end
