return function(Hub)
    local WeaponMods = {}
    WeaponMods.NoRecoil = false
    WeaponMods.NoSpread = false
    WeaponMods.Hooked = false
    WeaponMods.RecoilHooks = {}
    WeaponMods.SpreadHooks = {}

    local function hookRecoil()
        if not getgc or not hookfunction or not debug or not debug.getinfo then return end

        for _, obj in next, getgc(true) do
            if type(obj) == "table" and rawget(obj, "setWeaponRecoil") and not WeaponMods.RecoilHooks[obj] then
                local old
                local ok = pcall(function()
                    old = hookfunction(obj.setWeaponRecoil, function(...)
                        if WeaponMods.NoRecoil then return end
                        return old(...)
                    end)
                end)
                if ok and old then
                    WeaponMods.RecoilHooks[obj] = true
                end
            end

            if type(obj) == "function" and not WeaponMods.RecoilHooks[obj] then
                local info = debug.getinfo(obj)
                if info and info.name == "calculateRecoilOffset" then
                    local old
                    local ok = pcall(function()
                        old = hookfunction(obj, function(...)
                            if WeaponMods.NoRecoil then return UDim2.new() end
                            return old(...)
                        end)
                    end)
                    if ok and old then
                        WeaponMods.RecoilHooks[obj] = true
                    end
                end
            end

            if type(obj) == "table" and rawget(obj, "weaponKick") and not WeaponMods.RecoilHooks[obj] then
                local old
                local ok = pcall(function()
                    old = hookfunction(obj.weaponKick, function(...)
                        if WeaponMods.NoRecoil then return end
                        return old(...)
                    end)
                end)
                if ok and old then
                    WeaponMods.RecoilHooks[obj] = true
                end
            end
        end
    end

    local function hookSpread()
        if not getgc or not hookfunction then return end

        for _, obj in next, getgc(true) do
            if type(obj) == "table" and rawget(obj, "getTrueSpread") and not WeaponMods.SpreadHooks[obj] then
                local old
                local ok = pcall(function()
                    old = hookfunction(obj.getTrueSpread, function(p1)
                        if WeaponMods.NoSpread then return 0 end
                        return old(p1)
                    end)
                end)
                if ok and old then
                    WeaponMods.SpreadHooks[obj] = true
                end
            end
        end
    end

    function WeaponMods.EnsureHooks()
        if not WeaponMods.Hooked then
            hookRecoil()
            hookSpread()
            WeaponMods.Hooked = true
        end
    end

    function WeaponMods.SetNoRecoil(v)
        WeaponMods.NoRecoil = v
        if v then WeaponMods.EnsureHooks() end
        print("[WeaponMods] No Recoil:", v and "ON" or "OFF")
    end

    function WeaponMods.SetNoSpread(v)
        WeaponMods.NoSpread = v
        if v then WeaponMods.EnsureHooks() end
        print("[WeaponMods] No Spread:", v and "ON" or "OFF")
    end

    function WeaponMods.Disable()
        WeaponMods.NoRecoil = false
        WeaponMods.NoSpread = false
    end

    task.spawn(function()
        task.wait(2)
        pcall(hookRecoil)
        pcall(hookSpread)
        WeaponMods.Hooked = true
        print("[WeaponMods] hooks installed")
    end)

    return WeaponMods
end