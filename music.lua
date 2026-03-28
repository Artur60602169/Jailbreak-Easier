-- =====================================================================
-- ♛ JAILBREAK CUSTOM AUDIO PLAYER ♛
-- Developer: Artur606021 | GitHub: Artur60602169
-- File: music.lua (Odtwarzacz muzyki z repozytorium)
-- =====================================================================

local function StartGitHubAudio()
    local CoreGui = game:GetService("CoreGui")
    local HttpService = game:GetService("HttpService")
    
    -- Konfiguracja plików
    local FileName = "muzyka.ogg"
    local GitHubRawURL = "https://raw.githubusercontent.com/Artur60602169/Jailbreak-Easier/main/" .. FileName

    -- Funkcja czyszcząca stare audio (zapobiega nakładaniu się muzyki)
    if CoreGui:FindFirstChild("Artur_AFK_Music") then
        CoreGui.Artur_AFK_Music:Destroy()
        print("[AUDIO]: Stara ścieżka usunięta.")
    end

    -- [ MODUŁ POBIERANIA ]
    -- Jeśli plik nie istnieje na telefonie, pobieramy go z GitHuba
    if not isfile(FileName) then
        warn("[AUDIO]: Brak pliku lokalnego. Rozpoczynam pobieranie z GitHub...")
        
        local success, result = pcall(function()
            return game:HttpGet(GitHubRawURL)
        end)

        if success and result then
            writefile(FileName, result)
            print("[AUDIO]: Plik " .. FileName .. " został pomyślnie zapisany w pamięci Delta X.")
        else
            warn("[AUDIO ERROR]: Nie udało się pobrać pliku. Sprawdź nazwę na GitHubie!")
            return
        end
    end

    -- [ MODUŁ ODTWARZANIA ]
    local Sound = Instance.new("Sound")
    Sound.Name = "Artur_AFK_Music"
    
    -- getcustomasset zamienia plik z pamięci telefonu na ID zrozumiałe dla Robloxa
    local successAsset, assetId = pcall(function()
        return getcustomasset(FileName)
    end)

    if successAsset then
        Sound.SoundId = assetId
        Sound.Volume = 0.6          -- Głośność (0.1 - 1.0)
        Sound.Looped = true         -- Pętla włączona
        Sound.Parent = CoreGui      -- Parent w CoreGui (gra po śmierci postaci)
        
        Sound:Play()
        print("[AUDIO]: Sukces! Muzyka gra w pętli.")
    else
        warn("[AUDIO ERROR]: Twój egzekutor nie wspiera getcustomasset!")
    end
end

-- Uruchomienie odtwarzacza
pcall(StartGitHubAudio)
