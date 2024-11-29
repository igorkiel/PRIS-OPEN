local t = {
    Position(33314, 31592, 15), -- stone position
    Position(33317, 31589, 15), -- teleport creation position
    Position(33322, 31592, 14) -- where the teleport takes you
}

local function resetLever(position)
    local tile = position:getTile()
    if tile then
        local lever = tile:getItemById(1946)
        if lever then
            lever:transform(1945)
        end
    end
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if item.itemid == 1945 then
        local tile = t[1]:getTile()
        if tile then
            local stone = tile:getItemById(1355)
            if stone then
                stone:remove()
            else
            end
        else
        end

        local teleport = Game.createItem(1387, 1, t[2])
        if teleport then
            teleport:setDestination(t[3])
            t[2]:sendMagicEffect(CONST_ME_TELEPORT)
        else
        end
        addEvent(resetLever, 5 * 60 * 1000, fromPosition)
    elseif item.itemid == 1946 then
        local tile = t[2]:getTile()
        if tile then
            local teleport = tile:getItemById(1387)
            if teleport and teleport:isTeleport() then
                teleport:remove()
            else
            end
        else
        end
        t[2]:sendMagicEffect(CONST_ME_POFF)
        
        local stoneTile = t[1]:getTile()
        if stoneTile then
            local existingStone = stoneTile:getItemById(1355)
            if not existingStone then
                Game.createItem(1355, 1, t[1])
            else
            end
        end
        addEvent(resetLever, 5 * 60 * 1000, fromPosition)
    end
    return item:transform(item.itemid == 1945 and 1946 or 1945)
end
