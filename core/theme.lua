local Theme = {}

Theme.Accent = Color3.fromRGB(245, 166, 35)
Theme.AccentHi = Color3.fromRGB(255, 184, 77)
Theme.AccentDim = Color3.fromRGB(74, 52, 18)

Theme.Background = Color3.fromRGB(13, 13, 16)
Theme.Panel = Color3.fromRGB(16, 16, 22)
Theme.Item = Color3.fromRGB(26, 26, 31)
Theme.ItemHover = Color3.fromRGB(34, 34, 42)
Theme.Settings = Color3.fromRGB(13, 13, 16)
Theme.Border = Color3.fromRGB(28, 28, 34)
Theme.Border2 = Color3.fromRGB(42, 42, 50)
Theme.Border3 = Color3.fromRGB(58, 58, 68)

Theme.Text = Color3.fromRGB(216, 216, 220)
Theme.TextHi = Color3.fromRGB(255, 255, 255)
Theme.TextDim = Color3.fromRGB(110, 110, 120)
Theme.TextMuted = Color3.fromRGB(69, 69, 78)

Theme.Red = Color3.fromRGB(224, 62, 62)
Theme.Green = Color3.fromRGB(74, 222, 128)
Theme.Orange = Color3.fromRGB(245, 166, 35)

Theme.Corner = UDim.new(0, 2)
Theme.CornerMain = UDim.new(0, 3)

function Theme.SetAccent(c) Theme.Accent = c end

return Theme