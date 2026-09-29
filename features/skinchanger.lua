return function(Hub)
    local RS = game:GetService("ReplicatedStorage")

    local SkinChanger = {}
    SkinChanger.Enabled = false
    SkinChanger.SelectedWeapon = nil
    SkinChanger.SelectedSkin = nil
    SkinChanger.SelectedFloat = 0
    SkinChanger.AllSkins = {}
    SkinChanger.AppliedWeapon = nil
    SkinChanger.Hooked = false

    local skinsModule = nil
    local animationModule = nil
    local originalGetCameraModel = nil
    local originalGetWorldModel = nil
    local originalConstruct = nil

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

    local function hookModules()
        if SkinChanger.Hooked then return end
        if not ensureModules() then
            warn("[SkinChanger] cannot load skins module")
            return
        end

        originalGetCameraModel = skinsModule.GetCameraModel
        originalGetWorldModel = skinsModule.GetWorldModel
        originalConstruct = nil

        skinsModule.GetCameraModel = function(weapon, skin, float)
            local result = originalGetCameraModel(weapon, skin, float)

            if SkinChanger.Enabled and SkinChanger.SelectedWeapon and SkinChanger.SelectedSkin then
                if weapon == SkinChanger.SelectedWeapon then
                    local ok, overrideModel = pcall(originalGetCameraModel, weapon, SkinChanger.SelectedSkin, SkinChanger.SelectedFloat or 0)
                    if ok and overrideModel then
                        return overrideModel
                    end
                end
            end

            return result
        end

        skinsModule.GetWorldModel = function(weapon, skin, float)
            local result = originalGetWorldModel(weapon, skin, float)

            if SkinChanger.Enabled and SkinChanger.SelectedWeapon and SkinChanger.SelectedSkin then
                if weapon == SkinChanger.SelectedWeapon then
                    local ok, overrideModel = pcall(originalGetWorldModel, weapon, SkinChanger.SelectedSkin, SkinChanger.SelectedFloat or 0)
                    if ok and overrideModel then
                        return overrideModel
                    end
                end
            end

            return result
        end

        SkinChanger.Hooked = true
        print("[SkinChanger] hooked GetCameraModel and GetWorldModel")
    end

    local function unhookModules()
        if not SkinChanger.Hooked then return end
        if skinsModule and originalGetCameraModel then
            skinsModule.GetCameraModel = originalGetCameraModel
        end
        if skinsModule and originalGetWorldModel then
            skinsModule.GetWorldModel = originalGetWorldModel
        end
        SkinChanger.Hooked = false
        print("[SkinChanger] unhooked")
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

        print("[SkinChanger] applied:", weaponName, "->", skinName, "float:", SkinChanger.SelectedFloat)
        return true
    end

    function SkinChanger.Reset()
        SkinChanger.Enabled = false
        SkinChanger.SelectedWeapon = nil
        SkinChanger.SelectedSkin = nil
        unhookModules()
        print("[SkinChanger] reset")
    end

    function SkinChanger.Enable()
        SkinChanger.Enabled = true
        if not SkinChanger.Hooked then
            hookModules()
        end
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