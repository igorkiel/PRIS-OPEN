
function onUse(cid, item, fromPosition, itemEx, toPosition)
    if item:getActionId() == 46513 then
        if item:getId() == 10044 then
            item:transform(10045)
        elseif item:getId() == 10045 then
            item:transform(10044)
        end
        item:setActionId(0)

        local position = Position(32692, 31496, 11)
        local wagon = Game.createItem(7132, 1, position)
        if wagon then
            wagon:setActionId(46517)
        end

    end

	return true
end