local BASE = "https://raw.githubusercontent.com/YOUR_USER/YOUR_REPO/main/KritHub"
local USE_GITHUB = false

local function getSource(path)
    if USE_GITHUB then
        return game:HttpGet(BASE .. "/" .. path .. ".lua")
    end
    return nil
end

local folder = script and script.Parent or nil
local function load(path)
    if USE_GITHUB then
        return loadstring(getSource(path))()
    end
    return nil
end

if USE_GITHUB then
    local Hub = {}
    Hub.Theme = load("core/theme")
    Hub.State = load("core/state")
    Hub.Utils = load("core/utils")
    Hub.Input = load("core/input")
    Hub.Window = load("ui/window")
    Hub.Tabs = load("ui/tabs")
    Hub.Module = load("ui/module")
    Hub.Elements = {
        Toggle = load("ui/elements/toggle"),
        Slider = load("ui/elements/slider"),
        Keybind = load("ui/elements/keybind"),
        Dropdown = load("ui/elements/dropdown"),
        ColorPicker = load("ui/elements/colorpicker"),
        Button = load("ui/elements/button"),
    }
    Hub.Features = {
        Aimbot = load("features/aimbot")(Hub),
        ESP = load("features/esp")(Hub),
    }
    Hub.Window.Init(Hub)
    load("tabs/movement")(Hub)
    load("tabs/visuals")(Hub)
    load("tabs/combat")(Hub)
    load("tabs/misc")(Hub)
    Hub.Input.Init(Hub)
    return Hub
else
    local Hub = {
        Theme = _G.KritHub.Theme,
        State = _G.KritHub.State,
        Utils = _G.KritHub.Utils,
        Input = _G.KritHub.Input,
        Window = _G.KritHub.Window,
        Tabs = _G.KritHub.Tabs,
        Module = _G.KritHub.Module,
        Elements = _G.KritHub.Elements,
        Features = _G.KritHub.Features,
    }
    Hub.Window.Init(Hub)
    _G.KritHub.Tabs_movement(Hub)
    _G.KritHub.Tabs_visuals(Hub)
    _G.KritHub.Tabs_combat(Hub)
    _G.KritHub.Tabs_misc(Hub)
    Hub.Input.Init(Hub)
    return Hub
end
