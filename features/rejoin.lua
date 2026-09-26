return function(Hub)
    local Players = game:GetService("Players")
    local TeleportService = game:GetService("TeleportService")
    local Rejoin = {}

    Rejoin.Enabled = false

    function Rejoin.DoRejoin()
        local placeId = game.PlaceId
        local jobId = game.JobId

        if jobId and jobId ~= "" then
            pcall(function()
                TeleportService:TeleportToPlaceInstance(placeId, jobId, Players.LocalPlayer)
            end)
        else
            pcall(function()
                TeleportService:Teleport(placeId, Players.LocalPlayer)
            end)
        end
    end

    function Rejoin.Enable()
        Rejoin.Enabled = true
        Rejoin.DoRejoin()
    end

    function Rejoin.Disable()
        Rejoin.Enabled = false
    end

    return Rejoin
end