local function setStoredOutfit(player, storedLookType, storedLookAddons, storedLookWings, storedLookAura, storedLookShader)
    local playerOutfit = player:getOutfit()
    
    if storedLookType > 0 then
        playerOutfit.lookType = storedLookType
    end
    if storedLookAddons > 0 then
        playerOutfit.lookAddons = storedLookAddons
    end
    if storedLookWings > 0 then
        playerOutfit.lookWings = storedLookWings
    end
    if storedLookAura > 0 then
        playerOutfit.lookAura = storedLookAura
    end
    if storedLookShader > 0 then
        playerOutfit.lookShader = storedLookShader
    end
    
    player:setOutfit(playerOutfit)
end



local events = {
	'TutorialCockroach',
	'ElementalSpheresOverlords',
	'BigfootBurdenVersperoth',
	'BigfootBurdenWarzone',
	'BigfootBurdenWeeper',
	'BigfootBurdenWiggler',
	'SvargrondArenaKill',
	'NewFrontierShardOfCorruption',
	'NewFrontierTirecz',
	'ServiceOfYalaharDiseasedTrio',
	'ServiceOfYalaharAzerus',
	'ServiceOfYalaharQuaraLeaders',
	'InquisitionBosses',
	'InquisitionUngreez',
	'KillingInTheNameOfKills',
	'MastersVoiceServants',
	'SecretServiceBlackKnight',
	'ThievesGuildNomad',
	'WotELizardMagistratus',
	'WotELizardNoble',
	'WotEKeeper',
	'WotEBosses',
	'WotEZalamon',
	'PlayerDeath',
	'AdvanceSave',
	'AdvanceRookgaard',
	'PythiusTheRotten',
	'DropLoot'
}


local function onMovementRemoveProtection(cid, oldPosition, time)
	local player = Player(cid)
	if not player then
		return true
	end

	local playerPosition = player:getPosition()
	if (playerPosition.x ~= oldPosition.x or playerPosition.y ~= oldPosition.y or playerPosition.z ~= oldPosition.z) or player:getTarget() or time <= 0 then
		player:setStorageValue(Storage.combatProtectionStorage, 0)
		return true
	end

	addEvent(onMovementRemoveProtection, 1000, cid, oldPosition, time - 1)
end

function onLogin(player)
    local playerId = player:getGuid()
    local serverName = configManager.getString(configKeys.SERVER_NAME)
    local loginStr = "Welcome to " .. serverName .. "!"

       --Relic Box Effects
       -- local light_level = Condition(CONDITION_LIGHT)
        if player:getStorageValue(8381) > 5 then
            local combat = Combat()
            combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
            combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)
            
            local condition = Condition(CONDITION_LIGHT)
            condition:setParameter(CONDITION_PARAM_LIGHT_LEVEL, player:getStorageValue(8381))
            condition:setParameter(CONDITION_PARAM_LIGHT_COLOR, 215)
           -- condition:setParameter(CONDITION_PARAM_TICKS, (60 * 33 + 10) * 1000)
            combat:addCondition(condition)
     
            -- combat:execute(creature, variant)
        end
       -- p->addStorageValue(8381, 9);


    
       




       ------
    
    if player:getLastLoginSaved() <= 0 then
        loginStr = loginStr .. " Please choose your outfit."
        player:sendOutfitWindow()

        local startStorageKey = 110000
        local endStorageKey = 110200
        local resetStorage = false

        for storageKey = startStorageKey, endStorageKey do
            if player:getStorageValue(storageKey) == -1 then
                resetStorage = true
                break
            end
        end

        if resetStorage then
            for storageKey = startStorageKey, endStorageKey do
                player:setStorageValue(storageKey, 0)
            end
        end
    else
        if loginStr ~= "" then
            player:sendTextMessage(MESSAGE_STATUS_DEFAULT, loginStr)
        end
        loginStr = string.format("Your last visit in %s: %s.", serverName, os.date("%d %b %Y %X", player:getLastLoginSaved()))
    end
    
    player:sendTextMessage(MESSAGE_STATUS_DEFAULT, loginStr)
    



    local resultId = db.storeQuery("SELECT wings_id, shader_id, aura_id FROM players WHERE id = " .. playerId)
    if resultId ~= false then
        local wingsId = result.getDataInt(resultId, "wings_id")
        local shaderId = result.getDataInt(resultId, "shader_id")
        local auraId = result.getDataInt(resultId, "aura_id")
        result.free(resultId)

        -- aura/wings/shaders
        local outfit = player:getOutfit()
        outfit.lookWings = wingsId or outfit.lookWings
        outfit.lookShader = shaderId or outfit.lookShader
        outfit.lookAura = auraId or outfit.lookAura
        player:setOutfit(outfit)
    end
    
    local storedLookType = player:getStorageValue(709919)
    local storedLookAddons = player:getStorageValue(709920)
    local storedLookWings = player:getStorageValue(709921)
    local storedLookAura = player:getStorageValue(709922)
    local storedLookShader = player:getStorageValue(709923)

    if storedLookType > 0 or storedLookAddons > 0 or storedLookWings > 0 or storedLookAura > 0 or storedLookShader > 0 then
        setStoredOutfit(player, storedLookType, storedLookAddons, storedLookWings, storedLookAura, storedLookShader)
    end

    -- Eventos
    for i = 1, #events do
        player:registerEvent(events[i])
    end
	
	-- Eventos
	if player:getStorageValue(STORAGEVALUE_EVENTS) >= 1 then
		player:teleportTo(player:getTown():getTemplePosition())
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:setStorageValue(STORAGEVALUE_EVENTS, 0)
	end

    if Game.getStorageValue(GlobalStorage.FuryGates, 9710) == 1 then 
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 'Fury Gate is on Venore Today.')
    elseif Game.getStorageValue(GlobalStorage.FuryGates, 9711) == 2 then 
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 'Fury Gate is on Abdendriel Today.')
    elseif Game.getStorageValue(GlobalStorage.FuryGates, 9712) == 3 then 
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 'Fury Gate is on Thais Today.')
    elseif Game.getStorageValue(GlobalStorage.FuryGates, 9713) == 4 then 
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 'Fury Gate is on Carlin Today.')
    elseif Game.getStorageValue(GlobalStorage.FuryGates, 9714) == 5 then 
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 'Fury Gate is on Edron Today.')
    elseif Game.getStorageValue(GlobalStorage.FuryGates, 9716) == 6 then 
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 'Fury Gate is on Kazordoon Today.')
    elseif Game.getStorageValue(GlobalStorage.FuryGates, 9715) == 7 then 
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 'Fury Gate is on Darashia Today.')
    end
    
    if Game.getStorageValue(30048) == 1 then 
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 'Azure Portal is at north of Thais Today.')
    elseif Game.getStorageValue(30048) == 2 then 
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 'Azure Portal is at north est of Roshamuul Today.')
    elseif Game.getStorageValue(30048) == 3 then 
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 'Azure Portal is at west of Darashia Today.')
    elseif Game.getStorageValue(30048) == 4 then 
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 'Azure Portal is at south west of Svargrond Today.')
    end
    
    -- player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, 'Familiar: To summon a familiar use: !summonfamiliar . Autoloot: To enable/disable autoloot use: !autoloot, check panel example: !autoloot add, golden armor.')
    
local vocation = player:getVocation()
local promotion = vocation:getPromotion()

if player:isPremium() then
    local value = player:getStorageValue(PlayerStorageKeys.promotion)
    if value == 1 and promotion then
        player:setVocation(promotion)
    end
else
    if promotion then
        player:setVocation(vocation:getDemotion())
    end
end

    if player:isPremium() then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You are a Premium Account and you are receiving 20% ​​additional experience!")
    end


    if player:getStorageValue(Storage.combatProtectionStorage) <= os.time() then
        player:setStorageValue(Storage.combatProtectionStorage, os.time() + 10)
        onMovementRemoveProtection(playerId, player:getPosition(), 10)
    end
    
    -- Eventos
    player:registerEvent("GameStore")
    player:registerEvent("GameExtendedOpcode")
    -- Janelas Modais
    player:registerEvent("ModalWindowHelper")
    -- Morte e Saque
    player:registerEvent("PlayerDeath")
    player:registerEvent("DropLoot")
    -- Saque Personalizado com Efeitos de Bolsa de Saque
    player:registerEvent("onDeath_randomTierDrops")
    -- Rei Zelos
    player:registerEvent("graveMiniBossesDeath")
    -- Criatura e Chefe Impulsionados
    player:registerEvent("BootedDailyCreature")
    player:registerEvent("BootedDailyBoss")
    player:registerEvent("BoostedCreatureKill")
    player:registerEvent("TaskKill")
	--- AutoLoot ---
	player:registerEvent("AutoLoot")

    player:ApplySpeed()

    return true
end
