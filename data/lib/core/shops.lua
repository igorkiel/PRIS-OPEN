local Shops = {}
local Viewers = {}

local Config = {
    opcode = 101,
    maxOffersFree = 2,
    maxOffersPremium = 6,
    autoSendToDepot = true,

    goldCoin = 2148,
    platinumCoin = 2152,
    crystalCoin = 2160,
}

Shop = setmetatable({
    getShops = function() return Shops end
}, {
    __call = function(self, player)
        if player and player:isPlayer() then
            return Shops[player:getGuid()] or nil
        end

        local obj = {
            seller = nil,
            message = "",
            -- pendingRequest = false,
            active = false,
            earned = 0,
            offers = {},
            viewers = {}
        }

        return setmetatable(obj, { __index = Shop })
    end
})

local function formatNumber(n)
    return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1,")
                                  :gsub(",(%-?)$","%1"):reverse()
end

function parseShopRequest(player, buffer)
    if type(buffer) == 'string' then buffer = json.decode(buffer) end
    if not buffer or not player then return end

    local evt = buffer.e
    local data = buffer.d

    if evt == 'SHOP_REMOVE_OFFER' then
        return player:onRequestRemoveOffer(data)
    elseif evt == 'SHOP_OPEN' then
        return player:onRequestOpenShop(data)
    elseif evt == 'SHOP_ADD_OFFER' then
        return player:onRequestAddOffer(data)
    elseif evt == 'SHOP_EDIT_OFFER' then
        return player:onRequestEditOffer(data)
    elseif evt == 'SHOP_BUY' then
        return player:onRequestBuyItem(data)
    elseif evt == 'SHOP_TOGGLE' then
        return player:onRequestTogglePause(data)
    elseif evt == 'SHOP_CLOSE' then
        return player:onShopClose(data)
    elseif evt == 'SHOP_FETCH' then
        return player:onFetchShops(data)
    end
end

function Shop.save(self)
    local seller = self:getSeller()
    if seller then
        self.active = false
        seller:onShopClose()
        
        self.seller = seller:getGuid()
    end

    if self:getOffers() < 1 then return end

    local offers = {}

    for offerId, offerData in pairs(self.offers) do
        local offer = self:getOffer(offerId)
        if offer then
            local data = {
                sid = offerData.sid,
                count = offerData.count,
                subtype = offerData.subtype,
                price = offerData.price,
                attr = base64.encode(offerData.attr)
            }

            table.insert(offers, data)
        end
    end

    local encodedData = json.encode(offers)
    db.query("INSERT INTO `pshops` (`player_guid`, `offers`) VALUES ("..self.seller..", "..db.escapeString(base64.encode(encodedData))..")")
end

local currOfferId = 0
function Shop.load(self, guid, offers)
    if not Shops[guid] then
        Shops[guid] = self
        self.seller = guid
    end

    for _,offerData in ipairs(offers) do
        local itemType = ItemType(offerData.sid)

        currOfferId = currOfferId+1
        self.offers[currOfferId] = {
            sid = offerData.sid,
            count = offerData.count,
            subtype = offerData.subtype,
            price = offerData.price,
            attr = base64.decode(offerData.attr),
            cid = itemType:getClientId(),
            name = Item.getFormattedName(itemType, offerData.count),
            weight = itemType:getWeight()
        }
    end

    self.logout = os.time()
    db.asyncQuery("DELETE FROM `pshops` WHERE `player_guid` = "..self.seller)
end

function Player.onRequestOpenShop(self, data)
    local seller = Player(data)
    if not seller or not seller:isPlayer() then
        return self:popupFYI("Request failed. (-15)")
    end

    if seller == self then
        if not self:shopActive() then
            self:createShop()
        end
    else
        if Viewers[data] then
            self:onShopClose()
        end

        self:openRemoteShop(data)
    end
end

function Player.onShopClose(self, data)
    local shop = self:getShop()
    local cid = self:getId()

    if shop and not Viewers[cid] then -- Is looking own shop
        if data == true then
            for offerId,_ in pairs(shop.offers) do
                shop:removeOffer(offerId)
            end
        end

        self:setIcon(0)
        self:setNoIdle(false)
        shop.active = false
        
        shop:notify()
    elseif Viewers[cid] then
        local seller = Player(Viewers[cid])
        Viewers[cid] = nil

        if not seller then return end

        local shop = seller:getShop()
        if shop then
            shop.viewers[cid] = nil
        end
    end
end

function Player.onRequestEditOffer(self, data)
    local shop = self:getShop()
    if not shop then
        self:popupFYI("Request failed. (-60)")
        return shop:send(self)
    end

    local offerId = data.offer
    local offer = shop:getOffer(offerId)
    if not offer then
        self:popupFYI("Request failed. (-61)")
        return shop:send(self)
    end

    local newprice = data.price
    if newprice and newprice ~= offer.price and newprice > 0 then
        if self:shopActive() then
            self:popupFYI("Request failed. (-62)")
            return shop:send(self)
        end

        offer.price = newprice
    end

    local handleAddMore = function (howMuch)
        if self:getItemCount(offer.sid) < howMuch then
            self:popupFYI("Request failed. (-63)")
            return shop:send(self)
        end

        if not self:removeItem(offer.sid, howMuch) then
            self:popupFYI("Request failed. (-64)")
            return shop:send(self)
        end

        offer.count = offer.count + howMuch
        offer.subtype = offer.count
    end

    local handleWithdraw = function (howMuch)
        if offer.count < howMuch then
            self:popupFYI("Request failed. (-65)")
            return shop:send(self)
        end

        local item = Game.createItem(offer.sid, howMuch)
        if not item then
            self:popupFYI("Request failed. (-66)")
            return shop:send(self)
        end

        local itemName = item:getFormattedName()
        local verb = offer.count == 1 and 'was' or 'were'

        local ret = shop:giveItem(self, item)
        if ret == 'SUCCESS' then
            self:sendTextMessage(MESSAGE_EVENT_ORANGE, itemName.." "..verb.." returned to your inventory.")
        elseif ret == 'NOROOM' then
            self:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, itemName.." "..verb.." sent to your depot on "..self:getTown():getName().." because you do not have enough free capacity.")
        end

        offer.count = offer.count - howMuch
        offer.subtype = offer.count
    end

    local newcount = data.count
    if newcount and newcount ~= offer.count then
        local itemType = ItemType(offer.sid)
        if not itemType or not itemType:isStackable() then
            self:popupFYI("Request failed. (-67)")
            return shop:send(self)
        end

        if newcount > 100 then
            self:popupFYI("You can only sell up to 100 items per slot.")
            newcount = 100
        end

        if newcount > offer.count then
            handleAddMore(newcount - offer.count)
        else
            if self:shopActive() then
                self:popupFYI("Request failed. (-68)")
                return shop:send(self)
            end

            handleWithdraw(offer.count - newcount)
        end

        offer.name = Item.getFormattedName(itemType, offer.count)
    end

    shop:update()
end

function Player.onRequestBuyItem(self, data)
    local offerId = data.offer
    local count = data.count

    local seller = Player(Viewers[self:getId()])
    if not seller then return self:popupFYI("Request failed. (-98)") end

    if seller == self then
        return self:popupFYI("Request failed. You cannot purchase your own items.")
    end

    local shop = seller:getShop()
    if not shop then return self:popupFYI("Request failed. (-97)") end

    local offer = shop:getOffer(offerId)
    if not offer then
        self:popupFYI("This offer is not available anymore.")
        return shop:send(self)
    end

    local itemcid = data.cid
    if itemcid ~= offer.cid then return self:popupFYI("Request failed. (-95)") end

    shop:buyItem(self, offerId, count)
end

function Player.onRequestRemoveOffer(self, offerId)
    local shop = self:getShop()
    if not shop then return self:popupFYI("Request failed. (-12)") end

    shop:removeOffer(offerId)
    shop:update()
end

function Player.onRequestAddOffer(self, data)
    if not data or type(data) ~= 'table' then return end

    local shop = self:getShop()
    if not shop then return end

    if not data.cid or not data.count or not data.price or not data.pos or type(data.pos) ~= 'table' or not data.pos.x or not data.pos.y or not data.pos.z then
        self:popupFYI("Request failed. (-2)")
        shop:send(self)
        return
    end

    if data.count < 1 then
        self:popupFYI("Please submit a valid item count.")
        shop:send(self)
        return
    end

    if data.price < 1 then
        self:popupFYI("Please submit a valid price.")
        shop:send(self)
        return
    end

    shop:addOffer(data.cid, data.count, data.price, data.pos)
end

function Player.getMaxShopOffers(self)
    return self:isPremium() and Config.maxOffersPremium or Config.maxOffersFree
end

function Shop.assign(self, player)
    if Shops[player:getGuid()] ~= nil then return end

    self.seller = player:getId()
    Shops[player:getGuid()] = self
end

function Shop.send(self, player)
    local seller = self:getSeller()
    if not seller then return end

    local payload = {
        e = 'SHOP_OPEN',
        d = {
            info = self.message,
            seller = seller:getId(),
            offers = {}
        }
    }

    if player:getId() == self.seller then
        payload.d.own = true
        payload.d.maxOffers = seller:getMaxShopOffers()
        payload.d.open = self.active
        payload.d.earned = self.earned
    else
        payload.d.money = player:getMoney()
    end

    for offerId,offerData in pairs(self.offers) do
        local itemData = {
            offer = offerId,
            cid = offerData.cid,
            name = offerData.name,
            count = offerData.count,
            subtype = offerData.subtype,
            weight = offerData.weight,
            price = offerData.price,
        }

        local itemType = ItemType(offerData.sid)
        if not itemType:isStackable() and itemType:isFluidContainer() then
            itemData.subtype = bit.band(itemData.subtype, 7)
        end

        if ItemType(offerData.sid):isContainer() and offerData.content ~= {} then
            itemData.content = {}
            for _,o in ipairs(offerData.content) do
                local c = {
                    cid = o.cid,
                    name = o.name,
                    count = o.count,
                    subtype = o.subtype,
                }

                itemType = ItemType(o.sid)
                if not itemType:isStackable() and itemType:isFluidContainer() then
                    c.subtype = bit.band(c.subtype, 7)
                end

                table.insert(itemData.content, c)
            end
        end

        table.insert(payload.d.offers, itemData)
    end

    player:sendExtendedOpcode(Config.opcode, json.encode(payload))
end

function Player.shopActive(self)
    local shop = Shop(self)
    return shop ~= nil and shop.seller == self:getId() and shop.active == true and shop:getOffers() > 0
end

function Player.getShop(self)
    return Shop(self)
end

function Player.onShopNearby(self, seller)
    if type(seller) == 'userdata' and seller:isPlayer() then
        seller = { seller }
    elseif type(seller) ~= 'table' then
        return
    end
    
    local sellers = {}
    for i=1,#seller do
        local shop = seller[i]:getShop()
        local message = shop.message

        if not message or message == '' then
            message = "Welcome to my shop!"
        end

        table.insert(sellers, {
            id = seller[i]:getId(),
            info = message
        })
    end

    local payload = {
        e = 'SHOP_NEARBY',
        d = sellers
    }

    self:sendExtendedOpcode(Config.opcode, json.encode(payload))
end

function Player.createShop(self, message)
    local shop = self:getShop()
    if shop then
        shop.seller = self:getId()
    else
        shop = Shop()
        shop.message = message
        shop:assign(self)
    end
    
    shop:send(self)
end

function Player.onRequestTogglePause(self)
    local shop = self:getShop()
    if not shop then return self:popupFYI("Request failed.(-70)") end

    if shop:getOffers() < 1 then
        return self:popupFYI("First add an offer.")
    end

    if self:shopActive() then
        self:setIcon(0)
        self:setNoIdle(false)
        shop.active = false
    else
        self:setIcon(2)
        self:setNoIdle(true)
        shop.active = true
    end

    shop:send(shop:getSeller())
    shop:notify()
end

function Player.openRemoteShop(self, sellerId)
    local cid = self:getId()
    if cid == sellerId then return end

    local seller = Player(sellerId)
    if not seller then
        return self:popupFYI("This player is not online.")
    end

    if Viewers[cid] and Viewers[cid] ~= sellerId then
        self:closeRemoteShop(Viewers[cid])
    end

    Viewers[cid] = sellerId

    local shop = seller:getShop()

    if not shop or not shop.active then
        assert(shop ~= nil)
        print(string.format("%s", shop.active))
        return self:popupFYI(seller:getName().."\'s shop is not active.")
    elseif self:getPosition():getDistance(seller:getPosition()) > 20 then
        return self:popupFYI(seller:getName().." is too far away.")
    end

    shop.viewers[cid] = cid
    shop:send(self)
end

function Player.closeRemoteShop(self, sellerId)
    self:onShopClose()

    local payload = {
        e = 'SHOP_CLOSE'
    }

    self:sendExtendedOpcode(Config.opcode, json.encode(payload))
end

function Shop.notify(self)
    if not self.active then
        for viewerId,_ in pairs(self.viewers) do
            local viewer = Player(viewerId)
            if viewer then viewer:closeRemoteShop(self.seller) end
        end

        return
    end

    local seller = self:getSeller()
    local players = Game.getSpectators(seller:getPosition(), false, true, 12, 12, 12, 12)
    for i=1,#players do
        if players[i] ~= seller then
            players[i]:onShopNearby(seller)
        end
    end
end

function Shop.setInfo(self, message)
    self.message = message
    self:update()
end

function Shop.getSeller(self)
    return Player(self.seller)
end

function Shop.requestAllowed(self, buyerId)
    return buyerId == self.seller or (self:isViewer(buyerId) and self.active == true)
end

function Shop.getOffer(self, offerId)
    return self.offers[offerId] or nil
end

function Shop.getOffers(self)
    return table.size(self.offers or {})
end

function Shop.removeOffer(self, offerId)
    local seller = self:getSeller()

    local offer = self:getOffer(offerId)
    if not offer then return seller:popupFYI("Request failed. (-12)") end

    local item = Game.createItem(offer.sid, offer.count)
    if not item then return seller:popupFYI("Request failed.") end

    if not ItemType(offer.sid):isStackable() then
        item:loadAttributes(offer.attr)
    end

    if item:isContainer() then
        for _,v in ipairs(offer.content) do
            local content = Game.createItem(v.sid, offer.count)
            if content and content:isItem() then
                content:loadAttributes(v.attr)
                item:addItemEx(content)
            end
        end
    end

    local itemName = item:getFormattedName()
    local verb = offer.count == 1 and 'was' or 'were'

    local ret = self:giveItem(seller, item)
    if ret == 'SUCCESS' then
        seller:sendTextMessage(MESSAGE_EVENT_ORANGE, itemName.." "..verb.." returned to your inventory.")
    elseif ret == 'NOROOM' then
        seller:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, itemName.." "..verb.." sent to your depot on "..seller:getTown():getName().." because you do not have enough free capacity.")
    end

    self:removeItems(offerId, offer.count)
end

function Shop.update(self)
    if self:getOffers() < 1 then
        self.active = false
    end

    self:send(self:getSeller())

    local updateViewer = function(viewerId)
        local viewer = Player(viewerId)
        if viewer then
            if self:requestAllowed(viewerId) then
                self:send(viewer)
            else
                viewer:closeRemoteShop(self.seller)
            end
        else
            self.viewers[viewerId] = nil
        end
    end

    for viewerId,_ in pairs(self.viewers) do
        updateViewer(viewerId)
    end
end

function Shop.isViewer(self, cid)
    return Viewers[cid] == self.seller and self.viewers[cid] == cid
end

local function serializeItem(item)
    if not item or not item:isItem() then return end

    local itemType = ItemType(item:getId())

    local itemData = {
        sid = itemType:getId(),
        cid = itemType:getClientId(),
        count = item:getCount(),
        name = item:getFormattedName(),
        weight = item:getWeight(),
        subtype = item:getSubType(),
        attr = item:getAttributes()
    }

    if itemType:isContainer() then
        itemData.content = {}
        for i=1,item:getItemHoldingCount() do
            local _ = item:getItem(i-1)
            if _ then table.insert(itemData.content, serializeItem(_)) end
        end
    end

    return itemData
end

function Item.getFormattedName(self, count)
    count = count or self:getCount()
    if count == 1 then
        local article = self:getArticle()
        return article..(article ~= "" and " " or "")..self:getName()
    else
        return "x"..count.." "..self:getPluralName()
    end
end

function Shop.buyItem(self, buyer, offerId, count)
    if not self:requestAllowed(buyer:getId()) then
        return buyer:popupFYI("Request failed. (-99)")
    end

    local offer = self:getOffer(offerId)
    if not offer or not offer.sid or offer.count < 1 then
        return buyer:popupFYI("This item is no longer for sale.")
    end

    local itemType = ItemType(offer.sid)
    if not itemType then return false end

    if not itemType:isStackable() and count ~= 1 then
        count = 1
    end

    -- if self:pendingRequest() then return false end

    local totalPrice = offer.price*count
    if buyer:getMoney() < totalPrice then
      return buyer:popupFYI("You do not have enough money.")
    end

    if not Config.autoSendToDepot and itemType:getWeight() * count > buyer:getFreeCapacity() then
        return buyer:popupFYI("You do not have enough capacity.")
    end

    local oldcount = count
    if count > offer.count then
        count = offer.count
    end

    local item = Game.createItem(offer.sid, count)
    if not item or not item:isItem() then return buyer:popupFYI("Request failed. (-37)") end

    if not itemType:isStackable() then 
        item:loadAttributes(offer.attr)
    end

    if item:isContainer() then
        for _,v in ipairs(offer.content) do
            local content = Game.createItem(v.sid, v.count)
            if content and content:isItem() then
                content:loadAttributes(v.attr)
                item:addItemEx(content)
            end
        end
    end

    if not buyer:removeMoney(totalPrice) then
        item:remove(count)
        return buyer:popupFYI("You do not have enough money.")
    end

    local ret = self:giveItem(buyer, item)

    self:removeItems(offerId, count)
    self:addHistoric(buyer, { itemid = offer.sid, subtype = offer.subtype, count = count, price = offer.price, attr = base64.encode(offer.attr) })
    
    local itemName = item:getFormattedName()
    if ret == 'SUCCESS' then
        buyer:sendTextMessage(MESSAGE_EVENT_ORANGE, "You purchased "..itemName.." for "..totalPrice.."gp.")
    elseif ret == 'NOROOM' then
        local verb = count == 1 and 'was' or 'were'
        buyer:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, itemName.." "..verb.." sent your depot on "..buyer:getTown():getName().." because you do not have enough free capacity.\nTotal spent: "..totalPrice.."gp.")
    end

    if oldcount ~= count then
        buyer:popupFYI("The offer has changed. You purchased "..count.." units instead of "..oldcount..".\nTotal spent: "..totalPrice.." gp.")
    end

    local seller = self:getSeller()
    seller:sendTextMessage(MESSAGE_EVENT_ORANGE, "You sold "..itemName.." for "..totalPrice.."gp.")
    self:giveMoney(seller, totalPrice)

    self.earned = self.earned + totalPrice

    self:update()
end

function Shop.giveItem(self, player, item)
    local ret = player:addItemEx(item, false)
    if ret == RETURNVALUE_NOERROR then return 'SUCCESS'
    else
        local townId = player:getTown():getId()
        local depotChest = player:getDepotChest(townId, true)
        item:moveTo(depotChest, FLAG_NOLIMIT)
        return 'NOROOM'
    end
end

function Shop.giveMoney(self, player, amount)
    local coins
    local depotMoney = 0

    local crystal = math.floor(amount / 10000)
    amount = amount - crystal * 10000
    while crystal > 0 do
        local count = math.min(100, crystal)

        coins = Game.createItem(Config.crystalCoin, count)
        ret = self:giveItem(player, coins)
        if ret == 'NOROOM' then
            depotMoney = depotMoney + (count * 10000)
        end
        
        crystal = crystal - count
    end

    local platinum = math.floor(amount / 100)
    if platinum > 0 then
        coins = Game.createItem(Config.platinumCoin, platinum)
        ret = self:giveItem(player, coins)
        if ret == 'NOROOM' then
            depotMoney = depotMoney + (platinum * 100)
        end

        amount = amount - platinum * 100
    end

    if amount > 0 then
        coins = Game.createItem(Config.goldCoin, amount)
        ret = self:giveItem(player, coins)
        if ret == 'NOROOM' then
            depotMoney = depotMoney + amount
        end
    end

    if depotMoney > 0 then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, depotMoney.."gp were sent to your depot on "..player:getTown():getName().." because you do not have enough free capacity.")
    end
end

function Shop.removeItems(self, offerId, count)
    local offer = self:getOffer(offerId)
    if not offer then return self:getSeller():popupFYI("Request failed. (-12)") end

    if count >= offer.count then
        self.offers[offerId] = nil
    else
        self.offers[offerId].count = self.offers[offerId].count - count
        self.offers[offerId].name = Item.getFormattedName(ItemType(offer.sid), self.offers[offerId].count)
    end
end

function Shop.addHistoric(self, buyer, negotiation)
    negotiation = base64.encode(json.encode(negotiation))
    db.asyncQuery("INSERT INTO `pshops_historic` (`seller`, `buyer`, `timestamp`,`negotiation`) VALUES ( "..db.escapeString(self:getSeller():getName())..",\
                                                                                                        "..db.escapeString(buyer:getName())..",\
                                                                                                        "..os.time()..",\
                                                                                                        "..db.escapeString(negotiation)..")")
end

function Shop.addOffer(self, itemid, count, price, position)
    local seller = self:getSeller()
    if not seller then return false end

    if self:getOffers() == seller:getMaxShopOffers() then
        if not seller:isPremium() then
            return seller:popupFYI("You have reached the maximum of "..Config.maxOffersFree.." offers.\nUpgrade your account to Premium status to unlock more slots.")
        else
            return seller:popupFYI("You have reached the maximum of "..Config.maxOffersPremium.." offers.\n")
        end
    end

    if position.x ~= 0xFFFF then
        seller:popupFYI("First place the item in your inventory.")
        return false
    end

    local container = nil
    local item = nil
    if bit.band(position.y, 0x40) ~= 0 then
        local container = seller:getContainerById(bit.band(position.y, 0x0F))
        if not container then
            seller:popupFYI("Request failed. (-5)")
            return false
        end

        item = container:getItem(position.z)
    else
        item = seller:getSlotItem(position.y)
    end

    if not item then
        return seller:popupFYI("Request failed. (-6)")
    end
    
    local itemType = ItemType(item:getId())
    if not itemType or itemid ~= itemType:getClientId() then
        seller:popupFYI("Request failed. (-7)")
        return 
    end

    if item:getId() == Config.goldCoin or item:getId() == Config.platinumCoin or item:getId() == Config.crystalCoin then
        return seller:popupFYI("Request failed. (-8)")
    end

    if itemType:isContainer() then
        for i=1,item:getItemHoldingCount() do
            local _ = item:getItem(i)
            if _ and ItemType(_:getId()):isContainer() then
                seller:popupFYI("Cannot sell nested containers.")
                return false
            end
        end
    end

    if itemType:isStackable() then
        if count > item:getCount() then
            if count > seller:getItemCount(itemid) then
                seller:popupFYI("Request failed. (-9)")
                return false
            end
        end
    elseif count ~= 1 then
        count = 1
    end

    local itemData = serializeItem(item)
    if not item:remove(count) then
        seller:popupFYI("Request failed. (-10)")
        return false
    end

    itemData.name = item:getFormattedName(count)
    itemData.count = count
    itemData.price = price

    currOfferId = currOfferId + 1

    self.offers[currOfferId] = itemData
    self:update()
end