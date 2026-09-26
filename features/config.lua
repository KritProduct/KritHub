return function(Hub)
    local Config = {}
    Config.File = "KritHub_config.json"

    local function hasFileApi()
        return writefile and readfile and isfile
    end

    local function collectSettings()
        local data = {}

        local A = Hub.Features.Aimbot
        if A then
            data.Aimbot = {
                FOV = A.FOV,
                Speed = A.Speed,
                TargetPart = A.TargetPart,
                WallCheck = A.WallCheck,
                FriendCheck = A.FriendCheck,
                DrawFOV = A.DrawFOV,
            }
        end

        local T = Hub.Features.TriggerBot
        if T then
            data.TriggerBot = {
                NoFriendDamage = T.NoFriendDamage,
                WallCheck = T.WallCheck,
                TargetMode = T.TargetMode,
                ShotDelay = T.ShotDelay,
            }
        end

        local E = Hub.Features.ESP
        if E then
            data.ESP = {
                Box = E.Box,
                Name = E.Name,
                Health = E.Health,
                Distance = E.Distance,
                Line = E.Line,
                MaxDist = E.MaxDist,
            }
        end

        local V = Hub.Features.VisualsPlayers
        if V then
            data.VisualsPlayers = {
                ChamsThroughWalls = V.ChamsThroughWalls,
                ChamsFillTransparency = V.ChamsFillTransparency,
                SkeletonThroughWalls = V.SkeletonThroughWalls,
            }
        end

        local F = Hub.Features.Fog
        if F then
            data.Fog = {
                Density = F.Density,
                Haze = F.Haze,
                Glare = F.Glare,
                Offset = F.Offset,
            }
        end

        local CC = Hub.Features.ColorCorrection
        if CC then
            data.ColorCorrection = {
                Brightness = CC.Brightness,
                Contrast = CC.Contrast,
                Saturation = CC.Saturation,
            }
        end

        local W = Hub.Features.Watermark
        if W then
            data.Watermark = {
                ShowFPS = W.ShowFPS,
                ShowPing = W.ShowPing,
                ShowTime = W.ShowTime,
                ShowUsername = W.ShowUsername,
            }
        end

        local AFK = Hub.Features.AntiAFK
        if AFK then
            data.AntiAFK = {
                Interval = AFK.Interval,
                DoRotate = AFK.DoRotate,
                DoJump = AFK.DoJump,
                DoClick = AFK.DoClick,
            }
        end

        return data
    end

    local function applySettings(data)
        if not data then return end

        if data.Aimbot and Hub.Features.Aimbot then
            local A = Hub.Features.Aimbot
            local d = data.Aimbot
            if d.FOV then A.FOV = d.FOV end
            if d.Speed then A.Speed = d.Speed end
            if d.TargetPart then A.TargetPart = d.TargetPart end
            if d.WallCheck ~= nil then A.WallCheck = d.WallCheck end
            if d.FriendCheck ~= nil then A.FriendCheck = d.FriendCheck end
            if d.DrawFOV ~= nil then A.DrawFOV = d.DrawFOV end
        end

        if data.TriggerBot and Hub.Features.TriggerBot then
            local T = Hub.Features.TriggerBot
            local d = data.TriggerBot
            if d.NoFriendDamage ~= nil then T.NoFriendDamage = d.NoFriendDamage end
            if d.WallCheck ~= nil then T.WallCheck = d.WallCheck end
            if d.TargetMode then T.TargetMode = d.TargetMode end
            if d.ShotDelay then T.ShotDelay = d.ShotDelay end
        end

        if data.ESP and Hub.Features.ESP then
            local E = Hub.Features.ESP
            local d = data.ESP
            if d.Box ~= nil then E.Box = d.Box end
            if d.Name ~= nil then E.Name = d.Name end
            if d.Health ~= nil then E.Health = d.Health end
            if d.Distance ~= nil then E.Distance = d.Distance end
            if d.Line ~= nil then E.Line = d.Line end
            if d.MaxDist then E.MaxDist = d.MaxDist end
        end

        if data.VisualsPlayers and Hub.Features.VisualsPlayers then
            local V = Hub.Features.VisualsPlayers
            local d = data.VisualsPlayers
            if d.ChamsThroughWalls ~= nil then V.ChamsThroughWalls = d.ChamsThroughWalls end
            if d.ChamsFillTransparency then V.ChamsFillTransparency = d.ChamsFillTransparency end
            if d.SkeletonThroughWalls ~= nil then V.SkeletonThroughWalls = d.SkeletonThroughWalls end
        end

        if data.Fog and Hub.Features.Fog then
            local F = Hub.Features.Fog
            local d = data.Fog
            if d.Density then F.Density = d.Density end
            if d.Haze then F.Haze = d.Haze end
            if d.Glare then F.Glare = d.Glare end
            if d.Offset then F.Offset = d.Offset end
        end

        if data.ColorCorrection and Hub.Features.ColorCorrection then
            local CC = Hub.Features.ColorCorrection
            local d = data.ColorCorrection
            if d.Brightness then CC.Brightness = d.Brightness end
            if d.Contrast then CC.Contrast = d.Contrast end
            if d.Saturation then CC.Saturation = d.Saturation end
        end

        if data.Watermark and Hub.Features.Watermark then
            local W = Hub.Features.Watermark
            local d = data.Watermark
            if d.ShowFPS ~= nil then W.ShowFPS = d.ShowFPS end
            if d.ShowPing ~= nil then W.ShowPing = d.ShowPing end
            if d.ShowTime ~= nil then W.ShowTime = d.ShowTime end
            if d.ShowUsername ~= nil then W.ShowUsername = d.ShowUsername end
        end

        if data.AntiAFK and Hub.Features.AntiAFK then
            local AFK = Hub.Features.AntiAFK
            local d = data.AntiAFK
            if d.Interval then AFK.Interval = d.Interval end
            if d.DoRotate ~= nil then AFK.DoRotate = d.DoRotate end
            if d.DoJump ~= nil then AFK.DoJump = d.DoJump end
            if d.DoClick ~= nil then AFK.DoClick = d.DoClick end
        end
    end

    function Config.Save()
        if not hasFileApi() then
            warn("[KritHub] writefile not supported")
            return
        end

        local data = collectSettings()
        local ok, encoded = pcall(function()
            return game:GetService("HttpService"):JSONEncode(data)
        end)

        if ok and encoded then
            pcall(writefile, Config.File, encoded)
            print("[KritHub] config saved to " .. Config.File)
        end
    end

    function Config.Load()
        if not hasFileApi() then
            warn("[KritHub] readfile not supported")
            return
        end

        if not isfile(Config.File) then
            warn("[KritHub] config file not found")
            return
        end

        local ok, content = pcall(readfile, Config.File)
        if not ok or not content then return end

        local ok2, decoded = pcall(function()
            return game:GetService("HttpService"):JSONDecode(content)
        end)

        if ok2 and decoded then
            applySettings(decoded)
            print("[KritHub] config loaded from " .. Config.File)
        end
    end

    function Config.Delete()
        if not hasFileApi() then return end
        if isfile(Config.File) then
            pcall(delfile, Config.File)
            print("[KritHub] config deleted")
        end
    end

    return Config
end