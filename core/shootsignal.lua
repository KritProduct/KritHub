local ShootSignal = {}
ShootSignal.Listeners = {}
ShootSignal.Hooked = false
ShootSignal.SendFunc = nil
ShootSignal.Original = nil

local function FindSendFunc()
    if not getgc then return nil end
    for _, obj in next, getgc(true) do
        if type(obj) == "table" and rawget(obj, "shoot") and typeof(obj.shoot) == "function" then
            local ok, ups = pcall(function() return debug.getupvalues(obj.shoot) end)
            if ok and ups then
                for _, uv in pairs(ups) do
                    if type(uv) == "table" and rawget(uv, "Inventory") and rawget(uv.Inventory, "ShootWeapon") then
                        local send = uv.Inventory.ShootWeapon.Send
                        if send then return send end
                    end
                end
            end
        end
    end
    return nil
end

function ShootSignal.Subscribe(callback)
    table.insert(ShootSignal.Listeners, callback)
end

function ShootSignal.Install()
    if ShootSignal.Hooked then return true end
    if not hookfunction or not newcclosure then return false end

    ShootSignal.SendFunc = FindSendFunc()
    if not ShootSignal.SendFunc then return false end

    ShootSignal.Original = hookfunction(ShootSignal.SendFunc, newcclosure(function(...)
        local args = {...}

        if args[1] and type(args[1].Bullets) == "table" then
            for _, bullet in pairs(args[1].Bullets) do
                if type(bullet.Hits) == "table" then
                    for _, hitData in pairs(bullet.Hits) do
                        for _, listener in ipairs(ShootSignal.Listeners) do
                            pcall(listener, hitData, bullet)
                        end
                    end
                end
            end
        end

        return ShootSignal.Original(unpack(args))
    end))

    ShootSignal.Hooked = true
    print("[ShootSignal] hooked")
    return true
end

return ShootSignal