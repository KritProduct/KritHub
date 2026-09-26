return function(Hub, module, label, min, max, default, callback)
    local T = Hub.Theme
    local W = Hub.State.Window

    local el = {
        Value = default,
        Min = min,
        Max = max,
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

    local valTxt = Drawing.new("Text")
    valTxt.Text = tostring(default)
    valTxt.Size = 13
    valTxt.Center = true
    valTxt.Outline = true
    valTxt.Color = T.Accent
    valTxt.Position = Vector2.new(W.Pos.X + 600, y + 5)
    valTxt.Visible = true

    local track = Drawing.new("Square")
    track.Size = Vector2.new(80, 4)
    track.Position = Vector2.new(W.Pos.X + 630, y + 11)
    track.Color = Color3.fromRGB(50, 50, 65)
    track.Filled = true
    track.Visible = true

    local fill = Drawing.new("Square")
    fill.Size = Vector2.new(40, 4)
    fill.Position = Vector2.new(W.Pos.X + 630, y + 11)
    fill.Color = T.Accent
    fill.Filled = true
    fill.Visible = true

    el.SetVisible = function(v)
        bg.Visible = v
        txt.Visible = v
        valTxt.Visible = v
        track.Visible = v
        fill.Visible = v
    end

    el.Update = function()
        local frac = (el.Value - min) / (max - min)
        fill.Size = Vector2.new(80 * frac, 4)
        valTxt.Text = tostring(math.floor(el.Value))
    end

    el.Set = function(v)
        el.Value = math.clamp(v, min, max)
        el.Update()
        if callback then callback(el.Value) end
    end

    el.Inc = function()
        el.Set(el.Value + (max - min) / 20)
    end

    el.Dec = function()
        el.Set(el.Value - (max - min) / 20)
    end

    table.insert(module.Elements, el)
    el.Update()
    return el
end
