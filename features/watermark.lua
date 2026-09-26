return function(Hub)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Stats = game:GetService("Stats")
    local LocalPlayer = Players.LocalPlayer
    local T = Hub.Theme

    local Watermark = {}
    Watermark.Enabled = false
    Watermark.ShowFPS = true
    Watermark.ShowPing = true
    Watermark.ShowTime = true
    Watermark.ShowUsername = true

    local screenGui = nil
    local frame = nil
    local brandLabel = nil
    local separator = nil
    local infoLabel = nil
    local updateConn = nil

    local dragging = false
    local dragStart = nil
    local startPos = nil

    local function build()
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "KritHubWatermark"
        screenGui.ResetOnSpawn = false
        screenGui.IgnoreGuiInset = true
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

        frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 380, 0, 30)
        frame.Position = UDim2.new(0, 20, 0, 20)
        frame.BackgroundColor3 = T.Background
        frame.BorderSizePixel = 0
        frame.Active = true
        frame.Parent = screenGui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = frame

        local stroke = Instance.new("UIStroke")
        stroke.Color = T.Accent
        stroke.Thickness = 1
        stroke.Parent = frame

        local grad = Instance.new("UIGradient")
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 45)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 14, 20)),
        })
        grad.Rotation = 0
        grad.Parent = frame

        brandLabel = Instance.new("TextLabel")
        brandLabel.Size = UDim2.new(0, 100, 1, 0)
        brandLabel.Position = UDim2.new(0, 12, 0, 0)
        brandLabel.BackgroundTransparency = 1
        brandLabel.Text = "KRITHUB"
        brandLabel.TextColor3 = T.Accent
        brandLabel.Font = Enum.Font.GothamBold
        brandLabel.TextSize = 14
        brandLabel.TextXAlignment = Enum.TextXAlignment.Left
        brandLabel.ZIndex = 2
        brandLabel.Parent = frame

        separator = Instance.new("Frame")
        separator.Size = UDim2.new(0, 1, 0, 16)
        separator.Position = UDim2.new(0, 105, 0.5, -8)
        separator.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
        separator.BorderSizePixel = 0
        separator.ZIndex = 2
        separator.Parent = frame

        infoLabel = Instance.new("TextLabel")
        infoLabel.Size = UDim2.new(1, -125, 1, 0)
        infoLabel.Position = UDim2.new(0, 115, 0, 0)
        infoLabel.BackgroundTransparency = 1
        infoLabel.Text = "..."
        infoLabel.TextColor3 = T.Text
        infoLabel.Font = Enum.Font.Gotham
        infoLabel.TextSize = 12
        infoLabel.TextXAlignment = Enum.TextXAlignment.Left
        infoLabel.ZIndex = 2
        infoLabel.Parent = frame

        local dragHandle = Instance.new("TextButton")
        dragHandle.Size = UDim2.new(1, 0, 1, 0)
        dragHandle.BackgroundTransparency = 1
        dragHandle.Text = ""
        dragHandle.ZIndex = 5
        dragHandle.AutoButtonColor = false
        dragHandle.Parent = frame

        dragHandle.MouseButton1Down:Connect(function()
            dragging = true
            dragStart = UserInputService:GetMouseLocation()
            startPos = frame.Position
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local m = UserInputService:GetMouseLocation()
                local delta = m - dragStart
                frame.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
    end

    local function destroy()
        if screenGui then
            screenGui:Destroy()
            screenGui = nil
            frame = nil
        end
    end

    local fpsCount = 0
    local fpsTime = 0
    local lastFps = 0

    local function update()
        if not frame then return end

        local parts = {}

        if Watermark.ShowFPS then
            fpsCount = fpsCount + 1
            local now = tick()
            if now - fpsTime >= 1 then
                lastFps = fpsCount
                fpsCount = 0
                fpsTime = now
            end
            table.insert(parts, "FPS: " .. lastFps)
        end

        if Watermark.ShowPing then
            local ping = 0
            pcall(function()
                ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            end)
            table.insert(parts, "Ping: " .. ping .. "ms")
        end

        if Watermark.ShowUsername then
            table.insert(parts, LocalPlayer.Name)
        end

        if Watermark.ShowTime then
            local t = os.date("*t")
            table.insert(parts, string.format("%02d:%02d:%02d", t.hour, t.min, t.sec))
        end

        local text = table.concat(parts, "  |  ")
        infoLabel.Text = text

        local charWidth = 6.5
        local estimatedTextWidth = #text * charWidth
        local neededWidth = 130 + estimatedTextWidth

        if neededWidth < 200 then neededWidth = 200 end

        frame.Size = UDim2.new(0, neededWidth, 0, 30)
        infoLabel.Size = UDim2.new(1, -125, 1, 0)
    end

    function Watermark.Enable()
        Watermark.Enabled = true
        if not frame then build() end

        if not updateConn then
            updateConn = RunService.RenderStepped:Connect(update)
        end
    end

    function Watermark.Disable()
        Watermark.Enabled = false
        if updateConn then
            updateConn:Disconnect()
            updateConn = nil
        end
        destroy()
    end

    return Watermark
end