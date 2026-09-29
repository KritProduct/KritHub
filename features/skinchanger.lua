return function(Hub)
    local RS = game:GetService("ReplicatedStorage")

    local SkinChanger = {}
    SkinChanger.Enabled = false
    SkinChanger.SelectedWeapon = nil
    SkinChanger.SelectedSkin = nil
    SkinChanger.SelectedFloat = 0
    SkinChanger.AllSkins = {}
    SkinChanger.Hooked = false
    SkinChanger.OriginalModules = {}
    SkinChanger.ReapplyConn = nil

    local skinsModule = nil

    local function ensureModules()
        if skinsModule then return true end
        local ok, result = pcall(function()
            return require(RS.Database.Components.Libraries.Skins)
        end)
        if ok and result then
            skinsModule = result
        end
        return skinsModule ~= nil
    end

    function SkinChanger.GetAllWeapons()
        if not ensureModules() then return {} end
        local list = {}
        for _, w in ipairs(RS.Database.Custom.Weapons:GetChildren()) do
            if w:IsA("ModuleScript") then
                table.insert(list, w.Name)
            end
        end
        return list
    end

    function SkinChanger.GetSkinsForWeapon(weaponName)
        if not ensureModules() then return {} end
        local ok, list = pcall(skinsModule.GetAllSkinsForWeapon, weaponName)
        if not ok or not list then return {} end
        local result = {}
        for _, s in ipairs(list) do
            if s.skin then
                table.insert(result, {
                    Name = s.skin,
                    Rarity = s.rarity,
                    Collection = s.collection,
                    PaintId = s.paintId,
                    Description = s.description,
                })
            end
        end
        return result
    end

    function SkinChanger.GetCurrentWeaponName()
        local cam = workspace:FindFirstChild("Camera")
        if not cam then return nil end
        for _, obj in ipairs(cam:GetChildren()) do
            if obj:IsA("Model") then
                return obj.Name
            end
        end
        return nil
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

    local function getSkinsRoot()
        local assets = RS:FindFirstChild("Assets")
        if not assets then return nil end
        return assets:FindFirstChild("Skins")
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

        local factoryNew = cameraFolder:FindFirstChild("Factory New")
        if not factoryNew then
            factoryNew = cameraFolder:GetChildren()[1]
        end
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

        print("[SkinChanger] applied " .. applied .. " SurfaceAppearance(s) to " .. currentModel.Name)
    end

    SkinChanger.Reapply = applySkinToCurrentModel

    local function hookModules()
        if SkinChanger.Hooked then return end
        if not ensureModules() then
            warn("[SkinChanger] cannot load skins module")
            return
        end

        SkinChanger.OriginalModules.GetCameraModel = skinsModule.GetCameraModel
        SkinChanger.OriginalModules.GetWorldModel = skinsModule.GetWorldModel

        skinsModule.GetCameraModel = function(weapon, skin, float)
            if SkinChanger.Enabled and SkinChanger.SelectedWeapon and SkinChanger.SelectedSkin then
                if weapon == SkinChanger.SelectedWeapon then
                    local ok, overrideModel = pcall(SkinChanger.OriginalModules.GetCameraModel, weapon, SkinChanger.SelectedSkin, SkinChanger.SelectedFloat or 0)
                    if ok and overrideModel then
                        return overrideModel
                    end
                end
            end
            return SkinChanger.OriginalModules.GetCameraModel(weapon, skin, float)
        end

        skinsModule.GetWorldModel = function(weapon, skin, float)
            if SkinChanger.Enabled and SkinChanger.SelectedWeapon and SkinChanger.SelectedSkin then
                if weapon == SkinChanger.SelectedWeapon then
                    local ok, overrideModel = pcall(SkinChanger.OriginalModules.GetWorldModel, weapon, SkinChanger.SelectedSkin, SkinChanger.SelectedFloat or 0)
                    if ok and overrideModel then
                        return overrideModel
                    end
                end
            end
            return SkinChanger.OriginalModules.GetWorldModel(weapon, skin, float)
        end

        SkinChanger.Hooked = true
        print("[SkinChanger] hooked GetCameraModel and GetWorldModel")
    end

    local function unhookModules()
        if not SkinChanger.Hooked then return end
        if skinsModule and SkinChanger.OriginalModules.GetCameraModel then
            skinsModule.GetCameraModel = SkinChanger.OriginalModules.GetCameraModel
        end
        if skinsModule and SkinChanger.OriginalModules.GetWorldModel then
            skinsModule.GetWorldModel = SkinChanger.OriginalModules.GetWorldModel
        end
        SkinChanger.Hooked = false
        print("[SkinChanger] unhooked")
    end

    local function setupReapply()
        if SkinChanger.ReapplyConn then return end
        local cam = workspace:FindFirstChild("Camera")
        if not cam then return end

        SkinChanger.ReapplyConn = cam.ChildAdded:Connect(function(child)
            if not SkinChanger.Enabled then return end
            if not child:IsA("Model") then return end
            task.wait(0.1)
            pcall(applySkinToCurrentModel)
        end)
        print("[SkinChanger] re-apply hook installed")
    end

    function SkinChanger.Apply(weaponName, skinName, float)
        if not weaponName or not skinName then return false end

        SkinChanger.SelectedWeapon = weaponName
        SkinChanger.SelectedSkin = skinName
        SkinChanger.SelectedFloat = float or 0
        SkinChanger.Enabled = true

        if not SkinChanger.Hooked then
            hookModules()
        end

        setupReapply()

        task.defer(applySkinToCurrentModel)

        print("[SkinChanger] applied: " .. weaponName .. " -> " .. skinName .. " float: " .. tostring(SkinChanger.SelectedFloat))
        return true
    end

    function SkinChanger.Reset()
        SkinChanger.Enabled = false
        SkinChanger.SelectedWeapon = nil
        SkinChanger.SelectedSkin = nil
        unhookModules()
        if SkinChanger.ReapplyConn then
            SkinChanger.ReapplyConn:Disconnect()
            SkinChanger.ReapplyConn = nil
        end
        print("[SkinChanger] reset")
    end

    function SkinChanger.Enable()
        SkinChanger.Enabled = true
        if not SkinChanger.Hooked then hookModules() end
        setupReapply()
        task.defer(applySkinToCurrentModel)
    end

    function SkinChanger.Disable()
        SkinChanger.Enabled = false
    end

    function SkinChanger.GetStatus()
        return {
            Hooked = SkinChanger.Hooked,
            Enabled = SkinChanger.Enabled,
            Weapon = SkinChanger.SelectedWeapon,
            Skin = SkinChanger.SelectedSkin,
            Float = SkinChanger.SelectedFloat,
        }
    end

    return SkinChanger
end