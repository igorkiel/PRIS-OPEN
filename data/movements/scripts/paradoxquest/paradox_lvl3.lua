local LadderId = 1386
local LadderPos = Position(32478, 31904, 5)

function onStepIn(creature, item, position, fromPosition)
    if creature:isPlayer() or creature:isMonster() then
        Game.createItem(LadderId, 1, LadderPos)
        -- print("Ladder created at position:", LadderPos)
    end
    return true
end

function onStepOut(creature, item, position, toPosition)
    if creature:isPlayer() or creature:isMonster() then
        local ladderItem = Tile(LadderPos):getItemById(LadderId)
        if ladderItem then
            ladderItem:remove()
            -- print("Ladder removed from position:", LadderPos)
        else
            -- print("No ladder found at position:", LadderPos)
        end
    end
    return true
end
