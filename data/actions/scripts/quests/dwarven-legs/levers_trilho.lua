function get_sqm(pos)
    local positions = {
        [Position(32697, 31455, 13)] = {sqm = Position(32696, 31454, 13)}, -- lever 1
        [Position(32691, 31453, 13)] = {sqm = Position(32692, 31454, 13)}, -- lever 2
        [Position(32686, 31453, 13)] = {sqm = Position(32687, 31453, 13)}, -- lever 3
        [Position(32683, 31456, 13)] = {sqm = Position(32682, 31456, 13)}, -- lever 4
        [Position(32687, 31458, 13)] = {sqm = Position(32688, 31457, 13)}, -- lever 5
        [Position(32693, 31459, 13)] = {sqm = Position(32692, 31460, 13)}, -- lever 6
        [Position(32696, 31463, 13)] = {sqm = Position(32696, 31462, 13)}, -- lever 7
        [Position(32696, 31466, 13)] = {sqm = Position(32695, 31465, 13)}, -- lever 8
        [Position(32691, 31465, 13)] = {sqm = Position(32690, 31466, 13)}, -- lever 9
        [Position(32685, 31466, 13)] = {sqm = Position(32684, 31465, 13)}, -- lever 10
        [Position(32689, 31471, 13)] = {sqm = Position(32688, 31470, 13)}, -- lever 11
    }

    for k, v in pairs(positions) do
        if k.x == pos.x and k.y == pos.y and k.z == pos.z then
            return v.sqm
        end
    end

    return nil
end

function change_sqm(sqm)
    local sqm_change = {
        [Position(32696, 31454, 13)] = {item1 = 7123, item2 = 7122, item3 = 7121}, -- lever 1
        [Position(32692, 31454, 13)] = {item1 = 7126, item2 = 7122, item3 = 7121}, -- lever 2
        [Position(32687, 31453, 13)] = {item1 = 7126, item2 = 7125, item3 = 7124}, -- lever 3
        [Position(32682, 31456, 13)] = {item1 = 7126, item2 = 7121, item3 = 7123},-- lever 4
        [Position(32688, 31457, 13)] = {item1 = 7126, item2 = 7122, item3 = 7129},-- lever 5
        [Position(32692, 31460, 13)] = {item1 = 7126, item2 = 7123, item3 = 7129},-- lever 6
        [Position(32696, 31462, 13)] = {item1 = 7126, item2 = 7122, item3 = 7123},-- lever 7
        [Position(32695, 31465, 13)] = {item1 = 7126, item2 = 7122, item3 = 7129},-- lever 8
        [Position(32690, 31466, 13)] = {item1 = 7126, item2 = 7125, item3 = 7127},-- lever 9
        [Position(32684, 31465, 13)] = {item1 = 7126, item2 = 7122, item3 = 7125}, -- lever 10
        [Position(32688, 31470, 13)] = {item1 = 7121, item2 = 7124, item3 = 7129}, -- lever 11
    }

    for k, v in pairs(sqm_change) do
        if k.x == sqm.x and k.y == sqm.y and k.z == sqm.z then
            local tile = Tile(sqm)
            if tile then
                local item = tile:getItemById(v.item1) or tile:getItemById(v.item2) or tile:getItemById(v.item3)
                if item then
                    if item:getId() == v.item1 then
                        item:transform(v.item2) -- Change the item to item1
                    elseif item:getId() == v.item2 then
                        item:transform(v.item3) -- Change the item to item1
                    elseif item:getId() == v.item3 then
                        item:transform(v.item1) -- Change the item to item1
                    else
                        return false
                    end
                end
            end
            break
        end
    end



end


function onUse(cid, item, fromPosition, itemEx, toPosition)
    local sqm = get_sqm(toPosition)
    change_sqm(sqm)
    return true
end