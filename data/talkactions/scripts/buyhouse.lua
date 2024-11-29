function onSay(player, words, param)
	local housePrice = configManager.getNumber(configKeys.HOUSE_PRICE)
	if housePrice == -1 then
		return true
	end

	if not player:isPremium() then
		player:sendCancelMessage("You need a premium account.")
		return false
	end

	local position = player:getPosition()
	position:getNextPosition(player:getDirection())

	local tile = Tile(position)
	local house = tile and tile:getHouse()
	if not house then
		player:sendCancelMessage("You have to be looking at the door of the house you would like to buy.")
		return false
	end

	if house:getOwnerGuid() > 0 then
		player:sendCancelMessage("This house already has an owner.")
		return false
	end

	if player:getHouse() then
		player:sendCancelMessage("You are already the owner of a house.")
		return false
	end

	-- Verificar se a casa é uma guildhall
	if house:isGuildHall() then
		local guild = player:getGuild()
		if not guild then
			player:sendCancelMessage("You must be in a guild to purchase a guildhall.")
			return false
		end

		-- Verificar se o jogador é o líder da guilda
		local leaderName = guild:getLeaderName()
		if player:getName() ~= leaderName then
			player:sendCancelMessage("Only the leader of the guild can purchase a guildhall.")
			return false
		end

		if not player:removeMoney(price) then
			player:sendCancelMessage("You do not have gold enough to buy this guild hall.")
			return false
		end


	end

	local price = house:getTileCount() * housePrice
	local house_scroll = 28316
	if not house:isGuildHall() then
		if not player:removeItem(house_scroll, 1) then
			if not player:removeMoney(price) then
				player:sendCancelMessage("You do not have a house scroll or gold enough to buy this house.")
				return false
			end
		end
	end

	house:setOwnerGuid(player:getGuid())
	player:sendTextMessage(MESSAGE_INFO_DESCR, "You have successfully bought this house, be sure to have the money for the rent in the bank.")
	return false
end
