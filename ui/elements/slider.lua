return function(Hub, module, label, min, max, default, callback)
    local W = Hub.State.Window
    local T = Hub.Theme

    local el = { Value = default, Min = min, Max = max, Label = label }

    local function newObj(class, props)
        local o = Drawing.new(class)
        for k, v in pairs(props) do o[k] = v end
        o.Visible = false
        return o
    end

    el.Bg = newObj("Square", { Size = Vector2.new(410, 26), Color = T.Settings, Filled = true })
    el.Txt = newObj("Text", { Text = label, Size = 13, Outline = true, Color = T.Text })
    el.Val = newObj("Text", { Text = tostring(default), Size = 13, Center = true, Outline = true, Color = T.Accent })
    el.Track = newObj("Square", { Size = Vector2.new(120, 4), Color = Color3.fromRGB(45, 45, 60), Filled = true })
    el.Fill = newObj("Square", { Size = Vector2.new(0, 4), Color = T.Accent, Filled = true })
    el.Knob = newObj("Circle", { Radius = 5, Filled = true, Color = Color3.fromRGB(255, 255, 255) })

    el.Objects = { el.Bg, el.Txt, el.Val, el.Track, el.Fill, el.Knob }

    el.UpdateFill = function()
        local frac = (el.Value - min) / (max - min)
        el.Fill.Size = Vector2.new(120 * frac, 4)
        el.Val.Text = tostring(math.floor(el.Value))
    end

    el.UpdatePositions = function(y, x)
        el.Bg.Position = Vector2.new(x + 10, y)
        el.Txt.Position = Vector2.new(x + 22, y + 5)
        el.Val.Position = Vector2.new(x + 290, y + 5)
        el.Track.Position = Vector2.new(x + 220, y + 11)
        el.Fill.Position = Vector2.new(x + 220, y + 11)
        el.Knob.Position = Vector2.new(x + 220 + (120 * ((el.Value - min) / (max - min))), y + 13)
        el.TrackBounds = { X = x + 220, Y = y + 11, W = 120, H = 4 }
    end

    el.Show = function() for _, o in ipairs(el.Objects) do o.Visible = true end end
    el.Hide = function() for _, o in ipairs(el.Objects) do o.Visible = false end end

    el.Set = function(v)
        el.Value = math.clamp(v, min, max)
        el.UpdateFill()
        el.UpdatePositions(el.Bg.Position.Y, el.Bg.Position.X - 10)
        if callback then callback(el.Value) end
    end

    el.SetFromMouse = function(mx)
        if not el.TrackBounds then return end
        local frac = math.clamp((mx - el.TrackBounds.X) / el.TrackBounds.W, 0, 1)
        el.Set(min + frac * (max - min))
    end

    el.UpdateFill()

    table.insert(module.Elements, el)
    return el
end