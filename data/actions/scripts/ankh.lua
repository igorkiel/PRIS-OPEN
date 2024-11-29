local BLESSINGS = {"Spiritual Shielding", "Embrace of Tibia", "Fire of the Suns", "Spark of the Phoenix", "Wisdom of Solitude"}
local BLESS_IDS = {1, 2, 3, 4, 5}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local amount = 0
    local missing = {}

    for i = 1, #BLESS_IDS do
        if player:hasBlessing(BLESS_IDS[i]) then
            amount = amount + 1
        else
            table.insert(missing, BLESSINGS[i])
        end
    end

    local s = amount == 1 and '' or 's'
    local percentage = amount * 20

    local message = string.format("You have %d blessing%s (%d%%).\n", amount, s, percentage)

    if #missing > 0 then
        message = message .. "Missing blessings:\n"
        for i = 1, #missing do
            message = message .. "- " .. missing[i] .. "\n"
        end
    end

    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)

    return true
end
