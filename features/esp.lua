return function(Hub)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera

    local ESP = {}
    ESP.Enabled = false
    ESP.Box = true
    ESP.Name = true
    ESP.Health = true
    ESP.Distance = true
    ESP.Line = false
    ESP.Dot = false
    ESP.TeamOnly = false
    ESP.MaxDist = 2000
    ESP.EnemyColor = Color3.fromRGB(255, 60, 60)
    ESP.FriendColor = Color3.fromRGB(60, 255, 60)

    local cache = {}

    local function GetFolder()
        return workspace:FindFirstChild("Characters")
    end

    local function IsAlive(ch)
        if ch:GetAttribute("Dead") == true then return false end
        local hp = ch:GetAttribute("Health")
        if hp and hp <= 0 then return false end
        return ch:FindFirstChild("Head") ~= nil
    end

    local function GetTeam(ch)
        local n = ch:GetAttribute("CharacterName")
        if not n then return nil end
        if n == "Anarchist" or n == "Terrorist" or n == "Rebel" then return "T" end
        if n == "IDF" or n == "SEAL" or n == "SAS" or n == "Counter-Terrorist" then return "CT" end
        return nil
    end

    local function GetMyTeam()
        local me = LocalPlayer.Character
        if not me then return nil end
        return GetTeam(me)
    end

    local function GetDisplayName(ch)
        local charName = ch:GetAttribute("CharacterName")
        if charName and charName ~= "" then
            return charName
        end
        local plr = Players:GetPlayerFromCharacter(ch)
        if plr then
            return plr.DisplayName or plr.Name
        end
        return ch.Name
    end

    local function Create(ch)
        local d = {}
        d.Box = Drawing.new("Square")
        d.Box.Thickness = 1
        d.Box.Filled = false
        d.Box.Visible = false

        d.BoxOutline = Drawing.new("Square")
        d.BoxOutline.Thickness = 3
        d.BoxOutline.Filled = false
        d.BoxOutline.Visible = false

        d.Name = Drawing.new("Text")
        d.Name.Size = 14
        d.Name.Center = true
        d.Name.Outline = true
        d.Name.Visible = false

        d.Distance = Drawing.new("Text")
        d.Distance.Size = 13
        d.Distance.Center = true
        d.Distance.Outline = true
        d.Distance.Visible = false

        d.HealthBg = Drawing.new("Square")
        d.HealthBg.Thickness = 1
        d.HealthBg.Filled = true
        d.HealthBg.Visible = false

        d.HealthBar = Drawing.new("Square")
        d.HealthBar.Thickness = 1
        d.HealthBar.Filled = true
        d.HealthBar.Visible = false

        d.Line = Drawing.new("Line")
        d.Line.Thickness = 1
        d.Line.Visible = false

        d.Dot = Drawing.new("Circle")
        d.Dot.Radius = 3
        d.Dot.Filled = true
        d.Dot.Visible = false

        cache[ch] = d
        return d
    end

    local function Remove(ch)
        local d = cache[ch]
        if not d then return end
        for _, o in pairs(d) do pcall(function() o:Remove() end) end
        cache[ch] = nil
    end

    local function HideAll(d)
        for _, o in pairs(d) do o.Visible = false end
    end

    local function GetBox(ch)
        local head = ch:FindFirstChild("Head")
        local root = ch:FindFirstChild("HumanoidRootPart") or ch:FindFirstChild("UpperTorso")
        if not head or not root then return nil end
        local cam = workspace.CurrentCamera
        if not cam then return nil end

        local hPos = head.Position + Vector3.new(0, 0.7, 0)
        local fPos = root.Position - Vector3.new(0, 3.2, 0)

        local hS, hOn = cam:WorldToViewportPoint(hPos)
        local fS, fOn = cam:WorldToViewportPoint(fPos)
        if not hOn or not fOn then return nil end

        local height = math.abs(fS.Y - hS.Y)
        local width = height * 0.55
        local tl = Vector2.new(hS.X - width / 2, hS.Y)
        return tl, Vector2.new(width, height), hS, fS
    end

    local function GetHealth(ch)
        return ch:GetAttribute("Health") or 0
    end

    local function GetMaxHealth(ch)
        return ch:GetAttribute("MaxHealth") or 100
    end

    local function Update()
        if not ESP.Enabled then
            for _, d in pairs(cache) do HideAll(d) end
            return
        end

        local folder = GetFolder()
        local cam = workspace.CurrentCamera
        if not folder or not cam then return end

        local myTeam = GetMyTeam()
        local myChar = LocalPlayer.Character
        local seen = {}

        for _, ch in ipairs(folder:GetChildren()) do
            if ch:IsA("Model") and ch ~= myChar and IsAlive(ch) then
                seen[ch] = true
                local d = cache[ch] or Create(ch)

                local isFriend = false
                if myTeam then
                    local t = GetTeam(ch)
                    if t == myTeam then isFriend = true end
                end

                if ESP.TeamOnly and not isFriend then
                    HideAll(d)
                else
                    local tl, size, hS, fS = GetBox(ch)
                    if tl and size then
                        local dist = (cam.CFrame.Position - ch:GetPivot().Position).Magnitude
                        if dist <= ESP.MaxDist then
                            local color = isFriend and ESP.FriendColor or ESP.EnemyColor

                            if ESP.Box then
                                d.BoxOutline.Position = tl - Vector2.new(1, 1)
                                d.BoxOutline.Size = size + Vector2.new(2, 2)
                                d.BoxOutline.Color = Color3.fromRGB(0, 0, 0)
                                d.BoxOutline.Visible = true

                                d.Box.Position = tl
                                d.Box.Size = size
                                d.Box.Color = color
                                d.Box.Visible = true
                            else
                                d.Box.Visible = false
                                d.BoxOutline.Visible = false
                            end

                            if ESP.Name then
                                d.Name.Text = GetDisplayName(ch)
                                d.Name.Color = color
                                d.Name.Position = tl + Vector2.new(size.X / 2, -16)
                                d.Name.Visible = true
                            else
                                d.Name.Visible = false
                            end

                            if ESP.Distance then
                                d.Distance.Text = tostring(math.floor(dist / 3)) .. "m"
                                d.Distance.Color = Color3.fromRGB(255, 255, 255)
                                d.Distance.Position = tl + Vector2.new(size.X / 2, size.Y + 2)
                                d.Distance.Visible = true
                            else
                                d.Distance.Visible = false
                            end

                            if ESP.Health then
                                local hp = GetHealth(ch)
                                local maxHp = GetMaxHealth(ch)
                                local frac = math.clamp(hp / maxHp, 0, 1)
                                local bw = 3
                                local bh = size.Y

                                d.HealthBg.Position = tl - Vector2.new(bw + 2, 0)
                                d.HealthBg.Size = Vector2.new(bw, bh)
                                d.HealthBg.Color = Color3.fromRGB(30, 30, 30)
                                d.HealthBg.Visible = true

                                local hpc
                                if frac > 0.6 then hpc = Color3.fromRGB(60, 220, 60)
                                elseif frac > 0.3 then hpc = Color3.fromRGB(240, 200, 40)
                                else hpc = Color3.fromRGB(220, 50, 50) end

                                d.HealthBar.Position = tl - Vector2.new(bw + 2, 0) + Vector2.new(0, bh * (1 - frac))
                                d.HealthBar.Size = Vector2.new(bw, bh * frac)
                                d.HealthBar.Color = hpc
                                d.HealthBar.Visible = true
                            else
                                d.HealthBar.Visible = false
                                d.HealthBg.Visible = false
                            end

                            if ESP.Line then
                                d.Line.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
                                d.Line.To = Vector2.new(tl.X + size.X / 2, tl.Y + size.Y)
                                d.Line.Color = color
                                d.Line.Visible = true
                            else
                                d.Line.Visible = false
                            end

                            if ESP.Dot then
                                d.Dot.Position = Vector2.new(hS.X, hS.Y)
                                d.Dot.Color = color
                                d.Dot.Visible = true
                            else
                                d.Dot.Visible = false
                            end
                        else
                            HideAll(d)
                        end
                    else
                        HideAll(d)
                    end
                end
            end
        end

        for ch, _ in pairs(cache) do
            if not seen[ch] then Remove(ch) end
        end
    end

    RunService.RenderStepped:Connect(function()
        pcall(Update)
    end)

    function ESP.Enable() ESP.Enabled = true end
    function ESP.Disable() ESP.Enabled = false end
    function ESP.Update() Update() end

    return ESP
end