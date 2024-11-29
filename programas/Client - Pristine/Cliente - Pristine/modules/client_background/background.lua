-- private variables
local background
local infoWindow
local topMenu
local dailyMonstersPanel
local hoverWindow

local infoTexts = {
  [1] = "Tibia Pristine Client",
  [2] = "v1.0",
  [3] = "Copyright (C) 2024",
  [4] = "by Shalk",
  [5] = "All rights reserved.",
  [6] = "Official website",
  [7] = "tibiapristine.online",
}

-- public functions
function init()
  -- Attempt to load the background UI
  background = g_ui.displayUI('background')
  if not background then
    g_logger.error("Failed to load the background UI. Check the .otui file.")
    return
  end
  background:lower()

  infoWindow = background:getChildById('infoBox')
  if infoWindow then
    infoWindow:hide()
  else
    g_logger.error("infoBox not found in background UI.")
  end
  
  -- Get the top menu widget
  topMenu = modules.client_topmenu.getTopMenu()
  
  dailyMonstersPanel = background:getChildById("dailyMonsters")
  if not dailyMonstersPanel then
    g_logger.error("dailyMonsters panel not found in background UI.")
  end

  connect(g_game, { onGameStart = hide })
  connect(g_game, { onGameEnd = show })
  
  setClientInfo()
end

function terminate()
  disconnect(g_game, { onGameStart = hide })
  disconnect(g_game, { onGameEnd = show })

  if infoWindow then infoWindow:destroy() end
  if background then background:destroy() end
  
  background = nil
end

function hide()
  if background then
    background:hide()
  end
  
  -- Always hide the top menu
  if topMenu then
    topMenu:hide()
  end
end

function show()
  if background then
    background:show()
  end
  
  -- Always hide the top menu even when background is shown
  if topMenu then
    topMenu:hide()
  end
end

function infoShow()
  if infoWindow and not infoWindow:isVisible() then
    infoWindow:setVisible(true)
  end
end

function infoHide()
  if infoWindow and infoWindow:isVisible() then
    infoWindow:setVisible(false)
  end
end

function setClientInfo()
  if not infoWindow then
    g_logger.error("infoWindow is not initialized.")
    return
  end

  for label, text in pairs(infoTexts) do 
    local labelWidget = infoWindow:getChildById('infoLabel' .. label)
    if labelWidget then
      labelWidget:setText(text)
    else
      g_logger.error("Label infoLabel" .. label .. " not found.")
    end
  end
end

function getBackground()
  return background
end

function getImageClip(id)
  if not id then
    return "0 0 19 19"
  end

  return (((id - 1) % 8) * 19) .. " " .. ((math.ceil(id / 8) - 1) * 19) .. " 19 19"
end

function setIconImageType(widget, id)
  if not id then
    return false
  end

  widget:setImageClip(getImageClip(id))
end

function onHoverChange(self, hovered)
  if not hovered then
    if hoverWindow then
      hoverWindow:destroy()
      hoverWindow = nil
    end
    return true
  end

  local pos = self:getPosition()
  pos.x = pos.x - 82
  pos.y = pos.y - 112

  hoverWindow = g_ui.displayUI("dailybonus")
  if hoverWindow then
    hoverWindow:setPosition(pos)
  else
    g_logger.error("Failed to create hover window.")
    return
  end

  for k, v in pairs(self.data) do
    local iconId = 0
    local description = ""
    if k == "damage" then
      iconId = 19
      description = v .. "% More Damage"
    elseif k == "health" then
      iconId = 27
      description = v .. "% More Maximum Health"
    elseif k == "experience" then
      iconId = 49
      description = v .. "% More Experience"
    elseif k == "loot" then
      iconId = 15
      description = v .. "% Higher Drop Chance"
    elseif k == "spawn" then
      iconId = 38
      description = v .. "% Faster Spawn Rate"
    end

    if iconId ~= 0 then
      local widget = g_ui.createWidget("DailyMultiplierLabel", hoverWindow:getChildById("list"))
      if widget then
        setIconImageType(widget:getChildById("icon"), iconId)
        widget:setText(description)
      else
        g_logger.error("Failed to create DailyMultiplierLabel widget.")
      end
    end
  end
end

function updateDailyMonsters(dailyMonsters)
  if not dailyMonstersPanel then
    g_logger.error("dailyMonstersPanel is not initialized.")
    return
  end

  for i = 1, #dailyMonsters do
    local widget = g_ui.createWidget("DailyMonster", dailyMonstersPanel)
    if widget then
      widget:getChildById("creature"):setOutfit(dailyMonsters[i][2])
      widget:getChildById("name"):setText(dailyMonsters[i][1].name)
      widget.data = dailyMonsters[i][1]
      widget.onHoverChange = onHoverChange
    else
      g_logger.error("Failed to create DailyMonster widget.")
    end
  end

  dailyMonstersPanel:setWidth((#dailyMonsters * 128) + ((#dailyMonsters - 1) * 4))
end
