local text = {
    [1] = 'first', [2] = 'second', [3] = 'third', [4] = 'fourth', [5] = 'fifth',
    [6] = 'sixth', [7] = 'seventh', [8] = 'eighth', [9] = 'ninth', [10] = 'tenth',
    [11] = 'eleventh', [12] = 'twelfth', [13] = 'thirteenth', [14] = 'fourteenth', [15] = 'fifteenth'
}

local stonePositions = {
    Position(32851, 32333, 12),
    Position(32852, 32333, 12)
}

-- Função para criar pedras nas posições especificadas e resetar o contador de alavancas
local function createStones()
    for i = 1, #stonePositions do
        Game.createItem(1304, 1, stonePositions[i])
    end

    Game.setStorageValue(GlobalStorage.PitsOfInfernoLevers, 1)  -- Reseta o contador das alavancas para 1
end

-- Função para reverter a alavanca para o estado inicial após um tempo
local function revertLever(position)
    local leverItem = Tile(position):getItemById(1946)
    if leverItem then
        leverItem:transform(1945)
    end
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if item.itemid ~= 1945 then
        return false
    end

    -- Obtém o valor atual do contador de alavancas ou inicializa-o como 1 se não existir
    local leverCount = Game.getStorageValue(GlobalStorage.PitsOfInfernoLevers) or 1

    -- Debug: Print leverCount
    print("Current lever count:", leverCount)

    -- Verifica se a alavanca está no intervalo correto (2050 a 2064)
    if item.uid > 2049 and item.uid < 2065 then
        local number = item.uid - 2049  -- Determina o número da alavanca
        if leverCount ~= number then
            return false  -- A alavanca foi puxada fora de ordem
        end

        -- Atualiza o contador de alavancas
        Game.setStorageValue(GlobalStorage.PitsOfInfernoLevers, number + 1)
        player:say('You flipped the ' .. text[number] .. ' lever. Hurry up and find the next one!', TALKTYPE_MONSTER_SAY, false, player, toPosition)
    elseif item.uid == 2065 then  -- Verifica se é a alavanca final
        if leverCount ~= 16 then
            player:say('The final lever won\'t budge... yet.', TALKTYPE_MONSTER_SAY)
            return true  -- A alavanca final não pode ser ativada ainda
        end

        -- Remove pedras se todas as alavancas foram ativadas na ordem correta
        local stone
        for i = 1, #stonePositions do
            stone = Tile(stonePositions[i]):getItemById(1304)
            if stone then
                stone:remove()  -- Remove a pedra
                stonePositions[i]:sendMagicEffect(CONST_ME_EXPLOSIONAREA)
            end
        end

        -- Recria as pedras após 15 minutos
        addEvent(createStones, 15 * 60 * 1000)
    end

    -- Transforma a alavanca para mostrar que foi usada e agenda a reversão
    item:transform(1946)
    addEvent(revertLever, 15 * 60 * 1000, toPosition)
    return true
end
