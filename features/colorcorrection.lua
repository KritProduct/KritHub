return function(Hub)
    local Lighting = game:GetService("Lighting")
    local CC = {}

    local cc = Lighting:FindFirstChild("KritHubCC")
    local created = false
    if not cc then
        cc = Instance.new("ColorCorrectionEffect")
        cc.Name = "KritHubCC"
        cc.Parent = Lighting
        created = true
    end

    local original = {
        Brightness = cc.Brightness,
        Contrast = cc.Contrast,
        Saturation = cc.Saturation,
        TintColor = cc.TintColor,
    }

    CC.Enabled = false
    CC.Brightness = 0
    CC.Contrast = 0
    CC.Saturation = 0
    CC.TintColor = Color3.fromRGB(255, 255, 255)

    function CC.Enable()
        CC.Enabled = true
        cc.Brightness = CC.Brightness
        cc.Contrast = CC.Contrast
        cc.Saturation = CC.Saturation
        cc.TintColor = CC.TintColor
    end

    function CC.Disable()
        CC.Enabled = false
        cc.Brightness = original.Brightness
        cc.Contrast = original.Contrast
        cc.Saturation = original.Saturation
        cc.TintColor = original.TintColor
        if created then
            task.delay(0.1, function() cc:Destroy() end)
        end
    end

    function CC.SetBrightness(v)
        CC.Brightness = v
        if CC.Enabled then cc.Brightness = v end
    end

    function CC.SetContrast(v)
        CC.Contrast = v
        if CC.Enabled then cc.Contrast = v end
    end

    function CC.SetSaturation(v)
        CC.Saturation = v
        if CC.Enabled then cc.Saturation = v end
    end

    function CC.SetTint(c)
        CC.TintColor = c
        if CC.Enabled then cc.TintColor = c end
    end

    return CC
end