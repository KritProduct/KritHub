local BASE = "https://raw.githubusercontent.com/KritProduct/KritHub/main"

local function load(path)
    local url = BASE .. "/" .. path
    local ok, res = pcall(function()
        return game:HttpGet(url)
    end)
    if not ok or not res or res == "" then
        warn("[KritHub] fetch failed: " .. url)
        return nil
    end
    if string.byte(res, 1) == 239 then
        res = string.sub(res, 4)
    end
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

print("[KritHub] downloading modules...")

local Hub = {}

Hub.Theme = load("core/theme.lua")
Hub.State = load("core/state.lua")
Hub.Utils = load("core/utils.lua")
Hub.Input = load("core/input.lua")
Hub.Window = load("ui/window.lua")
Hub.Tabs = load("ui/tabs.lua")
Hub.Module = load("ui/module.lua")

Hub.Elements = {
    Toggle = load("ui/elements/toggle.lua"),
    Slider = load("ui/elements/slider.lua"),
    Keybind = load("ui/elements/keybind.lua"),
    Dropdown = load("ui/elements/dropdown.lua"),
    ColorPicker = load("ui/elements/colorpicker.lua"),
    Button = load("ui/elements/button.lua"),
}

Hub.Features = {}

local aimbotLoader = load("features/aimbot.lua")
if aimbotLoader then Hub.Features.Aimbot = aimbotLoader(Hub) end

local espLoader = load("features/esp.lua")
if espLoader then Hub.Features.ESP = espLoader(Hub) end

if Hub.Window and Hub.Window.Init then
    Hub.Window.Init(Hub)
end

local movTab = load("tabs/movement.lua")
if movTab then movTab(Hub) end

local visTab = load("tabs/visuals.lua")
if visTab then visTab(Hub) end

local cmbTab = load("tabs/combat.lua")
if cmbTab then cmbTab(Hub) end

local miscTab = load("tabs/misc.lua")
if miscTab then miscTab(Hub) end

if Hub.Input and Hub.Input.Init then
    Hub.Input.Init(Hub)
end

print("[KritHub] loaded")
return Hub