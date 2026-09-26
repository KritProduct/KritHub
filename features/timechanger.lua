return function(Hub)
    local Lighting = game:GetService("Lighting")
    local RunService = game:GetService("RunService")
    local TimeChanger = {}

    TimeChanger.Enabled = false
    TimeChanger.Time = 14
    TimeChanger.Original = Lighting.ClockTime

    local heartbeatConn = nil
    local propConn = nil

    local function enforce()
        if not TimeChanger.Enabled then return end
        if math.abs(Lighting.ClockTime - TimeChanger.Time) > 0.1 then
            Lighting.ClockTime = TimeChanger.Time
        end
    end

    function TimeChanger.Enable()
        TimeChanger.Enabled = true
        Lighting.ClockTime = TimeChanger.Time

        if not propConn then
            propConn = Lighting:GetPropertyChangedSignal("ClockTime"):Connect(function()
                if TimeChanger.Enabled then
                    task.defer(enforce)
                end
            end)
        end

        if not heartbeatConn then
            heartbeatConn = RunService.Heartbeat:Connect(enforce)
        end
    end

    function TimeChanger.Disable()
        TimeChanger.Enabled = false
        if propConn then propConn:Disconnect() propConn = nil end
        if heartbeatConn then heartbeatConn:Disconnect() heartbeatConn = nil end
        Lighting.ClockTime = TimeChanger.Original
    end

    function TimeChanger.Set(t)
        TimeChanger.Time = t
        if TimeChanger.Enabled then
            Lighting.ClockTime = t
        end
    end

    return TimeChanger
end