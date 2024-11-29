function onUse(cid, item, fromPosition, itemEx, toPosition)
local p = {x = 32624, y = 31514, z = 9} -- 32694, 31495, 11

local rock_pos = Tile(Position(32619, 31515, 9))
	if not rock_pos:getItemById(5709) then
		doTeleportThing(cid,p)
		doSendMagicEffect(p,10)
		local new_rock_pos = Position(32619, 31515, 9)
		local new_rock = Game.createItem(5709, 1, new_rock_pos)
		if new_rock then
			new_rock:setActionId(50114)
		end
		
	else
		doCreatureSay(cid, "Zzz Dont working.", TALKTYPE_ORANGE_1)
		return true
	end

end

--[[
local position = Position(32692, 31496, 11)
        local wagon = Game.createItem(7132, 1, position)
        if wagon then
            wagon:setActionId(46514)
        end
		]]