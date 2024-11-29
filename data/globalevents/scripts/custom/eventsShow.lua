local EventsList = {
    ["Sunday"] = {
  		{name = "SnowBall", time = "15:05"},
  		{name = "Battlefield", time = "15:00"},
  		{name = "SafeZone", time = "20:00"},
    },
    ["Monday"] = {
  		{name = "SnowBall", time = "12:54"},
  		{name = "Battlefield", time = "15:00"},
  		{name = "SafeZone", time = "20:00"},
    },
    ["Tuesday"] = {
  		{name = "SnowBall", time = "19:10"},
  		{name = "Battlefield", time = "15:00"},
  		{name = "SafeZone", time = "20:00"},
    },
    ["Wednesday"] = {
  		{name = "SnowBall", time = "10:00"},
  		{name = "Battlefield", time = "15:00"},
  		{name = "SafeZone", time = "20:00"},
    },
    ["Thursday"] = {
  		{name = "SnowBall", time = "10:00"},
  		{name = "Battlefield", time = "21:00"},
  		{name = "SafeZone", time = "20:00"},
    },
    ["Friday"] = {
  		{name = "SnowBall", time = "12:00"},
  		{name = "Battlefield", time = "15:00"},
  		{name = "SafeZone", time = "20:00"},
    },
    ["Saturday"] = {
  		{name = "SnowBall", time = "12:00"},
  		{name = "Battlefield", time = "15:00"},
  		{name = "SafeZone", time = "20:00"},
    },
}

local position = Position(32364, 32232, 7)

function onThink(interval, lastExecution)
	local spectators = Game.getSpectators(position, false, true, 7, 7, 5, 5)
	local event = EventsList[os.date("%A")]
	for a, b in pairs(event) do
		local eventTime = hourToNumber(b.time)
		local realTime = hourToNumber(os.date("%H:%M:%S"))
		if eventTime >= realTime then
			if #spectators > 0 then
				for i = 1, #spectators do
					local tile = Tile(position)
					if tile then
						local item = tile:getItemById(1387)
						if item then
							if item:getActionId() == Bosses.actionIdTp then
								spectators[i]:say("[BOSS] ".. Bosses:getBossName() .."!", TALKTYPE_MONSTER_SAY, false, spectators[i], position)
								position:sendMagicEffect(56)
								position:sendMagicEffect(57)
							else
								spectators[i]:say("Participe agora\ndo evento!", TALKTYPE_MONSTER_SAY, false, spectators[i], position)
								position:sendMagicEffect(56)
								position:sendMagicEffect(57)
							end
							return true
						else
							spectators[i]:say("Pr�ximo evento:\n"..b.name.." �s "..b.time..".", TALKTYPE_MONSTER_SAY, false, spectators[i], position)
							position:sendMagicEffect(40)
							return true
						end
					end
				end
        	end
	    end
 	end
	return true
end
