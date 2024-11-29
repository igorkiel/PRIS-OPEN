function onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end

    local wagon_final = Position(32692, 31496, 11)
    local wagon_final_ID = Tile(wagon_final):getItemById(7132)

    if wagon_final_ID then
        creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Use the wagon on the center of this room first.")
        return false
    end

    local itemPosition = Position(32699, 31495, 11)
    local itemID = Tile(itemPosition):getItemById(8641)

    if itemID then
        itemID:transform(8642)
        local effectPositions = {
            Position(32694, 31495, 10),
            Position(32695, 31495, 10),
            Position(32696, 31495, 10),
            Position(32697, 31495, 11),
            Position(32699, 31495, 11)
        }

        for _, pos in ipairs(effectPositions) do
            pos:sendMagicEffect(320)
        end
        
        local lever_pos = Position(32693, 31496, 11)
        local lever_ID = Tile(lever_pos):getItemById(10044)
        local lever_ID2 = Tile(lever_pos):getItemById(10045)

        if lever_ID then
            lever_ID:setActionId(46513)
            lever_ID:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)

        elseif lever_ID2 then
            lever_ID2:setActionId(46513)
            lever_ID2:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
        end

    end



	return true
end

