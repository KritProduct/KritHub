return function(Hub)
    local RunService = game:GetService("RunService")

    local Weather = {}
    Weather.Mode = "None"
    Weather.Part = nil
    Weather.Emitter = nil

    local function cleanup()
        if Weather.Part then
            Weather.Part:Destroy()
            Weather.Part = nil
            Weather.Emitter = nil
        end
    end

    local function createWeather(mode)
        cleanup()
        if mode == "None" then return end

        local cam = workspace.CurrentCamera
        if not cam then return end

        local part = Instance.new("Part")
        part.Name = "KritHub_Weather"
        part.Size = Vector3.new(100, 1, 100)
        part.Transparency = 1
        part.Anchored = true
        part.CanCollide = false
        part.CanQuery = false
        part.Parent = cam

        local emitter = Instance.new("ParticleEmitter")
        emitter.Parent = part
        emitter.EmissionDirection = Enum.NormalId.Bottom
        emitter.Enabled = true

        if mode == "Rain" then
            emitter.Texture = "rbxassetid://241868005"
            emitter.Rate = 1000
            emitter.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
            emitter.LightEmission = 0.2
            emitter.Transparency = NumberSequence.new(0)
            emitter.Size = NumberSequence.new(3, 6)
            emitter.Lifetime = NumberRange.new(2, 2.5)
            emitter.Speed = NumberRange.new(80, 100)
            emitter.SpreadAngle = Vector2.new(0, 0)
            emitter.Acceleration = Vector3.new(0, -50, 0)
        elseif mode == "Snow" then
            emitter.Texture = "rbxassetid://99851851"
            emitter.Rate = 200
            emitter.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
            emitter.Size = NumberSequence.new(0.25, 0.35)
            emitter.Speed = NumberRange.new(30, 30)
            emitter.Lifetime = NumberRange.new(5, 10)
            emitter.Acceleration = Vector3.new(0, 0, 0)
            emitter.SpreadAngle = Vector2.new(50, 50)
            emitter.LightEmission = 0.5
        elseif mode == "Hell Fire" then
            emitter.Texture = "rbxassetid://242205518"
            emitter.Rate = 400
            emitter.Color = ColorSequence.new(Color3.fromRGB(255, 100, 0), Color3.fromRGB(150, 0, 0))
            emitter.Size = NumberSequence.new(2, 4)
            emitter.Speed = NumberRange.new(40, 60)
            emitter.Lifetime = NumberRange.new(2, 3)
            emitter.Acceleration = Vector3.new(0, -10, 0)
            emitter.RotSpeed = NumberRange.new(50, 100)
        end

        Weather.Part = part
        Weather.Emitter = emitter
    end

    function Weather.Set(mode)
        Weather.Mode = mode
        createWeather(mode)
    end

    RunService.RenderStepped:Connect(function()
        if Weather.Part and workspace.CurrentCamera then
            Weather.Part.CFrame = workspace.CurrentCamera.CFrame * CFrame.new(0, 30, 0)
        end
    end)

    return Weather
end