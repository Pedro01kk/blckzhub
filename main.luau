-- ===== CONFIGURAÇÃO =====
local _ENV = (getgenv or getrenv or getfenv)()
local HttpService = game:GetService("HttpService")

-- URL base do repositório (ajuste para o seu nome de usuário e repo)
local repoBase = "https://raw.githubusercontent.com/Pedro01kk/blckzhub/main.lua/"

-- Lista de jogos suportados
local Scripts = {
    {
        -- Blox Fruits
        GameId = 994732206,
        Path   = "Scripts/BloxFruits/main.luau"
    },
    {
        -- Meme Sea
        PlacesIds = {10260193230},
        Path      = "Scripts/MemeSea/main.luau"
    }
}

-- ===== FUNÇÃO DE BAIXA E EXECUTA =====
local function loadScript(url)
    local success, data = pcall(function()
        return HttpService:GetAsync(url)
    end)

    if not success then
        warn("[LOADER] Falha ao baixar:", url)
        return
    end

    local fn, err = loadstring(data)
    if type(fn) ~= "function" then
        warn("[LOADER] Erro de compilação:", err)
        return
    end

    local ok, runErr = pcall(fn)
    if not ok then
        warn("[LOADER] Erro na execução:", runErr)
    end
end

-- ===== DETEÇÃO DE JOGO =====
local function isCurrentGame(cfg)
    if cfg.PlacesIds and table.find(cfg.PlacesIds, game.PlaceId) then
        return true
    end
    if cfg.GameId and cfg.GameId == game.GameId then
        return true
    end
    return false
end

-- ===== EXECUÇÃO =====
for _, cfg in ipairs(Scripts) do
    if isCurrentGame(cfg) then
        local fullUrl = repoBase .. cfg.Path
        print("[LOADER] Baixando e executando:", fullUrl)
        loadScript(fullUrl)
        return
    end
end

print("[LOADER] Nenhum script encontrado para este jogo.")
