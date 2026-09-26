local Module = {}

function Module.Create(Hub, tab, name)
    local W = Hub.State.Window
    local T = Hub.Theme

    local mod = {
        Name = name,
        Tab = tab,
        Hub = Hub,
        Open = false,
        Enabled = false,
        Elements = {},
        Index = #tab.Modules + 1,
        BaseY = 0,
    }

    local function newObj(class, props)
        local o = Drawing.new(class)
        for k, v in pairs(props) do o[k] = v end
        o.Visible = false
        return o
    end

    mod.Head = newObj("Square", {
        Size = Vector2.new(430, 36),
        Color = T.Item,
        Filled = true,
    })

    mod.Dot = newObj("Circle", {
        Radius = 6,
        Filled = true,
        Color = T.Red,
    })

    mod.DotHalo = newObj("Circle", {
        Radius = 10,
        Filled = false,
        Thickness = 2,
        Color = T.Red,
        Transparency = 0.6,
    })

    mod.Label = newObj("Text", {
        Text = name,
        Size = 14,
        Center = false,
        Outline = true,
        Color = T.Text,
    })

    mod.ExpandBtn = newObj("Square", {
        Size = Vector2.new(26, 24),
        Color = Color3.fromRGB(50, 50, 65),
        Filled = true,
    })

    mod.ExpandTxt = newObj("Text", {
        Text = "v",
        Size = 14,
        Center = true,
        Outline = true,
        Color = T.Text,
    })

    mod.BindBtn = newObj("Square", {
        Size = Vector2.new(26, 24),
        Color = Color3.fromRGB(50, 50, 65),
        Filled = true,
    })

    mod.BindTxt = newObj("Text", {
        Text = "+",
        Size = 14,
        Center = true,
        Outline = true,
        Color = T.Text,
    })

    mod.Objects = {
        mod.Head, mod.Dot, mod.DotHalo, mod.Label,
        mod.ExpandBtn, mod.ExpandTxt, mod.BindBtn, mod.BindTxt,
    }

    mod.UpdatePositions = function()
        local x = W.Pos.X + 170
        local y = W.Pos.Y + 60 + (mod.Index - 1) * 46

        if mod.Tab ~= W.ActiveTab then
            mod.BaseY = -9999
            return
        end

        for _, m in ipairs(tab.Modules) do
            if m ~= mod and m.Index < mod.Index and m.Open then
                y = y + m.OpenHeight or y
            end
        end

        mod.BaseY = y

        mod.Head.Position = Vector2.new(x, y)
        mod.Dot.Position = Vector2.new(x + 18, y + 18)
        mod.DotHalo.Position = Vector2.new(x + 18, y + 18)
        mod.Label.Position = Vector2.new(x + 38, y + 11)
        mod.ExpandBtn.Position = Vector2.new(x + 430 - 60, y + 6)
        mod.ExpandTxt.Position = Vector2.new(x + 430 - 47, y + 12)
        mod.BindBtn.Position = Vector2.new(x + 430 - 30, y + 6)
        mod.BindTxt.Position = Vector2.new(x + 430 - 17, y + 12)

        for i, el in ipairs(mod.Elements) do
            if el.UpdatePositions then
                el.UpdatePositions(y + 40 + (i - 1) * 30, x)
            end
        end
    end

    mod.Show = function()
        for _, o in ipairs(mod.Objects) do o.Visible = true end
        if mod.Open then
            for _, el in ipairs(mod.Elements) do
                if el.Show then el.Show() end
            end
        end
        mod.UpdatePositions()
    end

    mod.Hide = function()
        for _, o in ipairs(mod.Objects) do o.Visible = false end
        for _, el in ipairs(mod.Elements) do
            if el.Hide then el.Hide() end
        end
    end

    mod.Toggle = function()
        mod.Enabled = not mod.Enabled
        local c = mod.Enabled and T.Green or T.Red
        mod.Dot.Color = c
        mod.DotHalo.Color = c
    end

    mod.SetOpen = function(open)
        mod.Open = open
        mod.ExpandTxt.Text = open and "^" or "v"
        for _, el in ipairs(mod.Elements) do
            if open then
                if el.Show then el.Show() end
            else
                if el.Hide then el.Hide() end
            end
        end
        if mod.Tab then mod.Tab.UpdatePositions() end
    end

    table.insert(tab.Modules, mod)
    return mod
end

return Module