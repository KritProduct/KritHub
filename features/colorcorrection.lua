return function(Hub)
    local Lighting = game:GetService("Lighting")
    local RunService = game:GetService("RunService")
    local CC = {}

    local cc = Lighting:FindFirstChild("KritHubCC")
    if not cc then
        cc = Instance.new("ColorCorrectionEffect")
        cc.Name = "KritHubCC"
        cc.Parent = Lighting
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

    local heartbeatConn = nil
    local propConns = {}

    local function ensureCC()
        if not cc or not cc.Parent then
            cc = Instance.new("ColorCorrectionEffect")
            cc.Name = "KritHubCC"
            cc.Parent = Lighting
            cc.Brightness = CC.Brightness
            cc.Contrast = CC.Contrast
            cc.Saturation = CC.Saturation
            cc.TintColor = CC.TintColor
        end
    end

    local function enforce()
        if not CC.Enabled then return end
        ensureCC()
        if math.abs(cc.Brightness - CC.Brightness) > 0.01 then cc.Brightness = CC.Brightness end
        if math.abs(cc.Contrast - CC.Contrast) > 0.01 then cc.Contrast = CC.Contrast end
        if math.abs(cc.Saturation - CC.Saturation) > 0.01 then cc.Saturation = CC.Saturation end
        if cc.TintColor ~= CC.TintColor then cc.TintColor = CC.TintColor end
    end

    local function hookProps()
        for _, c in ipairs(propConns) do c:Disconnect() end
        propConns = {}
        ensureCC()
        for _, prop in ipairs({"Brightness", "Contrast", "Saturation", "TintColor"}) do
            table.insert(propConns, cc:GetPropertyChangedSignal(prop):Connect(function()
                if CC.Enabled then task.defer(enforce) end
            end))
        end
    end

    local function unhookProps()
        for _, c in ipairs(propConns) do c:Disconnect() end
        propConns = {}
    end

    function CC.Enable()
        CC.Enabled = true
        ensureCC()
        cc.Brightness = CC.Brightness
        cc.Contrast = CC.Contrast
        cc.Saturation = CC.Saturation
        cc.TintColor = CC.TintColor
        hookProps()
        if not heartbeatConn then
            heartbeatConn = RunService.Heartbeat:Connect(enforce)
        end
    end

    function CC.Disable()
        CC.Enabled = false
        unhookProps()
        if heartbeatConn then heartbeatConn:Disconnect() heartbeatConn = nil end
        if cc and cc.Parent then
            cc.Brightness = original.Brightness
            cc.Contrast = original.Contrast
            cc.Saturation = original.Saturation
            cc.TintColor = original.TintColor
        end
    end

    function CC.SetBrightness(v)
        CC.Brightness = v
        if CC.Enabled then ensureCC() cc.Brightness = v end
    end

    function CC.SetContrast(v)
        CC.Contrast = v
        if CC.Enabled then ensureCC() cc.Contrast = v end
    end

    function CC.SetSaturation(v)
        CC.Saturation = v
        if CC.Enabled then ensureCC() cc.Saturation = v end
    end

    function CC.SetTint(c)
        CC.TintColor = c
        if CC.Enabled then ensureCC() cc.TintColor = c end
    end

    return CC
end