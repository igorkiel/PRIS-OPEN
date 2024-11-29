local dummyMonsterName = "Training Dummy"
local exhaustStorage = 12345
local exhaustTime = 60

local function isWalkable(pos, creature, pz, proj)
    local tile = Tile(pos)
    if not tile or (tile:hasFlag(TILESTATE_PROTECTIONZONE) and not pz) or 
       tile:hasFlag(TILESTATE_BLOCKSOLID) or tile:hasFlag(TILESTATE_BLOCKPATH) or 
       (proj and tile:hasFlag(TILESTATE_BLOCKPROJECTILE)) then
        return false
    end

    for _, item in ipairs(tile:getItems()) do
        if item:hasProperty(CONST_PROP_BLOCKSOLID) or item:hasProperty(CONST_PROP_BLOCKPATH) then
            return false
        end
    end

    return #tile:getCreatures() == 0
end

local function getWalkablePositionAround(player)
    local playerPos = player:getPosition()
    local surroundingPositions = {
        Position(playerPos.x + 1, playerPos.y, playerPos.z),
        Position(playerPos.x - 1, playerPos.y, playerPos.z),
        Position(playerPos.x, playerPos.y + 1, playerPos.z),
        Position(playerPos.x, playerPos.y - 1, playerPos.z)
    }

    for _, pos in ipairs(surroundingPositions) do
        if isWalkable(pos, player, true, true) then
            return pos
        end
    end

    return nil
end

local function summonDummy(player)
    local pos = getWalkablePositionAround(player)
    if pos then
        local dummy = Game.createMonster(dummyMonsterName, pos)
        if not dummy then
            return nil
        end
        player:setDummy(dummy)
        dummy:setDummyOwner(player)
        return dummy:getId()
    end
    return nil
end

local function removeDummy(player)
    player:removeDummy()
end

function onEquip(player, item, slot, isCheck)
    if isCheck then
        return true
    end

    local currentTime = os.time()

    if player:getStorageValue(exhaustStorage) > currentTime then
        local remainingTime = player:getStorageValue(exhaustStorage) - currentTime
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "You must wait " .. remainingTime .. " seconds to use this ring again.")
        return false
    end

    if player:getDummy() then
        return true
    end

    local dummyId = summonDummy(player)
    if dummyId then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have summoned a training dummy.")
        player:setStorageValue(exhaustStorage, currentTime + exhaustTime)
    else
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "There is no space around you to summon a training dummy.")
    end
    return true
end

function onDeEquip(player, item, slot)
    removeDummy(player)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The training dummy has been removed.")
    return true
end
