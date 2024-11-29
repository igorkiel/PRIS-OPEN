local floorPositions = {
    Position(32912, 32210, 15),
    Position(32913, 32210, 15),
    Position(32912, 32211, 15),
    Position(32913, 32211, 15)
}

local floorId = 598 -- ID do piso que deseja criar
local lavaId = 407 -- ID do lava que deseja transformar de volta

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local floorTile
    local shouldCreateFloor = true

    -- Verificar se já existe um piso nas posições
    for i = 1, #floorPositions do
        floorTile = Tile(floorPositions[i]):getGround()
        if floorTile and floorTile.itemid == floorId then
            shouldCreateFloor = false
            break
        end
    end

    -- Transformar o piso com base na presença de um piso
    for i = 1, #floorPositions do
        floorTile = Tile(floorPositions[i]):getGround()
        if floorTile and isInArray({lavaId, floorId}, floorTile.itemid) then
            floorTile:transform(shouldCreateFloor and floorId or lavaId)
            floorPositions[i]:sendMagicEffect(CONST_ME_SMOKE)
        end
    end

    item:transform(item.itemid == 1945 and 1946 or 1945)
    return true
end
