local Utils = {}

function Utils.Corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = radius or UDim.new(0, 4)
    c.Parent = parent
    return c
end

function Utils.Stroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

function Utils.Padding(parent, all)
    local p = Instance.new("UIPadding")
    p.PaddingTop = UDim.new(0, all)
    p.PaddingBottom = UDim.new(0, all)
    p.PaddingLeft = UDim.new(0, all)
    p.PaddingRight = UDim.new(0, all)
    p.Parent = parent
    return p
end

function Utils.Gradient(parent, color1, color2, rotation)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(color1, color2)
    g.Rotation = rotation or 90
    g.Parent = parent
    return g
end

return Utils