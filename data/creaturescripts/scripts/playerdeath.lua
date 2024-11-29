local deathListEnabled = true
local maxDeathRecords = 5

function onDeath(player, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
	local playerId = player:getId()
	if nextUseStaminaTime[playerId] then
		nextUseStaminaTime[playerId] = nil
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are dead.")
	if not deathListEnabled then
		return
	end

	local byPlayer = 0
	local killerName
	if killer then
		if killer:isPlayer() then
			byPlayer = 1
		else
			local master = killer:getMaster()
			if master and master ~= killer and master:isPlayer() then
				killer = master
				byPlayer = 1
			end
		end
		killerName = killer:getName()
	else
		killerName = "field item"
	end

	local byPlayerMostDamage = 0
	local mostDamageKillerName
	if mostDamageKiller then
		if mostDamageKiller:isPlayer() then
			byPlayerMostDamage = 1
		else
			local master = mostDamageKiller:getMaster()
			if master and master ~= mostDamageKiller and master:isPlayer() then
				mostDamageKiller = master
				byPlayerMostDamage = 1
			end
		end
		mostDamageName = mostDamageKiller:getName()
	else
		mostDamageName = "field item"
	end

	local playerGuid = player:getGuid()
	db.query("INSERT INTO `player_deaths` (`player_id`, `time`, `level`, `killed_by`, `is_player`, `mostdamage_by`, `mostdamage_is_player`, `unjustified`, `mostdamage_unjustified`) VALUES (" .. playerGuid .. ", " .. os.time() .. ", " .. player:getLevel() .. ", " .. db.escapeString(killerName) .. ", " .. byPlayer .. ", " .. db.escapeString(mostDamageName) .. ", " .. byPlayerMostDamage .. ", " .. (lastHitUnjustified and 1 or 0) .. ", " .. (mostDamageUnjustified and 1 or 0) .. ")")
	local resultId = db.storeQuery("SELECT `player_id` FROM `player_deaths` WHERE `player_id` = " .. playerGuid)

	local deathRecords = 0
	local tmpResultId = resultId
	while tmpResultId ~= false do
		tmpResultId = result.next(resultId)
		deathRecords = deathRecords + 1
	end

	if resultId ~= false then
		result.free(resultId)
	end

	local limit = deathRecords - maxDeathRecords
	if limit > 0 then
		db.asyncQuery("DELETE FROM `player_deaths` WHERE `player_id` = " .. playerGuid .. " ORDER BY `time` LIMIT " .. limit)
	end

	if byPlayer == 1 then
		local targetGuild = player:getGuild()
		targetGuild = targetGuild and targetGuild:getId() or 0
		if targetGuild ~= 0 then
			local killerGuild = killer:getGuild()
			killerGuild = killerGuild and killerGuild:getId() or 0
			if killerGuild ~= 0 and targetGuild ~= killerGuild and isInWar(playerId, killer:getId()) then
				local warId = false
				resultId = db.storeQuery("SELECT `id` FROM `guild_wars` WHERE `status` = 1 AND ((`guild1` = " .. killerGuild .. " AND `guild2` = " .. targetGuild .. ") OR (`guild1` = " .. targetGuild .. " AND `guild2` = " .. killerGuild .. "))")
				if resultId ~= false then
					warId = result.getNumber(resultId, "id")
					result.free(resultId)
				end

				if warId ~= false then
					db.asyncQuery("INSERT INTO `guildwar_kills` (`killer`, `target`, `killerguild`, `targetguild`, `time`, `warid`) VALUES (" .. db.escapeString(killerName) .. ", " .. db.escapeString(player:getName()) .. ", " .. killerGuild .. ", " .. targetGuild .. ", " .. os.time() .. ", " .. warId .. ")")
				end
			end
		end

		-- Check for daily, weekly, and monthly kills
		local currentTime = os.time()
		local dayStart = currentTime - (currentTime % 86400)
		local weekStart = currentTime - (currentTime % (86400 * 7))
		local monthStart = currentTime - (currentTime % (86400 * 30))

		local dailyKills = db.storeQuery("SELECT COUNT(*) as count FROM `player_deaths` WHERE `killed_by` = " .. db.escapeString(killerName) .. " AND `time` >= " .. dayStart)
		local weeklyKills = db.storeQuery("SELECT COUNT(*) as count FROM `player_deaths` WHERE `killed_by` = " .. db.escapeString(killerName) .. " AND `time` >= " .. weekStart)
		local monthlyKills = db.storeQuery("SELECT COUNT(*) as count FROM `player_deaths` WHERE `killed_by` = " .. db.escapeString(killerName) .. " AND `time` >= " .. monthStart)

		local dailyCount = result.getNumber(dailyKills, "count")
		local weeklyCount = result.getNumber(weeklyKills, "count")
		local monthlyCount = result.getNumber(monthlyKills, "count")

		if dailyCount >= 2 or weeklyCount >= 10 or monthlyCount >= 20 then
			local banDays = 10
			local accountId = killer:getAccountId()
			local killer_id = killer:getGuid()
			local ban_reason = "Excessive Kills"
			local ban_system = 151

			local timeNow = os.time()
			db.query("INSERT INTO `account_bans` (`account_id`, `reason`, `banned_at`, `expires_at`, `banned_by`) VALUES (" ..
				accountId .. ", " .. db.escapeString(ban_reason) .. ", " .. timeNow .. ", " .. timeNow + (banDays * 86400) .. ", " .. ban_system .. ")")

			ban_system = "System"

			db.query("INSERT INTO `players_ban` (`id`, `name`, `account_id`, `reason`, `banned_at`, `expires_at`, `banned_by`) VALUES (" ..
				killer_id .. ", '" .. killerName .. "', " .. accountId .. ", '".. ban_reason .. "', " .. timeNow .. ", " .. timeNow + (banDays * 86400) .. ", '" .. ban_system .. "')")


			killer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have been banned for 10 days due to excessive kills.")
			killer:remove()
		end

		if dailyKills ~= false then
			result.free(dailyKills)
		end
		if weeklyKills ~= false then
			result.free(weeklyKills)
		end
		if monthlyKills ~= false then
			result.free(monthlyKills)
		end
	end
end
