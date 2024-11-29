function onUse(cid, item, fromPosition, itemEx, toPosition)
	if cid:getStorageValue(46785) == 1 then
        cid:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Questlog Updated.")
        cid:setStorageValue(46785, 2)
		cid:addItem(1966, 1)
	end
	
	return true
end