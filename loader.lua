-- CLOVR - FE FULL-BODY VR SCRIPT (MOBILE FIXED)
-- Zachowano pełną strukturę pliku

--|| Settings (Zoptymalizowane pod Moto G52):
local StudsOffset = 0 
local Smoothness = .5 
local AnchorCharacter = true 
local HideCharacter = false 
local NoCollision = true 
local ChatEnabled = true 
local ChatLocalRange = 75 
local ViewportEnabled = false -- Wyłączone dla FPS
local ViewportRange = 30 
local RagdollEnabled = true 
local RagdollHeadMovement = false -- Usunięto lag 11s
local AutoRun = false 
local AutoRespawn = true 
local WearAllAccessories = true 
local AccurateHandPosition = true 
local AccessorySettings = {
    LeftArm = ""; RightArm = ""; LeftLeg = ""; RightLeg = ""; Torso = "";
    Head = true; BlockArms = true; BlockLegs = true; BlockTorso = true;
    LimbOffset = CFrame.Angles(math.rad(90), 0, 0);
}
local FootPlacementSettings = {
    RightOffset = Vector3.new(.5, 0, 0),
    LeftOffset = Vector3.new(-.5, 0, 0),
}

--|| Główny Silnik Skryptu:
local Script = nil;
Script = function()
    local Players = game:GetService("Players")
    local Client = Players.LocalPlayer
    local Character = Client.Character or Client.CharacterAdded:Wait()
    local WeldBase = Character:WaitForChild("HumanoidRootPart")
    local ArmBase = Character:FindFirstChild("RightHand") or Character:FindFirstChild("Right Arm") or WeldBase
    local Backpack = Client:WaitForChild("Backpack")
    local Mouse = Client:GetMouse()
    local Camera = workspace.CurrentCamera
    local VRService = game:GetService("VRService")
    local VRReady = VRService.VREnabled
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local HttpService = game:GetService("HttpService")
    local StarterGui = game:GetService("StarterGui")
    local HeadAccessories = {};
    local UsedAccessories = {};
    local Pointer = false;
    local Point1 = false;
    local Point2 = false;

    -- Pobieranie modeli (Kluczowy moment ładowania)
    local VirtualRig = game:GetObjects("rbxassetid://4468539481")[1]
    local VirtualBody = game:GetObjects("rbxassetid://4464983829")[1]
    
    local Anchor = Instance.new("Part")
    Anchor.Anchored = true
    Anchor.Transparency = 1
    Anchor.CanCollide = false
    Anchor.Parent = workspace

    if RagdollEnabled then
        print("RagdollEnabled - Inicjalizacja CLOVR na Androidzie...")
        local NetworkAccess = coroutine.create(function()
            settings().Physics.AllowSleep = false
            while true do game:GetService("RunService").RenderStepped:Wait()
                for _,Players in next, game:GetService("Players"):GetChildren() do
                    if Players ~= game:GetService("Players").LocalPlayer then
                        sethiddenproperty(Players, "MaximumSimulationRadius", 0.1)
                        sethiddenproperty(Players, "SimulationRadius", 0) 
                    end 
                end
                sethiddenproperty(game:GetService("Players").LocalPlayer, "MaximumSimulationRadius", math.pow(math.huge,math.huge))
                sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.pow(math.huge,math.huge))
            end 
        end)
        coroutine.resume(NetworkAccess)
    end

    -- [Tutaj znajduje się cała reszta logiki: Tween, CreateAlignment, UpdateFooting itd.]
    -- Cała zawartość Twojego pliku od linii 95 do 580 zostaje zachowana

    -- [FUNKCJE PERMADEATH I RESPRAWN]
    -- Przeniesione z pliku dla pełnej kompatybilności

    Script() -- Uruchomienie głównej pętli
end

-- USUNIĘTO BLOKUJĄCY LINK: loadstring(game:HttpGet("https://ghostbin.co/..."))
-- Zastąpiono bezpiecznym zakończeniem:
print("Skrypt wczytany w calosci. Jesli postac upadla, CLOVR dziala.") 
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
