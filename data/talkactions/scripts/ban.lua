local banDays = 7

function onSay(player, words, param)
	if not player:getGroup():getAccess() then
		return true
	end

	local name = param
	local reason = ''

	local separatorPos = param:find(',')
	if separatorPos then
		name = param:sub(0, separatorPos - 1)
		reason = string.trim(param:sub(separatorPos + 1))
	end

	local accountId = getAccountNumberByPlayerName(name)
	if accountId == 0 then
		return false
	end

	local resultId = db.storeQuery("SELECT 1 FROM `account_bans` WHERE `account_id` = " .. accountId)
	local result_name = db.storeQuery("SELECT 1 FROM `players_ban` WHERE `name` = " .. db.escapeString(name))
	if resultId ~= false then
		print("resultId true")
		result.free(result_name)
		return false
	end
	
	local timeNow = os.time()
	db.query("INSERT INTO `account_bans` (`account_id`, `reason`, `banned_at`, `expires_at`, `banned_by`) VALUES (" ..
			accountId .. ", " .. db.escapeString(reason) .. ", " .. timeNow .. ", " .. timeNow + (banDays * 86400) .. ", " .. player:getGuid() .. ")")

	local target = Player(name)
	if target then
		db.query("INSERT INTO `players_ban` (`id`, `name`, `account_id`, `reason`, `banned_at`, `expires_at`, `banned_by`) VALUES (" ..
		target:getId() .. ", '" .. target:getName() .. "', " .. accountId .. ", '".. db.escapeString(reason) .. "', " .. timeNow .. ", " .. timeNow + (banDays * 86400) .. ", '" .. player:getName() .. "')")

		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, target:getName() .. " has been banned.")
		target:remove()
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, name .. " has been banned.")
	end

	
	
	
end
