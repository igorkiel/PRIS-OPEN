function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.TibiaTales.ultimateBoozeQuest) == 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Done! report your mission to Boozer.")
		player:setStorageValue(Storage.TibiaTales.ultimateBoozeQuest, 2)
	end
	
	player:say("GULP, GULP, GULP", TALKTYPE_MONSTER_SAY, false, 0, toPosition)
	toPosition:sendMagicEffect(CONST_ME_SOUND_YELLOW)
	return true
end