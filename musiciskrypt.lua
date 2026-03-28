-- =====================================================================
-- ♛ JAILBREAK MASTER LOADER [MUSIC + SCRIPT] ♛
-- Developer: Artur606021 | Repo: Jailbreak-Easier
-- System: Automatyczne ładowanie muzyki i farmy AFK
-- =====================================================================

local function LoadArturSystem()
    local GitHubURL = "https://raw.githubusercontent.com/Artur60602169/Jailbreak-Easier/main/"
    
    print("[SYSTEM]: Inicjalizacja pakietu Artur606021...")

    -- 1. Ładowanie Odtwarzacza Muzyki (music.lua)
    local successMusic, errMusic = pcall(function()
        loadstring(game:HttpGet(GitHubURL .. "music.lua"))()
    end)
    
    if successMusic then
        print("[SYSTEM]: Muzyka załadowana pomyślnie.")
    else
        warn("[SYSTEM ERROR]: Nie udało się odpalić music.lua -> " .. tostring(errMusic))
    end

    task.wait(1) -- Krótka przerwa dla stabilności Delta X

    -- 2. Ładowanie Głównego Skryptu (loader.lua / Master Script)
    local successScript, errScript = pcall(function()
        loadstring(game:HttpGet(GitHubURL .. "loader.lua"))()
    end)

    if successScript then
        print("[SYSTEM]: Główny skrypt farmy uruchomiony.")
    else
        warn("[SYSTEM ERROR]: Nie udało się odpalić loader.lua -> " .. tostring(errScript))
    end

    -- 3. Powiadomienie końcowe w rogu ekranu (Safe Popup Style)
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
