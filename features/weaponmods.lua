return function(Hub)
    local WeaponMods = {}
    WeaponMods.NoRecoil = false
    WeaponMods.NoSpread = false
    WeaponMods.InstantReload = false
    WeaponMods.ReloadSpeed = 199
    WeaponMods.Hooked = false
    WeaponMods.RecoilHooks = {}
    WeaponMods.SpreadHooks = {}
    WeaponMods.ReloadHooked = {}
    WeaponMods.LastWeapon = nil

    local RELOAD_ANIMS = {
        ["Reload"] = true,
        ["ReloadStart"] = true,
        ["ReloadAction"] = true,
        ["ReloadEnd"] = true,
    }

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
                if ok and old then WeaponMods.RecoilHooks[obj] = true end
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
                    if ok and old then WeaponMods.RecoilHooks[obj] = true end
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
                if ok and old then WeaponMods.RecoilHooks[obj] = true end
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
                if ok and old then WeaponMods.SpreadHooks[obj] = true end
            end
        end
    end

    local function getWeaponObjectSafe()
        local ok, IC = pcall(function()
            return require(game:GetService("ReplicatedStorage").Controllers.InventoryController)
        end)
        if not ok or not IC then return nil end
        return IC.peekCurrentEquippedForMovement and IC.peekCurrentEquippedForMovement() or nil
    end

    local function hookAnimationReload(animModule)
        if not animModule or WeaponMods.ReloadHooked[animModule] then return end
        WeaponMods.ReloadHooked[animModule] = true

        pcall(function()
            local origPlay = animModule.play
            animModule.play = function(self_anim, animName, ...)
                local track = origPlay(self_anim, animName, ...)
                if track and RELOAD_ANIMS[animName] then
                    task.defer(function()
                        pcall(function()
                            if WeaponMods.InstantReload and track.IsPlaying then
                                track:AdjustSpeed(WeaponMods.ReloadSpeed)
                            end
                        end)
                    end)
                end
                return track
            end
        end)
    end

    task.spawn(function()
        while task.wait(0.1) do
            pcall(function()
                local weapon = getWeaponObjectSafe()
                if not weapon then return end

                if weapon ~= WeaponMods.LastWeapon then
                    WeaponMods.LastWeapon = weapon
                    if weapon.Viewmodel and weapon.Viewmodel.Animation then
                        hookAnimationReload(weapon.Viewmodel.Animation)
                    end
                    if weapon.CharacterAnimator then
                        hookAnimationReload(weapon.CharacterAnimator)
                    end
                end

                if not WeaponMods.InstantReload then return end

                if weapon.IsReloading then
                    pcall(function()
                        if weapon.Viewmodel and weapon.Viewmodel.Animation and weapon.Viewmodel.Animation.Animations then
                            for name, track in pairs(weapon.Viewmodel.Animation.Animations) do
                                if RELOAD_ANIMS[name] and track.IsPlaying then
                                    track:AdjustSpeed(WeaponMods.ReloadSpeed)
                                end
                            end
                        end
                        if weapon.CharacterAnimator and weapon.CharacterAnimator.Animations then
                            for name, track in pairs(weapon.CharacterAnimator.Animations) do
                                if RELOAD_ANIMS[name] and track.IsPlaying then
                                    track:AdjustSpeed(WeaponMods.ReloadSpeed)
                                end
                            end
                        end
                    end)
                end
            end)
        end
    end)

    pcall(function()
        local IC = require(game:GetService("ReplicatedStorage").Controllers.InventoryController)
        if IC.OnInventoryItemEquipped then
            IC.OnInventoryItemEquipped:Connect(function(_, weapon)
                if not weapon then return end
                task.defer(function()
                    if weapon.Viewmodel and weapon.Viewmodel.Animation then
                        hookAnimationReload(weapon.Viewmodel.Animation)
                    end
                    if weapon.CharacterAnimator then
                        hookAnimationReload(weapon.CharacterAnimator)
                    end
                end)
            end)
        end
    end)

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
    end

    function WeaponMods.SetNoSpread(v)
        WeaponMods.NoSpread = v
        if v then WeaponMods.EnsureHooks() end
    end

    function WeaponMods.SetInstantReload(v)
        WeaponMods.InstantReload = v
    end

    function WeaponMods.SetReloadSpeed(v)
        WeaponMods.ReloadSpeed = v
    end

    function WeaponMods.Disable()
        WeaponMods.NoRecoil = false
        WeaponMods.NoSpread = false
        WeaponMods.InstantReload = false
    end

    task.spawn(function()
        task.wait(2)
        pcall(hookRecoil)
        pcall(hookSpread)
        WeaponMods.Hooked = true
    end)

    return WeaponMods
end