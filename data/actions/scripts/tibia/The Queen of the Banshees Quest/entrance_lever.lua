function onUse(player, item, fromPosition, target, toPosition)

    local magicwallPos = Position(32266, 31860, 11)
    local stairPos = Position(32266, 31860, 11)
    local tilePos = Position(32266, 31860, 11)

    local magicWall = Tile(magicwallPos):getItemById(1498)
    local stair = Tile(stairPos):getItemById(410)
    local tile = Tile(tilePos):getGround()

    if tile then
    end

    if not item.actionid then
        player:sendCancelMessage("The item has no actionid.")
        return true
    end

    if item.actionid == 50019 and item.itemid == 1945 and magicWall and tile and tile.itemid == 407 then
        magicWall:remove()
        item:transform(item.itemid + 1)
        Game.createItem(410, 1, stairPos)
    elseif item.actionid == 50019 and item.itemid == 1946 and not magicWall and stair and stair.itemid == 410 then
        stair:remove()
        Game.createItem(407, 1, tilePos)
        Game.createItem(1498, 1, magicwallPos)
        item:transform(item.itemid - 1)
    else
        player:sendCancelMessage("Sorry, not possible.")
    end
    
    return true
end
