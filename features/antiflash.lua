return function(Hub)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local AntiFlash = {}

    AntiFlash.Enabled = false
    AntiFlash.HideOverlay = true
    AntiFlash.HideScreenshot = true

    local pgConn = nil
    local childConns = {}

    local function hideElement(d)
        if d:IsA("Frame") then
            d.BackgroundTransparency = 1
        elseif d:IsA("ImageLabel") then
            d.ImageTransparency = 1
            d.BackgroundTransparency = 1
        elseif d:IsA("TextLabel") then
            d.TextTransparency = 1
            d.BackgroundTransparency = 1
        else
            return
        end

        d.Visible = false

        d.Changed:Connect(function(prop)
            if not AntiFlash.Enabled then return end
            if prop == "Visible" then
                d.Visible = false
            elseif prop == "BackgroundTransparency" then
                d.BackgroundTransparency = 1
            elseif prop == "ImageTransparency" and d:IsA("ImageLabel") then
                d.ImageTransparency = 1
            elseif prop == "TextTransparency" and d:IsA("TextLabel") then
                d.TextTransparency = 1
            end
        end)
    end

    local function handleOverlay(gui)
        local function process(d)
            if not AntiFlash.Enabled then return end
            if not AntiFlash.HideOverlay then return end
            if d.Name == "FlashOverlay" then
                hideElement(d)
            end
        end
        for _, d in ipairs(gui:GetDescendants()) do process(d) end
        table.insert(childConns, gui.DescendantAdded:Connect(process))
    end

    local function handleScreenshot(gui)
        local function process(d)
            if not AntiFlash.Enabled then return end
            if not AntiFlash.HideScreenshot then return end
            if d.Name == "ScreenshotImage" then
                hideElement(d)
            end
        end
        for _, d in ipairs(gui:GetDescendants()) do process(d) end
        table.insert(childConns, gui.DescendantAdded:Connect(process))
    end

    local function handleGui(gui)
        if not AntiFlash.Enabled then return end
        if not gui:IsA("ScreenGui") then return end

        if gui.Name == "FlashbangEffect" then
            handleOverlay(gui)
        elseif gui.Name == "FlashScreenshot" then
            handleScreenshot(gui)
        end
    end

    function AntiFlash.Enable()
        AntiFlash.Enabled = true

        local pg = LocalPlayer:WaitForChild("PlayerGui")

        for _, g in ipairs(pg:GetChildren()) do
            handleGui(g)
        end

        if pgConn then pgConn:Disconnect() end
        pgConn = pg.ChildAdded:Connect(function(child)
            task.defer(function()
                handleGui(child)
            end)
        end)
    end

    function AntiFlash.Disable()
        AntiFlash.Enabled = false
        if pgConn then pgConn:Disconnect() pgConn = nil end
        for _, c in ipairs(childConns) do c:Disconnect() end
        childConns = {}
    end

    return AntiFlash
end