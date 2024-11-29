function get_teleport(pos, player)
    local positions = {
        [Position(33195, 33002, 14)] = {item = 2352, has_item = Position(33178, 33015, 14), no_has_item = Position(33206, 32980, 14)}, -- Omruc (Crystal Arrow)
        [Position(33103, 32590, 15)] = {item = 2354, has_item = Position(33126, 32591, 15), no_has_item = Position(33073, 32605, 15)}, -- Dipthrah (Ornamented Ankh)
        [Position(33191, 32959, 15)] = {item = 2353, has_item = Position(33174, 32934, 15), no_has_item = Position(33183, 32755, 15)}, -- Mahrdis (Burning Heart) -- AQUI
        [Position(33174, 32694, 14)] = {item = 2350, has_item = Position(33182, 32714, 14), no_has_item = Position(33263, 32670, 13)}, -- Morguthis (Sword Hilt)
        [Position(33073, 32781, 14)] = {item = 2348, has_item = Position(33051, 32776, 14), no_has_item = Position(33120, 32809, 15)}, -- Rahemos (Ancient Rune)
        [Position(33396, 32852, 14)] = {item = 2351, has_item = Position(33349, 32827, 14), no_has_item = Position(33366, 32853, 14)}, -- Thalas (Cobrafang Dagger) -- AQUI
        [Position(33116, 32656, 15)] = {item = 2349, has_item = Position(33145, 32665, 15), no_has_item = Position(33180, 32664, 15)}, -- Vashresamun (Blue Note)

        [Position(33179, 32890, 11)] = {item = 9999, has_item = Position(33206, 32980, 14), no_has_item = Position(32696, 31454, 13)}, -- Ashmunrah (final boss)

    }

    for k, v in pairs(positions) do
        if k.x == pos.x and k.y == pos.y and k.z == pos.z then
            local destination = Position(32210, 32300, 6)
            if player:getItemCount(v.item) > 0 then
                destination = v.has_item
            else
                destination = v.no_has_item
            end
            player:teleportTo(destination)
            return true
        end
    end
end


function onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end

    local itemPos = item:getPosition()
    get_teleport(itemPos, player)

	return true
end

