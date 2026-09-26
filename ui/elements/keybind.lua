return function(Hub, module, label, default, callback)
    local T = Hub.Theme
    local W = Hub.State.Window

    local el = {
        Value = default,
        Listening = false,
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

    local keyBg = Drawing.new("Square")
    keyBg.Size = Vector2.new(60, 20)
    keyBg.Position = Vector2.new(W.Pos.X + 640, y + 3)
    keyBg.Color = Color3.fromRGB(60, 60, 80)
    keyBg.Filled = true
    keyBg.Visible = true

    local keyTxt = Drawing.new("Text")
    keyTxt.Text = tostring(default)
    keyTxt.Size = 12
    keyTxt.Center = true
    keyTxt.Outline = true
    keyTxt.Color = T.Text
    keyTxt.Position = Vector2.new(W.Pos.X + 670, y + 7)
    keyTxt.Visible = true

    el.SetVisible = function(v)
        bg.Visible = v
        txt.Visible = v
        keyBg.Visible = v
        keyTxt.Visible = v
    end

    el.Btn = { Pos = Vector2.new(W.Pos.X + 640, y + 3), Size = Vector2.new(60, 20) }

    el.StartListen = function()
        el.Listening = true
        keyTxt.Text = "..."
        keyBg.Color = T.Accent
    end

    el.Set = function(k)
        el.Value = k
        keyTxt.Text = tostring(k)
        keyBg.Color = Color3.fromRGB(60, 60, 80)
        el.Listening = false
        if callback then callback(k) end
    end

    table.insert(module.Elements, el)
    return el
end
