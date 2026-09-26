local Utils = {}
function Utils.Corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = radius or UDim.new(0, 8)
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
return Utils