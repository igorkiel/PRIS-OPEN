function onSay(player, words, param)
	-- Coletar as informações do jogador
	local playerLevel = player:getLevel()
	local expRate = Game.getExperienceStage(playerLevel)

	-- Obter as taxas de habilidades
	local fistRate = getSkillRate(player, SKILL_FIST)
	local clubRate = getSkillRate(player, SKILL_CLUB)
	local swordRate = getSkillRate(player, SKILL_SWORD)
	local axeRate = getSkillRate(player, SKILL_AXE)
	local distanceRate = getSkillRate(player, SKILL_DISTANCE)
	local shieldingRate = getSkillRate(player, SKILL_SHIELD)
	local fishingRate = getSkillRate(player, SKILL_FISHING)
	local magicRate = getSkillRate(player, SKILL_MAGLEVEL)
	local lootRate = configManager.getNumber(configKeys.RATE_LOOT)

	-- Enviar as informações ao jogador
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Server Info:"
		.. "\nExp rate: " .. expRate
		.. "\nFist fighting rate: " .. fistRate
		.. "\nClub fighting rate: " .. clubRate
		.. "\nSword fighting rate: " .. swordRate
		.. "\nAxe fighting rate: " .. axeRate
		.. "\nDistance fighting rate: " .. distanceRate
		.. "\nShielding rate: " .. shieldingRate
		.. "\nFishing rate: " .. fishingRate
		.. "\nMagic rate: " .. magicRate
		.. "\nLoot rate: " .. lootRate)
		
	return false
end
