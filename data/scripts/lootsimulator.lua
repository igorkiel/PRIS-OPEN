-- made by rondel, discord: @rondel_

lootSimulator = {
  OPCODE = 222,
  MAX_PACKET_SIZE = 6000,
  corpseContainers = {1987}, -- add all the containers which are created inside your monsters
  MONSTERS = {
    "amazon",
    "rotworm",
    "rat",
    "cave rat",
    "dragon",
    "dragon lord"
  }
}

lootSimulator.getMonsterOutfit = function(mInfo)
  if mInfo then
    local outfit = mInfo:getOutfit()
    return {
      type = outfit.lookType,
      head = outfit.lookHead,
      body = outfit.lookBody,
      legs = outfit.lookLegs,
      feet = outfit.lookFeet
    }
  end
end

lootSimulator.sendJSON = function(cid, tablex)
  local player = Player(cid)
  if not player then
    return false
  end
  local buffer = json.encode(tablex)
  local s = {}
  for i = 1, #buffer, lootSimulator.MAX_PACKET_SIZE do
    s[#s + 1] = buffer:sub(i, i + lootSimulator.MAX_PACKET_SIZE - 1)
  end
  if #s == 1 then
    player:sendExtendedOpcode(lootSimulator.OPCODE, s[1])
    return
  end
  player:sendExtendedOpcode(lootSimulator.OPCODE, "S" .. s[1])
  for i = 2, #s - 1 do
    player:sendExtendedOpcode(lootSimulator.OPCODE, "P" .. s[i])
  end
  player:sendExtendedOpcode(lootSimulator.OPCODE, "E" .. s[#s])
end

lootSimulator.simulateLootDrop = function(pid, monsterName, monsterKills, rateLoot)
  local mType = MonsterType(monsterName)
  local ret = {}
  if mType then
    local mLoot = mType:getLoot()
    local droppedItems = {}
    for k = 1, monsterKills do
      local mCorpse = Game.createItem(1988)
      for i = 1, #mLoot do
        local item = mCorpse:createSimulationLootItem(mLoot[i], rateLoot)
        if not item then
          -- print('[lootSimulator - simulateLootDrop]:', 'Could not add loot item to corpse.')
        end
      end

      for _, item in ipairs(mCorpse:getItems()) do
        local itemName = item:getName():lower()
        local itemId = item:getId()
        if table.contains(lootSimulator.corpseContainers, itemId) then
          for _, it in ipairs(item:getItems()) do
            local itName = it:getName():lower()
            local itId = it:getId()
            if droppedItems[itId] then
              droppedItems[itId].count = droppedItems[itId].count + it:getCount()
            else
              droppedItems[itId] = {
                count = it:getCount(),
                name = itName,
                cId = ItemType(itId):getClientId(),
              }
            end
          end
        else
          if droppedItems[itemId] then
            droppedItems[itemId].count = droppedItems[itemId].count + item:getCount()
          else
            droppedItems[itemId] = {
              count = item:getCount(),
              name = itemName,
              cId = ItemType(itemId):getClientId(),
            }
          end
        end
      end
      mCorpse:remove()
    end

    for _, itemInfo in pairs(droppedItems) do
      local chance = 100 / (monsterKills / itemInfo.count)
      if chance > 100 then
        chance = 100
      end
      local it = {
        count = itemInfo.count,
        name = itemInfo.name,
        cId = itemInfo.cId,
        get = math.ceil(monsterKills / itemInfo.count),
        avg = string.format("%.3f", itemInfo.count / monsterKills ),
        chance = string.format("%.2f", chance),
      }
      table.insert(ret, it)
    end

    local data = {
      action = "renderSimulationLoot",
      data = {
        items = ret,
        kills = monsterKills,
        outfit = lootSimulator.getMonsterOutfit(mType),
        name = monsterName,
        rate = rateLoot,
      }
    }

    lootSimulator.sendJSON(pid, data)
  end
end

lootSimulator.sendMonsterPossibleDrop = function(pid, monsterName)
  local ret = {}
  local mType = MonsterType(monsterName)
  local mLoot = mType:getLoot()
  for _, item in ipairs(mLoot) do
    if table.contains(lootSimulator.corpseContainers, item.itemId) then
      for _, childItem in ipairs(item.childLoot) do
        local itType = ItemType(childItem.itemId)
        local it = {
          name = itType:getName(),
          cId = itType:getClientId(),
          count = childItem.maxCount,
          chance = string.format("%.2f", childItem.chance / 1000)
        }
        table.insert(ret, it)
      end
    else
      local itType = ItemType(item.itemId)
      local it = {
        name = itType:getName(),
        cId = itType:getClientId(),
        count = item.maxCount,
        chance = string.format("%.2f", item.chance / 1000)
      }
      table.insert(ret, it)
    end
  end

  local data = {
    action = "getAvailableMonsterLoot",
    data = ret
  }
  lootSimulator.sendJSON(pid, data)
end

lootSimulator.sendAvailableMonsters = function(pid)
  local ret = {}
  for i = 1, #lootSimulator.MONSTERS do
    local mName = lootSimulator.MONSTERS[i]
    local mType = MonsterType(mName)
    if mType then
      local mLoot = mType:getLoot()
      if #mLoot ~= 0 then
        local mInfo = {
          outfit = lootSimulator.getMonsterOutfit(mType),
          name = mName,
        }

        table.insert(ret, mInfo)
      end
    end
  end

  table.sort(ret, function (a, b)
    return MonsterType(a.name):experience() < MonsterType(b.name):experience()
  end)

  local data = {
    action = "renderAvailableMonsters",
    data = ret
  }
  lootSimulator.sendJSON(pid, data)
end

local lootSimulatorExtendedOpcode = CreatureEvent("LootSimulatorExtendedOpcode")
function lootSimulatorExtendedOpcode.onExtendedOpcode(player, opcode, buffer)
  if opcode ~= lootSimulator.OPCODE then
    return false
  end

  local playerId = player:getId()

  local decodedData = json.decode(buffer)
  if decodedData.action == "getAvailableMonsters" then
    lootSimulator.sendAvailableMonsters(playerId)
  elseif decodedData.action == "getAvailableMonsterLoot" then
    lootSimulator.sendMonsterPossibleDrop(playerId, decodedData.data)
  elseif decodedData.action == "runSimulation" then
    lootSimulator.simulateLootDrop(playerId, decodedData.data.monster, decodedData.data.kills, decodedData.data.rateLoot)
  end
end
lootSimulatorExtendedOpcode:register()

local lootSimulatorOnLogin = CreatureEvent("LootSimulatorLogin")
function lootSimulatorOnLogin.onLogin(player)
  player:registerEvent("LootSimulatorExtendedOpcode")
  return true
end
lootSimulatorOnLogin:register()