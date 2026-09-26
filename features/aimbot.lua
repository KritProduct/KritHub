return function(Hub)
    local Aimbot = {}

    Aimbot.Enabled = false
    Aimbot.FOV = 300
    Aimbot.Speed = 0.3
    Aimbot.TargetPart = "Head"
    Aimbot.WallCheck = false
    Aimbot.FriendCheck = true
    Aimbot.Keybind = Enum.KeyCode.E

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local LocalPlayer = Players.LocalPlayer

    local FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 2
    FOVCircle.Color = Color3.fromRGB(255, 255, 255)
    FOVCircle.Transparency = 0
    FOVCircle.Filled = false
    FOVCircle.Visible = false
    FOVCircle.Radius = Aimbot.FOV

    local function GetFolder()
        return workspace:FindFirstChild("Characters")
    end

    local function IsAlive(ch)
        if ch:GetAttribute("Dead") == true then return false end
        local hp = ch:GetAttribute("Health")
        if hp and hp <= 0 then return false end
        return ch:FindFirstChild("Head") ~= nil
    end

    local function GetTeam(ch)
        local n = ch:GetAttribute("CharacterName")
        if not n then return nil end
        if n == "Anarchist" or n == "Terrorist" or n == "Rebel" then return "T" end
        if n == "IDF" or n == "SEAL" or n == "SAS" or n == "Counter-Terrorist" then return "CT" end
        return nil
    end

    local function GetMyTeam()
        local me = LocalPlayer.Character
        if not me then return nil end
        return GetTeam(me)
    end

    local function GetTargetPart(ch)
        if Aimbot.TargetPart == "Head" then
            return ch:FindFirstChild("Head")
        elseif Aimbot.TargetPart == "Torso" then
            return ch:FindFirstChild("UpperTorso") or ch:FindFirstChild("Torso") or ch:FindFirstChild("HumanoidRootPart")
        elseif Aimbot.TargetPart == "Legs" then
            return ch:FindFirstChild("LeftUpperLeg") or ch:FindFirstChild("RightUpperLeg") or ch:FindFirstChild("LowerTorso")
        end
        return ch:FindFirstChild("Head")
    end

    local function IsVisible(ch, targetPart)
        if not Aimbot.WallCheck then return true end

        local char = LocalPlayer.Character
        if not char then return false end
        local cam = workspace.CurrentCamera
        if not cam then return false end
        local head = ch:FindFirstChild("Head")
        if not head then return false end

        local ignore = {char}
        local folder = GetFolder()
        if folder then
            for _, other in ipairs(folder:GetChildren()) do
                if other:IsA("Model") then
                    for _, d in ipairs(other:GetDescendants()) do
                        if d ~= head then
                            table.insert(ignore, d)
                        end
                    end
                end
            end
        end

        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = ignore
        params.IgnoreWater = true

        local origin = cam.CFrame.Position
        local dir = head.Position - origin
        local ray = workspace:Raycast(origin, dir, params)

        if ray == nil then return true end
        if ray.Instance == head then return true end
        return false
    end

    local function GetAllTargets()
        local list = {}
        local folder = GetFolder()
        if not folder then return list end
        local myTeam = GetMyTeam()
        for _, obj in ipairs(folder:GetChildren()) do
            if obj:IsA("Model") and obj ~= LocalPlayer.Character and IsAlive(obj) then
                if Aimbot.FriendCheck and myTeam then
                    local t = GetTeam(obj)
                    if t ~= myTeam then table.insert(list, obj) end
                else
                    table.insert(list, obj)
                end
            end
        end
        return list
    end

    local function GetClosestTarget()
        local cam = workspace.CurrentCamera
        if not cam then return nil end
        local closest, closestDist = nil, Aimbot.FOV
        local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
        for _, ch in ipairs(GetAllTargets()) do
            local part = GetTargetPart(ch)
            if part then
                local sp, onScreen = cam:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                    if dist < closestDist and IsVisible(ch, part) then
                        closest = part
                        closestDist = dist
                    end
                end
            end
        end
        return closest
    end

    RunService.RenderStepped:Connect(function()
        local cam = workspace.CurrentCamera
        if not cam then return end

        if Aimbot.Enabled then
            FOVCircle.Position = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
            FOVCircle.Radius = Aimbot.FOV
            FOVCircle.Visible = true

            local target = GetClosestTarget()
            if target then
                local sp, onScreen = cam:WorldToViewportPoint(target.Position)
                if onScreen then
                    local mouse = UserInputService:GetMouseLocation()
                    local mx = (sp.X - mouse.X) * Aimbot.Speed
                    local my = (sp.Y - mouse.Y) * Aimbot.Speed
                    if mousemoverel then mousemoverel(mx, my) end
                end
            end
        else
            FOVCircle.Visible = false
        end
    end)

    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Aimbot.Keybind then
            Aimbot.Enabled = not Aimbot.Enabled
        end
    end)

    function Aimbot.Enable() Aimbot.Enabled = true end
    function Aimbot.Disable() Aimbot.Enabled = false end

    return Aimbot
end
