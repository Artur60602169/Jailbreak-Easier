-- Jailbreak Farmer+Easier v17 - Artur606021
-- Exclusive for Moto G52 & Delta X Mobile
-- System: REAL Gemini 3 Flash API + Floating Rainbow UI

local targetUser = "Artur606021"
local lp = game:GetService("Players").LocalPlayer
local API_KEY = 

-- BLOKADA NICKU
if lp.Name ~= targetUser then
    lp:Kick("Skrypt zastrzezony dla: " .. targetUser)
    return
end

-- --- FUNKCJA REALNEGO ZAPYTANIA DO GEMINI PRO ---
local function CallGeminiPro(prompt)
    local url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=" .. API_KEY
    local data = {contents = {{parts = {{text = prompt}}}}}
    local response = request({
        Url = url, Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = game:GetService("HttpService"):JSONEncode(data)
    })
    
    if response.Success then
        local decoded = game:GetService("HttpService"):JSONDecode(response.Body)
        if decoded.candidates and decoded.candidates[1] then
            return decoded.candidates[1].content.parts[1].text
        end
    end
    return "Analiza zoptymalizowana."
end

-- --- LOGIKA JAZDY GEMINI PRO ---
local function GeminiDrive(targetPos)
    local vehicle = lp.Character.Humanoid.SeatPart and lp.Character.Humanoid.SeatPart.Parent
    if vehicle then
        vehicle.PrimaryPart.Velocity = vehicle.PrimaryPart.CFrame.LookVector * 145 -- 100 mph
        vehicle:SetPrimaryPartCFrame(CFrame.new(vehicle.PrimaryPart.Position, Vector3.new(targetPos.X, vehicle.PrimaryPart.Position.Y, targetPos.Z)))
    end
end

local function StartGeminiLoop()
    local RobberyOrder = {
        {name = "Jewelry Shop", pos = Vector3.new(100, 18, 1300)},
        {name = "Cargo Plane", pos = Vector3.new(-1200, 18, 2800)},
        {name = "Power Plant", pos = Vector3.new(600, 18, 2300)},
        {name = "Gas Station", pos = Vector3.new(-1500, 18, 700)},
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
