function onUse(cid, item, fromPosition, itemEx, toPosition)
	if item.itemid == 28164 then ---<  change 
		doPlayerAddBlessing(cid, 1) 
		doPlayerAddBlessing(cid, 2) 
		doPlayerAddBlessing(cid, 3) 
		doPlayerAddBlessing(cid, 4) 
		doPlayerAddBlessing(cid, 5)
        doSendMagicEffect(getPlayerPosition(cid), CONST_ME_MAGIC_BLUE)		
		doRemoveItem(item.uid, 1)
	end
return true
end