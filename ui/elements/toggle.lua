return function(Hub, module, label, default, callback)
    local W = Hub.State.Window
    local T = Hub.Theme

    local el = { Value = default, Label = label }

    local function newObj(class, props)
        local o = Drawing.new(class)
        for k, v in pairs(props) do o[k] = v end
        o.Visible = false
        return o
    end

    el.Bg = newObj("Square", { Size = Vector2.new(410, 26), Color = T.Settings, Filled = true })
    el.Txt = newObj("Text", { Text = label, Size = 13, Outline = true, Color = T.Text })
    el.Dot = newObj("Circle", { Radius = 6, Filled = true, Color = default and T.Green or T.Red })
    el.Halo = newObj("Circle", { Radius = 9, Filled = false, Thickness = 1, Color = default and T.Green or T.Red, Transparency = 0.5 })

    el.Objects = { el.Bg, el.Txt, el.Dot, el.Halo }

    el.UpdatePositions = function(y, x)
        el.Bg.Position = Vector2.new(x + 10, y)
        el.Txt.Position = Vector2.new(x + 22, y + 5)
        el.Dot.Position = Vector2.new(x + 390, y + 13)
        el.Halo.Position = Vector2.new(x + 390, y + 13)
        el.HitPos = Vector2.new(x + 390, y + 13)
        el.HitRadius = 10
    end

    el.Show = function()
        for _, o in ipairs(el.Objects) do o.Visible = true end
    end

    el.Hide = function()
        for _, o in ipairs(el.Objects) do o.Visible = false end
    end

    el.Toggle = function()
        el.Value = not el.Value
        local c = el.Value and T.Green or T.Red
        el.Dot.Color = c
        el.Halo.Color = c
        if callback then callback(el.Value) end
    end

    table.insert(module.Elements, el)
    return el
end