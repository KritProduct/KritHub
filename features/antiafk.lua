return function(Hub)
    local Players = game:GetService("Players")
    local VirtualUser = game:GetService("VirtualUser")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer

    local AntiAFK = {}
    AntiAFK.Enabled = false
    AntiAFK.Interval = 5
    AntiAFK.DoRotate = true
    AntiAFK.DoJump = false
    AntiAFK.DoClick = true

    local lastTick = 0
    local flip = false

    local function doAntiAFK()
        if AntiAFK.DoRotate then
            pcall(function()
                local cam = workspace.CurrentCamera
                if cam then
                    flip = not flip
                    cam.CFrame = cam.CFrame * CFrame.Angles(0, flip and 0.05 or -0.05, 0)
                end
            end)
        end

        if AntiAFK.DoJump then
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then hum.Jump = true end
                end
            end)
        end

        if AntiAFK.DoClick then
            pcall(function()
                VirtualUser:Button1Down(Vector2.new(0, 0))
                task.wait(0.05)
                VirtualUser:Button1Up(Vector2.new(0, 0))
            end)
        end

        pcall(function()
            VirtualUser:CaptureController()
        end)
    end

    RunService.Heartbeat:Connect(function()
        if not AntiAFK.Enabled then return end
        if tick() - lastTick < AntiAFK.Interval then return end
        lastTick = tick()
        doAntiAFK()
    end)

    function AntiAFK.Enable() AntiAFK.Enabled = true end
    function AntiAFK.Disable() AntiAFK.Enabled = false end

    return AntiAFK
end