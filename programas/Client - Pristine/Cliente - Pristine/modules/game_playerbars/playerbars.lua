playerBarsWindow = nil
skillsButton = nil
battleButton = nil
vipButton = nil
spelllistButton = nil
cooldownButton = nil
hotkeyButton = nil
questLogButton = nil
healthInfoButton = nil
unjustifieldButton = nil
preyButton = nil
preytrackerButton = nil
analyzerButton = nil
inventoryButton = nil
minimapButton = nil
taskButton = nil
tasktrackerButton = nil
guildButton = nil
storebutton = nil
resizeButton = nil

function init()
  connect(g_game, {
    onGameStart = online,
    onGameEnd = offline
  })

  playerBarsWindow = g_ui.loadUI('playerbars', modules.game_interface.getRightPanel())

  -- Referenciando os botões corretamente
  resizeButton = playerBarsWindow:recursiveGetChildById('resizeButton')
  skillsButton = playerBarsWindow:recursiveGetChildById('SkillsButton')
  battleButton = playerBarsWindow:recursiveGetChildById('BattleButton')
  vipButton = playerBarsWindow:recursiveGetChildById('VipButton')
  spelllistButton = playerBarsWindow:recursiveGetChildById('spelllistButton')
  cooldownButton = playerBarsWindow:recursiveGetChildById('cooldownButton')
  hotkeyButton = playerBarsWindow:recursiveGetChildById('hotkeyButton')
  questLogButton = playerBarsWindow:recursiveGetChildById('questLogButton')
  healthInfoButton = playerBarsWindow:recursiveGetChildById('healthInfoButton')
  unjustifieldButton = playerBarsWindow:recursiveGetChildById('unjustifieldButton')
  preyButton = playerBarsWindow:recursiveGetChildById('preyButton')
  preytrackerButton = playerBarsWindow:recursiveGetChildById('preytrackerButton')
  analyzerButton = playerBarsWindow:recursiveGetChildById('analyzerButton')
  inventoryButton = playerBarsWindow:recursiveGetChildById('inventoryButton')
  minimapButton = playerBarsWindow:recursiveGetChildById('minimapButton')
  taskButton = playerBarsWindow:recursiveGetChildById('taskButton')
  tasktrackerButton = playerBarsWindow:recursiveGetChildById('tasktrackerButton')
  guildButton = playerBarsWindow:recursiveGetChildById('guildButton')
  storebutton = playerBarsWindow:recursiveGetChildById('storebutton')
  
  playerBarsWindow:open()

end

function terminate()
  disconnect(g_game, {
    onGameStart = online,
    onGameEnd = offline
  })

  playerBarsWindow:destroy()
end

function offline()
  local lastPlayerBars = g_settings.getNode('LastPlayerBars')
  if not lastPlayerBars then
    lastPlayerBars = {}
  end

  local player = g_game.getLocalPlayer()
  if player then
    local char = g_game.getCharacterName()

    lastPlayerBars[char] = {
      checkSkill = getCheckedButtons(skillsButton),
      checkBattle = getCheckedButtons(battleButton),
      checkVip = getCheckedButtons(vipButton),
    }
    g_settings.setNode('LastPlayerBars', lastPlayerBars)
  end
end

function online()
  local player = g_game.getLocalPlayer()
  if player then
    local char = g_game.getCharacterName()
    local lastPlayerBars = g_settings.getNode('LastPlayerBars')
    if not table.empty(lastPlayerBars) then
      if lastPlayerBars[char] then
         skillsButton:setChecked(lastPlayerBars[char].checkSkill)
         battleButton:setChecked(lastPlayerBars[char].checkBattle)
         vipButton:setChecked(lastPlayerBars[char].checkVip)
      end
    end
  end
end

function getCheckedButtons(button)
 if button:isChecked() then
   return 1
 else
   return nil
 end
end

function toggleResize()
    local minimizedHeight = 50  -- Altura quando minimizado
    local maximizedHeight = 100  -- Altura quando maximizado

    -- Alterna entre os estados minimizado e maximizado
    if playerBarsWindow:getHeight() == minimizedHeight then
        playerBarsWindow:setHeight(maximizedHeight)
        resizeButton:setImageSource('/images/topbuttons/button_shrink')  -- Ícone para minimizar
        resizeButton:setImageClip({0, 0, 44, 20})  -- Define o clip padrão
    else
        playerBarsWindow:setHeight(minimizedHeight)
        resizeButton:setImageSource('/images/topbuttons/button_enlarge')  -- Ícone para maximizar
        resizeButton:setImageClip({0, 0, 44, 20})  -- Define o clip padrão
    end
end

