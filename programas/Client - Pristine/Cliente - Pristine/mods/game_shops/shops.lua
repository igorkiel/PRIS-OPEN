local EditShopWindow, SelectItemWindow
MainWindow = {}

local Config = {
  opcode = 101,
  defaultShopMessage = 'Good wares at excellent prices!',

  -- Players cannot sell money. Set the client ids of the money
  money = {
    3031,
    3035,
    3043
  }
}

local function onGameStart()
  if not MainWindow then return end
  hide()
end
  
local function onGameEnd()
  if not MainWindow then return end
  hide()
end

function onShopClose() -- Player requested shop close
  local shopClose = function(recoverItems)
    local payload = {
      e = 'SHOP_CLOSE',
      d = recoverItems
    }

    g_game.getProtocolGame():sendExtendedOpcode(Config.opcode, json.encode(payload))
    hide()
  end

  if isOwnShop() then
    if MainWindow.currentShop.offers < 1 then
      hide()
      return
    end

    local confirmActionWindow = g_ui.createWidget("ConfirmActionWindow", MainWindow)
    confirmActionWindow:setText("Close Shop")
    confirmActionWindow.message:setText("Do you wish to retrieve your items?")

    confirmActionWindow.buttonOk:setText("Yes")
    confirmActionWindow.buttonCancel:setText("Not yet")

    confirmActionWindow.buttonOk:disable()
    confirmActionWindow.buttonOk:setText("Yes (2)")

    scheduleEvent(function()
      if not confirmActionWindow.buttonOk then return end
      confirmActionWindow.buttonOk:setText("Yes (1)")
      scheduleEvent(function()
        if not confirmActionWindow.buttonOk then return end
        confirmActionWindow.buttonOk:setText("Yes")
        confirmActionWindow.buttonOk:setEnabled(true)
        confirmActionWindow.onEnter = function() shopClose(true) confirmActionWindow:destroy() end
      end, 1000)
    end, 100)

    confirmActionWindow.buttonOk.onClick = function()
      shopClose(true)
      confirmActionWindow:destroy()
    end

    confirmActionWindow.buttonCancel.onClick = function()
      shopClose(false)
      confirmActionWindow:destroy()
    end

    confirmActionWindow.onEscape = function()
      shopClose(false)
      confirmActionWindow:destroy()
    end

    confirmActionWindow:show()
    confirmActionWindow:raise()
    confirmActionWindow:focus()
  else
    shopClose()
  end
end

function openShop(sellerId)
  local payload = {
    e = 'SHOP_OPEN',
    d = sellerId
  }

  g_game.getProtocolGame():sendExtendedOpcode(Config.opcode, json.encode(payload))
end

local function requestRemoveOffer(offerId)
  if not MainWindow.currentShop or MainWindow.currentShop.seller ~= g_game.getLocalPlayer():getId() then return false end

  for i=1,6 do
    local panel = MainWindow:getChildById('offer'..i)

    local offer = panel.offerData
    if offer and offer.id == offerId then
      local payload = {
        e = 'SHOP_REMOVE_OFFER',
        d = offerId
      }

      g_game.getProtocolGame():sendExtendedOpcode(Config.opcode, json.encode(payload))
      break
    end
  end

  return true
end

local function requestModifyOffer(offerId, newitem)
  if MainWindow.currentShop.open then
    scheduleEvent(
      function()
        MainWindow.pauseButton:setBorderWidth(1)
        scheduleEvent(function() MainWindow.pauseButton:setBorderWidth(0) end, 350)
      end
    , 150)

    return false
  end

  local panel
  for i=1,6 do
    local p = MainWindow:getChildById('offer'..i)
    if p.offerData and p.offerData.id == offerId then
      panel = p
    end
  end

  if not panel then return end
  local offer = panel.offerData

  SelectItemWindow:setText("Edit Offer")

  SelectItemWindow.count = offer.count

  SelectItemWindow.priceLabel:setText('New price: ')
  SelectItemWindow.priceEdit:setText(offer.price)
  SelectItemWindow.priceEdit:enable()

  SelectItemWindow.item:setItem(panel.offerItem:getItem())
  SelectItemWindow.item:setItemCount(offer.count)
  SelectItemWindow.item:setShowCount(true)

  local scrollbar = SelectItemWindow.amountScrollBar
  scrollbar:setMinimum(1)

  if panel.offerItem:getItem():isStackable() then
    local max = offer.count
    if newitem then
      scrollbar:setMinimum(offer.count)
      max = math.min(100, offer.count + newitem:getCount())
      SelectItemWindow.priceEdit:disable()
    end

    scrollbar:setMaximum(max)

    scrollbar.onValueChange = function (self, value)
      SelectItemWindow.item:setItemCount(value)
      SelectItemWindow.count = value
      panel.offerItem:setItemCount(value)
      if SelectItemWindow.price > 0 then
        SelectItemWindow.priceLabel:setText('(total earnings: '..SelectItemWindow.price + SelectItemWindow.count..')')
      else
        SelectItemWindow.priceLabel:setText('New price: ')
      end
      scrollbar:setText(value)
    end

    scrollbar:enable()
  else
    scrollbar:setMaximum(1)
    scrollbar:disable()
  end

  scrollbar:setValue(offer.count)
  scrollbar:setText(offer.count)

  SelectItemWindow.buttonOk.onClick = function()
    if SelectItemWindow.price < 1 then
      return displayInfoBox("Enter a valid price.")
    elseif SelectItemWindow.count < 1 or SelectItemWindow.count > 100 then
      return displayInfoBox("Select a valid item count.")
    end

    local payload = {
      e = 'SHOP_EDIT_OFFER',
      d = {
        offer = offerId,
        count = SelectItemWindow.count,
        price = SelectItemWindow.price
      }
    }

    g_game.getProtocolGame():sendExtendedOpcode(Config.opcode, json.encode(payload))
    SelectItemWindow:hide()
  end

  SelectItemWindow.buttonCancel.onClick = function()
    SelectItemWindow.item:clearItem()
    panel.offerItem:setItemCount(offer.count)
    SelectItemWindow:hide()
  end

  SelectItemWindow:show()
  return true
end

function isOwnShop()
  if not MainWindow.currentShop then return false end
  return g_game.getLocalPlayer():getId() == MainWindow.currentShop.seller
end

function onSelectOffer(widget)
  local item = widget.offerItem
  if not item then return end

  if isOwnShop() then return end

  if MainWindow.selectedPanel then
      MainWindow.selectedPanel:setChecked(false)
      MainWindow.buyButton:setEnabled(false)
      if MainWindow.selectedPanel == widget then
        MainWindow.selectedPanel = nil
        return
      end

      MainWindow.selectedPanel = nil
  end

  if widget.offerData.price > MainWindow.currentShop.funds then
    scheduleEvent(
      function()
        MainWindow.earnings:setColor("white")
        scheduleEvent(function() MainWindow.earnings:setColor("yellow") end, 350)
      end
    , 150)
    return
  end

  MainWindow.selectedPanel = widget
  MainWindow.selectedPanel:setChecked(true)
  MainWindow.buyButton:setEnabled(true)
end

local function onSlotHoverChange(widget, hovered)
  local draggingWidget = g_ui.getDraggingWidget()

  local panel = widget:getParent()
    
  if hovered then
    if draggingWidget and widget ~= draggingWidget then
      local gotItem = draggingWidget:getClassName() == 'UIItem' and not draggingWidget:isVirtual()
      if gotItem then
        local item = draggingWidget:getItem()
        if not widget:isOn() then
          if item:getId() == panel.offerData.cid or not item:isStackable() then
            widget:setOn(true)
          else
            return
          end
        end

        if item and not table.contains(Config.money, item:getId()) and not item:isContainer() and item:getPosition() and item:getPosition().x == 0xFFFF and isOwnShop() then
          widget:setBorderWidth(1)
          draggingWidget.hoveredWho = widget
          return
        end
      end

      draggingWidget.hoveredWho = nil
    end
  end
  
  widget:setBorderWidth(0)
end

local function onSelectItemToSell(widget, draggedItem, mousePos, forced)
  local panel = widget:getParent()

  if not widget:canAcceptDrop(draggedItem, mousePos) and not forced then return false end
  if not panel.offerItem:isOn() then return false end

  local item = draggedItem.currentDragThing
  if not item or not item:isItem() or not item:isPickupable() then return false end

  local count = item:getCount()

  widget:setBorderWidth(0)

  if table.contains(Config.money, item:getId()) or item:isContainer() then
    return false
  end

  if not table.empty(panel.offerData) then
    if item:getId() == panel.offerData.cid and item:isStackable() then
      return requestModifyOffer(panel.offerData.id, item)
    else
      widget:setOn(false)
      return false
    end
  end

  if item:getPosition().x ~= 0xFFFF then
    displayInfoBox("Error", "The item must be in your inventory.")
    return false
  end

  widget:setItem(Item.create(item:getId(), item:getCountOrSubType()))
  local fromPos = item:getPosition()

  SelectItemWindow:setText("Add Offer")

  SelectItemWindow.priceLabel:setText('Enter price: ')
  SelectItemWindow.priceEdit:clearText()
  SelectItemWindow.priceEdit:enable()

  local scrollbar = SelectItemWindow.amountScrollBar

  SelectItemWindow.item:setItemId(widget:getItemId())
  SelectItemWindow.item:setItemCount(count)
  SelectItemWindow.item:setItemSubType(widget:getItemSubType())
  
  SelectItemWindow.item:setShowCount(true)

  SelectItemWindow.count = item:getCount()

  scrollbar:setMaximum(count)
  scrollbar:setMinimum(1)

  scrollbar.onValueChange = function (self, value)
    SelectItemWindow.item:setItemCount(value)
    SelectItemWindow.count = value
    if SelectItemWindow.price > 0 then
      SelectItemWindow.priceLabel:setText('(total earnings: '..SelectItemWindow.price * SelectItemWindow.count..')')
    else
      SelectItemWindow.priceLabel:setText('Enter price: ')
    end
    scrollbar:setText(value)
  end

  scrollbar:setValue(count)
  scrollbar:setText(count)

  SelectItemWindow.buttonOk.onClick = function()
    if SelectItemWindow.price < 1 then
      return displayInfoBox("Enter a valid price.")
    elseif SelectItemWindow.count < 1 then
      return displayInfoBox("Select a valid item count.")
    end

    panel.offerItem:setOn(false)

    local payload = {
      e = 'SHOP_ADD_OFFER',
      d = {
        cid = item:getId(),
        subtype = widget:getItemSubType(),
        count = SelectItemWindow.count,
        pos = fromPos,
        price = SelectItemWindow.price
      }
    }

    g_game.getProtocolGame():sendExtendedOpcode(Config.opcode, json.encode(payload))
    SelectItemWindow:hide()
  end

  SelectItemWindow.buttonCancel.onClick = function()
    panel.offerItem:clearItem()
    panel.offerItem:setOn(true)
    SelectItemWindow:hide()
  end

  MainWindow.selectItem:show()
  MainWindow.selectItem:focus()
end

local function formatNumber(n)
  return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1,")
                                :gsub(",(%-?)$","%1"):reverse()
end

local function parseShopOpen(data)
  if MainWindow.currentShop ~= {} then
    if MainWindow.lockUpdate then
      MainWindow.lockUpdate = data
      return
    end

    MainWindow.currentShop = {}
    --hide()
  end

  local message = data.info

  MainWindow.currentShop.message = data.info
  MainWindow.currentShop.seller = data.seller
  MainWindow.currentShop.own = data.own
  MainWindow.currentShop.maxOffers = data.maxOffers
  MainWindow.currentShop.offers = 0

  MainWindow.currentShop.earnings = data.earned

  if isOwnShop() then
    MainWindow.earnings:setText(formatNumber(data.earned))
    MainWindow.closeButton:setImageColor("red")

    MainWindow.closeButton:addAnchor(AnchorTop, 'pauseButton', AnchorBottom)

    MainWindow.buyButton:disable()
    MainWindow.buyButton:setHeight(0)

    MainWindow.pauseButton:show()
    MainWindow.pauseButton:enable()

    MainWindow.currentShop.open = data.open

    if data.open then
      MainWindow.pauseButton:setOn(true)
    else
      MainWindow.pauseButton:setOn(false)
    end

    MainWindow.pauseButton.onClick = function()
      local payload = {
        e = 'SHOP_TOGGLE'
      }

      g_game.getProtocolGame():sendExtendedOpcode(Config.opcode, json.encode(payload))
    end

    MainWindow.earningsLabel:setText("Your earnings: ")

    if data.earned < 100 then
      MainWindow.earnings:setColor("white")
    else
      MainWindow.earnings:setColor("green")
    end
  else
    MainWindow.pauseButton:hide()
    MainWindow.earningsLabel:setText("Your funds: ")

    MainWindow.buyButton:setHeight(25)
    MainWindow.buyButton:disable()

    MainWindow.closeButton:addAnchor(AnchorTop, 'buyButton', AnchorBottom)

    MainWindow.closeButton:setImageColor("#dfdfdf")

    if data.money then
      MainWindow.currentShop.funds = data.money
      MainWindow.earnings:setText(formatNumber(data.money))
      MainWindow.earnings:setColor("yellow")
    else
      MainWindow.currentShop.funds = 0
      MainWindow.earnings:setText("?")
      MainWindow.earnings:setColor("white")
    end
  end

  MainWindow.earningsLabel:resizeToText()

  --MainWindow.earnings:addAnchor(AnchorLeft, 'earningsLabel', AnchorRight)

  for i=1,6 do
    local offer = data.offers[i]
    local panel = MainWindow:getChildById('offer'..i)
  
    if panel.activeContainerPanel then panel.activeContainerPanel:destroy() end

    panel.offerItem.onHoverChange = onSlotHoverChange
    if not panel.offerData then panel.offerData = {} end

    panel:setTooltip("")

    panel.offerItem:setOn(false)

    panel:setChecked(false)

    if offer then
      local offerId = offer.offer

      panel.price:setColor("yellow")
      if panel.offerData.id ~= offerId or panel.offerData.cid ~= offer.cid or panel.offerData.count ~= offer.count or panel.offerData.price ~= offer.price then
        panel.emptyLabel:hide()

        local name = offer.name
        name = name:sub(1,1):upper() .. name:sub(2)

        
        panel.itemName:setText(name)

        panel.priceLabel:show()

        local weightString = tr("%.2f oz.", offer.weight / 100)
        panel.weight:setText(weightString)

        panel.offerData = {
          id = offerId,
          cid = offer.cid,
          price = offer.price,
          count = offer.count,
          content = offer.content
        }

        panel.offerItem:setItemId(offer.cid)
        panel.offerItem:setItemCount(offer.count)

        panel.price:setText(formatNumber(offer.price))
        panel.price:show()

        if not panel.offerItem:getItem():isStackable() then
          panel.offerItem:setItemSubType(offer.subtype)
        end

        panel.offerItem:setShowCount(true)
        panel:setOn(true)

        if offer.count > 1 then
          panel:setTooltip("Total: "..offer.price*offer.count.."gp")
        end

        panel.offerItem:show()
        panel.itemName:show()
        panel.priceLabel:show()
        panel.weight:show()
      end

      if not isOwnShop()then
        if offer.price > data.money then
          panel.price:setColor("#ff1212")
        else
          panel.price:setColor("green")
        end
      end

      MainWindow.currentShop.offers = MainWindow.currentShop.offers + 1
    else
      panel.emptyLabel:show()
      panel.offerItem:hide()
      panel.itemName:hide()
      panel.price:hide()
      panel.priceLabel:hide()
      panel.weight:hide()

      panel.offerData = {}
      
      panel.offerItem:clearItem()
      panel:setOn(false)

      if isOwnShop() then
        panel.offerItem:setOn(true)
        panel.offerItem:show()
      end
    end
    
    if isOwnShop() then
      panel.offerItem.onDrop = onSelectItemToSell
    
      panel.onMouseRelease = function (self, mousePosition, mouseButton)
        if mouseButton == MouseRightButton and self:isOn() then
          local menu = g_ui.createWidget('PopupMenu')
          menu:addOption('Remove', function() return requestRemoveOffer(panel.offerData.id) end)
          menu:addOption('Modify', function() return requestModifyOffer(panel.offerData.id) end)
          menu:setGameMenu(true)
          menu:display(mousePos)
        end
      end
    end
  end

  local seller = g_map.getCreatureById(data.seller)
  if not seller or not seller:isPlayer() then displayInfoBox("Error", "Player not found.") end

  --local shopMessage = currentShop.message
  --if not shopMessage then
  --  currentShop.message = StaticText.create()
  --  shopMessage = currentShop.message
  --  shopMessage:addMessage(nil, MessageModes.NpcFrom, Config.defaultShopMessage)
  --else
  --  shopMessage:hide()
  --end

  --g_map.addThing(shopMessage, seller:getPosition(), -1)

  MainWindow.creature:setOutfit(seller:getOutfit())

  if isOwnShop() then
    MainWindow:setText("Your Shop")
  else
    MainWindow:setText(seller:getName().."\'s shop")
  end

  show()
end

function onPressBuy(button)
  local panel = MainWindow.selectedPanel
  if not panel then
    button:setEnabled(false)
    return
  end

  if not MainWindow.lockUpdate then
    MainWindow.lockUpdate = {}
  end
  
  local offerId = panel.offerData.id
  local itemcid = panel.offerData.cid
  local price = panel.offerData.price
  local count = panel.offerData.count

  local ConfirmBuyWindow = g_ui.createWidget('ConfirmBuyWindow', MainWindow)
  local scrollbar = ConfirmBuyWindow.amountScrollBar

  ConfirmBuyWindow.item:setItemId(itemcid)
  ConfirmBuyWindow.item:setItemCount(count)
  ConfirmBuyWindow.item:setShowCount(true)

  scrollbar:setMaximum(count)
  scrollbar:setMinimum(1)

  scrollbar.onValueChange = function (self, value)
    ConfirmBuyWindow.item:setItemCount(value)
    ConfirmBuyWindow.count = value
    ConfirmBuyWindow.priceLabel:setText('(total spent: '..price * value..')')
    scrollbar:setText(value)
  end

  ConfirmBuyWindow.count = count or 1
  scrollbar:setValue(count)
  scrollbar:setText(count)

  local requestBuy = function()
    local payload = {
      e = 'SHOP_BUY',
      d = {
        offer = offerId,
        count = ConfirmBuyWindow.count,
        cid = panel.offerData.cid
      }
    }

    g_game.getProtocolGame():sendExtendedOpcode(Config.opcode, json.encode(payload))

    if MainWindow.lockUpdate ~= {} then
      parseShopOpen(MainWindow.lockUpdate)
    end

    MainWindow.lockUpdate = nil
  end

  if panel.offerItem:getItem():isStackable() and count > 1 then
    ConfirmBuyWindow.buttonOk.onClick = function()
        local ConfirmActionWindow = g_ui.createWidget('ConfirmActionWindow', ConfirmBuyWindow)
        ConfirmActionWindow.message:setText("You are about to buy "..panel.itemName:getText().." for "..price*ConfirmBuyWindow.count.."gp.\nDo you want to complete the purchase?")
        ConfirmActionWindow.buttonOk:setImageColor("green")
        ConfirmActionWindow.buttonOk:setText("Confirm (2)")
        ConfirmActionWindow.buttonOk:setEnabled(false)
        
        scheduleEvent(function()
          if not ConfirmActionWindow then return end
          ConfirmActionWindow.buttonOk:setText("Confirm (1)")
          scheduleEvent(function()
            if not ConfirmActionWindow then return end
            ConfirmActionWindow.buttonOk:setText("Confirm")
            ConfirmActionWindow.buttonOk:setEnabled(true)
          end, 1000)
        end, 150)
      
        ConfirmActionWindow.buttonOk.onClick = function()
          requestBuy()
        
          ConfirmActionWindow:destroy()
          ConfirmBuyWindow:destroy()
        end
      
        ConfirmActionWindow.buttonCancel.onClick = function()
          ConfirmActionWindow:destroy()
          ConfirmBuyWindow:focus()
        end
      end
  else
    ConfirmBuyWindow.buttonOk.onClick = function()
      requestBuy()
      ConfirmBuyWindow:hide()
    end
  end

  ConfirmBuyWindow.buttonCancel.onClick = function()
    ConfirmBuyWindow:hide()
    MainWindow:focus()

    if MainWindow.lockUpdate ~= {} then
      parseShopOpen(MainWindow.lockUpdate)
    end

    MainWindow.lockUpdate = nil
  end

  ConfirmBuyWindow:show()
end

local function parseShopClose()
  hide()
end

local function parseShop(protocol, opcode, buffer)
  if opcode ~= Config.opcode then return end

  buffer = json.decode(buffer)

  local data = buffer.d
  local evt = buffer.e

  if not evt then return end

  if evt == 'SHOP_OPEN' then
    parseShopOpen(data)
  elseif evt == 'SHOP_CLOSE' then
    parseShopClose()
  end
end

function onEditShop()
  EditShopWindow:show()

  EditShopWindow:raise()
  EditShopWindow:focus()
end

local function parseShopClose(data)
  MainWindow:hide()
  MainWindow:setEnabled(false)
  MainWindow.currentShop = {}
end

function doShopClose()
  local payload = {
    e = 'SHOP_CLOSE',
    d = MainWindow.currentShop.seller,
  }

  g_game.getProtocolGame():sendExtendedOpcode(Config.opcode, json.encode(payload))
end

function show()
  MainWindow:show()
  MainWindow:focus()
end

function hide()
  MainWindow.lockUpdate = nil
  MainWindow:hide()
  EditShopWindow:hide()
  SelectItemWindow:hide()
end

local function requestShopCreate(player)
  if MainWindow.currentShop and MainWindow.currentShop.seller == player:getId() then
    displayInfoBox("Error", "Your shop is already open.")
    return false
  end

  local payload = {
    e = 'SHOP_CREATE'
  }

  g_game.getProtocolGame():sendExtendedOpcode(Config.opcode, json.encode(payload))
end

local function onShopCreate(player, data)
  
end

function onPositionChange(player, newPos, oldPos)
  if player:isLocalPlayer() then
    show()
  end
end

function init()
  connect(g_game, {
    onGameEnd = onGameEnd,
    onGameStart = onGameStart
  })

  MainWindow = g_ui.loadUI('shops', g_ui.getRootWidget())
  EditShopWindow = g_ui.createWidget('EditShopWindow', g_ui.getRootWidget())
  -- MainWindow.onEscape = function() MainWindow:hide() end

  MainWindow.contentInfo = g_ui.createWidget('ContainerPanel', g_ui.getRootWidget())
  MainWindow.contentInfo.panel = nil
  MainWindow.contentInfo:hide()

  SelectItemWindow = MainWindow.selectItem

  hide()

  MainWindow.currentShop = {}
  
  MainWindow.offer5.offerItem:setImageSource("/images/ui/rarity_gold")
  MainWindow.offer6.offerItem:setImageSource("/images/ui/rarity_gold")

  if g_game.isOnline() then onGameStart() end
  ProtocolGame.registerExtendedOpcode(Config.opcode, parseShop)
end


local function onCreatureAppear(creature)
  local payload = {
    e = 'ASK',
    d = creature.id
  }

  g_game.getProtocolGame():sendExtendedOpcode(Config.opcode, json.encode(payload))
end