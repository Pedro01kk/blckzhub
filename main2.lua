-- =========================
--  TLREDZ – LOADER SIMPLIFICADO
-- =========================

-- 1️⃣ Variáveis globais
local _ENV  = (getgenv or getrenv or getfenv)()
local http  = game:GetService("HttpService")

-- 2️⃣ URL base do seu repositório (substitua roblox pelo seu nome)
local repoBase = "https://raw.githubusercontent.com/Pedro01kk/blckzhub/refs/heads/main/main2.lua"

-- 3️⃣ Mapeamento rápido de jogos → caminho do script
local scripts = {
    -- Blox Fruits (GameId = 994732206)
    [994732206] = "Scripts/BloxFruits/main.lua",

    -- Meme Sea (PlaceId = 10260193230)
    [10260193230] = "Scripts/MemeSea/main.lua",
}

-- 4️⃣ Função que baixa e executa um arquivo Lua
local function runFromURL(path)
    local url = repoBase .. path

    -- Tenta usar HttpService:GetAsync
    local ok, content = pcall(function() return http:GetAsync(url) end)

    -- Se falhar, tenta usar HttpService:RequestAsync (caso HttpService esteja bloqueado)
    if not ok then
        local request = http:RequestAsync({
            Url = url,
            Method = "GET",
            Headers = { ["User-Agent"] = "Roblox" }
        })
        if request.Success then
            content = request.Body
            ok = true
        end
    end

    if not ok then
        warn("[LOADER] Falha ao baixar:", url)
        return
    end

    local fn, err = loadstring(content)
    if type(fn) ~= "function" then
        warn("[LOADER] Erro de compilação:", err)
        return
    end

    local success, runErr = pcall(fn)
    if not success then
        warn("[LOADER] Erro ao executar:", runErr)
    end
end

-- 5️⃣ Detectar o jogo atual e rodar o script correspondente
local id = game.GameId ~= 0 and game.GameId or game.PlaceId
local path = scripts[id]

if path then
    print("[LOADER] Executando:", path)
    runFromURL(path)
else
    print("[LOADER] Nenhum script encontrado para este jogo.")
end
