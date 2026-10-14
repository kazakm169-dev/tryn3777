--============================================================
--  tryn hub | its tryn3777
--  Загружается через loadstring
--============================================================
local Players           = game:GetService("Players")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--============================================================
--  УТИЛИТЫ
--============================================================
local function create(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do o[k] = v end
    if parent then o.Parent = parent end
    return o
end

local function corner(par, r)
    return create("UICorner", { CornerRadius = UDim.new(0, r or 8) }, par)
end

local function gradientStroke(par)
    local s = create("UIStroke", {
        Thickness = 1.5,
        Color = Color3.fromRGB(0, 170, 255),
        Transparency = 0.15,
    }, par)
    create("UIGradient", {
        Rotation = 45,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 170, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 90, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 60, 120)),
        }),
    }, s)
    return s
end

local function getHum()
    local c = player.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function getRoot()
    local c = player.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

--============================================================
--  УБИРАЕМ СТАРЫЙ GUI
--============================================================
local old = playerGui:FindFirstChild("tryn_hub")
if old then old:Destroy() end

--============================================================
--  ГЛАВНЫЙ GUI
--============================================================
local gui = create("ScreenGui", {
    Name = "tryn_hub",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 999,
}, playerGui)

--================= ВЕРХНЯЯ НАДПИСЬ =================
local topBar = create("Frame", {
    Size = UDim2.new(1, 0, 0, 40),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = Color3.fromRGB(12, 12, 18),
    BackgroundTransparency = 0.3,
    BorderSizePixel = 0,
}, gui)

local topLine = create("Frame", {
    Size = UDim2.new(1, 0, 0, 2),
    Position = UDim2.new(0, 0, 1, -2),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BorderSizePixel = 0,
}, topBar)

create("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 170, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 60, 120)),
    }),
}, topLine)

local topLabel = create("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "its tryn",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBlack,
    TextSize = 20,
}, topBar)

task.spawn(function()
    local t = 0
    while gui.Parent do
        t += 0.02
        topLabel.TextColor3 = Color3.fromHSV(t % 1, 0.35, 1)
        task.wait(0.03)
    end
end)

--================= КНОПКА-ТОГЛ =================
local toggle = create("TextButton", {
    Size = UDim2.new(0, 60, 0, 60),
    Position = UDim2.new(0, 20, 0.5, -30),
    BackgroundColor3 = Color3.fromRGB(15, 15, 20),
    Text = "tryn",
    TextColor3 = Color3.fromRGB(0, 170, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    BorderSizePixel = 0,
    AutoButtonColor = false,
}, gui)
corner(toggle, 14)
gradientStroke(toggle)

--================= ОКНО МЕНЮ =================
local window = create("Frame", {
    Size = UDim2.new(0, 340, 0, 420),
    Position = UDim2.new(0, 90, 0.5, -210),
    BackgroundColor3 = Color3.fromRGB(12, 12, 18),
    BackgroundTransparency = 0.05,
    BorderSizePixel = 0,
    Visible = false,
}, gui)
corner(window, 14)
gradientStroke(window)

local title = create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 44),
    BackgroundTransparency = 1,
    Text = "tryn hub",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBlack,
    TextSize = 20,
}, window)

create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 14),
    Position = UDim2.new(0, 0, 0, 42),
    BackgroundTransparency = 1,
    Text = "by its tryn3777",
    TextColor3 = Color3.fromRGB(140, 140, 160),
    Font = Enum.Font.Gotham,
    TextSize = 11,
}, window)

local close = create("TextButton", {
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -40, 0, 8),
    BackgroundColor3 = Color3.fromRGB(40, 20, 30),
    Text = "X",
    TextColor3 = Color3.fromRGB(255, 100, 100),
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    BorderSizePixel = 0,
    AutoButtonColor = false,
}, window)
corner(close, 8)

--================= СПИСОК ФУНКЦИЙ =================
local scroll = create("ScrollingFrame", {
    Size = UDim2.new(1, -20, 1, -80),
    Position = UDim2.new(0, 10, 0, 62),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255),
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, window)

create("UIListLayout", {
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, scroll)

--============================================================
--  СОЗДАНИЕ КНОПОК
--============================================================
local function makeBtn(text, color, callback)
    local b = create("TextButton", {
        Size = UDim2.new(1, -8, 0, 40),
        BackgroundColor3 = color or Color3.fromRGB(30, 30, 40),
        Text = text,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        BorderSizePixel = 0,
        AutoButtonColor = false,
    }, scroll)
    corner(b, 8)

    b.MouseEnter:Connect(function()
        b.BackgroundColor3 = (color or Color3.fromRGB(30, 30, 40)):Lerp(Color3.new(1,1,1), 0.15)
    end)
    b.MouseLeave:Connect(function()
        b.BackgroundColor3 = color or Color3.fromRGB(30, 30, 40)
    end)

    b.MouseButton1Click:Connect(function()
        local ok, err = pcall(callback)
        if not ok then warn("[tryn hub]", err) end
    end)
    return b
end

--============================================================
--  ФУНКЦИИ
--============================================================

--============ SPEED ============
makeBtn("Speed: 16 (обычная)", Color3.fromRGB(40, 60, 80), function()
    local h = getHum() if h then h.WalkSpeed = 16 end
end)
makeBtn("Speed: 50", Color3.fromRGB(40, 80, 100), function()
    local h = getHum() if h then h.WalkSpeed = 50 end
end)
makeBtn("Speed: 100", Color3.fromRGB(40, 100, 140), function()
    local h = getHum() if h then h.WalkSpeed = 100 end
end)

--============ JUMP ============
makeBtn("Jump: 50 (обычный)", Color3.fromRGB(40, 60, 80), function()
    local h = getHum() if h then h.UseJumpPower = true h.JumpPower = 50 end
end)
makeBtn("Jump: 150", Color3.fromRGB(40, 100, 140), function()
    local h = getHum() if h then h.UseJumpPower = true h.JumpPower = 150 end
end)

--============ HEAL ============
makeBtn("Исцелиться", Color3.fromRGB(40, 100, 60), function()
    local h = getHum() if h then h.Health = h.MaxHealth end
end)

--============ FLY ============
local flying = false
local flyConn, flyBV, flyBG

local function stopFly()
    flying = false
    if flyBV then flyBV:Destroy() flyBV = nil end
    if flyBG then flyBG:Destroy() flyBG = nil end
    if flyConn then flyConn:Disconnect() flyConn = nil end
end

makeBtn("Fly: ВКЛ / ВЫКЛ", Color3.fromRGB(60, 60, 120), function()
    if flying then stopFly() return end

    local root = getRoot()
    local hum  = getHum()
    if not root or not hum then return end

    flying = true
    hum.PlatformStand = true

    flyBV = Instance.new("BodyVelocity")
    flyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    flyBV.Velocity = Vector3.zero
    flyBV.Parent = root

    flyBG = Instance.new("BodyGyro")
    flyBG.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    flyBG.P = 1000
    flyBG.D = 50
    flyBG.CFrame = root.CFrame
    flyBG.Parent = root

    local cam = workspace.CurrentCamera
    flyConn = RunService.RenderStepped:Connect(function()
        if not flying or not root.Parent then stopFly() return end
        local move = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move -= Vector3.new(0,1,0) end
        flyBV.Velocity = move.Magnitude > 0 and move.Unit * 100 or Vector3.zero
        flyBG.CFrame = cam.CFrame
    end)
end)

--============ NOCLIP ============
local noclip = false
local noclipConn

makeBtn("Noclip: ВКЛ / ВЫКЛ", Color3.fromRGB(80, 60, 100), function()
    noclip = not noclip
    if noclip then
        noclipConn = RunService.Stepped:Connect(function()
            if noclip and player.Character then
                for _, p in ipairs(player.Character:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
    else
        if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    end
end)

--============ FULLBRIGHT ============
local fullbright = false

makeBtn("Fullbright: ВКЛ / ВЫКЛ", Color3.fromRGB(100, 80, 40), function()
    fullbright = not fullbright
    if fullbright then
        game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        game.Lighting.Brightness = 2
        game.Lighting.ClockTime = 12
        game.Lighting.GlobalShadows = false
    else
        game.Lighting.Ambient = Color3.fromRGB(0, 0, 0)
        game.Lighting.Brightness = 1
        game.Lighting.GlobalShadows = true
    end
end)

--============ БАННЕР ============
local bannerGui

makeBtn("Баннер its tryn3777", Color3.fromRGB(120, 40, 60), function()
    if bannerGui then bannerGui:Destroy() bannerGui = nil return end

    bannerGui = create("ScreenGui", {
        Name = "tryn_banner",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 998,
    }, playerGui)

    local bg = create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.55,
        BorderSizePixel = 0,
    }, bannerGui)

    local lbl = create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "its tryn3777",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBlack,
        TextScaled = true,
    }, bg)

    local st = create("UIStroke", { Thickness = 6, Transparency = 0.1 }, lbl)

    task.spawn(function()
        local t = 0
        while bannerGui.Parent do
            t += 0.015
            local hue = t % 1
            lbl.TextColor3 = Color3.fromHSV(hue, 0.4, 1)
            st.Color = Color3.fromHSV((hue + 0.5) % 1, 0.7, 1)
            task.wait(0.03)
        end
    end)
end)

--============================================================
--  ОТКРЫТИЕ / ЗАКРЫТИЕ
--============================================================
local open = false
local function setOpen(v)
    open = v
    window.Visible = v
end

toggle.MouseButton1Click:Connect(function() setOpen(not open) end)
close.MouseButton1Click:Connect(function() setOpen(false) end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        setOpen(not open)
    end
end)

--================= ПЕРЕТАСКИВАНИЕ =================
local dragging, dragStart, startPos
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = window.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        window.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + d.X,
            startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

--================= ПРИ СМЕРТИ =================
player.CharacterAdded:Connect(function()
    if flying then stopFly() end
end)

print("[tryn hub] Загружено | by its tryn3777")
