return function(Hub)
    local RunService = game:GetService("RunService")
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local Camera = workspace.CurrentCamera

    local GrenadeESP = {}
    GrenadeESP.Tracers = false
    GrenadeESP.TracerColor = Color3.fromRGB(255, 100, 0)
    GrenadeESP.MolotovZone = false
    GrenadeESP.MolotovColor = Color3.fromRGB(255, 60, 0)
    GrenadeESP.SmokeZone = false
    GrenadeESP.SmokeColor = Color3.fromRGB(180, 180, 180)
    GrenadeESP.FlightTrail = false

    local TracerLines = {}
    local TrackedGrenades = {}

    local KNIFE_NAMES = {["CT Knife"]=true,["T Knife"]=true}
    local PLAYER_PARTS = {["Head"]=true,["UpperTorso"]=true,["LowerTorso"]=true,["HumanoidRootPart"]=true,["LeftUpperArm"]=true,["RightUpperArm"]=true,["LeftLowerArm"]=true,["RightLowerArm"]=true,["LeftUpperLeg"]=true,["RightUpperLeg"]=true,["LeftLowerLeg"]=true,["RightLowerLeg"]=true,["LeftFoot"]=true,["RightFoot"]=true,["LeftHand"]=true,["RightHand"]=true}

    local function IsGrenade(obj)
        if not obj then return false end
        if obj:IsA("Model") then
            local prim = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            if prim and prim.Size.Magnitude < 8 then
                local name = obj.Name:lower()
                if name:find("grenade") or name:find("molotov") or name:find("flash")
                   or name:find("smoke") or name:find("frag") or name:find("decoy")
                   or name:find("incendiary") or name:find("nade") then
                    return true
                end
            end
        end
        return false
    end

    local function GetGrenadePart(g)
        if g:IsA("Model") then
            return g.PrimaryPart or g:FindFirstChildWhichIsA("BasePart")
        elseif g:IsA("BasePart") then
            return g
        end
        return nil
    end

    local function UpdateTracers()
        for obj, data in pairs(TrackedGrenades) do
            if not obj.Parent then
                if data.line then data.line:Remove() end
                if data.trailLines then
                    for _, l in ipairs(data.trailLines) do l:Remove() end
                end
                TrackedGrenades[obj] = nil
            else
                if data.line and GrenadeESP.Tracers then
                    local part = GetGrenadePart(obj)
                    if part then
                        local sp, onScreen = Camera:WorldToViewportPoint(part.Position)
                        if onScreen then
                            data.line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                            data.line.To = Vector2.new(sp.X, sp.Y)
                            data.line.Color = GrenadeESP.TracerColor
                            data.line.Visible = true
                        else
                            data.line.Visible = false
                        end
                    end
                elseif data.line then
                    data.line.Visible = false
                end
            end
        end
    end

    local function TryTrackGrenade(obj)
        if TrackedGrenades[obj] then return end
        if not IsGrenade(obj) then return end

        local data = {
            line = Drawing.new("Line"),
            trailLines = {},
        }
        data.line.Thickness = 2
        data.line.Visible = false

        for i = 1, 20 do
            local l = Drawing.new("Line")
            l.Thickness = 2
            l.Visible = false
            table.insert(data.trailLines, l)
        end

        data.history = {}
        TrackedGrenades[obj] = data
    end

    local function UpdateFlightTrails()
        for obj, data in pairs(TrackedGrenades) do
            if not obj.Parent then continue end
            if not GrenadeESP.FlightTrail then
                for _, l in ipairs(data.trailLines) do l.Visible = false end
                continue
            end
            local part = GetGrenadePart(obj)
            if not part then continue end

            table.insert(data.history, 1, part.Position)
            if #data.history > 21 then table.remove(data.history) end

            for i, l in ipairs(data.trailLines) do
                local p1 = data.history[i]
                local p2 = data.history[i + 1]
                if p1 and p2 then
                    local s1, o1 = Camera:WorldToViewportPoint(p1)
                    local s2, o2 = Camera:WorldToViewportPoint(p2)
                    if (o1 or o2) and s1.Z > 0 and s2.Z > 0 then
                        local fade = 1 - (i / #data.trailLines)
                        l.From = Vector2.new(s1.X, s1.Y)
                        l.To = Vector2.new(s2.X, s2.Y)
                        l.Color = GrenadeESP.TracerColor
                        l.Thickness = math.max(2 * fade, 0.5)
                        l.Transparency = 1 - fade
                        l.Visible = true
                    else
                        l.Visible = false
                    end
                else
                    l.Visible = false
                end
            end
        end
    end

    local function ScanGrenades()
        for _, obj in ipairs(workspace:GetChildren()) do
            TryTrackGrenade(obj)
        end
    end

    task.spawn(function()
        while true do
            task.wait(0.1)
            pcall(ScanGrenades)
        end
    end)

    workspace.ChildAdded:Connect(function(obj)
        task.wait(0.1)
        pcall(TryTrackGrenade, obj)
    end)

    RunService.RenderStepped:Connect(function()
        pcall(UpdateTracers)
        pcall(UpdateFlightTrails)
    end)

    function GrenadeESP.Enable() end
    function GrenadeESP.Disable() end

    return GrenadeESP
end