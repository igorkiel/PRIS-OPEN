local config = {
    bridgePositions = {
        {position = Position(32100, 32205, 8), groundId = 493, itemId = 4799},
        {position = Position(32101, 32205, 8), groundId = 493, itemId = 4797}
    },
    leverPositions = {
        Position(32098, 32204, 8),
        Position(32104, 32204, 8)
    },
    relocatePosition = Position(32102, 32205, 8),
    relocateMonsterPosition = Position(32103, 32205, 8),
    bridgeId = 5770,
    leverCooldown = {}
}

local function resetLevers()
    for i = 1, #config.leverPositions do
        local lever = Tile(config.leverPositions[i]):getItemById(1946)
        if lever then
            lever:transform(1945)
        end
    end
end

local function closeBridge()
    local tile, tmpItem, bridge
    for i = 1, #config.bridgePositions do
        bridge = config.bridgePositions[i]
        tile = Tile(bridge.position)

        tile:relocateTo(config.relocatePosition, true, config.relocateMonsterPosition)
        tile:getGround():transform(bridge.groundId)
        Game.createItem(bridge.itemId, 1, bridge.position)
    end
    resetLevers()
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local playerId = player:getId()

    if config.leverCooldown[playerId] and os.time() < config.leverCooldown[playerId] then
        player:sendCancelMessage("You have to wait before using this lever again.")
        return true
    end

    local leverLeft = item.itemid == 1945
    for i = 1, #config.leverPositions do
        local lever = Tile(config.leverPositions[i]):getItemById(leverLeft and 1945 or 1946)
        if lever then
            lever:transform(leverLeft and 1946 or 1945)
        end
    end

    local tile, tmpItem, bridge
    if leverLeft then
        for i = 1, #config.bridgePositions do
            bridge = config.bridgePositions[i]
            tile = Tile(bridge.position)

            tmpItem = tile:getGround()
            if tmpItem then
                tmpItem:transform(config.bridgeId)
            end

            if bridge.itemId then
                tmpItem = tile:getItemById(bridge.itemId)
                if tmpItem then
                    tmpItem:remove()
                end
            end
        end
        addEvent(closeBridge, 10000) -- Fecha a ponte após 10 segundos (10000 milissegundos)
    else
        closeBridge()
    end

    config.leverCooldown[playerId] = os.time() + 2 -- Define um cooldown de 2 segundos antes de permitir usar a alavanca novamente

    return true
end
