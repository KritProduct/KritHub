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
local trigger = load("features/triggerbot.lua")
if trigger then Hub.Features.TriggerBot = trigger(Hub) end
local esp = load("features/esp.lua")
if esp then Hub.Features.ESP = esp(Hub) end
local timechanger = load("features/timechanger.lua")
if timechanger then Hub.Features.TimeChanger = timechanger(Hub) end
local fog = load("features/fog.lua")
if fog then Hub.Features.Fog = fog(Hub) end
local cc = load("features/colorcorrection.lua")
if cc then Hub.Features.ColorCorrection = cc(Hub) end
local antiflash = load("features/antiflash.lua")
if antiflash then Hub.Features.AntiFlash = antiflash(Hub) end
local visualsPlayers = load("features/visuals_players.lua")
if visualsPlayers then Hub.Features.VisualsPlayers = visualsPlayers(Hub) end
local rejoin = load("features/rejoin.lua")
if rejoin then Hub.Features.Rejoin = rejoin(Hub) end
local antiafk = load("features/antiafk.lua")
if antiafk then Hub.Features.AntiAFK = antiafk(Hub) end
local xray = load("features/xray.lua")
if xray then Hub.Features.Xray = xray(Hub) end
local watermark = load("features/watermark.lua")
if watermark then Hub.Features.Watermark = watermark(Hub) end
local config = load("features/config.lua")
if config then Hub.Features.Config = config(Hub) end
local weaponmods = load("features/weaponmods.lua")
if weaponmods then Hub.Features.WeaponMods = weaponmods(Hub) end
local grenadeesp = load("features/grenadeesp.lua")
if grenadeesp then Hub.Features.GrenadeESP = grenadeesp(Hub) end
local weather = load("features/weather.lua")
if weather then Hub.Features.Weather = weather(Hub) end
local outdoorcolor = load("features/outdoorcolor.lua")
if outdoorcolor then Hub.Features.OutdoorColor = outdoorcolor(Hub) end
local movement = load("features/movement.lua")
if movement then Hub.Features.Movement = movement(Hub) end

local skinchanger = load("features/skinchanger.lua")
if skinchanger then Hub.Features.SkinChanger = skinchanger(Hub) end

Hub.UI = {}
Hub.UI.Window = load("ui/window.lua")
Hub.UI.Tabs = load("ui/tabs.lua")
Hub.UI.Module = load("ui/module.lua")
Hub.UI.Elements = {
    Toggle = load("ui/elements/toggle.lua"),
    Slider = load("ui/elements/slider.lua"),
    ColorPicker = load("ui/elements/colorpicker.lua"),
    Dropdown = load("ui/elements/dropdown.lua"),
    Button = load("ui/elements/button.lua"),
}
Hub.UI.ConfigWindow = load("ui/configwindow.lua")
Hub.UI.SkinChangerUI = load("ui/skinchangerui.lua")
Hub.UI.Main = load("ui/main.lua")

_G.KritHub = Hub
_G.KritHubConfig = Hub.Features.Config

print("[KritHub] Hub exported to _G.KritHub")

if Hub.UI.Main then Hub.UI.Main.Build(Hub) end

print("[KritHub] loaded")
return Hub