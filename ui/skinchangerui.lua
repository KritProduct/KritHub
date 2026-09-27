local SkinChangerUI = {}

function SkinChangerUI.Build(Hub, W, tab)
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local RS = game:GetService("ReplicatedStorage")
    local T = Hub.Theme
    local U = Hub.Utils
    local SC = Hub.Features.SkinChanger

    local UI = {}
    UI.SC = SC
    UI.CurrentWeapon = nil
    UI.SelectedSkin = nil
    UI.SelectedCondition = "Factory New"

    local parent = Instance.new("Frame")
    parent.Name = "SkinChangerRoot"
    parent.Size = UDim2.new(1, -6, 0, 500)
    parent.BackgroundTransparency = 1
    parent.LayoutOrder = 1
    parent.ClipsDescendants = true
    parent.ZIndex = 3
    parent.Parent = W.ContentScroll
    U.Corner(parent, UDim.new(0, 10))

    local viewportFrame = Instance.new("ViewportFrame")
    viewportFrame.Size = UDim2.new(1, 0, 0, 220)
    viewportFrame.Position = UDim2.new(0, 0, 0, 0)
    viewportFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    viewportFrame.BorderSizePixel = 0
    viewportFrame.ZIndex = 4
    viewportFrame.Parent = parent
    U.Corner(viewportFrame, UDim.new(0, 10))

    local viewportCam = Instance.new("Camera")
    viewportCam.FieldOfView = 40
    viewportCam.Parent = viewportFrame
    viewportFrame.CurrentCamera = viewportCam

    local light = Instance.new("PointLight")
    light.Brightness = 2
    light.Range = 20
    light.Parent = viewportCam

    local leftArrow = Instance.new("TextButton")
    leftArrow.Size = UDim2.new(0, 40, 0, 40)
    leftArrow.Position = UDim2.new(0, 10, 0, 90)
    leftArrow.BackgroundColor3 = T.Accent
    leftArrow.BackgroundTransparency = 0.2
    leftArrow.BorderSizePixel = 0
    leftArrow.Text = "<"
    leftArrow.TextColor3 = Color3.fromRGB(255, 255, 255)
    leftArrow.Font = Enum.Font.GothamBold
    leftArrow.TextSize = 22
    leftArrow.ZIndex = 10
    leftArrow.AutoButtonColor = false
    leftArrow.Parent = viewportFrame
    U.Corner(leftArrow, UDim.new(0, 8))

    local rightArrow = Instance.new("TextButton")
    rightArrow.Size = UDim2.new(0, 40, 0, 40)
    rightArrow.Position = UDim2.new(1, -50, 0, 90)
    rightArrow.BackgroundColor3 = T.Accent
    rightArrow.BackgroundTransparency = 0.2
    rightArrow.BorderSizePixel = 0
    rightArrow.Text = ">"
    rightArrow.TextColor3 = Color3.fromRGB(255, 255, 255)
    rightArrow.Font = Enum.Font.GothamBold
    rightArrow.TextSize = 22
    rightArrow.ZIndex = 10
    rightArrow.AutoButtonColor = false
    rightArrow.Parent = viewportFrame
    U.Corner(rightArrow, UDim.new(0, 8))

    local weaponNameLabel = Instance.new("TextLabel")
    weaponNameLabel.Size = UDim2.new(1, -120, 0, 30)
    weaponNameLabel.Position = UDim2.new(0, 60, 0, 95)
    weaponNameLabel.BackgroundTransparency = 1
    weaponNameLabel.Text = "No weapon"
    weaponNameLabel.TextColor3 = T.Accent
    weaponNameLabel.Font = Enum.Font.GothamBold
    weaponNameLabel.TextSize = 18
    weaponNameLabel.ZIndex = 10
    weaponNameLabel.Parent = viewportFrame

    local skinListTitle = Instance.new("TextLabel")
    skinListTitle.Size = UDim2.new(1, 0, 0, 24)
    skinListTitle.Position = UDim2.new(0, 10, 0, 228)
    skinListTitle.BackgroundTransparency = 1
    skinListTitle.Text = "SKINS"
    skinListTitle.TextColor3 = T.Accent
    skinListTitle.Font = Enum.Font.GothamBold
    skinListTitle.TextSize = 14
    skinListTitle.TextXAlignment = Enum.TextXAlignment.Left
    skinListTitle.ZIndex = 4
    skinListTitle.Parent = parent

    local skinScroll = Instance.new("ScrollingFrame")
    skinScroll.Size = UDim2.new(1, 0, 0, 200)
    skinScroll.Position = UDim2.new(0, 0, 0, 254)
    skinScroll.BackgroundTransparency = 1
    skinScroll.BorderSizePixel = 0
    skinScroll.ScrollBarThickness = 5
    skinScroll.ScrollBarImageColor3 = T.Accent
    skinScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    skinScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    skinScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    skinScroll.ZIndex = 4
    skinScroll.Parent = parent

    local skinGrid = Instance.new("UIGridLayout")
    skinGrid.CellSize = UDim2.new(0, 100, 0, 40)
    skinGrid.CellPadding = UDim2.new(0, 6, 0, 6)
    skinGrid.SortOrder = Enum.SortOrder.LayoutOrder
    skinGrid.Parent = skinScroll

    local applyBtn = Instance.new("TextButton")
    applyBtn.Size = UDim2.new(0, 120, 0, 34)
    applyBtn.Position = UDim2.new(0, 0, 0, 460)
    applyBtn.BackgroundColor3 = T.Green
    applyBtn.BorderSizePixel = 0
    applyBtn.Text = "APPLY"
    applyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    applyBtn.Font = Enum.Font.GothamBold
    applyBtn.TextSize = 14
    applyBtn.ZIndex = 4
    applyBtn.AutoButtonColor = false
    applyBtn.Parent = parent
    U.Corner(applyBtn, UDim.new(0, 8))

    local resetBtn = Instance.new("TextButton")
    resetBtn.Size = UDim2.new(0, 120, 0, 34)
    resetBtn.Position = UDim2.new(0, 130, 0, 460)
    resetBtn.BackgroundColor3 = T.Red
    resetBtn.BorderSizePixel = 0
    resetBtn.Text = "RESET"
    resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    resetBtn.Font = Enum.Font.GothamBold
    resetBtn.TextSize = 14
    resetBtn.ZIndex = 4
    resetBtn.AutoButtonColor = false
    resetBtn.Parent = parent
    U.Corner(resetBtn, UDim.new(0, 8))

    local function clearViewport()
        for _, c in ipairs(viewportFrame:GetChildren()) do
            if c:IsA("Model") or c:IsA("BasePart") then
                c:Destroy()
            end
        end
    end

    local function updateViewportModel()
        clearViewport()

        if not UI.CurrentWeapon then
            weaponNameLabel.Text = "No weapon"
            return
        end

        local cam = workspace:FindFirstChild("Camera")
        if not cam then return end

        local weaponModel = nil
        for _, obj in ipairs(cam:GetChildren()) do
            if obj:IsA("Model") and obj.Name == UI.CurrentWeapon then
                weaponModel = obj
                break
            end
        end

        if not weaponModel then
            weaponNameLabel.Text = UI.CurrentWeapon .. " (not equipped)"
            return
        end

        weaponNameLabel.Text = UI.CurrentWeapon

        local clone = weaponModel:Clone()
        clone.Parent = viewportFrame

        for _, d in ipairs(clone:GetDescendants()) do
            if d:IsA("BasePart") then
                d.Anchored = true
            end
        end

        local inner = clone:FindFirstChild("Weapon")
        local center = inner and inner:FindFirstChildOfClass("Model") or clone

        local cf, size = center:GetBoundingBox()
        local maxSize = math.max(size.X, size.Y, size.Z)
        if maxSize <= 0 then maxSize = 5 end

        local distance = maxSize * 2.2

        viewportCam.CFrame = CFrame.new(cf.Position + Vector3.new(distance * 0.7, distance * 0.4, distance * 0.9), cf.Position)
    end

    local function updateWeaponList()
        local weapons = SC.GetWeapons()
        UI.Weapons = weapons
        UI.WeaponIndex = 1

        local current = SC.GetCurrentWeaponName()
        for i, w in ipairs(weapons) do
            if w == current then
                UI.WeaponIndex = i
                break
            end
        end

        UI.CurrentWeapon = weapons[UI.WeaponIndex]
        updateViewportModel()
        SkinChangerUI.RefreshSkins(Hub, UI)
    end

    local function refreshSkins()
        for _, c in ipairs(skinScroll:GetChildren()) do
            if c:IsA("TextButton") then
                c:Destroy()
            end
        end

        if not UI.CurrentWeapon then return end

        local skins = SC.GetSkinsForWeapon(UI.CurrentWeapon)

        for _, skinName in ipairs(skins) do
            local btn = Instance.new("TextButton")
            btn.BackgroundColor3 = T.Item
            btn.BorderSizePixel = 0
            btn.Text = skinName
            btn.TextColor3 = T.Text
            btn.Font = Enum.Font.GothamSemibold
            btn.TextSize = 12
            btn.TextWrapped = true
            btn.ZIndex = 5
            btn.AutoButtonColor = false
            btn.Parent = skinScroll
            U.Corner(btn, UDim.new(0, 6))

            btn.MouseEnter:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = T.ItemHover}):Play()
            end)
            btn.MouseLeave:Connect(function()
                if UI.SelectedSkin ~= skinName then
                    TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = T.Item}):Play()
                end
            end)

            btn.MouseButton1Click:Connect(function()
                UI.SelectedSkin = skinName

                for _, c in ipairs(skinScroll:GetChildren()) do
                    if c:IsA("TextButton") then
                        if c.Text == skinName then
                            c.BackgroundColor3 = T.Accent
                        else
                            c.BackgroundColor3 = T.Item
                        end
                    end
                end
            end)
        end
    end

    SkinChangerUI.RefreshSkins = refreshSkins

    leftArrow.MouseButton1Click:Connect(function()
        if not UI.Weapons or #UI.Weapons == 0 then return end
        UI.WeaponIndex = UI.WeaponIndex - 1
        if UI.WeaponIndex < 1 then UI.WeaponIndex = #UI.Weapons end
        UI.CurrentWeapon = UI.Weapons[UI.WeaponIndex]
        UI.SelectedSkin = nil
        updateViewportModel()
        refreshSkins()
    end)

    rightArrow.MouseButton1Click:Connect(function()
        if not UI.Weapons or #UI.Weapons == 0 then return end
        UI.WeaponIndex = UI.WeaponIndex + 1
        if UI.WeaponIndex > #UI.Weapons then UI.WeaponIndex = 1 end
        UI.CurrentWeapon = UI.Weapons[UI.WeaponIndex]
        UI.SelectedSkin = nil
        updateViewportModel()
        refreshSkins()
    end)

    applyBtn.MouseButton1Click:Connect(function()
        if not UI.CurrentWeapon or not UI.SelectedSkin then return end
        local conds = SC.GetConditions(UI.CurrentWeapon, UI.SelectedSkin)
        local cond = conds[1] or "Factory New"
        SC.Apply(UI.CurrentWeapon, UI.SelectedSkin, cond)
    end)

    resetBtn.MouseButton1Click:Connect(function()
        SC.Reset()
    end)

    leftArrow.MouseEnter:Connect(function()
        TweenService:Create(leftArrow, TweenInfo.new(0.15), {BackgroundColor3 = T.Accent, BackgroundTransparency = 0}):Play()
    end)
    leftArrow.MouseLeave:Connect(function()
        TweenService:Create(leftArrow, TweenInfo.new(0.15), {BackgroundColor3 = T.Accent, BackgroundTransparency = 0.2}):Play()
    end)
    rightArrow.MouseEnter:Connect(function()
        TweenService:Create(rightArrow, TweenInfo.new(0.15), {BackgroundColor3 = T.Accent, BackgroundTransparency = 0}):Play()
    end)
    rightArrow.MouseLeave:Connect(function()
        TweenService:Create(rightArrow, TweenInfo.new(0.15), {BackgroundColor3 = T.Accent, BackgroundTransparency = 0.2}):Play()
    end)

    UI.UpdateWeaponList = updateWeaponList
    UI.RefreshSkins = refreshSkins

    task.delay(0.2, function()
        updateWeaponList()
    end)

    return UI
end

return SkinChangerUI