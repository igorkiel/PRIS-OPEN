function Player:onBrowseField(position)
	if hasEventCallback(EVENT_CALLBACK_ONBROWSEFIELD) then
		return EventCallback(EVENT_CALLBACK_ONBROWSEFIELD, self, position)
	end
	return true
end

function Player:onLook(thing, position, distance)
    local description = ""
    
    if hasEventCallback(EVENT_CALLBACK_ONLOOK) then
        local callbackResult = EventCallback(EVENT_CALLBACK_ONLOOK, self, thing, position, distance, description)
        
        if callbackResult then
            description = callbackResult
        end
    end
    
    if thing:isCreature() then
        if thing:isPlayer() then
            local rankTask = getRankTask(thing)
            if rankTask then
                description = string.format("%s\n Ancestral Rank: %s", description, rankTask)
            end
        end
    end
    
    self:sendTextMessage(MESSAGE_INFO_DESCR, description)
end

function Player:onLookInBattleList(creature, distance)
	local description = ""
	if hasEventCallback(EVENT_CALLBACK_ONLOOKINBATTLELIST) then
		description = EventCallback(EVENT_CALLBACK_ONLOOKINBATTLELIST, self, creature, distance, description)
	end
	self:sendTextMessage(MESSAGE_INFO_DESCR, description)
end

function Player:onLookInTrade(partner, item, distance)
	local description = "You see " .. item:getDescription(distance)
	if hasEventCallback(EVENT_CALLBACK_ONLOOKINTRADE) then
		description = EventCallback(EVENT_CALLBACK_ONLOOKINTRADE, self, partner, item, distance, description)
	end
	self:sendTextMessage(MESSAGE_INFO_DESCR, description)
end

function Player:onLookInShop(itemType, count, description)
	local description = "You see " .. description
	if hasEventCallback(EVENT_CALLBACK_ONLOOKINSHOP) then
		description = EventCallback(EVENT_CALLBACK_ONLOOKINSHOP, self, itemType, count, description)
	end
	self:sendTextMessage(MESSAGE_INFO_DESCR, description)
end

function Player:onMoveItem(item, count, fromPosition, toPosition, fromCylinder, toCylinder)
	if item:getActionId() == CURSED_CHESTS_AID then return false end
    if hasEventCallback(EVENT_CALLBACK_ONMOVEITEM) then
        return EventCallback(EVENT_CALLBACK_ONMOVEITEM, self, item, count, fromPosition, toPosition, fromCylinder, toCylinder)
    end
	return RETURNVALUE_NOERROR
end

function Player:onItemMoved(item, count, fromPosition, toPosition, fromCylinder, toCylinder)
	if hasEventCallback(EVENT_CALLBACK_ONITEMMOVED) then
		EventCallback(EVENT_CALLBACK_ONITEMMOVED, self, item, count, fromPosition, toPosition, fromCylinder, toCylinder)
	end
end

function Player:onMoveCreature(creature, fromPosition, toPosition)
	if hasEventCallback(EVENT_CALLBACK_ONMOVECREATURE) then
		return EventCallback(EVENT_CALLBACK_ONMOVECREATURE, self, creature, fromPosition, toPosition)
	end
	return true
end

function Player:onReportRuleViolation(targetName, reportType, reportReason, comment, translation)
	if hasEventCallback(EVENT_CALLBACK_ONREPORTRULEVIOLATION) then
		EventCallback(EVENT_CALLBACK_ONREPORTRULEVIOLATION, self, targetName, reportType, reportReason, comment, translation)
	end
end

function Player:onReportBug(message, position, category)
	if hasEventCallback(EVENT_CALLBACK_ONREPORTBUG) then
		return EventCallback(EVENT_CALLBACK_ONREPORTBUG, self, message, position, category)
	end
	return true
end

function Player:onTurn(direction)
	if hasEventCallback(EVENT_CALLBACK_ONTURN) then
		return EventCallback(EVENT_CALLBACK_ONTURN, self, direction)
	end
	return true
end

function Player:onTradeRequest(target, item)
	if hasEventCallback(EVENT_CALLBACK_ONTRADEREQUEST) then
		return EventCallback(EVENT_CALLBACK_ONTRADEREQUEST, self, target, item)
	end
	return true
end

function Player:onTradeAccept(target, item, targetItem)
	if hasEventCallback(EVENT_CALLBACK_ONTRADEACCEPT) then
		return EventCallback(EVENT_CALLBACK_ONTRADEACCEPT, self, target, item, targetItem)
	end
	return true
end

function Player:onTradeCompleted(target, item, targetItem, isSuccess)
	if hasEventCallback(EVENT_CALLBACK_ONTRADECOMPLETED) then
		EventCallback(EVENT_CALLBACK_ONTRADECOMPLETED, self, target, item, targetItem, isSuccess)
	end
end

local function useStamina(player)
	local staminaMinutes = player:getStamina()
	if staminaMinutes == 0 then
		return
	end

	local playerId = player:getId()
	if not nextUseStaminaTime[playerId] then
		nextUseStaminaTime[playerId] = 0
	end

	local currentTime = os.time()
	local timePassed = currentTime - nextUseStaminaTime[playerId]
	if timePassed <= 0 then
		return
	end

	if timePassed > 60 then
		if staminaMinutes > 2 then
			staminaMinutes = staminaMinutes - 2
		else
			staminaMinutes = 0
		end
		nextUseStaminaTime[playerId] = currentTime + 120
	else
		staminaMinutes = staminaMinutes - 1
		nextUseStaminaTime[playerId] = currentTime + 60
	end
	player:setStamina(staminaMinutes)
end

local pet_storage_experience = 633451
local pet_storage_level = 633452
local pet_id = 633453

function Player:getPet()
    local petId = self:getStorageValue(pet_id)
    if petId > 0 then
        return Creature(petId)
    end
    return nil
end

local monsterExpBoosts = {
    ["Bloated Man-Maggot"] = 876547,
    ["Converter"] = 876548,
    ["Darklight Construct"] = 876549,
	["Darklight Emitter"] = 876550,
	["Darklight Matter"] = 876551,
	["Darklight Source"] = 876552,
	["Darklight Striker"] = 876553,
	["Meandering Mushroom"] = 876554,
	["Mycobiontic Beetle"] = 876555,
	["Oozing Carcass"] = 876556,
	["Oozing Corpus"] = 876557,
	["Elder Bloodjaw"] = 876558,
	["Rotten Man-Maggot"] = 876559,
	["Sopping Carcass"] = 876560,
	["Sopping Corpus"] = 876561,
	["Walking Pillar"] = 876562,
	["Wandering Pillar"] = 876563,
	["Bony Sea Devil"] = 876564,
	["Brachiodemon"] = 876565,
	["Branchy Crawler"] = 876566,
	["Capricious Phantom"] = 876567,
	["Cloak Of Terror"] = 876568,
	["Courage Leech"] = 876569,
	["Distorted Phantom"] = 876570,
	["Druid's Apparition"] = 876571,
	["Hazardous Phantom"] = 876572,
	["Infernal Demon"] = 876573,
	["Infernal Phantom"] = 876574,
	["Knight's Apparition"] = 876575,
	["Many Faces"] = 876576,
	["Mould Phantom"] = 876577,
	["Paladin's Apparition"] = 876578,
	["Rotten Golem"] = 876579,
	["Sorcerer's Apparition"] = 876580,
	["Turbulent Elemental"] = 876581,
	["Vibrant Phantom"] = 876582
}

function Player:onGainExperience(source, exp, rawExp)
	if not source or source:isPlayer() then
		return exp
	end
	local sourceName = source:getName():lower()
    local storageValue = monsterExpBoosts[sourceName]
    if storageValue then
        if self:getStorageValue(storageValue) >= 1 then
            exp = exp * 1.03 -- Gives 3% EXP Boost Permanent to the monster - 1.00 = Normal, 1.03 = 3%, 2.00 = 100% Plus
        end
    end
	if source:isMonster() then
        local bonusExperience = source:getMonsterLevel() * 0.03
        if source:getMonsterLevel() > 0 and bonusExperience > 1 then
            exp = exp * bonusExperience
        end
    end

	-- Apply experience stage multiplier
	exp = exp * Game.getExperienceStage(self:getLevel())

	-- Stamina modifier
	if configManager.getBoolean(configKeys.STAMINA_SYSTEM) then
		useStamina(self)
		local staminaMinutes = self:getStamina()
		if staminaMinutes > 2400 and self:isPremium() then
			exp = exp * 1.5
		elseif staminaMinutes <= 840 then
			exp = exp * 0.5
		end
	end
	if self:getStorageValue(6000) >= os.time() then
        exp = exp * 2.00
    end

	local pet = self:getPet()
    if not pet then
        return exp
    end
    local petId = self:getStorageValue(pet_id)

    if petId <= 0 then
        return exp
    end

    local pet_experience = pet:getStorageValue(pet_storage_experience)
    local pet_level = pet:getStorageValue(pet_storage_level)
    local petNextLevelExperience = calculateNextLevelExperience(pet_level)
    local petExp = exp * 0.2 

    pet_experience = pet_experience + petExp

    while pet_experience >= petNextLevelExperience do
        pet_level = pet_level + 1
        pet_experience = pet_experience - petNextLevelExperience
        petNextLevelExperience = calculateNextLevelExperience(pet_level)

        if pet_level == 50 then
            self:setStorageValue(688110, 1)
        elseif pet_level == 100 then
            self:setStorageValue(688111, 1)
        elseif pet_level == 150 then
            self:setStorageValue(688112, 1)
        elseif pet_level == 200 then
            self:setStorageValue(688113, 1)
        elseif pet_level == 250 then
            self:setStorageValue(688114, 1)
        elseif pet_level == 300 then
            self:setStorageValue(688115, 1)
        end
    end

    pet:setStorageValue(pet_storage_experience, pet_experience)
    pet:setStorageValue(pet_storage_level, pet_level)

    db.query("UPDATE `players` SET `pet_experience` = " .. pet_experience .. ", `pet_level` = " .. pet_level .. " WHERE `id` = " .. self:getGuid())

    return exp
end


function Player:onLoseExperience(exp)
	return hasEventCallback(EVENT_CALLBACK_ONLOSEEXPERIENCE) and EventCallback(EVENT_CALLBACK_ONLOSEEXPERIENCE, self, exp) or exp
end

function Player:onGainSkillTries(skill, tries)
	if APPLY_SKILL_MULTIPLIER == false then
		return hasEventCallback(EVENT_CALLBACK_ONGAINSKILLTRIES) and EventCallback(EVENT_CALLBACK_ONGAINSKILLTRIES, self, skill, tries) or tries
	end

	if skill == SKILL_MAGLEVEL then
		tries = tries * configManager.getNumber(configKeys.RATE_MAGIC)
		return hasEventCallback(EVENT_CALLBACK_ONGAINSKILLTRIES) and EventCallback(EVENT_CALLBACK_ONGAINSKILLTRIES, self, skill, tries) or tries
	end
	tries = tries * configManager.getNumber(configKeys.RATE_SKILL)
	return hasEventCallback(EVENT_CALLBACK_ONGAINSKILLTRIES) and EventCallback(EVENT_CALLBACK_ONGAINSKILLTRIES, self, skill, tries) or tries
end

function Player:onWrapItem(item)
	local topCylinder = item:getTopParent()
	if not topCylinder then
		return
	end

	local tile = Tile(topCylinder:getPosition())
	if not tile then
		return
	end

	local house = tile:getHouse()
	if not house then
		self:sendCancelMessage("You can only wrap and unwrap this item inside a house.")
		return
	end

	if house ~= self:getHouse() and not string.find(house:getAccessList(SUBOWNER_LIST):lower(), "%f[%a]" .. self:getName():lower() .. "%f[%A]") then
		self:sendCancelMessage("You cannot wrap or unwrap items from a house, which you are only guest to.")
		return
	end

	local wrapId = item:getAttribute("wrapid")
	if wrapId == 0 then
		return
	end

	if not hasEventCallback(EVENT_CALLBACK_ONWRAPITEM) or EventCallback(EVENT_CALLBACK_ONWRAPITEM, self, item) then
		local oldId = item:getId()
		item:remove(1)
		local item = tile:addItem(wrapId)
		if item then
			item:setAttribute("wrapid", oldId)
		end
	end
end


function Player:onQueueLeave(queue)
	self:sendExtendedOpcode(ExtendedOPCodes.CODE_DUNGEONS, json.encode({action = "queue", data = {joined = false}}))
	local dungeon = queue:getDungeon()
	local players = Game.getPlayers()
	local inQueue = queue:getPlayersNumber()
	for _, player in ipairs(players) do
		player:sendExtendedOpcode(
			ExtendedOPCodes.CODE_DUNGEONS,
			json.encode({action = "queueUpdate", data = {id = dungeon:getId(), queue = inQueue, estimated = dungeon:getEstimatedQueueTime(player)}})
		)
	end
end

local config = {
	[0] = { -- Configurações para vocação 0 - ROOKER
		[SKILL_FIST] = {
			{fromLevel = 10, toLevel = 255, rate = 1.2}
		},
		[SKILL_CLUB] = {
			{fromLevel = 10, toLevel = 255, rate = 1.2}
		},
		[SKILL_SWORD] = {
			{fromLevel = 10, toLevel = 255, rate = 1.2}
		},
		[SKILL_AXE] = {
			{fromLevel = 10, toLevel = 255, rate = 1.2}
		},
		[SKILL_DISTANCE] = {
			{fromLevel = 10, toLevel = 255, rate = 1.2}
		},
		[SKILL_SHIELD] = {
			{fromLevel = 10, toLevel = 255, rate = 1.2}
		},
		[SKILL_FISHING] = {
			{fromLevel = 10, toLevel = 255, rate = 1.2}
		},
		[SKILL_MAGLEVEL] = {
			{fromLevel = 10, toLevel = 255, rate = 1.2}
		}
	},
	[1] = { -- Configurações para vocação 1 - Sorcerer - ok
		[SKILL_FIST] = {
			{fromLevel = 10, toLevel = 255, rate = 10}
		},
		[SKILL_CLUB] = {
			{fromLevel = 10, toLevel = 255, rate = 10}
		},
		[SKILL_SWORD] = {
			{fromLevel = 10, toLevel = 255, rate = 10}
		},
		[SKILL_AXE] = {
			{fromLevel = 10, toLevel = 255, rate = 10}
		},
		[SKILL_DISTANCE] = {
			{fromLevel = 10, toLevel = 255, rate = 10}
		},
		[SKILL_SHIELD] = {
			{fromLevel = 10, toLevel = 35, rate = 15},
			{fromLevel = 36, toLevel = 99, rate = 9}
		},
		[SKILL_FISHING] = {
			{fromLevel = 10, toLevel = 19, rate = 5},
			{fromLevel = 20, toLevel = 29, rate = 10}
		},
		[SKILL_MAGLEVEL] = {
			{fromLevel = 0, toLevel = 10, rate = 30},
			{fromLevel = 11, toLevel = 20, rate = 26},
			{fromLevel = 21, toLevel = 30, rate = 22},
			{fromLevel = 31, toLevel = 40, rate = 18},
			{fromLevel = 41, toLevel = 50, rate = 14},
			{fromLevel = 51, toLevel = 60, rate = 12},
			{fromLevel = 61, toLevel = 70, rate = 10},
			{fromLevel = 71, toLevel = 80, rate = 9},
			{fromLevel = 81, toLevel = 9, rate = 8},
			{fromLevel = 91, toLevel = 100, rate = 7},
			{fromLevel = 101, toLevel = 255, rate = 6}
		}
	},
	[2] = { -- Configurações para vocação 2 - Druid - ok
		[SKILL_FIST] = {
			{fromLevel = 10, toLevel = 255, rate = 10}
		},
		[SKILL_CLUB] = {
			{fromLevel = 10, toLevel = 255, rate = 10}
		},
		[SKILL_SWORD] = {
			{fromLevel = 10, toLevel = 255, rate = 10}
		},
		[SKILL_AXE] = {
			{fromLevel = 10, toLevel = 255, rate = 10}
		},
		[SKILL_DISTANCE] = {
			{fromLevel = 10, toLevel = 255, rate = 10}
		},
		[SKILL_SHIELD] = {
			{fromLevel = 10, toLevel = 35, rate = 15},
			{fromLevel = 36, toLevel = 99, rate = 9}
		},
		[SKILL_FISHING] = {
			{fromLevel = 10, toLevel = 19, rate = 5},
			{fromLevel = 20, toLevel = 29, rate = 10}
		},
		[SKILL_MAGLEVEL] = {
			{fromLevel = 0, toLevel = 10, rate = 30},
			{fromLevel = 11, toLevel = 20, rate = 26},
			{fromLevel = 21, toLevel = 30, rate = 22},
			{fromLevel = 31, toLevel = 40, rate = 18},
			{fromLevel = 41, toLevel = 50, rate = 14},
			{fromLevel = 51, toLevel = 60, rate = 12},
			{fromLevel = 61, toLevel = 70, rate = 10},
			{fromLevel = 71, toLevel = 80, rate = 9},
			{fromLevel = 81, toLevel = 90, rate = 8},
			{fromLevel = 91, toLevel = 100, rate = 7},
			{fromLevel = 101, toLevel = 255, rate = 6}
		}
	},
	[3] = { -- Configurações para vocação 3 - Paladin - ok
		[SKILL_FIST] = {
			{fromLevel = 10, toLevel = 255, rate = 15}
		},
		[SKILL_CLUB] = {
			{fromLevel = 10, toLevel = 255, rate = 15}
		},
		[SKILL_SWORD] = {
			{fromLevel = 10, toLevel = 255, rate = 15}
		},
		[SKILL_AXE] = {
			{fromLevel = 10, toLevel = 255, rate = 15}
		},
		[SKILL_DISTANCE] = {
			{fromLevel = 10, toLevel = 20, rate = 85},
			{fromLevel = 21, toLevel = 30, rate = 70},
			{fromLevel = 31, toLevel = 40, rate = 40},
			{fromLevel = 41, toLevel = 50, rate = 25},
			{fromLevel = 51, toLevel = 60, rate = 15},
			{fromLevel = 61, toLevel = 70, rate = 10},
			{fromLevel = 71, toLevel = 255, rate = 7}
		},
		[SKILL_SHIELD] = {
			{fromLevel = 10, toLevel = 35, rate = 20},
			{fromLevel = 36, toLevel = 99, rate = 10}
		},
		[SKILL_FISHING] = {
			{fromLevel = 10, toLevel = 19, rate = 5},
			{fromLevel = 20, toLevel = 29, rate = 10}
		},
		[SKILL_MAGLEVEL] = {
			{fromLevel = 0, toLevel = 5, rate = 40},
			{fromLevel = 6, toLevel = 8, rate = 30},
			{fromLevel = 9, toLevel = 11, rate = 20},
			{fromLevel = 12, toLevel = 15, rate = 10},
			{fromLevel = 16, toLevel = 20, rate = 10},
			{fromLevel = 21, toLevel = 30, rate = 10}
		}
	},
	[4] = { -- Configurações para vocação 4 - Knight - ok
		[SKILL_FIST] = {
			{fromLevel = 10, toLevel = 20, rate = 70},
			{fromLevel = 21, toLevel = 30, rate = 65},
			{fromLevel = 31, toLevel = 40, rate = 50},
			{fromLevel = 41, toLevel = 50, rate = 45},
			{fromLevel = 51, toLevel = 60, rate = 31},
			{fromLevel = 61, toLevel = 70, rate = 20},
			{fromLevel = 71, toLevel = 90, rate = 15},
			{fromLevel = 91, toLevel = 255, rate = 10}
		},
		[SKILL_CLUB] = {
			{fromLevel = 10, toLevel = 20, rate = 70},
			{fromLevel = 21, toLevel = 30, rate = 65},
			{fromLevel = 31, toLevel = 40, rate = 50},
			{fromLevel = 41, toLevel = 50, rate = 45},
			{fromLevel = 51, toLevel = 60, rate = 31},
			{fromLevel = 61, toLevel = 70, rate = 20},
			{fromLevel = 71, toLevel = 90, rate = 15},
			{fromLevel = 91, toLevel = 255, rate = 10}
		},
		[SKILL_SWORD] = {
			{fromLevel = 10, toLevel = 20, rate = 70},
			{fromLevel = 21, toLevel = 30, rate = 65},
			{fromLevel = 31, toLevel = 40, rate = 50},
			{fromLevel = 41, toLevel = 50, rate = 45},
			{fromLevel = 51, toLevel = 60, rate = 31},
			{fromLevel = 61, toLevel = 70, rate = 20},
			{fromLevel = 71, toLevel = 90, rate = 15},
			{fromLevel = 91, toLevel = 255, rate = 10}
		},
		[SKILL_AXE] = {
			{fromLevel = 10, toLevel = 20, rate = 70},
			{fromLevel = 21, toLevel = 30, rate = 65},
			{fromLevel = 31, toLevel = 40, rate = 50},
			{fromLevel = 41, toLevel = 50, rate = 45},
			{fromLevel = 51, toLevel = 60, rate = 31},
			{fromLevel = 61, toLevel = 70, rate = 20},
			{fromLevel = 71, toLevel = 90, rate = 15},
			{fromLevel = 91, toLevel = 255, rate = 10}
		},
		[SKILL_DISTANCE] = {
			{fromLevel = 10, toLevel = 20, rate = 10},
			{fromLevel = 21, toLevel = 30, rate = 10},
			{fromLevel = 31, toLevel = 40, rate = 10},
			{fromLevel = 41, toLevel = 50, rate = 10},
			{fromLevel = 51, toLevel = 60, rate = 10},
			{fromLevel = 61, toLevel = 70, rate = 10},
			{fromLevel = 71, toLevel = 255, rate = 10}
		},
		[SKILL_SHIELD] = {
			{fromLevel = 10, toLevel = 20, rate = 70},
			{fromLevel = 21, toLevel = 30, rate = 65},
			{fromLevel = 31, toLevel = 40, rate = 50},
			{fromLevel = 41, toLevel = 50, rate = 45},
			{fromLevel = 51, toLevel = 60, rate = 31},
			{fromLevel = 61, toLevel = 70, rate = 20},
			{fromLevel = 71, toLevel = 90, rate = 15},
			{fromLevel = 91, toLevel = 255, rate = 10}
		},
		[SKILL_FISHING] = {
			{fromLevel = 10, toLevel = 255, rate = 15}
		},
		[SKILL_MAGLEVEL] = {
			{fromLevel = 0, toLevel = 3, rate = 45},
			{fromLevel = 4, toLevel = 6, rate = 25},
			{fromLevel = 7, toLevel = 9, rate = 15},
			{fromLevel = 10, toLevel = 12, rate = 11},
			{fromLevel = 12, toLevel = 18, rate = 7}
		},
	},
	[5] = { -- Configurações para vocação 5 - Master Sorcerer - ok
		[SKILL_FIST] = {
			{fromLevel = 10, toLevel = 255, rate = 15}
		},
		[SKILL_CLUB] = {
			{fromLevel = 10, toLevel = 255, rate = 15}
		},
		[SKILL_SWORD] = {
			{fromLevel = 10, toLevel = 255, rate = 15}
		},
		[SKILL_AXE] = {
			{fromLevel = 10, toLevel = 255, rate = 15}
		},
		[SKILL_DISTANCE] = {
			{fromLevel = 10, toLevel = 255, rate = 15}
		},
		[SKILL_SHIELD] = {
			{fromLevel = 10, toLevel = 35, rate = 20},
			{fromLevel = 36, toLevel = 99, rate = 10}
		},
		[SKILL_FISHING] = {
			{fromLevel = 10, toLevel = 19, rate = 5},
			{fromLevel = 20, toLevel = 29, rate = 10}
		},
		[SKILL_MAGLEVEL] = {
			{fromLevel = 0, toLevel = 10, rate = 34},
			{fromLevel = 11, toLevel = 20, rate = 30},
			{fromLevel = 21, toLevel = 30, rate = 26},
			{fromLevel = 31, toLevel = 40, rate = 22},
			{fromLevel = 41, toLevel = 50, rate = 18},
			{fromLevel = 51, toLevel = 60, rate = 16},
			{fromLevel = 61, toLevel = 70, rate = 12},
			{fromLevel = 71, toLevel = 80, rate = 11},
			{fromLevel = 81, toLevel = 90, rate = 10},
			{fromLevel = 91, toLevel = 100, rate = 9},
			{fromLevel = 101, toLevel = 255, rate = 8}
		}
	},
	[6] = { -- Configurações para vocação 6 - Elder Druid - ok
		[SKILL_FIST] = {
			{fromLevel = 10, toLevel = 255, rate = 15}
		},
		[SKILL_CLUB] = {
			{fromLevel = 10, toLevel = 255, rate = 15}
		},
		[SKILL_SWORD] = {
			{fromLevel = 10, toLevel = 255, rate = 15}
		},
		[SKILL_AXE] = {
			{fromLevel = 10, toLevel = 255, rate = 15}
		},
		[SKILL_DISTANCE] = {
			{fromLevel = 10, toLevel = 255, rate = 15}
		},
		[SKILL_SHIELD] = {
			{fromLevel = 10, toLevel = 35, rate = 20},
			{fromLevel = 36, toLevel = 99, rate = 10}
		},
		[SKILL_FISHING] = {
			{fromLevel = 10, toLevel = 19, rate = 5},
			{fromLevel = 20, toLevel = 29, rate = 10}
		},
		[SKILL_MAGLEVEL] = {
			{fromLevel = 0, toLevel = 10, rate = 34},
			{fromLevel = 11, toLevel = 20, rate = 30},
			{fromLevel = 21, toLevel = 30, rate = 26},
			{fromLevel = 31, toLevel = 40, rate = 22},
			{fromLevel = 41, toLevel = 50, rate = 18},
			{fromLevel = 51, toLevel = 60, rate = 16},
			{fromLevel = 61, toLevel = 70, rate = 12},
			{fromLevel = 71, toLevel = 80, rate = 11},
			{fromLevel = 81, toLevel = 90, rate = 10},
			{fromLevel = 91, toLevel = 100, rate = 9},
			{fromLevel = 101, toLevel = 255, rate = 8}
		}
	},
	[7] = { -- Configurações para vocação 7 - Royal Paladin - ok
		[SKILL_FIST] = {
			{fromLevel = 10, toLevel = 19, rate = 4},
			{fromLevel = 20, toLevel = 29, rate = 5},
			{fromLevel = 150, toLevel = 300, rate = 65}
		},
		[SKILL_CLUB] = {
			{fromLevel = 10, toLevel = 19, rate = 4},
			{fromLevel = 20, toLevel = 29, rate = 5}
		},
		[SKILL_SWORD] = {
			{fromLevel = 10, toLevel = 19, rate = 4},
			{fromLevel = 20, toLevel = 29, rate = 5}
		},
		[SKILL_AXE] = {
			{fromLevel = 10, toLevel = 19, rate = 4},
			{fromLevel = 20, toLevel = 29, rate = 5}
		},
		[SKILL_DISTANCE] = {
			{fromLevel = 10, toLevel = 20, rate = 90},
			{fromLevel = 21, toLevel = 30, rate = 75},
			{fromLevel = 31, toLevel = 40, rate = 45},
			{fromLevel = 41, toLevel = 50, rate = 30},
			{fromLevel = 51, toLevel = 60, rate = 25},
			{fromLevel = 61, toLevel = 70, rate = 2},
			{fromLevel = 71, toLevel = 80, rate = 15},
			{fromLevel = 81, toLevel = 255, rate = 11}
		},
		[SKILL_SHIELD] = {
			{fromLevel = 10, toLevel = 19, rate = 4},
			{fromLevel = 20, toLevel = 29, rate = 5}
		},
		[SKILL_FISHING] = {
			{fromLevel = 10, toLevel = 19, rate = 4},
			{fromLevel = 20, toLevel = 29, rate = 5}
		},
		[SKILL_MAGLEVEL] = {
			{fromLevel = 0, toLevel = 5, rate = 50},
			{fromLevel = 6, toLevel = 8, rate = 40},
			{fromLevel = 9, toLevel = 11, rate = 30},
			{fromLevel = 12, toLevel = 15, rate = 20},
			{fromLevel = 16, toLevel = 20, rate = 20},
			{fromLevel = 21, toLevel = 30, rate = 10}
		}
	},
	[8] = { -- Configurações para vocação 8 - Elite Knight - ok
		[SKILL_FIST] = {
			{fromLevel = 10, toLevel = 20, rate = 80},
			{fromLevel = 21, toLevel = 30, rate = 75},
			{fromLevel = 31, toLevel = 40, rate = 60},
			{fromLevel = 41, toLevel = 50, rate = 55},
			{fromLevel = 51, toLevel = 60, rate = 41},
			{fromLevel = 61, toLevel = 70, rate = 30},
			{fromLevel = 71, toLevel = 90, rate = 15},
			{fromLevel = 91, toLevel = 255, rate = 1.1}
		},
		[SKILL_CLUB] = {
			{fromLevel = 10, toLevel = 20, rate = 80},
			{fromLevel = 21, toLevel = 30, rate = 75},
			{fromLevel = 31, toLevel = 40, rate = 60},
			{fromLevel = 41, toLevel = 50, rate = 55},
			{fromLevel = 51, toLevel = 60, rate = 41},
			{fromLevel = 61, toLevel = 70, rate = 30},
			{fromLevel = 71, toLevel = 90, rate = 15},
			{fromLevel = 91, toLevel = 255, rate = 1.1}
		},
		[SKILL_SWORD] = {
			{fromLevel = 10, toLevel = 20, rate = 80},
			{fromLevel = 21, toLevel = 30, rate = 75},
			{fromLevel = 31, toLevel = 40, rate = 60},
			{fromLevel = 41, toLevel = 50, rate = 55},
			{fromLevel = 51, toLevel = 60, rate = 41},
			{fromLevel = 61, toLevel = 70, rate = 30},
			{fromLevel = 71, toLevel = 90, rate = 15},
			{fromLevel = 91, toLevel = 255, rate = 1.1}
		},
		[SKILL_AXE] = {
			{fromLevel = 10, toLevel = 20, rate = 80},
			{fromLevel = 21, toLevel = 30, rate = 75},
			{fromLevel = 31, toLevel = 40, rate = 60},
			{fromLevel = 41, toLevel = 50, rate = 55},
			{fromLevel = 51, toLevel = 60, rate = 41},
			{fromLevel = 61, toLevel = 70, rate = 30},
			{fromLevel = 71, toLevel = 90, rate = 15},
			{fromLevel = 91, toLevel = 255, rate = 1.1}
		},
		[SKILL_DISTANCE] = {
			{fromLevel = 10, toLevel = 20, rate = 10},
			{fromLevel = 21, toLevel = 30, rate = 10},
			{fromLevel = 31, toLevel = 40, rate = 10},
			{fromLevel = 41, toLevel = 50, rate = 10},
			{fromLevel = 51, toLevel = 60, rate = 10},
			{fromLevel = 61, toLevel = 70, rate = 10},
			{fromLevel = 71, toLevel = 255, rate = 10}
		},
		[SKILL_SHIELD] = {
			{fromLevel = 10, toLevel = 20, rate = 80},
			{fromLevel = 21, toLevel = 30, rate = 75},
			{fromLevel = 31, toLevel = 40, rate = 60},
			{fromLevel = 41, toLevel = 50, rate = 55},
			{fromLevel = 51, toLevel = 60, rate = 41},
			{fromLevel = 61, toLevel = 70, rate = 30},
			{fromLevel = 71, toLevel = 90, rate = 15},
			{fromLevel = 91, toLevel = 255, rate = 1.1}
		},
		[SKILL_FISHING] = {
			{fromLevel = 10, toLevel = 255, rate = 15}
		},
		[SKILL_MAGLEVEL] = {
			{fromLevel = 0, toLevel = 3, rate = 40},
			{fromLevel = 4, toLevel = 6, rate = 25},
			{fromLevel = 7, toLevel = 9, rate = 15},
			{fromLevel = 10, toLevel = 12, rate = 10},
			{fromLevel = 12, toLevel = 18, rate = 8}
		}
	}
}

local function getSkillRate(player, skillId)
    local vocationId = player:getVocation():getId()

    local targetVocation = config[vocationId]

    if targetVocation then
        local targetSkillStage = targetVocation[skillId]
        if targetSkillStage then

            local skillLevel
            if skillId == SKILL_MAGLEVEL then
                skillLevel = player:getMagicLevel()
            else
                skillLevel = player:getSkillLevel(skillId)
            end

            if not skillLevel then
                return skillId == SKILL_MAGLEVEL and configManager.getNumber(configKeys.RATE_MAGIC) or configManager.getNumber(configKeys.RATE_SKILL)
            end

            for _, level in pairs(targetSkillStage) do
                if skillLevel >= level.fromLevel and skillLevel <= level.toLevel then
                    return level.rate
                end
            end

        else
            return skillId == SKILL_MAGLEVEL and configManager.getNumber(configKeys.RATE_MAGIC) or configManager.getNumber(configKeys.RATE_SKILL)
        end
    else
        return skillId == SKILL_MAGLEVEL and configManager.getNumber(configKeys.RATE_MAGIC) or configManager.getNumber(configKeys.RATE_SKILL)
    end
end


function Player:onGainSkillTries(skill, tries)
    if not APPLY_SKILL_MULTIPLIER then
        return tries
    end
    
    local skillRate = getSkillRate(self, skill)

    if not skillRate then
        skillRate = skill == SKILL_MAGLEVEL and configManager.getNumber(configKeys.RATE_MAGIC) or configManager.getNumber(configKeys.RATE_SKILL)
    end
    
    local newTries = tries * skillRate

    return newTries
end