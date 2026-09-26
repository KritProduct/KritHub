return function(Hub)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    local AntiFlash = {}

    AntiFlash.Enabled = false

    local connections = {}

    local function killGui(g)
        if not g:IsA("ScreenGui") then return end
        local n = string.lower(g.Name)
        if string.find(n, "flash", 1, true) then
            for _, d in ipairs(g:GetDescendants()) do
                pcall(function()
                    if d:IsA("Frame") or d:IsA("ImageLabel") or d:IsA("TextLabel") then
                        d.Visible = false
                        d.BackgroundTransparency = 1
                        if d:IsA("ImageLabel") then d.ImageTransparency = 1 end
                        if d:IsA("TextLabel") then d.TextTransparency = 1 end
                    end
                end)
            end
            g.Enabled = false
            g:Destroy()
        end
    end

    local function suppressLighting()
        local Lighting = game:GetService("Lighting")

        if Lighting.Brightness > 1 then Lighting.Brightness = 0 end

        for _, e in ipairs(Lighting:GetChildren()) do
            if e:IsA("BloomEffect") and e.Enabled then e.Enabled = false end
            if e:IsA("ColorCorrectionEffect") then
                if e.Brightness > 0 then e.Brightness = 0 end
                if e.TintColor ~= Color3.fromRGB(255, 255, 255) then
                    e.TintColor = Color3.fromRGB(255, 255, 255)
                end
            end
        end
    end

    local function scanAll(pg)
        for _, g in ipairs(pg:GetChildren()) do
            killGui(g)
        end
        suppressLighting()
    end

    function AntiFlash.Enable()
        AntiFlash.Enabled = true

        local pg = LocalPlayer:WaitForChild("PlayerGui")

        scanAll(pg)

        table.insert(connections, pg.ChildAdded:Connect(function(c)
            killGui(c)
        end))

        table.insert(connections, pg.DescendantAdded:Connect(function(d)
            if not AntiFlash.Enabled then return end
            if d.Name == "FlashOverlay" or d.Name == "ScreenshotImage" then
                pcall(function()
                    d.Visible = false
                    d.BackgroundTransparency = 1
                    if d:IsA("ImageLabel") then d.ImageTransparency = 1 end
                end)
            end
            local parent = d.Parent
            while parent do
                if parent:IsA("ScreenGui") and string.find(string.lower(parent.Name), "flash", 1, true) then
                    killGui(parent)
                    break
                end
                parent = parent.Parent
            end
        end))

        table.insert(connections, RunService.RenderStepped:Connect(function()
            if not AntiFlash.Enabled then return end
            scanAll(pg)
        end))
    end

    function AntiFlash.Disable()
        AntiFlash.Enabled = false
        for _, c in ipairs(connections) do c:Disconnect() end
        connections = {}
    end

    return AntiFlash
end