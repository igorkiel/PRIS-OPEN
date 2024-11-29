local magicLevelStages = {
    {min = 1, max = 50, rate = 5},   
    {min = 51, max = 100, rate = 3},
    {min = 101, max = 200, rate = 2}, 
}

local skillsStages = {
    {min = 1, max = 50, rate = 5},  
    {min = 51, max = 100, rate = 3},
    {min = 101, max = 200, rate = 2}, 
}

function getRateFromTable(stageTable, level, defaultRate)
    for _, stage in ipairs(stageTable) do
        if level >= stage.min and level <= stage.max then
            return stage.rate
        end
    end
    return defaultRate
end

local skills = {
    [27732] = {id=SKILL_SWORD,voc=4}, -- Exercise Sword
    [27733] = {id=SKILL_AXE,voc=4}, -- Exercise Axe
    [27734] = {id=SKILL_CLUB,voc=4}, -- Exercise Club
    [27758] = {id=SKILL_SHIELD,voc=4}, -- Exercise Shield
    [27759] = {id=SKILL_SHIELD,voc=4}, -- Durable Exercise Shield
    [27760] = {id=SKILL_SHIELD,voc=4}, -- Lasting Exercise Shield
    [27738] = {id=SKILL_SWORD,voc=4}, -- Durable Exercise Sword
    [27739] = {id=SKILL_AXE,voc=4}, -- Durable Exercise Axe
    [27740] = {id=SKILL_CLUB,voc=4}, -- Durable Exercise Club
    [27744] = {id=SKILL_SWORD,voc=4}, -- Lasting Exercise Sword
    [27745] = {id=SKILL_AXE,voc=4}, -- Lasting Exercise Axe
    [27746] = {id=SKILL_CLUB,voc=4}, -- Lasting Exercise Club
    [27735] = {id=SKILL_DISTANCE,voc=3,range=CONST_ANI_SIMPLEARROW}, -- Exercise bow
    [27736] = {id=SKILL_MAGLEVEL,voc=2,range=CONST_ANI_SMALLICE}, -- Exercise Rod
    [27737] = {id=SKILL_MAGLEVEL,voc=1,range=CONST_ANI_FIRE}, -- Exercise wand
    [27741] = {id=SKILL_DISTANCE,voc=3,range=CONST_ANI_SIMPLEARROW}, -- Durable Exercise bow
    [27742] = {id=SKILL_MAGLEVEL,voc=2,range=CONST_ANI_SMALLICE}, -- Durable Exercise Rod
    [27743] = {id=SKILL_MAGLEVEL,voc=1,range=CONST_ANI_FIRE}, -- Durable Exercise wand
    [27747] = {id=SKILL_DISTANCE,voc=3,range=CONST_ANI_SIMPLEARROW}, -- Lasting Exercise bow
    [27748] = {id=SKILL_MAGLEVEL,voc=2,range=CONST_ANI_SMALLICE}, -- Lasting Exercise Rod
    [27749] = {id=SKILL_MAGLEVEL,voc=1,range=CONST_ANI_FIRE}, -- Lasting Exercise wand
}

local houseDummies = {27751, 27752, 27753, 27754, 27755, 27756}
local freeDummies = {5787, 27750, 27757}
local skillRateDefault = configManager.getNumber(configKeys.RATE_SKILL)
local magicRateDefault = configManager.getNumber(configKeys.RATE_MAGIC)

local function removeExerciseWeapon(player, exercise, training)
    exercise:remove(1)
    player:sendTextMessage(MESSAGE_INFO_DESCR, "Your training weapon vanished.")
    stopEvent(training)
    player:setStorageValue(Exercise_Training.isTraining, 0) -- Reset the training status
end

local function start_train(pid, start_pos, itemid, fpos, bonusDummy, dummyId, training)
    local player = Player(pid)
    if player ~= nil then
        if Tile(fpos):getItemById(dummyId) then
            local pos_n = player:getPosition()
            if start_pos:getDistance(pos_n) == 0 and getTilePzInfo(pos_n) then
                if player:getItemCount(itemid) >= 1 then
                    local exercise = player:getItemById(itemid, true)
                    if exercise:isItem() then
                        if exercise:hasAttribute(ITEM_ATTRIBUTE_CHARGES) then
                            local charges_n = exercise:getAttribute(ITEM_ATTRIBUTE_CHARGES)
                            if charges_n >= 1 then
                                exercise:setAttribute(ITEM_ATTRIBUTE_CHARGES, (charges_n - 1))
                                local voc = player:getVocation()
                                if skills[itemid].id == SKILL_MAGLEVEL then
                                    local magicRate = getRateFromTable(magicLevelStages, player:getMagicLevel(), magicRateDefault)
                                    if not bonusDummy then
                                        player:addManaSpent(math.ceil(500 * magicRate))
                                    else
                                        player:addManaSpent(math.ceil(500 * magicRate) * 1.1) -- 10%
                                    end
                                else
                                    local skillRate = getRateFromTable(skillsStages, player:getEffectiveSkillLevel(skills[itemid].id), skillRateDefault)
                                    if not bonusDummy then
                                        player:addSkillTries(skills[itemid].id, 7 * skillRate)
                                    else
                                        player:addSkillTries(skills[itemid].id, (7 * skillRate) * 1.1) -- 10%
                                    end
                                end
                                fpos:sendMagicEffect(CONST_ME_HITAREA)
                                if skills[itemid].range then
                                    pos_n:sendDistanceEffect(fpos, skills[itemid].range)
                                end
                                if exercise:getAttribute(ITEM_ATTRIBUTE_CHARGES) == 0 then
                                    removeExerciseWeapon(player, exercise, training)
                                else
                                    training = addEvent(start_train, 750, pid, start_pos, itemid, fpos, bonusDummy, dummyId, training)
                                    player:setStorageValue(Exercise_Training.isTraining, 1)
                                end
                            else
                                removeExerciseWeapon(player, exercise, training)
                            end
                        end
                    end
                end
            else
                player:sendTextMessage(MESSAGE_INFO_DESCR, "Your training has stopped.")
                stopEvent(training)
                player:setStorageValue(Exercise_Training.isTraining, 0)
            end
        else
            stopEvent(training)
            player:sendTextMessage(MESSAGE_INFO_DESCR, "Your training has stopped.")
            player:setStorageValue(Exercise_Training.isTraining, 0)
        end
    else
        stopEvent(training)
        if player then
            player:sendTextMessage(MESSAGE_INFO_DESC, "Your training has stopped.")
            player:setStorageValue(Exercise_Training.isTraining, 0)
        end
    end
    return true
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local start_pos = player:getPosition()
    local training = player:getStorageValue(Exercise_Training.isTraining)
    
    if training == 1 then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You are already training.")
        player:setStorageValue(Exercise_Training.isTraining, 0)
        return false
    end
    
    if target:isItem() then
        if isInArray(houseDummies, target:getId()) then
            if not skills[item.itemid].range and start_pos:getDistance(target:getPosition()) > 1 then
                player:sendTextMessage(MESSAGE_INFO_DESCR, "Get closer to the dummy.")
                return true
            end
            player:sendTextMessage(MESSAGE_INFO_DESCR, "You started training.")
            start_train(player:getId(), start_pos, item.itemid, target:getPosition(), true, target:getId(), training)
        elseif isInArray(freeDummies, target:getId()) then
            if not skills[item.itemid].range and start_pos:getDistance(target:getPosition()) > 1 then
                player:sendTextMessage(MESSAGE_INFO_DESCR, "Get closer to the dummy.")
                return true
            end
            player:sendTextMessage(MESSAGE_INFO_DESCR, "You started training.")
            start_train(player:getId(), start_pos, item.itemid, target:getPosition(), false, target:getId(), training)
        end
    end
    return true
end

