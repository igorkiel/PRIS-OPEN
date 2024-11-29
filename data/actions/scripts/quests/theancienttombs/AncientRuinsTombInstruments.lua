local config = {
    [2367] = 1,
    [2373] = 2,
    [2370] = 3,
    [2372] = 4,
    [2369] = 5,
    [1241] = 6 -- Vamos manter o item 1241 como a porta final
}

local storage = Storage.TheAncientTombs.VashresamunInstruments

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local targetStep = config[item.itemid]
    if not targetStep then
        player:setStorageValue(storage, 0)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You played them wrong, now you must begin with the first instrument again!')
        doTargetCombatHealth(0, player, COMBAT_PHYSICALDAMAGE, -20, -20, CONST_ME_GROUNDSHAKER)
        return true
    end

    local currentStep = player:getStorageValue(storage)
    if currentStep < 0 then
        currentStep = 0
    end

    if targetStep == currentStep + 1 then
        player:setStorageValue(storage, targetStep)
        fromPosition:sendMagicEffect(CONST_ME_SOUND_BLUE)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You played the correct instrument!')
        if targetStep == 5 then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Congratulations! You earned the achievement "Minstrel".')
        end
    elseif item.itemid ~= 1241 then
        player:setStorageValue(storage, 0)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You played the wrong instrument, now you must begin with the first instrument again!')
        doTargetCombatHealth(0, player, COMBAT_PHYSICALDAMAGE, -20, -20, CONST_ME_GROUNDSHAKER)
    end

    if item.itemid == 1241 then
        if player:getStorageValue(storage) == 5 then
            player:teleportTo(toPosition, true)
            item:transform(item.itemid + 1)
        else
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You first must play the instruments in the correct order to get access!")
        end
    end

    return true
end
