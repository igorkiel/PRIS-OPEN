function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local power1Pos = Position({x = 32613, y = 32220, z = 10})
    local barrelPos = Position({x = 32614, y = 32209, z = 10})
    local wallPos = Position({x = 32614, y = 32205, z = 10})
    local stonePos = Position({x = 32614, y = 32206, z = 10})
    local burnPos = Position({x = 32615, y = 32221, z = 10})

    local power1 = Tile(power1Pos)
    local barrel = Tile(barrelPos)
    local wall = Tile(wallPos)
    local stone = Tile(stonePos)

    if item.itemid == 1945 then
        if power1 and power1:getItemById(2166) then
            if wall and wall:getItemById(1025) then
                if stone and stone:getItemById(1304) then
                    if barrel and barrel:getItemById(1774) then
                        power1:getItemById(2166):transform(1487)
                        wall:getItemById(1025):remove()
                        stone:getItemById(1304):transform(1025)
                        Game.createItem(1487, 1, burnPos)
                    end
                end
            end
        end
    end

    item:transform(item.itemid == 1945 and 1946 or 1945)
    return true
end
