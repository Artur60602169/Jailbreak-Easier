-- Artur System - Emergency Loader
local function Log(txt)
    game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
        Text = "[SYSTEM]: " .. txt,
        Color = Color3.fromRGB(255, 255, 0),
        Font = Enum.Font.SourceSansBold
    })
    print(txt)
end

local function LoadFile(name)
    local url = "https://raw.githubusercontent.com/Artur60602169/Jailbreak-Easier/main/" .. name
    local success, content = pcall(function() return game:HttpGet(url) end)
    
    if success and content and #content > 0 then
        local func, err = loadstring(content)
        if func then
            spawn(func)
            return true
        else
            Log("Błąd składni w " .. name .. ": " .. tostring(err))
        end
    else
        Log("Nie znaleziono pliku na GitHubie: " .. name)
    end
    return false
end

-- START SYSTEMU
Log("Próba połączenia z GitHubem...")

-- 1. Odpalanie Muzyki (Próbujemy załadować kod muzyki)
if LoadFile("music.lua") then
    Log("Odtwarzacz muzyki: OK")
else
    Log("Odtwarzacz muzyki: BŁĄD")
end

task.wait(2) -- Przerwa dla stabilności Delta X

-- 2. Odpalanie Głównego Skryptu
if LoadFile("loader.lua") then
    Log("Główny skrypt: OK")
else
    Log("Główny skrypt: BŁĄD")
end
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "ARTUR SYSTEM",
            Text = "Muzyka i Farma Aktywne!",
            Duration = 5,
            Icon = "rbxassetid://6023454746" -- Ikona tarczy/bezpieczeństwa
        })
    end)
end

-- Uruchomienie wszystkiego
LoadArturSystem()
