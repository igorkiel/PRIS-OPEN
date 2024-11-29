local SHOP_OPCODE = 101

local event = CreatureEvent("ShopExtendedOpcode")
function event.onExtendedOpcode(player, opcode, buffer)
    if SHOP_OPCODE == 101 then
        parseShopRequest(player, buffer)
    end

    return true
end
event:register("ShopExtendedOpcode")

event = CreatureEvent("DisableShop")
function event.onLogout(player)
	if Shop(player) then
        player:getShop().logout = os.time()
        player:getShop().seller = player:getGuid()

		player:onShopClose()
	end

    return true
end

event:register("DisableShop")

event = CreatureEvent("InitShop")
function event.onLogin(player)
    local spectators = Game.getSpectators(player:getPosition(), false, true, 12, 12, 12, 12)
    local sellers = {}
    for i=1,#spectators do
        if spectators[i] ~= player and spectators[i]:shopActive() then
            table.insert(sellers, spectators[i])
        end
    end

    if not table.empty(sellers) then
        player:onShopNearby(sellers)
    end

    player:registerEvent("DisableShop")
    player:registerEvent("ShopExtendedOpcode")

    return true
end

event:register("InitShop")