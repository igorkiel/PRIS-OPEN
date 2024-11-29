function onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true
    end

    local phoenixegg = Position(32477, 31900, 1)
    local gold = Position(32478, 31900, 1)
    local talons = Position(32479, 31900, 1)
    local wand = Position(32480, 31900, 1)
    
    if item.actionid == 50009 then -- Phoenix Egg
        player:setStorageValue(STORAGE_PARADOX1, 1)
        phoenixegg:sendMagicEffect(6)
    elseif item.actionid == 50010 then -- 10k
        player:setStorageValue(STORAGE_PARADOX2, 1)
        gold:sendMagicEffect(6)
    elseif item.actionid == 50011 then -- 32 Talons
        player:setStorageValue(STORAGE_PARADOX3, 1)
        talons:sendMagicEffect(6)
    elseif item.actionid == 50012 then -- Wand Of Cosmic
        player:setStorageValue(STORAGE_PARADOX4, 1)
        wand:sendMagicEffect(6)
    end
    
    return true
end
