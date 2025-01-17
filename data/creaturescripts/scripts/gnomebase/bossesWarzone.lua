local bosses = {
	['deathstrike'] = {status = 2, storage = Storage.BigfootBurden.Warzone1Reward},
	['gnomevil'] = {status = 3, storage = Storage.BigfootBurden.Warzone2Reward},
	['abyssador'] = {status = 4, storage = Storage.BigfootBurden.Warzone3Reward},
}

function onKill(creature, target)
	if not target or not target:isMonster() then
        return true
    end
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	local bossConfig = bosses[targetMonster:getName():lower()]
	if not bossConfig then
		return true
	end

	for pid, _ in pairs(targetMonster:getDamageMap()) do
		local attackerPlayer = Player(pid)
		if attackerPlayer then
			if attackerPlayer:getStorageValue(Storage.BigfootBurden.WarzoneStatus) < bossConfig.status then
				attackerPlayer:setStorageValue(Storage.BigfootBurden.WarzoneStatus, bossConfig.status)
			end

			attackerPlayer:setStorageValue(bossConfig.storage, 1)
		end
	end
end