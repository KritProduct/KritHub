return function(Hub)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local AntiFlash = {}

    AntiFlash.Enabled = false
    AntiFlash.HideOverlay = true
    AntiFlash.HideScreenshot = true

    local connections = {}

    local function processGui(gui)
        if not AntiFlash.Enabled then return end
        if not gui:IsA("ScreenGui") then return end

        if gui.Name == "FlashbangEffect" and AntiFlash.HideOverlay then
            for _, d in ipairs(gui:GetDescendants()) do
                if d:IsA("Frame") and d.Name == "FlashOverlay" then
                    d.BackgroundTransparency = 1
                    d.Visible = false
                    d.Changed:Connect(function(prop)
                        if prop == "BackgroundTransparency" or prop == "Visible" then
                            d.BackgroundTransparency = 1
                            d.Visible = false
                        end
                    end)
                end
            end
        end

        if gui.Name == "FlashScreenshot" and AntiFlash.HideScreenshot then
            for _, d in ipairs(gui:GetDescendants()) do
                if d:IsA("ImageLabel") and d.Name == "ScreenshotImage" then
                    d.ImageTransparency = 1
                    d.Visible = false
                    d.Changed:Connect(function(prop)
                        if prop == "ImageTransparency" or prop == "Visible" then
                            d.ImageTransparency = 1
                            d.Visible = false
                        end
                    end)
                end
            end
        end
    end

    function AntiFlash.Enable()
        AntiFlash.Enabled = true

        local pg = LocalPlayer:WaitForChild("PlayerGui")

        for _, g in ipairs(pg:GetChildren()) do
            processGui(g)
        end

        table.insert(connections, pg.ChildAdded:Connect(function(child)
            task.defer(function()
                processGui(child)
            end)
        end))
    end

    function AntiFlash.Disable()
        AntiFlash.Enabled = false
        for _, c in ipairs(connections) do c:Disconnect() end
        connections = {}
    end

    return AntiFlash
end