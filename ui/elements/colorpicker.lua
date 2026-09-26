return function(Hub, module, label, default, callback)
    local T = Hub.Theme
    local W = Hub.State.Window

    local palette = {
        Color3.fromRGB(77, 141, 255),
        Color3.fromRGB(230, 57, 70),
        Color3.fromRGB(61, 220, 132),
        Color3.fromRGB(176, 107, 255),
        Color3.fromRGB(255, 184, 0),
        Color3.fromRGB(255, 255, 255),
    }

    local el = {
        Value = default,
        Visible = true,
        Swatches = {},
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

    for i, col in ipairs(palette) do
        local sw = Drawing.new("Square")
        sw.Size = Vector2.new(18, 18)
        sw.Position = Vector2.new(W.Pos.X + 500 + (i - 1) * 24, y + 4)
        sw.Color = col
        sw.Filled = true
        sw.Visible = true
        table.insert(el.Swatches, { Btn = sw, Color = col })
    end

    el.SetVisible = function(v)
        bg.Visible = v
        txt.Visible = v
        for _, s in ipairs(el.Swatches) do s.Btn.Visible = v end
    end

    el.Set = function(c)
        el.Value = c
        if callback then callback(c) end
    end

    table.insert(module.Elements, el)
    return el
end
