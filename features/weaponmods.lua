return function(Hub)
    local WeaponMods = {}
    WeaponMods.NoRecoil = false
    WeaponMods.NoSpread = false
    WeaponMods.Hooked = false
    WeaponMods.RecoilHooks = {}
    WeaponMods.SpreadHooks = {}

    local originalSetWeaponRecoil = nil
    local originalCalculateRecoilOffset = nil
    local originalWeaponKick = nil
    local originalGetTrueSpread = nil

    local function hookRecoil()
        if not getgc then return end
        if not hookfunction then return end

        for _, obj in next, getgc(true) do
            if type(obj) == "table" and rawget(obj, "setWeaponRecoil") and not WeaponMods.RecoilHooks[obj] then
                local ok, old = pcall(function()
                    return hookfunction(obj.setWeaponRecoil, function(...)
                        if WeaponMods.NoRecoil then return end
                        return oldSetWeaponRecoil_global and oldSetWeaponRecoil_global(...) or nil
                    end)
                end)
                if ok and old then
                    _G.SwillRecoil_setWeaponRecoil = old
                    WeaponMods.RecoilHooks[obj] = true
                end
            end

            if type(obj) == "function" and not WeaponMods.RecoilHooks[obj] then
                local info = debug.getinfo(obj)
                if info and info.name == "calculateRecoilOffset" then
                    local ok, old = pcall(function()
                        return hookfunction(obj, function(...)
                            if WeaponMods.NoRecoil then return UDim2.new() end
                            return _G.SwillRecoil_calcOffset(...)
                        end)
                    end)
                    if ok and old then
                        _G.SwillRecoil_calcOffset = old
                        WeaponMods.RecoilHooks[obj] = true
                    end
                end
            end

            if type(obj) == "table" and rawget(obj, "weaponKick") and not WeaponMods.RecoilHooks[obj] then
                local ok, old = pcall(function()
                    return hookfunction(obj.weaponKick, function(...)
                        if WeaponMods.NoRecoil then return end
                        return _G.SwillRecoil_weaponKick(...)
                    end)
                end)
                if ok and old then
                    _G.SwillRecoil_weaponKick = old
                    WeaponMods.RecoilHooks[obj] = true
                end
            end
        end
    end

    local function hookSpread()
        if not getgc then return end
        if not hookfunction then return end

        for _, obj in next, getgc(true) do
            if type(obj) == "table" and rawget(obj, "getTrueSpread") and not WeaponMods.SpreadHooks[obj] then
                local ok, old = pcall(function()
                    return hookfunction(obj.getTrueSpread, function(p1)
                        if WeaponMods.NoSpread then return 0 end
                        return _G.SwillSpread_getTrueSpread(p1)
                    end)
                end)
                if ok and old then
                    _G.SwillSpread_getTrueSpread = old
                    WeaponMods.SpreadHooks[obj] = true
                end
            end
        end
    end

    function WeaponMods.EnableNoRecoil()
        WeaponMods.NoRecoil = true
        if not WeaponMods.Hooked then
            hookRecoil()
            WeaponMods.Hooked = true
        end
        print("[WeaponMods] No Recoil ON")
    end

    function WeaponMods.DisableNoRecoil()
        WeaponMods.NoRecoil = false
        print("[WeaponMods] No Recoil OFF")
    end

    function WeaponMods.EnableNoSpread()
        WeaponMods.NoSpread = true
        if not WeaponMods.Hooked then
            hookSpread()
            WeaponMods.Hooked = true
        end
        print("[WeaponMods] No Spread ON")
    end

    function WeaponMods.DisableNoSpread()
        WeaponMods.NoSpread = false
        print("[WeaponMods] No Spread OFF")
    end

    function WeaponMods.Enable()
        WeaponMods.NoRecoil = true
        WeaponMods.NoSpread = true
        hookRecoil()
        hookSpread()
        WeaponMods.Hooked = true
        print("[WeaponMods] enabled No Recoil + No Spread")
    end

    function WeaponMods.Disable()
        WeaponMods.NoRecoil = false
        WeaponMods.NoSpread = false
    end

    task.spawn(function()
        task.wait(2)
        if hookfunction and getgc then
            pcall(hookRecoil)
            pcall(hookSpread)
            WeaponMods.Hooked = true
            print("[WeaponMods] initial hooks installed")
        else
            warn("[WeaponMods] executor doesn't support getgc/hookfunction")
        end
    end)

    return WeaponMods
end