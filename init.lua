local BASE = "https://raw.githubusercontent.com/KritProduct/KritHub/main"

local function load(path)
    local url = BASE .. "/" .. path
    local ok, res = pcall(function() return game:HttpGet(url) end)
    if not ok or not res or res == "" then
        warn("[KritHub] fetch failed: " .. url)
        return nil
    end
    if string.byte(res, 1) == 239 then res = string.sub(res, 4) end
    local fn, err = loadstring(res)
    if not fn then
        warn("[KritHub] loadstring error in " .. path .. ": " .. tostring(err))
        return nil
    end
    local ok2, mod = pcall(fn)
    if not ok2 then
        warn("[KritHub] runtime error in " .. path .. ": " .. tostring(mod))
        return nil
    end
    return mod
end

print("[KritHub] loading...")

local Hub = {}
Hub.Theme = load("core/theme.lua")
Hub.State = load("core/state.lua")
Hub.Utils = load("core/utils.lua")

Hub.Features = {}
local aim = load("features/aimbot.lua")
if aim then Hub.Features.Aimbot = aim(Hub) end
local esp = load("features/esp.lua")
if esp then Hub.Features.ESP = esp(Hub) end

Hub.UI = load("ui/main.lua")
if Hub.UI then Hub.UI.Build(Hub) end

print("[KritHub] loaded")
return Hub