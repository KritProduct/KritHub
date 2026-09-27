return function(Hub)
    local RS = game:GetService("ReplicatedStorage")
    local SkinChanger = {}

    SkinChanger.Enabled = false
    SkinChanger.AutoApply = true
    SkinChanger.SelectedWeapon = nil
    SkinChanger.SelectedSkin = nil
    SkinChanger.SelectedCondition = "Factory New"
    SkinChanger.OriginalSkins = {}

    local camConn = nil

    local function GetSkinsFolder()
        local assets = RS:FindFirstChild("Assets")
        if not assets then return nil end
        return assets:FindFirstChild("Skins")
    end

    function SkinChanger.GetWeapons()
        local skins = GetSkinsFolder()
        if not skins then return {} end
        local list = {}
        for _, w in ipairs(skins:GetChildren()) do
            table.insert(list, w.Name)
        end
        return list
    end

    function SkinChanger.GetSkinsForWeapon(weaponName)
        local skins = GetSkinsFolder()
        if not skins then return {} end
        local weapon = skins:FindFirstChild(weaponName)
        if not weapon then return {} end
        local list = {}
        for _, s in ipairs(weapon:GetChildren()) do
            table.insert(list, s.Name)
        end
        return list
    end

    function SkinChanger.GetConditions(weaponName, skinName)
        local skins = GetSkinsFolder()
        if not skins then return {} end
        local weapon = skins:FindFirstChild(weaponName)
        if not weapon then return {} end
        local skin = weapon:FindFirstChild(skinName)
        if not skin then return {} end
        local view = skin:FindFirstChild("Camera")
        if not view then return {} end
        local list = {}
        for _, c in ipairs(view:GetChildren()) do
            table.insert(list, c.Name)
        end
        return list
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

    function SkinChanger.GetCurrentWeaponModel()
        local cam = workspace:FindFirstChild("Camera")
        if not cam then return nil end
        for _, obj in ipairs(cam:GetChildren()) do
            if obj:IsA("Model") then
                return obj
            end
        end
        return nil
    end

    function SkinChanger.GetSkinModel(weaponName, skinName, condition)
        local skins = GetSkinsFolder()
        if not skins then return nil end
        local weapon = skins:FindFirstChild(weaponName)
        if not weapon then return nil end
        local skin = weapon:FindFirstChild(skinName)
        if not skin then return nil end
        local view = skin:FindFirstChild("Camera")
        if not view then return nil end
        local cond = view:FindFirstChild(condition)
        if not cond then
            return view:GetChildren()[1]
        end
        return cond
    end

    local function SaveOriginal(weaponModel)
        if SkinChanger.OriginalSkins[weaponModel] then return end
        local saved = {}
        local weaponFolder = weaponModel:FindFirstChild("Weapon")
        if not weaponFolder then return end
        local inner = weaponFolder:FindFirstChildOfClass("Model")
        if not inner then return end

        for _, part in ipairs(inner:GetDescendants()) do
            if part:IsA("SurfaceAppearance") then
                saved[part] = {
                    ColorMap = part.ColorMap,
                    NormalMap = part.NormalMap,
                    RoughnessMap = part.RoughnessMap,
                    MetalnessMap = part.MetalnessMap,
                }
            end
        end
        SkinChanger.OriginalSkins[weaponModel] = saved
    end

    function SkinChanger.Apply(weaponName, skinName, condition)
        if not weaponName or not skinName then
            print("[SkinChanger] missing weapon or skin name")
            return false
        end

        local weaponModel = SkinChanger.GetCurrentWeaponModel()
        if not weaponModel then
            print("[SkinChanger] no weapon in workspace.Camera")
            return false
        end

        print("[SkinChanger] current weapon model:", weaponModel.Name, "| requested:", weaponName)

        if weaponModel.Name ~= weaponName then
            print("[SkinChanger] weapon mismatch: in hands=" .. weaponModel.Name .. ", requested=" .. weaponName)
            return false
        end

        local skinData = SkinChanger.GetSkinModel(weaponName, skinName, condition or "Factory New")
        if not skinData then
            print("[SkinChanger] skin model not found:", weaponName, skinName, condition)
            return false
        end

        SaveOriginal(weaponModel)

        local weaponFolder = weaponModel:FindFirstChild("Weapon")
        if not weaponFolder then
            print("[SkinChanger] no Weapon folder")
            return false
        end

        local inner = weaponFolder:FindFirstChildOfClass("Model")
        if not inner then
            print("[SkinChanger] no inner model")
            return false
        end

        local appliedCount = 0
        local missing = {}

        for _, part in ipairs(inner:GetDescendants()) do
            if part:IsA("SurfaceAppearance") then
                local skinPart = skinData:FindFirstChild(part.Name)
                if skinPart then
                    local skinSA = skinPart:FindFirstChildOfClass("SurfaceAppearance")
                    if skinSA then
                        local ok = pcall(function()
                            part.ColorMap = skinSA.ColorMap
                            part.NormalMap = skinSA.NormalMap
                            part.RoughnessMap = skinSA.RoughnessMap
                            part.MetalnessMap = skinSA.MetalnessMap
                        end)
                        if ok then
                            appliedCount = appliedCount + 1
                        end
                    end
                else
                    table.insert(missing, part.Name)
                end
            end
        end

        print("[SkinChanger] applied to " .. appliedCount .. " parts")
        if #missing > 0 then
            print("[SkinChanger] missing parts in skin:", table.concat(missing, ", "))
        end

        SkinChanger.SelectedWeapon = weaponName
        SkinChanger.SelectedSkin = skinName
        SkinChanger.SelectedCondition = condition or "Factory New"

        return appliedCount > 0
    end

    function SkinChanger.Reset()
        local weaponModel = SkinChanger.GetCurrentWeaponModel()
        if not weaponModel then return end

        local saved = SkinChanger.OriginalSkins[weaponModel]
        if not saved then return end

        for sa, data in pairs(saved) do
            if sa and sa.Parent then
                pcall(function()
                    sa.ColorMap = data.ColorMap
                    sa.NormalMap = data.NormalMap
                    sa.RoughnessMap = data.RoughnessMap
                    sa.MetalnessMap = data.MetalnessMap
                end)
            end
        end

        SkinChanger.OriginalSkins[weaponModel] = nil
        print("[SkinChanger] reset")
    end

    function SkinChanger.Enable()
        SkinChanger.Enabled = true
    end

    function SkinChanger.Disable()
        SkinChanger.Enabled = false
        if camConn then camConn:Disconnect() camConn = nil end
        SkinChanger.Reset()
    end

    return SkinChanger
end