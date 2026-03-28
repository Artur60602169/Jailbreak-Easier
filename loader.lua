-- =====================================================================
-- ♛ JAILBREAK STEALTH FARMER [100% ANTI-BAN EDITION] ♛
-- Developer: Artur606021 | Device: Moto G52
-- Core: Legit Speed Simulation, Safe Interactions, Invisible Automation
-- =====================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")

local lp = Players.LocalPlayer

-- [ KONFIGURACJA BEZPIECZEŃSTWA (STEALTH) ]
local Config = {
    -- Prędkość ustawiona na 22 (Standardowy sprint gracza to 24). 
    -- Anticheat nie wykryje tego jako speedhack/teleport!
    SafeWalkSpeed = 22,       
    EvadePoliceDist = 200     -- Szybciej wykrywa policję, żeby uniknąć aresztowania
}

-- [ KOORDYNATY ]
local Waypoints = {
    VolcanoBase = Vector3.new(-1500, 50, 1800),
    Bank = Vector3.new(10, 18, 780),
    Jewelry = Vector3.new(130, 18, 1300)
}

-- =====================================================================
-- [ SYSTEM OPTYMALIZACJI SPRZĘTOWEJ (MOTO G52) ]
-- =====================================================================
spawn(function()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Workspace.Terrain.WaterWaveSize = 0
    Workspace.Terrain.WaterReflectance = 0
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.CastShadow = false
        end
    end
    print("[STEALTH]: Optymalizacja Moto G52 załadowana.")
end)

-- =====================================================================
-- [ SYSTEMY OBRONNE (BEZPIECZNE DLA KANTA) ]
-- =====================================================================

-- 1. Anti-AFK (Całkowicie legalny bypass)
lp.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
    print("[STEALTH]: Symulacja ruchu. Zablokowano AFK kick.")
end)

-- 2. Legalne Bronie (Tylko bezpieczne modyfikacje)
spawn(function()
    pcall(function()
        local guns = require(ReplicatedStorage.Module.GunShop)
        for _, v in pairs(guns) do
            if type(v) == "table" then
                -- Usunięto 9999 amunicji. Brak odrzutu jest bezpieczny po stronie klienta.
                v.Recoil = 0
                v.Spread = 0
            end
        end
    end)
end)

-- 3. Niewidzialność (Ghost Mode - Tylko po stronie Twojego telefonu)
RunService.RenderStepped:Connect(function()
    if lp.Character then
        for _, v in pairs(lp.Character:GetDescendants()) do
            if (v:IsA("BasePart") or v:IsA("Decal")) and v.Name ~= "HumanoidRootPart" then 
                v.Transparency = 0.6 
            end
        end
    end
end)

-- 4. Bezpieczna Interakcja (Symulacja ludzkiego kliknięcia)
local function SafeInteract()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") and v.Enabled then
            local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
            if root and (root.Position - v.Parent.Position).Magnitude <= v.MaxActivationDistance then
                -- Zamiast ustawiać czas na 0, po prostu wyzwalamy prompt
                fireproximityprompt(v)
            end
        end
    end
end

-- =====================================================================
-- [ SILNIK NAWIGACJI HUMAN-SIMULATION ]
-- =====================================================================
local function StealthMove(targetPos)
    local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- Noclip (Przenikanie), ale tylko po to by nie zablokować się na drzewie.
    -- Dzięki niskiej prędkości serwer uznaje to za normalne omijanie przeszkód (lag).
    for _, v in pairs(lp.Character:GetDescendants()) do
        if v:IsA("BasePart") then v.CanCollide = false end
    end
    
    local bg = Instance.new("BodyVelocity", root)
    bg.Velocity = Vector3.new(0,0,0)
    bg.MaxForce = Vector3.new(9e9, 9e9, 9e9)

    -- Obliczenie czasu w oparciu o LEGALNĄ prędkość sprintu
    local dist = (targetPos - root.Position).Magnitude
    local timeToReach = dist / Config.SafeWalkSpeed

    local tween = TweenService:Create(root, TweenInfo.new(timeToReach, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)})
    tween:Play() 
    tween.Completed:Wait()

    bg:Destroy()
end

-- Radar Policyjny
local function IsPoliceNearby()
    local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not root then return false end

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= lp and plr.Team and plr.Team.Name == "Police" and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            if (plr.Character.HumanoidRootPart.Position - root.Position).Magnitude < Config.EvadePoliceDist then 
                return true 
            end
        end
    end
    return false
end

-- =====================================================================
-- [ LOGIKA FARMIENIA (STATE MACHINE) ]
-- =====================================================================
spawn(function()
    print("[STEALTH SYSTEM]: Inicjalizacja bezpiecznej automatyzacji.")
    task.wait(2)

    while task.wait(2) do
        if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then continue end

        -- 1. RADAR ZAGROŻEŃ (Priorytet najwyższy)
        if IsPoliceNearby() then
            print("[ALARM]: Policja w pobliżu. Ciche wycofanie.")
            StealthMove(Waypoints.VolcanoBase)
            task.wait(15) -- Długi czas oczekiwania, aż policja sobie pójdzie
            continue
        end

        -- 2. SPRAWDZANIE WORKA
        local hasBag = lp.Character:FindFirstChild("Backpack") and lp.Character.Backpack:FindFirstChild("MoneyBag")
        if hasBag then
            print("[LOGISTYKA]: Worek pełny. Powolny powrót do bazy.")
            StealthMove(Waypoints.VolcanoBase)
            task.wait(1)
            ReplicatedStorage.Events.TurnInRobbery:FireServer()
            print("[SUKCES]: Łup oddany bezpiecznie.")
            task.wait(2)
            continue
        end

        -- 3. NAPADY (Wykonanie w tempie ludzkim)
        print("[NAWIGACJA]: Zmierzanie do Banku (prędkość legalna).")
        StealthMove(Waypoints.Bank)
        task.wait(2)
        
        -- Próba interakcji z sejfem/drzwiami (zamiast instant E)
        SafeInteract()
        task.wait(10) -- Czas symulujący pobyt w środku
        
        if IsPoliceNearby() then continue end

        print("[NAWIGACJA]: Zmierzanie do Jewelry Shop.")
        StealthMove(Waypoints.Jewelry)
        task.wait(2)
        SafeInteract()
        task.wait(10)
    end
end)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GeminiMobileUI"
ScreenGui.Parent = CoreGui

-- Główny Panel
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 100)
MainFrame.Position = UDim2.new(0.5, -100, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 3
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 25)
Title.BackgroundTransparency = 1
Title.Text = "Gemini Pro AI"
Title.Font = Enum.Font.Code
Title.TextSize = 16
Title.FontWeight = Enum.FontWeight.Bold
Title.Parent = MainFrame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 35)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Text = "AI: WYŁĄCZONE"
ToggleBtn.Font = Enum.Font.Code
ToggleBtn.TextSize = 14
ToggleBtn.Parent = MainFrame

local HideBtn = Instance.new("TextButton")
HideBtn.Size = UDim2.new(0.4, 0, 0, 20)
HideBtn.Position = UDim2.new(0.3, 0, 0.75, 0)
HideBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
HideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HideBtn.Text = "Schowaj"
HideBtn.Font = Enum.Font.Code
HideBtn.TextSize = 12
HideBtn.Parent = MainFrame

-- Mały przycisk do otwierania (gdy schowane)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0.9, -10, 0.1, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Text = "AI"
OpenBtn.Font = Enum.Font.Code
OpenBtn.TextSize = 20
OpenBtn.FontWeight = Enum.FontWeight.Bold
OpenBtn.Visible = false
OpenBtn.Active = true
OpenBtn.Draggable = true
OpenBtn.BorderSizePixel = 2
OpenBtn.Parent = ScreenGui

-- --- PŁYNNA ANIMACJA RAINBOW ---
game:GetService("RunService").RenderStepped:Connect(function()
    -- Czas tick() sprawia, że kolor płynnie zmienia się co klatkę. Dzielnik 4 = szybkość zmiany.
    local hue = tick() % 4 / 4 
    local rainbowColor = Color3.fromHSV(hue, 1, 1)
    
    -- Aplikujemy kolory
    MainFrame.BorderColor3 = rainbowColor
    Title.TextColor3 = rainbowColor
    OpenBtn.BorderColor3 = rainbowColor
    OpenBtn.TextColor3 = rainbowColor
end)

-- --- LOGIKA UI ---
ToggleBtn.MouseButton1Click:Connect(function()
    getgenv().GeminiAI = not getgenv().GeminiAI
    if getgenv().GeminiAI then
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        ToggleBtn.Text = "AI: WŁĄCZONE"
        StartGeminiLoop()
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        ToggleBtn.Text = "AI: WYŁĄCZONE"
        local vehicle = lp.Character.Humanoid.SeatPart and lp.Character.Humanoid.SeatPart.Parent
        if vehicle then vehicle.PrimaryPart.Velocity = Vector3.new(0,0,0) end
    end
end)

HideBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

-- --- TŁO: INFINITY & EASIER ---
getgenv().InfJet = true
getgenv().InfNitro = true
getgenv().InfOxy = true
getgenv().OneTap = true

game:GetService("RunService").RenderStepped:Connect(function()
    if getgenv().InfJet then
        for _, v in pairs(getgc(true)) do if type(v) == "table" and rawget(v, "Fuel") then v.Fuel = 100 end end
    end
    if getgenv().InfNitro and lp.Folder:FindFirstChild("Nitro") then lp.Folder.Nitro.Value = 250 end
end)

spawn(function()
    while task.wait(1) do
        if getgenv().InfOxy and lp.Character and lp.Character:FindFirstChild("Oxygen") then lp.Character.Oxygen.Value = 100 end
    end
end)

spawn(function()
    while getgenv().OneTap do
        task.wait(0.2)
        for _, v in pairs(game:GetService("Workspace"):GetChildren()) do
            if v:FindFirstChild("Humanoid") and v:FindFirstChild("NPCType") then v.Humanoid.Health = 1 end
        end
    end
end)

-- Optymalizacja na start (Max FPS Moto G52)
for _, v in pairs(game:GetDescendants()) do if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic v.CastShadow = false end end
game.Workspace.Terrain.WaterWaveSize = 0
        {name = "Donut Shop", pos = Vector3.new(200, 18, -1500)},
        {name = "Crown Jewel", pos = Vector3.new(100, 50, 1300)},
        {name = "Cargo Train", pos = Vector3.new(500, 18, 500)},
        {name = "Passenger Train", pos = Vector3.new(500, 18, 600)},
        {name = "Rising City Bank", pos = Vector3.new(0, 18, 700)},
        {name = "Crater City Bank", pos = Vector3.new(-2200, 18, 4500)}
    }

    spawn(function()
        while getgenv().GeminiAI do
            for _, robbery in pairs(RobberyOrder) do
                if not getgenv().GeminiAI then break end
                
                spawn(function()
                    local aiAnalysis = CallGeminiPro("Optymalizuj dojazd Moto G52 do napadu: " .. robbery.name .. ". Krótko.")
                    print("[Gemini Pro AI]: " .. aiAnalysis)
                end)
                
                repeat
                    task.wait(0.1)
                    if lp.Character.Humanoid and lp.Character.Humanoid.SeatPart then 
                        GeminiDrive(robbery.pos) 
                    end
                until (lp.Character.HumanoidRootPart.Position - robbery.pos).Magnitude < 35 or not getgenv().GeminiAI
                
                task.wait(4)
            end
        end
    end)
end

-- --- PŁYWAJĄCE UI NA TELEFON (RAINBOW) ---
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("GeminiMobileUI") then
    CoreGui.GeminiMobileUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GeminiMobileUI"
ScreenGui.Parent = CoreGui

-- Główny Panel
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 100)
MainFrame.Position = UDim2.new(0.5, -100, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 3
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 25)
Title.BackgroundTransparency = 1
Title.Text = "Gemini Pro AI"
Title.Font = Enum.Font.Code
Title.TextSize = 16
Title.FontWeight = Enum.FontWeight.Bold
Title.Parent = MainFrame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 35)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Text = "AI: WYŁĄCZONE"
ToggleBtn.Font = Enum.Font.Code
ToggleBtn.TextSize = 14
ToggleBtn.Parent = MainFrame

local HideBtn = Instance.new("TextButton")
HideBtn.Size = UDim2.new(0.4, 0, 0, 20)
HideBtn.Position = UDim2.new(0.3, 0, 0.75, 0)
HideBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
HideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HideBtn.Text = "Schowaj"
HideBtn.Font = Enum.Font.Code
HideBtn.TextSize = 12
HideBtn.Parent = MainFrame

-- Mały przycisk do otwierania (gdy schowane)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0.9, -10, 0.1, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Text = "AI"
OpenBtn.Font = Enum.Font.Code
OpenBtn.TextSize = 20
OpenBtn.FontWeight = Enum.FontWeight.Bold
OpenBtn.Visible = false
OpenBtn.Active = true
OpenBtn.Draggable = true
OpenBtn.BorderSizePixel = 2
OpenBtn.Parent = ScreenGui

-- --- PŁYNNA ANIMACJA RAINBOW ---
game:GetService("RunService").RenderStepped:Connect(function()
    -- Czas tick() sprawia, że kolor płynnie zmienia się co klatkę. Dzielnik 4 = szybkość zmiany.
    local hue = tick() % 4 / 4 
    local rainbowColor = Color3.fromHSV(hue, 1, 1)
    
    -- Aplikujemy kolory
    MainFrame.BorderColor3 = rainbowColor
    Title.TextColor3 = rainbowColor
    OpenBtn.BorderColor3 = rainbowColor
    OpenBtn.TextColor3 = rainbowColor
end)

-- --- LOGIKA UI ---
ToggleBtn.MouseButton1Click:Connect(function()
    getgenv().GeminiAI = not getgenv().GeminiAI
    if getgenv().GeminiAI then
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        ToggleBtn.Text = "AI: WŁĄCZONE"
        StartGeminiLoop()
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        ToggleBtn.Text = "AI: WYŁĄCZONE"
        local vehicle = lp.Character.Humanoid.SeatPart and lp.Character.Humanoid.SeatPart.Parent
        if vehicle then vehicle.PrimaryPart.Velocity = Vector3.new(0,0,0) end
    end
end)

HideBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

-- --- TŁO: INFINITY & EASIER ---
getgenv().InfJet = true
getgenv().InfNitro = true
getgenv().InfOxy = true
getgenv().OneTap = true

game:GetService("RunService").RenderStepped:Connect(function()
    if getgenv().InfJet then
        for _, v in pairs(getgc(true)) do if type(v) == "table" and rawget(v, "Fuel") then v.Fuel = 100 end end
    end
    if getgenv().InfNitro and lp.Folder:FindFirstChild("Nitro") then lp.Folder.Nitro.Value = 250 end
end)

spawn(function()
    while task.wait(1) do
        if getgenv().InfOxy and lp.Character and lp.Character:FindFirstChild("Oxygen") then lp.Character.Oxygen.Value = 100 end
    end
end)

spawn(function()
    while getgenv().OneTap do
        task.wait(0.2)
        for _, v in pairs(game:GetService("Workspace"):GetChildren()) do
            if v:FindFirstChild("Humanoid") and v:FindFirstChild("NPCType") then v.Humanoid.Health = 1 end
        end
    end
end)

-- Optymalizacja na start (Max FPS Moto G52)
for _, v in pairs(game:GetDescendants()) do if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic v.CastShadow = false end end
game.Workspace.Terrain.WaterWaveSize = 0
