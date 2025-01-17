local config = {
    storage = 45393,
    exstorage = 40823,
}

local weekendNightmareCoin = Action()
function weekendNightmareCoin.onUse(cid, item, fromPosition, itemEx, toPosition, isHotkey)
    local player = Player(cid)
    local lastRewardTime = player:getStorageValue(config.storage) or 0
    local currentTime = os.time()
    
    if lastRewardTime > currentTime - (7 * 24 * 60 * 60) then
        local timeRemaining = (lastRewardTime + (7 * 24 * 60 * 60)) - currentTime
        local daysRemaining = math.ceil(timeRemaining / (24 * 60 * 60))
        return player:sendCancelMessage("The chest is empty. You can claim your next reward in " .. daysRemaining .. " days.")
    end
    
    player:addItem(26779, 2)
    
    player:setStorageValue(config.storage, currentTime)
    player:sendTextMessage(MESSAGE_INFO_DESCR, "You have received 2 nightmare coins.")
    return true
end

weekendNightmareCoin:uid(34802)
weekendNightmareCoin:register()
