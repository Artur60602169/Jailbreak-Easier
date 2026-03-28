-- [[ ARTUR SYSTEM - ULTIMATE FIX ]]
print("Inicjalizacja systemu...")

-- Zapobiega błędom ładowania (Bypass nil loadstring)
local function ExecuteRemote(url)
    local success, content = pcall(function() return game:HttpGet(url) end)
    if success and content then
        local func = loadstring(content)
        if func then 
            task.spawn(func) 
            return true
        end
    end
    return false
end

-- 1. ODTWARZACZ MUZYKI (Wbudowany, by nie wywalało błędu nil)
local function StartMusic()
    local url = "https://raw.githubusercontent.com/Artur60602169/Jailbreak-Easier/main/muzyka.ogg"
    local fileName = "muzyka.ogg"
    
    task.spawn(function()
        if not isfile(fileName) then
            local s, res = pcall(function() return game:HttpGet(url) end)
            if s and res then writefile(fileName, res) end
        end
        
        local s = Instance.new("Sound", game:GetService("CoreGui"))
        s.Name = "ArturMusic"
        s.SoundId = getcustomasset(fileName)
        s.Volume = 0.5
        s.Looped = true
        s:Play()
    end)
end

-- 2. GŁÓWNA LOGIKA (Main / Bots)
local lp = game:GetService("Players").LocalPlayer
local Roles = {
    Main = "Artur606021",
    Pass = "Artur50521001",
    Pol = "KolegaArtura123"
}

-- Powiadomienie na starcie
game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
    Text = "[SYSTEM]: Załadowano dla " .. lp.Name,
    Color = Color3.fromRGB(255, 215, 0)
})

-- Odpalanie muzyki
StartMusic()

-- Rozpoznawanie roli
if lp.Name == Roles.Main then
    -- LOGIKA GŁÓWNA (AutoHold E + Farma)
    game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(fireproximityprompt)
    while task.wait(5) do
        print("Farma Maina aktywna")
    end

elseif lp.Name == Roles.Pol then
    -- BOT POLICJANT
    game:GetService("RunService").Heartbeat:Connect(function()
        if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            lp.Character.HumanoidRootPart.CFrame = CFrame.new(720, 200, 1150)
        end
    end)

elseif lp.Name == Roles.Pass then
    -- BOT PASAŻER
    game:GetService("RunService").Heartbeat:Connect(function()
        local szef = game:GetService("Players"):FindFirstChild(Roles.Main)
        if szef and szef.Character and lp.Character then
            lp.Character.HumanoidRootPart.CFrame = szef.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
        end
    end)
end
