local Module = {}

Module.List = {}

function Module.Create(Hub, tab, name)
    local T = Hub.Theme
    local W = Hub.State.Window

    local mod = {
        Name = name,
        Tab = tab,
        Open = false,
        Enabled = false,
        Elements = {},
        Keybind = nil,
        Y = 0,
        Height = 0,
    }

    local index = #Module.List
    local baseY = W.Pos.Y + 70 + index * 46
    mod.Y = baseY

    local head = Drawing.new("Square")
    head.Size = Vector2.new(540, 38)
    head.Position = Vector2.new(W.Pos.X + 180, mod.Y)
    head.Color = T.Item
    head.Filled = true
    head.Visible = true

    local dot = Drawing.new("Circle")
    dot.Radius = 5
    dot.Filled = true
    dot.Color = T.Red
    dot.Position = Vector2.new(W.Pos.X + 200, mod.Y + 19)
    dot.Visible = true

    local txt = Drawing.new("Text")
    txt.Text = name
    txt.Size = 14
    txt.Center = false
    txt.Outline = true
    txt.Color = T.Text
    txt.Position = Vector2.new(W.Pos.X + 220, mod.Y + 12)
    txt.Visible = true

    local expand = Drawing.new("Square")
    expand.Size = Vector2.new(30, 26)
    expand.Position = Vector2.new(W.Pos.X + 640, mod.Y + 6)
    expand.Color = Color3.fromRGB(60, 60, 80)
    expand.Filled = true
    expand.Visible = true

    local expandTxt = Drawing.new("Text")
    expandTxt.Text = "v"
    expandTxt.Size = 14
    expandTxt.Center = true
    expandTxt.Outline = true
    expandTxt.Color = T.Text
    expandTxt.Position = Vector2.new(W.Pos.X + 655, mod.Y + 12)
    expandTxt.Visible = true

    local bind = Drawing.new("Square")
    bind.Size = Vector2.new(30, 26)
    bind.Position = Vector2.new(W.Pos.X + 680, mod.Y + 6)
    bind.Color = Color3.fromRGB(60, 60, 80)
    bind.Filled = true
    bind.Visible = true

    local bindTxt = Drawing.new("Text")
    bindTxt.Text = "+"
    bindTxt.Size = 14
    bindTxt.Center = true
    bindTxt.Outline = true
    bindTxt.Color = T.Text
    bindTxt.Position = Vector2.new(W.Pos.X + 695, mod.Y + 12)
    bindTxt.Visible = true

    mod.Draw = {
        Head = head,
        Dot = dot,
        Text = txt,
        Expand = expand,
        ExpandTxt = expandTxt,
        Bind = bind,
        BindTxt = bindTxt,
    }

    mod.SetVisible = function(v)
        for _, o in pairs(mod.Draw) do o.Visible = v end
        for _, el in ipairs(mod.Elements) do
            if el.SetVisible then el.SetVisible(v) end
        end
    end

    mod.SetEnabled = function(v)
        mod.Enabled = v
        dot.Color = v and T.Green or T.Red
    end

    mod.Toggle = function()
        mod.SetEnabled(not mod.Enabled)
    end

    table.insert(Module.List, mod)
    table.insert(tab.Modules, mod)

    return mod
end

return Module
