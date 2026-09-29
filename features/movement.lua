return function(Hub)
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local Movement = {}
    Movement.AutoBhop = false
    Movement.BhopSpeed = 18
    Movement.NoFallDamage = false

    local function GetMoveDirection()
        local cam = workspace.CurrentCamera
        if not cam then return Vector3.zero end
        local dir = Vector3.zero
        local look = cam.CFrame.LookVector
        local right = cam.CFrame.RightVector
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += look end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= look end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= right end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += right end
        return Vector3.new(dir.X, 0, dir.Z)
    end

    RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end

        if Movement.AutoBhop then
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                local params = RaycastParams.new()
                params.FilterDescendantsInstances = {char}
                params.FilterType = Enum.RaycastFilterType.Exclude
                local ground = workspace:Raycast(root.Position, Vector3.new(0, -4, 0), params)
                if ground then hum.Jump = true end
            end
            local dir = GetMoveDirection()
            if dir.Magnitude > 0 then
                local target = dir.Unit * math.clamp(Movement.BhopSpeed, 5, 30)
                local vel = root.AssemblyLinearVelocity
                local newX = vel.X + (target.X - vel.X) * 0.2
                local newZ = vel.Z + (target.Z - vel.Z) * 0.2
                root.AssemblyLinearVelocity = Vector3.new(newX, vel.Y, newZ)
            end
        end
    end)

    RunService.Heartbeat:Connect(function()
        if Movement.NoFallDamage then
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    pcall(function()
                        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                    end)
                end
            end
        end
    end)

    return Movement
end