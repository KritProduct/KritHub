return function(Hub)
    local Config = {}
    Config.Folder = "KritHub_Configs"
    Config.Extension = ".json"

    local function ensureFolder()
        if not isfolder or not makefolder then return false end
        if not isfolder(Config.Folder) then
            pcall(makefolder, Config.Folder)
        end
        return true
    end

    local function hasApi()
        return writefile and readfile and isfile and listfiles and delfile
    end

    local function collectSettings()
        local data = {}
        data.Modules = {}

        for name, mod in pairs(Hub.State.Modules) do
            local modData = {
                Enabled = mod.Enabled,
                Bind = nil,
                Elements = {},
            }

            if mod.Bind then
                if typeof(mod.Bind) == "EnumItem" then
                    modData.Bind = mod.Bind.Name
                else
                    modData.Bind = tostring(mod.Bind)
                end
            end

            if mod.ElementsByName then
                for elName, el in pairs(mod.ElementsByName) do
                    if el.Type ~= "button" then
                        local val
                        if el.Get then
                            val = el:Get()
                        else
                            val = el.Value
                        end
                        if typeof(val) == "Color3" then
                            modData.Elements[elName] = {
                                _type = "Color3",
                                R = val.R,
                                G = val.G,
                                B = val.B,
                            }
                        else
                            modData.Elements[elName] = val
                        end
                    end
                end
            end

            data.Modules[name] = modData
        end

        local A = Hub.Features.Aimbot
        if A then
            data.Aimbot = {
                FOV = A.FOV, Speed = A.Speed, TargetPart = A.TargetPart,
                WallCheck = A.WallCheck, FriendCheck = A.FriendCheck, DrawFOV = A.DrawFOV,
            }
        end

        local T = Hub.Features.TriggerBot
        if T then
            data.TriggerBot = {
                NoFriendDamage = T.NoFriendDamage, WallCheck = T.WallCheck,
                TargetMode = T.TargetMode, ShotDelay = T.ShotDelay,
            }
        end

        local E = Hub.Features.ESP
        if E then
            data.ESP = {
                Box = E.Box, Name = E.Name, Health = E.Health,
                Distance = E.Distance, Line = E.Line, MaxDist = E.MaxDist,
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
            data.Fog = { Density = F.Density, Haze = F.Haze, Glare = F.Glare, Offset = F.Offset }
        end

        local CC = Hub.Features.ColorCorrection
        if CC then
            data.ColorCorrection = { Brightness = CC.Brightness, Contrast = CC.Contrast, Saturation = CC.Saturation }
        end

        local W = Hub.Features.Watermark
        if W then
            data.Watermark = {
                ShowFPS = W.ShowFPS, ShowPing = W.ShowPing,
                ShowTime = W.ShowTime, ShowUsername = W.ShowUsername,
            }
        end

        local AFK = Hub.Features.AntiAFK
        if AFK then
            data.AntiAFK = {
                Interval = AFK.Interval, DoRotate = AFK.DoRotate,
                DoJump = AFK.DoJump, DoClick = AFK.DoClick,
            }
        end

        local X = Hub.Features.Xray
        if X then
            data.Xray = { Transparency = X.Transparency }
        end

        return data
    end

    local function applyModuleData(data)
        if not data or not data.Modules then return end

        for modName, modData in pairs(data.Modules) do
            local mod = Hub.State.Modules[modName]
            if mod then
                if modData.Bind then
                    if modData.Bind == "LMB" or modData.Bind == "RMB" then
                        mod.Bind = modData.Bind
                    else
                        local ok, keyCode = pcall(function() return Enum.KeyCode[modData.Bind] end)
                        if ok and keyCode then mod.Bind = keyCode end
                    end
                    if mod.SetBindDisplay then
                        mod.SetBindDisplay(modData.Bind)
                    end
                end

                if modData.Elements and mod.ElementsByName then
                    for elName, val in pairs(modData.Elements) do
                        local el = mod.ElementsByName[elName]
                        if el and el.Set then
                            if type(val) == "table" and val._type == "Color3" then
                                pcall(function() el:Set(Color3.new(val.R, val.G, val.B), false) end)
                            else
                                pcall(function() el:Set(val, false) end)
                            end
                        end
                    end
                end

                if modData.Enabled ~= nil and mod.SetEnabled then
                    pcall(function() mod.SetEnabled(modData.Enabled, false) end)
                end
            end
        end
    end

    local function applySettings(data)
        if not data then return end

        if data.Aimbot and Hub.Features.Aimbot then
            local A, d = Hub.Features.Aimbot, data.Aimbot
            if d.FOV then A.FOV = d.FOV end
            if d.Speed then A.Speed = d.Speed end
            if d.TargetPart then A.TargetPart = d.TargetPart end
            if d.WallCheck ~= nil then A.WallCheck = d.WallCheck end
            if d.FriendCheck ~= nil then A.FriendCheck = d.FriendCheck end
            if d.DrawFOV ~= nil then A.DrawFOV = d.DrawFOV end
        end

        if data.TriggerBot and Hub.Features.TriggerBot then
            local T, d = Hub.Features.TriggerBot, data.TriggerBot
            if d.NoFriendDamage ~= nil then T.NoFriendDamage = d.NoFriendDamage end
            if d.WallCheck ~= nil then T.WallCheck = d.WallCheck end
            if d.TargetMode then T.TargetMode = d.TargetMode end
            if d.ShotDelay then T.ShotDelay = d.ShotDelay end
        end

        if data.ESP and Hub.Features.ESP then
            local E, d = Hub.Features.ESP, data.ESP
            if d.Box ~= nil then E.Box = d.Box end
            if d.Name ~= nil then E.Name = d.Name end
            if d.Health ~= nil then E.Health = d.Health end
            if d.Distance ~= nil then E.Distance = d.Distance end
            if d.Line ~= nil then E.Line = d.Line end
            if d.MaxDist then E.MaxDist = d.MaxDist end
        end

        if data.VisualsPlayers and Hub.Features.VisualsPlayers then
            local V, d = Hub.Features.VisualsPlayers, data.VisualsPlayers
            if d.ChamsThroughWalls ~= nil then V.ChamsThroughWalls = d.ChamsThroughWalls end
            if d.ChamsFillTransparency then V.ChamsFillTransparency = d.ChamsFillTransparency end
            if d.SkeletonThroughWalls ~= nil then V.SkeletonThroughWalls = d.SkeletonThroughWalls end
        end

        if data.Fog and Hub.Features.Fog then
            local F, d = Hub.Features.Fog, data.Fog
            if d.Density then F.Density = d.Density end
            if d.Haze then F.Haze = d.Haze end
            if d.Glare then F.Glare = d.Glare end
            if d.Offset then F.Offset = d.Offset end
        end

        if data.ColorCorrection and Hub.Features.ColorCorrection then
            local CC, d = Hub.Features.ColorCorrection, data.ColorCorrection
            if d.Brightness then CC.Brightness = d.Brightness end
            if d.Contrast then CC.Contrast = d.Contrast end
            if d.Saturation then CC.Saturation = d.Saturation end
        end

        if data.Watermark and Hub.Features.Watermark then
            local W, d = Hub.Features.Watermark, data.Watermark
            if d.ShowFPS ~= nil then W.ShowFPS = d.ShowFPS end
            if d.ShowPing ~= nil then W.ShowPing = d.ShowPing end
            if d.ShowTime ~= nil then W.ShowTime = d.ShowTime end
            if d.ShowUsername ~= nil then W.ShowUsername = d.ShowUsername end
        end

        if data.AntiAFK and Hub.Features.AntiAFK then
            local AFK, d = Hub.Features.AntiAFK, data.AntiAFK
            if d.Interval then AFK.Interval = d.Interval end
            if d.DoRotate ~= nil then AFK.DoRotate = d.DoRotate end
            if d.DoJump ~= nil then AFK.DoJump = d.DoJump end
            if d.DoClick ~= nil then AFK.DoClick = d.DoClick end
        end

        if data.Xray and Hub.Features.Xray then
            local X, d = Hub.Features.Xray, data.Xray
            if d.Transparency then X.Transparency = d.Transparency end
        end

        applyModuleData(data)
    end

    function Config.Save(name)
        if not hasApi() then
            warn("[KritHub] file api not supported")
            return false
        end

        ensureFolder()

        if not name or name == "" then
            name = "default"
        end

        local path = Config.Folder .. "/" .. name .. Config.Extension
        local data = collectSettings()

        local ok, encoded = pcall(function()
            return game:GetService("HttpService"):JSONEncode(data)
        end)

        if ok and encoded then
            local ok2 = pcall(writefile, path, encoded)
            if ok2 then
                print("[KritHub] config saved: " .. path)
                return true
            end
        end
        return false
    end

    function Config.Load(name)
        if not hasApi() then
            warn("[KritHub] file api not supported")
            return false
        end

        local path = Config.Folder .. "/" .. name .. Config.Extension
        if not isfile(path) then
            warn("[KritHub] config not found: " .. path)
            return false
        end

        local ok, content = pcall(readfile, path)
        if not ok or not content then return false end

        local ok2, decoded = pcall(function()
            return game:GetService("HttpService"):JSONDecode(content)
        end)

        if ok2 and decoded then
            applySettings(decoded)
            print("[KritHub] config loaded: " .. name)
            return true
        end
        return false
    end

    function Config.Delete(name)
        if not hasApi() then return false end
        local path = Config.Folder .. "/" .. name .. Config.Extension
        if isfile(path) then
            pcall(delfile, path)
            print("[KritHub] config deleted: " .. name)
            return true
        end
        return false
    end

    function Config.List()
        if not hasApi() then return {} end
        ensureFolder()

        local files = {}
        local ok, listed = pcall(listfiles, Config.Folder)
        if not ok or not listed then return files end

        for _, path in ipairs(listed) do
            local name = path:match("([^/\\]+)" .. Config.Extension .. "$")
            if name then
                table.insert(files, name)
            end
        end
        return files
    end

    function Config.HasApi()
        return hasApi() and true or false
    end

    return Config
end