return function(Hub)
    local RunService = game:GetService("RunService")

    local BulletTracers = {}
    BulletTracers.Enabled = false
    BulletTracers.Style = "Block"
    BulletTracers.Color = Color3.fromRGB(0, 170, 255)
    BulletTracers.Rainbow = false
    BulletTracers.Lifetime = 2
    BulletTracers.ImpactsEnabled = false
    BulletTracers.ImpactColor = Color3.fromRGB(255, 0, 0)

    local function currentColor(base)
        if BulletTracers.Rainbow then
            return Color3.fromHSV((tick() % 5) / 5, 1, 1)
        end
        return base
    end

    local function createTracer(startPos, endPos)
        local style = BulletTracers.Style
        local color = currentColor(BulletTracers.Color)
        local duration = math.max(BulletTracers.Lifetime, 0.1)

        local beam = Instance.new("Part")
        beam.Name = "KritHub_Tracer"
        beam.Anchored = true
        beam.CanCollide = false
        beam.CanQuery = false
        beam.CanTouch = false
        beam.CastShadow = false
        beam.Material = Enum.Material.Neon
        beam.Color = color
        beam.Transparency = 0

        if style == "Cylinder" then
            beam.Shape = Enum.PartType.Cylinder
            beam.Size = Vector3.new((startPos - endPos).Magnitude, 0.12, 0.12)
            beam.CFrame = CFrame.new(startPos, endPos) * CFrame.new(0, 0, -beam.Size.X / 2) * CFrame.Angles(0, math.rad(90), 0)
        else
            beam.Size = Vector3.new(0.1, 0.1, (startPos - endPos).Magnitude)
            beam.CFrame = CFrame.new(startPos, endPos) * CFrame.new(0, 0, -beam.Size.Z / 2)
        end

        beam.Parent = workspace

        task.spawn(function()
            local t0 = tick()
            while tick() - t0 < duration do
                local a = (tick() - t0) / duration
                if beam and beam.Parent then
                    beam.Transparency = a
                    if BulletTracers.Rainbow then
                        beam.Color = Color3.fromHSV((tick() % 5) / 5, 1, 1)
                    end
                end
                task.wait()
            end
            if beam then beam:Destroy() end
        end)
    end

    local function createImpact(pos)
        local impact = Instance.new("Part")
        impact.Name = "KritHub_Impact"
        impact.Size = Vector3.new(0.6, 0.6, 0.6)
        impact.Shape = Enum.PartType.Block
        impact.Position = pos
        impact.Anchored = true
        impact.CanCollide = false
        impact.CanQuery = false
        impact.CanTouch = false
        impact.CastShadow = false
        impact.Material = Enum.Material.Neon
        impact.Color = BulletTracers.ImpactColor
        impact.Transparency = 0
        impact.Parent = workspace

        task.spawn(function()
            local t0 = tick()
            local duration = 3
            while tick() - t0 < duration do
                local a = (tick() - t0) / duration
                if impact and impact.Parent then
                    impact.Transparency = a
                end
                task.wait()
            end
            if impact then impact:Destroy() end
        end)
    end

    local ShootSignal = Hub.ShootSignal
    if ShootSignal then
        ShootSignal.Subscribe(function(hitData, bullet)
            if not hitData or not hitData.Position then return end
            local cam = workspace.CurrentCamera
            if not cam then return end
            local startPos = cam.CFrame.Position
            local endPos = hitData.Position

            if BulletTracers.Enabled then
                pcall(createTracer, startPos, endPos)
            end
            if BulletTracers.ImpactsEnabled then
                pcall(createImpact, endPos)
            end
        end)
    end

    function BulletTracers.Enable()
        BulletTracers.Enabled = true
        if Hub.ShootSignal then Hub.ShootSignal.Install() end
    end

    function BulletTracers.Disable() BulletTracers.Enabled = false end

    function BulletTracers.EnableImpacts()
        BulletTracers.ImpactsEnabled = true
        if Hub.ShootSignal then Hub.ShootSignal.Install() end
    end

    function BulletTracers.DisableImpacts() BulletTracers.ImpactsEnabled = false end

    return BulletTracers
end