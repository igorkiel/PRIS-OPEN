function onUse(player, item, fromPosition, target, toPosition)
    local switchPositions = {
        {pos = Position(32476, 31900, 6), expectedItemId = 1946},
        {pos = Position(32477, 31900, 6), expectedItemId = 1946},
        {pos = Position(32478, 31900, 6), expectedItemId = 1945},
        {pos = Position(32479, 31900, 6), expectedItemId = 1945},
        {pos = Position(32480, 31900, 6), expectedItemId = 1946},
        {pos = Position(32481, 31900, 6), expectedItemId = 1945}
    }
    local ladderPos = Position(32477, 31905, 6)

    -- print("Player used the item with actionid:", item.actionid, "and itemid:", item.itemid)

    if item.actionid == 52002 and item.itemid == 1945 then
        -- print("Checking switch positions...")
        local correctSwitches = true

        for i, switch in ipairs(switchPositions) do
            local tile = Tile(switch.pos)
            if tile then
                local currentSwitch = tile:getTopVisibleThing()
                if not currentSwitch or currentSwitch:getId() ~= switch.expectedItemId then
                    -- print(string.format("Switch at position: (%d, %d, %d) has itemid: %d. Expected itemid: %d", switch.pos.x, switch.pos.y, switch.pos.z, currentSwitch and currentSwitch:getId() or 0, switch.expectedItemId))
                    correctSwitches = false
                    break
                else
                    -- print(string.format("Switch at position: (%d, %d, %d) has the correct itemid: %d", switch.pos.x, switch.pos.y, switch.pos.z, currentSwitch:getId()))
                end
            else
                -- print(string.format("Tile not found at position: (%d, %d, %d)", switch.pos.x, switch.pos.y, switch.pos.z))
                correctSwitches = false
                break
            end
        end

        if correctSwitches then
            -- print("All switches are correct. Creating ladder and transforming item.")
            Game.createItem(1386, 1, ladderPos)
            item:transform(item.itemid + 1)
        else
            -- print("Switches are not in the correct positions.")
        end
    elseif item.actionid == 52002 and item.itemid == 1946 then
        -- print("Removing ladder and transforming item back.")
        local ladderItem = Tile(ladderPos):getItemById(1386)
        if ladderItem then
            ladderItem:remove()
            -- print("Ladder removed.")
        else
            -- print("Ladder not found.")
        end
        item:transform(item.itemid - 1)
    else
        -- print("Actionid or itemid do not match expected values.")
        return false
    end

    return true
end
