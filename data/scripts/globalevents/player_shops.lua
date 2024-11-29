local event = GlobalEvent("SaveAbandonedShops")

function event.onTime(interval)
    for _,shop in pairs(Shop.getShops()) do
        local player = shop:getSeller()
        if not player then
            if os.time() > shop.logout + interval then shop:save() end
        end
    end

	return true
end

event:interval(15 * 60 * 1000) -- 15 minutes
event:register()

event = GlobalEvent("LoadAllShops")
function event.onStartup()
    local resultId = db.storeQuery("SELECT * FROM `pshops` WHERE 1")
    if resultId ~= false then
        repeat
            local guid = result.getNumber(resultId, "player_guid")
            local encodedData = result.getString(resultId, "offers")

            local offers = base64.decode(encodedData)
            offers = json.decode(offers)

            if offers and type(offers) == 'table' and offers ~= {} then
                local shop = Shop()
                if shop then
                    shop:load(guid, offers)
                end
            end
        until not result.next(resultId)
        
        result.free(resultId)
    end

    return true
end

event:register()

event = GlobalEvent("SaveAllShops")
function event.onShutdown()
    for _,shop in pairs(Shop.getShops()) do
        shop:save()
    end

    return true
end

event:register()