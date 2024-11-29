local SHOP_EXTENDED_OPCODE = 201
local SHOP_OFFERS = {}
local SHOP_CALLBACKS = {}
local SHOP_CATEGORIES = nil
local SHOP_BUY_URL = "" -- can be empty
local SHOP_AD = { -- can be nil
  image = "",
  url = "",
  text = ""
}
local MAX_PACKET_SIZE = 4096


function init()
  SHOP_CATEGORIES = {}

  local category1 = addCategory({
    type = "item",
    item = ItemType(2160):getClientId(),
    count = 100,
    name = "Items"
  })
  local category2 = addCategory({
    type = "outfit",
    name = "Outfits",
    outfit = {
      mount = 0,
      feet = 114,
      legs = 114,
      body = 116,
      type = 143,
      auxType = 0,
      addons = 3,
      head = 2,
      rotating = true
    }
  })
  local category3 = addCategory({
    type = "item",
    item = ItemType(26077):getClientId(),
    count = 1,
    name = "House Decoration"
  })
  local category4 = addCategory({
    type = "item",
    item = ItemType(16101):getClientId(),
    count = 1,
    name = "Premium Time"
  })
  local category5 = addCategory({
    type = "item",
    item = ItemType(27760):getClientId(),
    count = 100,
    name = "Exercise Weapon"
  })
  local category6 = addCategory({
    type = "mount",
    name = "Mounts"
  })
  local category7 = addCategory({
    type = "aura",
    name = "Auras"
  })
  local category8 = addCategory({
    type = "wing",
    name = "Wings"
  })

  -- Adicionando itens às categorias
  category1.addItem(1, 2160, 1, "1 Crystal coin", "description of crystal coin")
  category1.addItem(5, 2160, 5, "5 Crystal coin", "description of crystal coin")
  category1.addItem(50, 2160, 50, "50 Crystal coin", "description of crystal coin")
  category1.addItem(90, 2160, 100, "100 Crystal coin", "description of crystal coin")

  category2.addOutfit(750, {
    storage = 535968,
    mount = 0,
    feet = 114,
    legs = 114,
    body = 116,
    type = 909,
    auxType = 0,
    addons = 2,
    head = 2,
    rotating = true,
    name = "Shadowlotus Outfit",
  }, "Shadowlotus Outfit", "Full Shadowlotus Outfit with addons.")

  category6.addMount(1000, 119, 1235, "Nuvem Voadora", "Did somebody say Moo?")
  category6.addMount(1500, 120, 1236, "Epic Mount", "Description of Epic Mount")
  category6.addMount(2000, 121, 1237, "Legendary Mount", "Description of Legendary Mount")

  category7.addAura(1000, 122, 1238, "Fiery Aura", "Description of Fiery Aura")
  category7.addAura(1500, 123, 1239, "Icy Aura", "Description of Icy Aura")

  category8.addWing(1000, 124, 1240, "Angel Wings", "Description of Angel Wings")
  category8.addWing(1500, 125, 1241, "Demonic Wings", "Description of Demonic Wings")
end


function addCategory(data)
  data['offers'] = {}
  table.insert(SHOP_CATEGORIES, data)
  table.insert(SHOP_CALLBACKS, {})
  local index = #SHOP_CATEGORIES
  return {
    addItem = function(cost, itemId, count, title, description, callback)    
      if not callback then
        callback = defaultItemBuyAction
      end
      table.insert(SHOP_CATEGORIES[index]['offers'], {
        cost = cost,
        type = "item",
        item = ItemType(itemId):getClientId(),
        itemId = itemId,
        count = count,
        title = title,
        description = description
      })
      table.insert(SHOP_CALLBACKS[index], callback)
    end,
    addOutfit = function(cost, outfit, title, description, callback)
      if not callback then
        callback = defaultOutfitBuyAction
      end
      table.insert(SHOP_CATEGORIES[index]['offers'], {
        cost = cost,
        type = "outfit",
        outfit = outfit,
        title = title,
        description = description
      })
      table.insert(SHOP_CALLBACKS[index], callback)
    end,
    addImage = function(cost, image, title, description, callback)
      if not callback then
        callback = defaultImageBuyAction
      end
      table.insert(SHOP_CATEGORIES[index]['offers'], {
        cost = cost,
        type = "image",
        image = image,
        title = title,
        description = description
      })
      table.insert(SHOP_CALLBACKS[index], callback)
    end,
    addMount = function(cost, id, clientId, title, description, callback)
      if not callback then
        callback = defaultMountBuyAction
      end
      table.insert(SHOP_CATEGORIES[index]['offers'], {
        cost = cost,
        type = "mount",
        id = id,
        clientId = clientId,
        title = title,
        description = description
      })
      table.insert(SHOP_CALLBACKS[index], callback)
    end,
    addAura = function(cost, id, clientId, title, description, callback)
      if not callback then
        callback = defaultAuraBuyAction
      end
      table.insert(SHOP_CATEGORIES[index]['offers'], {
        cost = cost,
        type = "aura",
        id = id,
        clientId = clientId,
        title = title,
        description = description
      })
      table.insert(SHOP_CALLBACKS[index], callback)
    end,
    addWing = function(cost, id, clientId, title, description, callback)
      if not callback then
        callback = defaultWingBuyAction
      end
      table.insert(SHOP_CATEGORIES[index]['offers'], {
        cost = cost,
        type = "wing",
        id = id,
        clientId = clientId,
        title = title,
        description = description
      })
      table.insert(SHOP_CALLBACKS[index], callback)
    end
  }
end

function defaultMountBuyAction(player, offer)
  if player:hasMount(offer.id) then
    return "You already have this mount!"
  end
  player:addMount(offer.id)
  return true
end

function defaultAuraBuyAction(player, offer)
  if player:getStorageValue(offer.id) > 0 then
    return "You already have this aura!"
  end
  player:setStorageValue(offer.id, 1)
  return true
end

function defaultWingBuyAction(player, offer)
  if player:getStorageValue(offer.id) > 0 then
    return "You already have these wings!"
  end
  player:setStorageValue(offer.id, 1)
  return true
end


function getStorePoints(player)
  local points = 0
  local resultId = db.storeQuery("SELECT `premium_points` FROM `accounts` WHERE `id` = " .. player:getAccountId())
  if resultId ~= false then
    points = result.getDataInt(resultId, "premium_points")
    result.free(resultId)
  end
  return points
end

function getStatus(player)
  local status = {
    ad = SHOP_AD,
    points = getStorePoints(player),
    buyUrl = SHOP_BUY_URL
  }
  return status
end

function sendJSON(player, action, data, forceStatus)
  local status = nil
  if not player:getStorageValue(1150001) or player:getStorageValue(1150001) + 10 < os.time() or forceStatus then
      status = getStatus(player)
  end
  player:setStorageValue(1150001, os.time())
 

  local buffer = json.encode({action = action, data = data, status = status})
  local s = {}
  for i=1, #buffer, MAX_PACKET_SIZE do
     s[#s+1] = buffer:sub(i,i+MAX_PACKET_SIZE - 1)
  end
  local msg = NetworkMessage()
  if #s == 1 then
    msg:addByte(50)
    msg:addByte(SHOP_EXTENDED_OPCODE)
    msg:addString(s[1])
    msg:sendToPlayer(player)
    return
  end
  -- split message if too big
  msg:addByte(50)
  msg:addByte(SHOP_EXTENDED_OPCODE)
  msg:addString("S" .. s[1])
  msg:sendToPlayer(player)
  for i=2,#s - 1 do
    msg = NetworkMessage()
    msg:addByte(50)
    msg:addByte(SHOP_EXTENDED_OPCODE)
    msg:addString("P" .. s[i])
    msg:sendToPlayer(player)
  end
  msg = NetworkMessage()
  msg:addByte(50)
  msg:addByte(SHOP_EXTENDED_OPCODE)
  msg:addString("E" .. s[#s])
  msg:sendToPlayer(player)
end

function sendMessage(player, title, msg, forceStatus)
  sendJSON(player, "message", {title=title, msg=msg}, forceStatus)
end

function onExtendedOpcode(player, opcode, buffer)
  if opcode ~= SHOP_EXTENDED_OPCODE then
    return false
  end
  local status, json_data = pcall(function() return json.decode(buffer) end)
  if not status then
    return false
  end

  local action = json_data['action']
  local data = json_data['data']
  if not action or not data then
    return false
  end

  if SHOP_CATEGORIES == nil then
    init()  
  end

  if action == 'init' then
    sendJSON(player, "categories", SHOP_CATEGORIES)
  elseif action == 'buy' then
    processBuy(player, data)
  elseif action == "history" then
    sendHistory(player)
  end
  return true
end

function processBuy(player, data)
  local categoryId = tonumber(data["category"])
  local offerId = tonumber(data["offer"])
  local offer = SHOP_CATEGORIES[categoryId]['offers'][offerId]
  local callback = SHOP_CALLBACKS[categoryId][offerId]
  if not offer or not callback or data["title"] ~= offer["title"] or data["cost"] ~= offer["cost"] then
    sendJSON(player, "categories", SHOP_CATEGORIES) -- refresh categories, maybe invalid
    return sendMessage(player, "Error!", "Invalid offer")    
  end
  local points = getStorePoints(player)
  if not offer['cost'] or offer['cost'] > points or points < 1 then
    return sendMessage(player, "Error!", "You don't have enough points to buy " .. offer['title'] .."!", true)  
  end
  local status = callback(player, offer)
  if status == true then  
    db.query("UPDATE `accounts` set `premium_points` = `premium_points` - " .. offer['cost'] .. " WHERE `id` = " .. player:getAccountId())
    db.asyncQuery("INSERT INTO `shop_history` (`account`, `player`, `date`, `title`, `cost`, `details`) VALUES ('" .. player:getAccountId() .. "', '" .. player:getGuid() .. "', NOW(), " .. db.escapeString(offer['title']) .. ", " .. db.escapeString(offer['cost']) .. ", " .. db.escapeString(json.encode(offer)) .. ")")
    return sendMessage(player, "Success!", "You bought " .. offer['title'] .."!", true)
  end
  if status == nil or status == false then
    status = "Unknown error while buying " .. offer['title']
  end
  sendMessage(player, "Error!", status)
end

function sendHistory(player)
  if player:getStorageValue(1150002) and player:getStorageValue(1150002) + 10 > os.time() then
    return -- min 10s delay
  end
  player:setStorageValue(1150002, os.time())
 
  local history = {}
  local resultId = db.storeQuery("SELECT * FROM `shop_history` WHERE `account` = " .. player:getAccountId() .. " order by `id` DESC")

  if resultId ~= false then
    repeat
      local details = result.getDataString(resultId, "details")
      local status, json_data = pcall(function() return json.decode(details) end)
      if not status then  
        json_data = {
          type = "image",
          title = result.getDataString(resultId, "title"),
          cost = result.getDataInt(resultId, "cost")
        }
      end
      table.insert(history, json_data)
      history[#history]["description"] = "Bought on " .. result.getDataString(resultId, "date") .. " for " .. result.getDataInt(resultId, "cost") .. " points."
    until not result.next(resultId)
    result.free(resultId)
  end
 
  sendJSON(player, "history", history)
end

-- BUY CALLBACKS
-- May be useful: print(json.encode(offer))

function defaultItemBuyAction(player, offer)
  -- todo: check if has capacity
  if player:addStoreItem(offer["itemId"], offer["count"], false) then
    return true
  end
  return "Can't add items! Do you have enough space?";
end
-------------------------------------------------------

function defaultOutfitBuyAction(player, offer)
  local outfit = offer['outfit']
  local mountId = outfit['mount']

  if player:getStorageValue(outfit['storage']) > 0 then
      local message = "You already have this " .. outfit['name'] .. "!"
      player:sendTextMessage(MESSAGE_INFO_DESCR, message)
      return false
  end

  local points = getStorePoints(player)
  if offer['cost'] > points or points < 1 then
      player:sendTextMessage(MESSAGE_INFO_DESCR, "You don't have enough points to buy this outfit")
      return false
  end

  if mountId ~= 0 then
    player:addMount(mountId) -- Adding the mount to the player
  end

  local outfit = offer["outfit"]
  local outfitId = player:addOutfit(outfit["type"], outfit["id"], outfit["addons"], mountId) -- Use the specified mountId

  if outfitId ~= 0 then
    player:setStorageValue(outfit['storage'], 1)

    -- Check if addons should be added
    if outfit["addons"] == 1 then
      player:addOutfitAddon(outfit["type"], 1) -- Add addon 1
    elseif outfit["addons"] == 2 then
      player:addOutfitAddon(outfit["type"], 1) -- Add addon 1
      player:addOutfitAddon(outfit["type"], 2) -- Add addon 2
    end

    local message = "You bought the " .. outfit['name'] .. "!"
    player:sendTextMessage(MESSAGE_INFO_DESCR, message)
    return true
  else
    return "Couldn't add the outfit to the player."
  end
end


function defaultImageBuyAction(player, offer)
  return "default image buy action is not implemented"
end

function customImageBuyAction(player, offer)
  local premiumDays = offer['cost'] 
  if not premiumDays or premiumDays <= 0 then
    return "Error: Invalid premium days"
  end
  player:addPremiumDays(premiumDays)
  player:sendTextMessage(MESSAGE_INFO_DESCR, "You bought " .. premiumDays .. " premium days!")
  return true
end