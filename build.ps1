$root = "$env:USERPROFILE\Desktop\KritHub"
$outFile = "$root\out\KritHub.lua"

$order = @(
    "core\theme.lua",
    "core\state.lua",
    "core\utils.lua",
    "core\input.lua",
    "ui\window.lua",
    "ui\tabs.lua",
    "ui\module.lua",
    "ui\elements\toggle.lua",
    "ui\elements\slider.lua",
    "ui\elements\keybind.lua",
    "ui\elements\dropdown.lua",
    "ui\elements\colorpicker.lua",
    "ui\elements\button.lua",
    "features\aimbot.lua",
    "features\esp.lua",
    "tabs\movement.lua",
    "tabs\visuals.lua",
    "tabs\combat.lua",
    "tabs\misc.lua"
)

$sb = New-Object System.Text.StringBuilder

[void]$sb.AppendLine("_G.KritHub = {}")
[void]$sb.AppendLine("local Hub = _G.KritHub")
[void]$sb.AppendLine("")

[void]$sb.AppendLine("Hub.Theme = (function()")
[void]$sb.AppendLine((Get-Content "$root\core\theme.lua" -Raw))
[void]$sb.AppendLine("end)()")
[void]$sb.AppendLine("")

[void]$sb.AppendLine("Hub.State = (function()")
[void]$sb.AppendLine((Get-Content "$root\core\state.lua" -Raw))
[void]$sb.AppendLine("end)()")
[void]$sb.AppendLine("")

[void]$sb.AppendLine("Hub.Utils = (function()")
[void]$sb.AppendLine((Get-Content "$root\core\utils.lua" -Raw))
[void]$sb.AppendLine("end)()")
[void]$sb.AppendLine("")

[void]$sb.AppendLine("Hub.Input = (function()")
[void]$sb.AppendLine((Get-Content "$root\core\input.lua" -Raw))
[void]$sb.AppendLine("end)()")
[void]$sb.AppendLine("")

[void]$sb.AppendLine("Hub.Window = (function()")
[void]$sb.AppendLine((Get-Content "$root\ui\window.lua" -Raw))
[void]$sb.AppendLine("end)()")
[void]$sb.AppendLine("")

[void]$sb.AppendLine("Hub.Tabs = (function()")
[void]$sb.AppendLine((Get-Content "$root\ui\tabs.lua" -Raw))
[void]$sb.AppendLine("end)()")
[void]$sb.AppendLine("")

[void]$sb.AppendLine("Hub.Module = (function()")
[void]$sb.AppendLine((Get-Content "$root\ui\module.lua" -Raw))
[void]$sb.AppendLine("end)()")
[void]$sb.AppendLine("")

[void]$sb.AppendLine("Hub.Elements = {}")
foreach ($el in @("toggle","slider","keybind","dropdown","colorpicker","button")) {
    [void]$sb.AppendLine("Hub.Elements." + ($el.Substring(0,1).ToUpper() + $el.Substring(1)) + " = (function()")
    [void]$sb.AppendLine((Get-Content "$root\ui\elements\$el.lua" -Raw))
    [void]$sb.AppendLine("end)()")
    [void]$sb.AppendLine("")
}

[void]$sb.AppendLine("Hub.Features = {}")
[void]$sb.AppendLine("Hub.Features.Aimbot = (function()")
[void]$sb.AppendLine((Get-Content "$root\features\aimbot.lua" -Raw))
[void]$sb.AppendLine("end)()(Hub)")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("Hub.Features.ESP = (function()")
[void]$sb.AppendLine((Get-Content "$root\features\esp.lua" -Raw))
[void]$sb.AppendLine("end)()(Hub)")
[void]$sb.AppendLine("")

[void]$sb.AppendLine("Hub.Window.Init(Hub)")
[void]$sb.AppendLine("")

foreach ($tab in @("movement","visuals","combat","misc")) {
    [void]$sb.AppendLine("(function()")
    [void]$sb.AppendLine((Get-Content "$root\tabs\$tab.lua" -Raw))
    [void]$sb.AppendLine("end)()(Hub)")
    [void]$sb.AppendLine("")
}

[void]$sb.AppendLine("Hub.Input.Init(Hub)")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("print('[KritHub] loaded')")

New-Item -ItemType Directory -Path "$root\out" -Force | Out-Null
[System.IO.File]::WriteAllText($outFile, $sb.ToString(), [System.Text.UTF8Encoding]::new($false))

Write-Host "Built: $outFile" -ForegroundColor Green
Write-Host "Size: $((Get-Item $outFile).Length) bytes" -ForegroundColor Green
