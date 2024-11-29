-- #####################################################
-- #                                                   #
-- #                CREATED BY TELASKO                 #
-- #                  DISCORD: .telasko.               #
-- #                                                   #
-- #####################################################


local pouchItemId = 28165 -- ID of the pouch item

local allowedItems = {
    [2148] = true,   -- gold coin
    [2152] = true,   -- platinum coin
    [2160] = true,   -- crystal coin
}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local pouch = player:getItemById(pouchItemId, true)
    if pouch and allowedItems[item:getId()] then
        local itemCount = item:getCount()
        item:moveTo(pouch)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have placed " .. itemCount .. " " .. item:getName() .. "(s) in your gold pouch.")
        return true
    else
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "You don't have a gold pouch or the item cannot be stored in it.")
        return false
    end
end
