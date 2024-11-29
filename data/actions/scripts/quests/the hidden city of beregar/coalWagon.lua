function att_pos(atual_position, side)
	local new_position = {x = atual_position.x, y = atual_position.y, z = atual_position.z}

	if side == "right" then
		new_position.x = new_position.x + 3
	elseif side == "left" then
		new_position.x = new_position.x - 3
	end

	return new_position
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
	local side

	if item:getId() == 7131 then
		side = "right"	
	elseif item:getId() == 10037 then
		side = "left"
	else
		return false
	end

	if item:getPosition().x == 32717 and item:getId() == 7131 then
		cid:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to fill this wagon with coal before move again.")
	elseif item:getPosition().x == 32699 and item:getId() == 10037 then
		cid:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to fill this wagon with coal before move again.")
	else
		local new_position = att_pos(item:getPosition(), side)
		item:moveTo(new_position)
	end

	--doSendMagicEffect(new_position, 10)
	--else doCreatureSay(cid, "Zzz Dont working.", TALKTYPE_ORANGE_1)
	return true
end