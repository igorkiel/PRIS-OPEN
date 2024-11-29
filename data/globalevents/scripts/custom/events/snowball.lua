function startGame(rounds)
	if rounds == 0 then
		if #CACHE_GAMEPLAYERS < SNOWBALL.minPlayers then
			for _, players in ipairs(CACHE_GAMEPLAYERS) do
				local player = Player(players)
				if player then
					player:teleportTo(player:getTown():getTemplePosition())
				end
			end
			broadcastMessage(SNOWBALL.prefixo .. SNOWBALL.mensagemEventoFaltaPlayer:format(SNOWBALL.minPlayers))
		else
			for _, players in ipairs(CACHE_GAMEPLAYERS) do
				local player = Player(players)
                if player then
                    player:setStorageValue(10109, 0)
                    player:setStorageValue(10108, SNOWBALL.muniInicial)
                    player:setStorageValue(STORAGEVALUE_EVENTS, 1)
                    player:teleportTo(CACHE_GAMEAREAPOSITIONS[math.random(1, #CACHE_GAMEAREAPOSITIONS)])
                end
			end
			broadcastMessage(SNOWBALL.prefixo .. SNOWBALL.mensagemInicioEvento)
			addEvent(terminarEvento, SNOWBALL.duracaoEvento * 60 * 1000)
		end

		local tpItem = getTileItemById(SNOWBALL.posTpEntrarEvento, 1387)
		if tpItem then
			Item(tpItem.uid):remove(1)
		end
		return true
	end

    -- Debug Logs
    print("DEBUG: Rounds:", rounds)
    print("DEBUG: Players needed:", SNOWBALL.minPlayers)
    print("DEBUG: Current players:", #CACHE_GAMEPLAYERS)
    print("DEBUG: Players missing:", SNOWBALL.minPlayers - #CACHE_GAMEPLAYERS)

	if #CACHE_GAMEPLAYERS < SNOWBALL.minPlayers then
		broadcastMessage(SNOWBALL.prefixo .. SNOWBALL.mensagemEsperandoIniciar:format(rounds, SNOWBALL.minPlayers - #CACHE_GAMEPLAYERS))
	else
		broadcastMessage(SNOWBALL.prefixo .. SNOWBALL.mensagemMinutosFaltam:format(rounds))
	end
	return addEvent(startGame, 60 * 1000, rounds - 1)
end


function onThink(interval)
	if SNOWBALL.days[os.date("%A")] then
		local hrs = tostring(os.date("%X")):sub(1, 5)
		if isInArray(SNOWBALL.days[os.date("%A")], hrs) then
			CACHE_GAMEPLAYERS = {}
			broadcastMessage(SNOWBALL.prefixo .. SNOWBALL.mensagemEventoAberto)
			local EventTeleport = Game.createItem(1387, 1, SNOWBALL.posTpEntrarEvento)
			EventTeleport:setActionId(10101)
			addEvent(startGame, 60 * 1000, SNOWBALL.duracaoEspera)
		end
	end
	return true
end
