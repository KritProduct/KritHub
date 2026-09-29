return function(Hub)
    local RS = game:GetService("ReplicatedStorage")

    local SkinChanger = {}
    SkinChanger.Enabled = false
    SkinChanger.SelectedWeapon = nil
    SkinChanger.SelectedSkin = nil
    SkinChanger.SelectedFloat = 0
    SkinChanger.Hooked = false
    SkinChanger.LoopConn = nil

    local function getSkinsRoot()
        local assets = RS:FindFirstChild("Assets")
        if not assets then return nil end
        return assets:FindFirstChild("Skins")
    end

    local function getCurrentWeaponModel()
        local cam = workspace:FindFirstChild("Camera")
        if not cam then return nil end
        for _, obj in ipairs(cam:GetChildren()) do
            if obj:IsA("Model") then
                return obj
            end
        end
        return nil
    end

    function SkinChanger.GetCurrentWeaponName()
        local m = getCurrentWeaponModel()
        return m and m.Name or nil
    end

    function SkinChanger.GetAllWeapons()
        local skinsRoot = getSkinsRoot()
        if not skinsRoot then return {} end
        local list = {}
        for _, w in ipairs(skinsRoot:GetChildren()) do
            table.insert(list, w.Name)
        end
        return list
    end

    function SkinChanger.GetSkinsForWeapon(weaponName)
        local skinsRoot = getSkinsRoot()
        if not skinsRoot then return {} end
        local weaponFolder = skinsRoot:FindFirstChild(weaponName)
        if not weaponFolder then return {} end
        local list = {}
        for _, s in ipairs(weaponFolder:GetChildren()) do
            table.insert(list, { Name = s.Name })
        end
        return list
    end

    local function applySkinToCurrentModel()
        if not SkinChanger.Enabled then return end
        if not SkinChanger.SelectedWeapon or not SkinChanger.SelectedSkin then return end

        local currentModel = getCurrentWeaponModel()
        if not currentModel then return end
        if currentModel.Name ~= SkinChanger.SelectedWeapon then return end

        local skinsRoot = getSkinsRoot()
        if not skinsRoot then return end

        local weaponFolder = skinsRoot:FindFirstChild(SkinChanger.SelectedWeapon)
        if not weaponFolder then return end

        local skinFolder = weaponFolder:FindFirstChild(SkinChanger.SelectedSkin)
        if not skinFolder then return end

        local cameraFolder = skinFolder:FindFirstChild("Camera")
        if not cameraFolder then return end

        local factoryNew = cameraFolder:FindFirstChild("Factory New") or cameraFolder:GetChildren()[1]
        if not factoryNew then return end

        local applied = 0

        for _, sa in ipairs(factoryNew:GetChildren()) do
            if sa:IsA("SurfaceAppearance") then
                local targetPart = currentModel:FindFirstChild(sa.Name, true)
                if targetPart and (targetPart:IsA("BasePart") or targetPart:IsA("MeshPart")) then
                    for _, old in ipairs(targetPart:GetChildren()) do
                        if old:IsA("SurfaceAppearance") then
                            old:Destroy()
                        end
                    end
                    sa:Clone().Parent = targetPart
                    applied = applied + 1
                end
            end
        end

        print("[SkinChanger] applied " .. applied .. " parts to " .. currentModel.Name)
    end

    SkinChanger.Reapply = applySkinToCurrentModel

    function SkinChanger.Apply(weaponName, skinName, float)
        if not weaponName or not skinName then return false end

        SkinChanger.SelectedWeapon = weaponName
        SkinChanger.SelectedSkin = skinName
        SkinChanger.SelectedFloat = float or 0
        SkinChanger.Enabled = true

        task.defer(applySkinToCurrentModel)

        print("[SkinChanger] applied: " .. weaponName .. " -> " .. skinName)
        return true
    end

    function SkinChanger.Reset()
        SkinChanger.Enabled = false
        SkinChanger.SelectedWeapon = nil
        SkinChanger.SelectedSkin = nil
        print("[SkinChanger] reset")
    end

    function SkinChanger.Enable()
        SkinChanger.Enabled = true
        task.defer(applySkinToCurrentModel)
    end

    function SkinChanger.Disable()
        SkinChanger.Enabled = false
    end

    function SkinChanger.GetStatus()
        return {
            Enabled = SkinChanger.Enabled,
            Weapon = SkinChanger.SelectedWeapon,
            Skin = SkinChanger.SelectedSkin,
        }
    end

    task.spawn(function()
        while true do
            pcall(function()
                if SkinChanger.Enabled then
                    applySkinToCurrentModel()
                end
            end)
            task.wait(0.5)
        end
    end)

    return SkinChanger
end