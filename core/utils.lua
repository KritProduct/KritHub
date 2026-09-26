local Utils = {}

function Utils.Inside(pos, size, point)
    return point.X >= pos.X and point.X <= pos.X + size.X
       and point.Y >= pos.Y and point.Y <= pos.Y + size.Y
end

function Utils.Lerp(a, b, t)
    return a + (b - a) * t
end

return Utils
