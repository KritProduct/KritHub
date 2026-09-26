return function(Hub)
    local Lighting = game:GetService("Lighting")
    local TimeChanger = {}

    TimeChanger.Enabled = false
    TimeChanger.Time = 14
    TimeChanger.Original = Lighting.ClockTime

    function TimeChanger.Enable()
        TimeChanger.Enabled = true
        Lighting.ClockTime = TimeChanger.Time
    end

    function TimeChanger.Disable()
        TimeChanger.Enabled = false
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