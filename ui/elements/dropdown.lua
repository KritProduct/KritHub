return function(Hub, module, label, options, default, callback)
    local T = Hub.Theme
    local W = Hub.State.Window

    local el = {
        Options = options,
        Index = 1,
        Value = default,
        Visible = true,
    }

    for i, opt in ipairs(options) do
        if opt == default then el.Index = i end
    end

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

    local dd = Drawing.new("Square")
    dd.Size = Vector2.new(100, 22)
    dd.Position = Vector2.new(W.Pos.X + 600, y + 2)
    dd.Color = Color3.fromRGB(60, 60, 80)
    dd.Filled = true
    dd.Visible = true

    local ddTxt = Drawing.new("Text")
    ddTxt.Text = tostring(default)
    ddTxt.Size = 12
    ddTxt.Center = true
    ddTxt.Outline = true
    ddTxt.Color = T.Text
    ddTxt.Position = Vector2.new(W.Pos.X + 650, y + 6)
    ddTxt.Visible = true

    el.SetVisible = function(v)
        bg.Visible = v
        txt.Visible = v
        dd.Visible = v
        ddTxt.Visible = v
    end

    el.Btn = { Pos = Vector2.new(W.Pos.X + 600, y + 2), Size = Vector2.new(100, 22) }

    el.Cycle = function()
        el.Index = el.Index % #options + 1
        el.Value = options[el.Index]
        ddTxt.Text = tostring(el.Value)
        if callback then callback(el.Value) end
    end

    table.insert(module.Elements, el)
    return el
end
