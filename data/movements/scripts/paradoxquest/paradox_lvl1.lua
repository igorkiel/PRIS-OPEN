local function ChangeBack()
    local position = Position(32478, 31902, 7)
    local tile = Tile(position)
    if tile then
        local item = tile:getItemById(1385) -- ID do item transformado
        if item then
            item:transform(1304) -- ID do item original
            position:sendMagicEffect(CONST_ME_MAGIC_BLUE)
            -- print("Item transformed back to original.")
        else
            -- print("Item not found to transform back.")
        end
    else
        -- print("Tile not found for position:", position)
    end
end

function onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true
    end

    -- print("Player stepped on tile with actionid:", item.actionid)

    if item.actionid == 50003 then
        local tile1Pos = Position(32478, 31906, 7)
        local tile2Pos = Position(32478, 31902, 7)

        local tile1 = Tile(tile1Pos)
        local tile2 = Tile(tile2Pos)

        if tile1 and tile2 then
            -- print("Tiles found for required positions.")
            local item1 = tile1:getItemById(2782)
            local item2 = tile2:getItemById(1304)

            if item1 and item2 then
                -- print("Required items found on tiles.")
                addEvent(ChangeBack, 45000)
                item2:transform(1385)
                tile2Pos:sendMagicEffect(CONST_ME_MAGIC_RED)
                -- print("Item transformed and event scheduled.")
            else
                -- print("Required items not found on tiles.")
                player:sendCancelMessage("Action cannot be completed because the required items are not present.")
            end
        else
            -- print("Required tiles not found.")
            player:sendCancelMessage("Tile not found.")
        end
    else
        -- print("Action ID does not match 50003.")
    end

    return true
end
