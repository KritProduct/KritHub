local Theme = {}

Theme.Accent = Color3.fromRGB(77, 141, 255)
Theme.Background = Color3.fromRGB(14, 14, 19)
Theme.Panel = Color3.fromRGB(22, 22, 29)
Theme.Item = Color3.fromRGB(28, 28, 38)
Theme.ItemHover = Color3.fromRGB(35, 35, 47)
Theme.Settings = Color3.fromRGB(18, 18, 26)
Theme.Text = Color3.fromRGB(230, 230, 240)
Theme.TextDim = Color3.fromRGB(138, 138, 153)
Theme.Red = Color3.fromRGB(230, 57, 70)
Theme.Green = Color3.fromRGB(61, 220, 132)
Theme.Radius = 8

function Theme.SetAccent(color)
    Theme.Accent = color
end

return Theme
