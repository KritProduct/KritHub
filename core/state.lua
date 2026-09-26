local State = {}

State.Modules = {}
State.Tabs = {}
State.CurrentTab = "Movement"
State.GUIVisible = true
State.Hub = nil

function State.RegisterModule(name, data)
    State.Modules[name] = data
end

function State.GetModule(name)
    return State.Modules[name]
end

function State.RegisterTab(name, data)
    State.Tabs[name] = data
end

return State
