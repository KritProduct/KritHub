local Theme = {}
Theme.Accent = Color3.fromRGB(77, 141, 255)
Theme.Background = Color3.fromRGB(18, 18, 24)
Theme.Panel = Color3.fromRGB(24, 24, 32)
Theme.Item = Color3.fromRGB(32, 32, 42)
Theme.ItemHover = Color3.fromRGB(40, 40, 52)
Theme.Settings = Color3.fromRGB(22, 22, 30)
Theme.Text = Color3.fromRGB(235, 235, 245)
Theme.TextDim = Color3.fromRGB(140, 140, 160)
Theme.Red = Color3.fromRGB(230, 57, 70)
Theme.Green = Color3.fromRGB(61, 220, 132)
Theme.Corner = UDim.new(0, 10)
Theme.CornerSmall = UDim.new(0, 6)
function Theme.SetAccent(c) Theme.Accent = c end
return Theme