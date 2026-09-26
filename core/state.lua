local State = {}
State.GUIVisible = true
State.CurrentTab = "Combat"
State.Tabs = {}
State.Modules = {}
function State.RegisterTab(name, data) State.Tabs[name] = data end
function State.RegisterModule(name, data) State.Modules[name] = data end
return State