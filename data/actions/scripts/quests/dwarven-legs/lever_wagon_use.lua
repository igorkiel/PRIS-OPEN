
function onUse(cid, item, fromPosition, itemEx, toPosition)
    local cave_north = {
        ["lever1"] = {sqm = Position(32692, 31454, 13), item = 7126}, -- lever 2
        ["lever2"] = {sqm = Position(32687, 31453, 13), item = 7125}, -- lever 3
        ["lever3"] = {sqm = Position(32682, 31456, 13), item = 7121},-- lever 4
        ["lever4"] = {sqm = Position(32690, 31466, 13), item = 7125},-- lever 9
        ["lever5"] = {sqm = Position(32684, 31465, 13), item = 7122}, -- lever 10
        ["lever6"] = {sqm = Position(32688, 31470, 13), item = 7124}, -- lever 11
    }

    local cave_north_east = {
        ["lever1"] = {sqm = Position(32692, 31454, 13), item = 7122}, -- lever 2
        ["lever2"] = {sqm = Position(32692, 31454, 13), item = 7122}, -- lever 2
        ["lever3"] = {sqm = Position(32687, 31453, 13), item = 7125}, -- lever 3
        ["lever4"] = {sqm = Position(32682, 31456, 13), item = 7121},-- lever 4
        ["lever5"] = {sqm = Position(32690, 31466, 13), item = 7125},-- lever 9
        ["lever6"] = {sqm = Position(32684, 31465, 13), item = 7122}, -- lever 10
        ["lever7"] = {sqm = Position(32688, 31470, 13), item = 7124}, -- lever 11
    }

    local cave_north_east2 = {
        ["lever1"] = {sqm = Position(32696, 31454, 13), item = 7123}, -- lever 2
        ["lever2"] = {sqm = Position(32692, 31460, 13), item = 7123}, -- lever 2
        ["lever3"] = {sqm = Position(32688, 31470, 13), item = 7121}, -- lever 3
    }



    local north_allLeversCorrect = true
    for _, lever in pairs(cave_north) do
        local tile = Tile(lever.sqm)
        if tile then
            local item = tile:getItemById(lever.item)
            if not item then
                north_allLeversCorrect = false
                break
            end
        else
            north_allLeversCorrect = false
            break
        end
    end

    local north_east_allLeversCorrect = true
    for _, lever in pairs(cave_north_east) do
        local tile = Tile(lever.sqm)
        if tile then
            local item = tile:getItemById(lever.item)
            if not item then
                north_east_allLeversCorrect = false
                break
            end
        else
            north_east_allLeversCorrect = false
            break
        end
    end

    local north_east_allLeversCorrect2 = true
    for _, lever in pairs(cave_north_east2) do
        local tile = Tile(lever.sqm)
        if tile then
            local item = tile:getItemById(lever.item)
            if not item then
                north_east_allLeversCorrect2 = false
                break
            end
        else
            north_east_allLeversCorrect2 = false
            break
        end
    end


    if north_allLeversCorrect then
        cid:teleportTo(Position(32702, 31451, 15))
    elseif north_east_allLeversCorrect then
        cid:teleportTo(Position(32722, 31489, 15))

    elseif north_east_allLeversCorrect2 then
        cid:teleportTo(Position(32722, 31489, 15)) 
    else
        cid:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to fix the path where the wagon will pass before.")
    end
    return true
end
