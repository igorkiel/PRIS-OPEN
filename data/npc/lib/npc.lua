-- Including the Advanced NPC System
dofile('data/npc/lib/npcsystem/npcsystem.lua')
dofile('data/npc/lib/npcsystem/customModules.lua')

isPlayerPremiumCallback = Player.isPremium

function randomPos(city)
	local destinations = {
		["venore"] = {position = Position(math.random(32951, 32958), math.random(32020, 32025), 6), sqm = Position(32956, 32022, 6), sqm2 = Position(32956, 32022, 6), sqm3 = Position(32956, 32022, 6)},
        ["thais"] = {position = Position(math.random(32307, 32313), math.random(32208, 32213), 6), sqm = Position(32310, 32212, 6), sqm2 = Position(32310, 32212, 6), sqm3 = Position(32310, 32212, 6)},
        ["carlin"] = { position = Position(math.random(32384, 32390), math.random(31819, 31823), 6), sqm = Position(32385, 31821, 6), sqm2 = Position(32390, 31821, 6), sqm3 = Position(32390, 31821, 6)},
        ["ab'dendriel"] = {position = Position(math.random(32732, 32736), math.random(31665, 31673), 6), sqm = Position(32737, 31666, 5), sqm2 = Position(32734, 31666, 6), sqm3 = Position(32734, 31672, 6)},
        ["edron"] = {position = Position(math.random(33171, 33180), math.random(31762, 31766), 6), sqm = Position(33172, 31764, 6), sqm2 = Position(33178, 31764, 6), sqm3 = Position(33180, 31762, 6)},
        ["port hope"] = {position = Position(math.random(32525, 32533), math.random(32782, 32786), 6), sqm = Position(32525, 32784, 6), sqm2 = Position(32531, 32784, 6), sqm3 = Position(32525, 32786, 6)},
        ["svargrond"] = {position = Position(math.random(32339, 32344), math.random(31107, 31111), 6), sqm = Position(32339, 31109, 6), sqm2 = Position(32343, 31109, 6), sqm3 = Position(32343, 31109, 6)},
        ["liberty bay"] = {position = Position(math.random(32282, 32288), math.random(32888, 32894), 6), sqm = Position(32285, 32893, 6), sqm2 = Position(32285, 32893, 6), sqm3 = Position(32285, 32893, 6)}, 
        ["ankrahmun"] = {position = Position(math.random(33089, 33095), math.random(32882, 32886), 6), sqm = Position(33089, 32882, 6), sqm2 = Position(33095, 32882, 6), sqm3 = Position(33092, 32885, 6)},
        ["darashia"] = {position = Position(math.random(33286, 33291), math.random(32479, 32483), 6), sqm = Position(33287, 32481, 6), sqm2 = Position(33287, 32481, 6), sqm3 = Position(33287, 32481, 6)},
		["yalahar"] = {position = Position(math.random(32815, 32819), math.random(31270, 31275), 6), sqm = Position(33287, 32481, 6), sqm2 = Position(33287, 32481, 6), sqm3 = Position(33287, 32481, 6)},
		["calassa"] = {position = Position(math.random(31743, 31750), math.random(32715, 32719), 6), sqm = Position(31745, 32717, 6), sqm2 = Position(31751, 32717, 6), sqm3 = Position(31751, 32717, 6)},
		["goroma"] = {position = Position(math.random(31991, 31997), math.random(32563, 32568), 6), sqm = Position(31994, 32567, 6), sqm2 = Position(31994, 32567, 6), sqm3 = Position(31994, 32567, 6)}
	}

	if destinations[city] then
        while true do
            local destination = destinations[city].position
            if destinations[city].sqm ~= destination and destinations[city].sqm2 ~= destination and destinations[city].sqm3 ~= destination then
				return destination
            end
        end
    end
end

function randomPosCarpet(city)
	local destinations = {
		["darashia"] = {position = Position(math.random(33267, 33272), math.random(32439, 32442), 6), sqm = Position(32956, 32022, 6), sqm2 = Position(32956, 32022, 6), sqm3 = Position(32956, 32022, 6)},
        ["edron"] = {position = Position(math.random(33190, 33195), math.random(31782, 31786), 3), sqm = Position(32310, 32212, 6), sqm2 = Position(32310, 32212, 6), sqm3 = Position(32310, 32212, 6)},
        ["femor hills"] = { position = Position(math.random(32533, 32538), math.random(31836, 31839), 4), sqm = Position(32385, 31821, 6), sqm2 = Position(32390, 31821, 6), sqm3 = Position(32390, 31821, 6)},
        ["svargrond"] = {position = Position(math.random(32249, 32255), math.random(31097, 31100), 4), sqm = Position(33172, 31764, 6), sqm2 = Position(33178, 31764, 6), sqm3 = Position(33180, 31762, 6)},
		["eclipse"] = {position = Position(math.random(32656, 32663), math.random(31911, 31917), 0), sqm = Position(32661, 31911, 0), sqm2 = Position(32661, 31911, 0), sqm3 = Position(32661, 31911, 0)}
	}

	if destinations[city] then
        while true do
            local destination = destinations[city].position
            if destinations[city].sqm ~= destination and destinations[city].sqm2 ~= destination and destinations[city].sqm3 ~= destination then
				return destination
            end
        end
    end
end

function msgcontains(message, keyword)
	local message, keyword = message:lower(), keyword:lower()
	if message == keyword then
		return true
	end

	return message:find(keyword) and not message:find('(%w+)' .. keyword)
end

function doNpcSellItem(cid, itemid, amount, subType, ignoreCap, inBackpacks, backpack)
	local amount = amount or 1
	local subType = subType or 0
	local item = 0
	if ItemType(itemid):isStackable() then
		if inBackpacks then
			stuff = Game.createItem(backpack, 1)
			item = stuff:addItem(itemid, math.min(100, amount))
		else
			stuff = Game.createItem(itemid, math.min(100, amount))
		end
		return Player(cid):addItemEx(stuff, ignoreCap) ~= RETURNVALUE_NOERROR and 0 or amount, 0
	end

	local a = 0
	if inBackpacks then
		local container, b = Game.createItem(backpack, 1), 1
		for i = 1, amount do
			local item = container:addItem(itemid, subType)
			if table.contains({(ItemType(backpack):getCapacity() * b), amount}, i) then
				if Player(cid):addItemEx(container, ignoreCap) ~= RETURNVALUE_NOERROR then
					b = b - 1
					break
				end

				a = i
				if amount > i then
					container = Game.createItem(backpack, 1)
					b = b + 1
				end
			end
		end
		return a, b
	end

	for i = 1, amount do -- normal method for non-stackable items
		local item = Game.createItem(itemid, subType)
		if Player(cid):addItemEx(item, ignoreCap) ~= RETURNVALUE_NOERROR then
			break
		end
		a = i
	end
	return a, 0
end

local func = function(cid, text, type, e, pcid)
	if Player(pcid):isPlayer() then
		local creature = Creature(cid)
		creature:say(text, type, false, pcid, creature:getPosition())
		e.done = true
	end
end

function doCreatureSayWithDelay(cid, text, type, delay, e, pcid)
	if Player(pcid):isPlayer() then
		e.done = false
		e.event = addEvent(func, delay < 1 and 1000 or delay, cid, text, type, e, pcid)
	end
end

function doPlayerTakeItem(cid, itemid, count)
	local player = Player(cid)
	if player:getItemCount(itemid) < count then
		return false
	end

	while count > 0 do
		local tempcount = 0
		if ItemType(itemid):isStackable() then
			tempcount = math.min (100, count)
		else
			tempcount = 1
		end

		local ret = player:removeItem(itemid, tempcount)
		if ret then
			count = count - tempcount
		else
			return false
		end
	end

	if count ~= 0 then
		return false
	end
	return true
end

function doPlayerSellItem(cid, itemid, count, cost)
	local player = Player(cid)
	if player:removeItem(itemid, count) then
		if not player:addMoney(cost) then
			error('Could not add money to ' .. player:getName() .. '(' .. cost .. 'gp)')
		end
		return true
	end
	return false
end

function doPlayerBuyItemContainer(cid, containerid, itemid, count, cost, charges)
	local player = Player(cid)
	if not player:removeTotalMoney(cost) then
		return false
	end

	for i = 1, count do
		local container = Game.createItem(containerid, 1)
		for x = 1, ItemType(containerid):getCapacity() do
			container:addItem(itemid, charges)
		end

		if player:addItemEx(container, true) ~= RETURNVALUE_NOERROR then
			return false
		end
	end
	return true
end

function getCount(string)
	local b, e = string:find("%d+")
	return b and e and tonumber(string:sub(b, e)) or -1
end

function Player.removeTotalMoney(self, amount)
    local moneyCount = self:getMoney()
    local bankCount = self:getBankBalance()

    if amount <= moneyCount then
        self:removeMoney(amount)
        return true

    elseif amount <= (moneyCount + bankCount) then
        if moneyCount ~= 0 then
            self:removeMoney(moneyCount)
            local remains = amount - moneyCount
            self:setBankBalance(bankCount - remains)
            self:sendTextMessage(MESSAGE_INFO_DESCR, ("Paid %d from inventory and %d gold from bank account. Your account balance is now %d gold."):format(moneyCount, amount - moneyCount, self:getBankBalance()))
            return true
        else
            self:setBankBalance(bankCount - amount)
            self:sendTextMessage(MESSAGE_INFO_DESCR, ("Paid %d gold from bank account. Your account balance is now %d gold."):format(amount, self:getBankBalance()))
            return true
        end
    end
    return false
end


function Player.getTotalMoney(self)
	return self:getMoney() + self:getBankBalance()
end
