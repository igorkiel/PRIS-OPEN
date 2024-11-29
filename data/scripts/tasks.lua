local RewardType = {
  Points = 1,
  Experience = 2,
  Gold = 3,
  Item = 4,
  Storage = 5
}

local Config = {
  TasksOpCode = 110,
  StoragePoints = 87613,
  StorageSlot = 87614, -- 87615 - 87625 reserved (10)
  StorageKillsSelected = 87626, -- 87627 - 87637 reserved (10)
  StorageKillsCurrent = 87638, -- 87639 - 87649 reserved (10)
  ActiveTasksLimit = 3, -- max 10 or you will have to adjust storage keys
  RecommendedLevelRange = 10, -- when player is within this range (at level 20, 10-20 and 20-30 levels), "Recommended" text will be displayed in tasks list
  RequiredKills = {Min = 100, Max = 5000}, -- Minimum and Maximum amount of kills that player can select
  KillsForBonus = 100, -- every how many kills should bonus be applied (not counting minimum amount of kills)
  --[[
    % increased rank points gained per KillsForBonus kills
    If player selects to kill 100 Trolls, only base value is granted
    Selecting 200 kills grants base value + PointsIncrease%
    Default: 100
    Type: Percent
  ]]
  PointsIncrease = 100,
  --[[
    % increased experience points gained per KillsForBonus kills
    Default: 10
    Type: Percent
  ]]
  ExperienceIncrease = 10,
  --[[
    % increased gold coins gained per KillsForBonus kills
    Default: 10
    Type: Percent
  ]]
  GoldIncrease = 10,
  Party = {
    Enabled = false, -- should party members share kills
    Range = 8 -- party members in this range (tiles) will have task kill added, 0 to make it infinite range
  },
  Ranks = {
    [5] = "Huntsman",
    [15] = "Ranger",
    [30] = "Big Game Hunter",
    [45] = "Trophy Hunter",
    [60] = "Pro Hunter",
    [75] = "Elite Hunter"
  },
  Tasks = {
    --[[
      {
        RaceName = "Trolls", -- Name of the task
        Level = 8, -- Recommended level for this task (see RecommendedLevelRange)
        Monsters = {"Troll", "Troll Champion"}, -- List of monsters that count for the task, case-sensitive
        Rewards = {
          {Type = RewardType.Points, BaseValue = 1}, -- Adds rank points
          {Type = RewardType.Experience, BaseValue = 1000}, -- Gives experience
          {Type = RewardType.Gold, BaseValue = 500} -- Gives gold coins to bank
          {Type = RewardType.Item, Id = 2353, Amount = 1}, -- Rewards with 1 Burning Heart item
          {Type = RewardType.Storage, Key = 1234, Value = 1, Description = "Access to new hunting area"}, -- Sets storage 1234 with value 1
          {Type = RewardType.Teleport, Position = Position(1000, 1000, 7), Description = "Troll Boss fight"} -- Teleports to Position when task is completed
        }
      },
    ]]
    {
      RaceName = "Trolls",
      Level = 8,
      Monsters = {"Troll", "Frost Troll", "Swamp Troll", "Troll Champion"},
      Rewards = {
        {Type = RewardType.Points, BaseValue = 1},
        {Type = RewardType.Experience, BaseValue = 1000},
        {Type = RewardType.Gold, BaseValue = 500},
        {Type = RewardType.Item, Id = 2353, Amount = 1},
        {Type = RewardType.Storage, Key = 1234, Value = 1, Description = "Access to new hunting area"},
      }
    },
    {
      RaceName = "Rotworms",
      Level = 8,
      Monsters = {"Rotworm", "Carrion Worm"},
      Rewards = {
        {Type = RewardType.Points, BaseValue = 1},
        {Type = RewardType.Experience, BaseValue = 1000},
        {Type = RewardType.Gold, BaseValue = 500}
      }
    },
    {
      RaceName = "Small Spiders",
      Level = 8,
      Monsters = {"Spider", "Poison Spider"},
      Rewards = {
        {Type = RewardType.Points, BaseValue = 1},
        {Type = RewardType.Experience, BaseValue = 1000},
        {Type = RewardType.Gold, BaseValue = 500}
      }
    },
    {
      RaceName = "Orcs",
      Level = 12,
      Monsters = {"Orc", "Orc Spearman", "Orc Shaman", "Orc Warrior", "Orc Rider"},
      Rewards = {
        {Type = RewardType.Points, BaseValue = 1},
        {Type = RewardType.Experience, BaseValue = 1500},
        {Type = RewardType.Gold, BaseValue = 800}
      }
    },
    {
      RaceName = "Minotaurs",
      Level = 12,
      Monsters = {"Minotaur", "Minotaur Archer", "Minotaur Mage", "Minotaur Guard"},
      Rewards = {
        {Type = RewardType.Points, BaseValue = 1},
        {Type = RewardType.Experience, BaseValue = 1500},
        {Type = RewardType.Gold, BaseValue = 800}
      }
    },
    {
      RaceName = "Ghoul",
      Level = 25,
      Monsters = {"Ghoul"},
      Rewards = {
        {Type = RewardType.Points, BaseValue = 1},
        {Type = RewardType.Experience, BaseValue = 3500},
        {Type = RewardType.Gold, BaseValue = 1500},
        {Type = RewardType.Item, Id = 2168, Amount = 1}
      }
    },
    {
      RaceName = "Dragon Hatchlings",
      Level = 40,
      Monsters = {"Dragon Hatchling", "Dragon Lord Hatchling", "Frost Dragon Hatchling"},
      Rewards = {
        {Type = RewardType.Points, BaseValue = 2},
        {Type = RewardType.Experience, BaseValue = 12000},
        {Type = RewardType.Gold, BaseValue = 2500}
      }
    },
    {
      RaceName = "Wyverns",
      Level = 40,
      Monsters = {"Wyvern"},
      Rewards = {
        {Type = RewardType.Points, BaseValue = 4},
        {Type = RewardType.Experience, BaseValue = 15000},
        {Type = RewardType.Gold, BaseValue = 3000}
      }
    },
    {
      RaceName = "Crystal Spiders",
      Level = 50,
      Monsters = {"Crystal Spider"},
      Rewards = {
        {Type = RewardType.Points, BaseValue = 4},
        {Type = RewardType.Experience, BaseValue = 18000},
        {Type = RewardType.Gold, BaseValue = 3500}
      }
    },
    {
      RaceName = "Dragons",
      Level = 60,
      Monsters = {"Dragon"},
      Rewards = {
        {Type = RewardType.Points, BaseValue = 4},
        {Type = RewardType.Experience, BaseValue = 18000},
        {Type = RewardType.Gold, BaseValue = 3500}
      }
    },
    {
      RaceName = "Wyrms",
      Level = 60,
      Monsters = {"Wyrm"},
      Rewards = {
        {Type = RewardType.Points, BaseValue = 4},
        {Type = RewardType.Experience, BaseValue = 20000},
        {Type = RewardType.Gold, BaseValue = 4000}
      }
    },
    {
      RaceName = "Giant Spiders",
      Level = 60,
      Monsters = {"Giant Spider"},
      Rewards = {
        {Type = RewardType.Points, BaseValue = 4},
        {Type = RewardType.Experience, BaseValue = 25000},
        {Type = RewardType.Gold, BaseValue = 10000}
      }
    },
    {
      RaceName = "Dragon Lords",
      Level = 70,
      Monsters = {"Dragon Lord"},
      Rewards = {
        {Type = RewardType.Points, BaseValue = 4},
        {Type = RewardType.Experience, BaseValue = 30000},
        {Type = RewardType.Gold, BaseValue = 15000}
      }
    },
    {
      RaceName = "Cyclopses",
      Level = 70,
      Monsters = {"Cyclops", "Cyclops Drone", "Cyclops Smith"},
      Rewards = {
        {Type = RewardType.Points, BaseValue = 4},
        {Type = RewardType.Experience, BaseValue = 35000},
        {Type = RewardType.Gold, BaseValue = 5500}
      }
    }
  }
}

local Cache = {}

local StartupEvent = GlobalEvent("TasksStartUp")

function StartupEvent.onStartup()
  Cache.Ranks = {}
  local ordered = {}
  for key, _ in pairs(Config.Ranks) do
    table.insert(ordered, key)
  end
  table.sort(ordered)
  
  local to = ordered[1] - 1
  for k = 0, to do
    Cache.Ranks[k] = Config.Ranks[ordered[1]]
  end

  for i = 1, #ordered do
    local from = ordered[i]
    local to = i == #ordered and ordered[i] or ordered[i + 1] - 1
    for k = from, to do
      Cache.Ranks[k] = Config.Ranks[from]
    end
    Cache.LastRank = from
  end

  Cache.Tasks = {}
  for id, task in ipairs(Config.Tasks) do
    for _, name in ipairs(task.Monsters) do
      Cache.Tasks[name] = id
    end
  end
  
  for _, task in ipairs(Config.Tasks) do
    if not task.Outfits then
      task.Outfits = {}
      for _, monster in ipairs(task.Monsters) do
        local monsterType = MonsterType(monster)
        if monsterType then
          table.insert(task.Outfits, monsterType:getOutfitOTC())
        end
      end
    end
  end
end


local LoginEvent = CreatureEvent("TasksLogin")

function LoginEvent.onLogin(player)
  player:registerEvent("TasksExtended")
  player:registerEvent("TasksKill")
  player:sendTasksData()
  return true
end

local ExtendedEvent = CreatureEvent("TasksExtended")

function ExtendedEvent.onExtendedOpcode(player, opcode, buffer)
  if opcode == Config.TasksOpCode then
    local status, json_data =
      pcall(
      function()
        return json.decode(buffer)
      end
    )
    if not status then
      return false
    end

    local action = json_data.action
    local data = json_data.data

    if action == "start" then
      player:startNewTask(data.taskId, data.kills)
    elseif action == "cancel" then
      player:cancelTask(data)
    end
  end
  return true
end

function Player:openTasksList()
  self:sendExtendedOpcode(Config.TasksOpCode, json.encode({action = "open"}))
end

function Player:closeTasksList()
  self:sendExtendedOpcode(Config.TasksOpCode, json.encode({action = "close"}))
end

function Player:sendTasksData()
  -- #region Enviar configuração das tasks
  -- print("[Tasks] Enviando configuração das tasks para o jogador: " .. self:getName())
  
  local config = {
    kills = Config.RequiredKills,
    bonus = Config.KillsForBonus,
    range = Config.RecommendedLevelRange,
    points = Config.PointsIncrease,
    exp = Config.ExperienceIncrease,
    gold = Config.GoldIncrease
  }
  self:sendExtendedOpcode(Config.TasksOpCode, json.encode({action = "config", data = config}))

  -- #endregion

  -- #region Enviar lista de tasks
  -- print("[Tasks] Enviando lista de tasks para o jogador: " .. self:getName())

  local tasks = {}
  for _, task in ipairs(Config.Tasks) do
    local taskData = {
      name = task.RaceName,
      lvl = task.Level,
      mobs = task.Monsters,
      outfits = task.Outfits,
      rewards = {}
    }

    for _, reward in ipairs(task.Rewards) do
      if reward.Type == RewardType.Points or reward.Type == RewardType.Experience or reward.Type == RewardType.Gold then
        table.insert(taskData.rewards, {type = reward.Type, value = reward.BaseValue})
      elseif reward.Type == RewardType.Item then
        table.insert(taskData.rewards, {type = reward.Type, name = ItemType(reward.Id):getName(), amount = reward.Amount})
      elseif reward.Type == RewardType.Storage or reward.Type == RewardType.Teleport then
        table.insert(taskData.rewards, {type = reward.Type, desc = reward.Description})
      end
    end

    table.insert(tasks, taskData)
  end

  local buffer = json.encode({action = "tasks", data = tasks})
  local s = {}
  for i = 1, #buffer, 8191 do
    s[#s + 1] = buffer:sub(i, i + 8191 - 1)
  end
  if #s == 1 then
    self:sendExtendedOpcode(Config.TasksOpCode, buffer)
  else
    -- print("[Tasks] Dividindo os dados das tasks em múltiplas partes")
    self:sendExtendedOpcode(Config.TasksOpCode, "S" .. s[1])
    for i = 2, #s - 1 do
      self:sendExtendedOpcode(Config.TasksOpCode, "P" .. s[i])
    end
    self:sendExtendedOpcode(Config.TasksOpCode, "E" .. s[#s])
  end
  -- #endregion

  -- #region Enviar tasks ativas
  -- print("[Tasks] Enviando tasks ativas para o jogador: " .. self:getName())

  local active = {}
  for slot = 1, Config.ActiveTasksLimit do
    local taskId = self:getTaskIdBySlot(slot)
    if taskId ~= 0 then
      local requiredKills = self:getTaskRequiredKills(slot)
      local kills = self:getTaskKills(slot)
      table.insert(active, {
        kills = kills,
        required = requiredKills,
        slot = slot,
        taskId = taskId
      })
      -- print("[Tasks] Task ativa enviada: taskId = " .. taskId .. ", kills = " .. kills .. "/" .. requiredKills)
    end
  end

  if #active > 0 then
    self:sendExtendedOpcode(Config.TasksOpCode, json.encode({action = "active", data = active}))
  end
  -- #endregion

  -- #region Enviar atualização de pontos de tasks
  self:sendTasksPointsUpdate()
end



function Player:sendTaskUpdate(taskId)
  local update = {}

  local slot = self:getSlotByTaskId(taskId)
  if not slot then
    update.status = 2 -- abandoned
    update.taskId = taskId
  else
    local requiredKills = self:getTaskRequiredKills(slot)
    local kills = self:getTaskKills(slot)

    if kills < requiredKills then
      update.status = 1 -- in progress
      update.kills = kills
      update.required = requiredKills
      update.taskId = taskId
    else
      update.status = 2 -- finished
      update.taskId = taskId
    end
  end

  self:sendExtendedOpcode(Config.TasksOpCode, json.encode({action = "update", data = update}))
end

function Player:sendTasksPointsUpdate()
  self:sendExtendedOpcode(Config.TasksOpCode, json.encode({action = "points", data = self:getTasksPoints()}))
end

function Player:startNewTask(taskId, kills)
  local task = Config.Tasks[taskId]
  if task then
    local slot = self:getFreeTaskSlot()
    if not slot then
      self:popupFYI("You can't accept more tasks.")
      return
    end

    if self:getSlotByTaskId(taskId) then
      self:popupFYI("You already have this task active.")
      return
    end

    kills = math.max(kills, Config.RequiredKills.Min)
    kills = math.min(kills, Config.RequiredKills.Max)

    self:setStorageValue(Config.StorageSlot + slot, taskId)
    self:setStorageValue(Config.StorageKillsCurrent + slot, 0)
    self:setStorageValue(Config.StorageKillsSelected + slot, kills)

    self:sendTaskUpdate(taskId)
  end
end

function Player:cancelTask(taskId)
  local task = Config.Tasks[taskId]
  if task then
    local slot = self:getSlotByTaskId(taskId)
    if slot then
      self:setStorageValue(Config.StorageSlot + slot, -1)
      self:setStorageValue(Config.StorageKillsCurrent + slot, -1)
      self:setStorageValue(Config.StorageKillsSelected + slot, -1)
      self:sendTaskUpdate(taskId)
    end
  end
end

local KillEvent = CreatureEvent("TasksKill")

function KillEvent.onKill(player, target)
	if player:isCreature() and target:isMonster() and not target:getMaster() then
	  if not target or target:isPlayer() or target:getMaster() then
		return true
	  end

	  local targetName = target:getName()
	  if not targetName then
		return true
	  end

	  local taskId = Cache and Cache.Tasks and Cache.Tasks[targetName]
	  if not taskId then
		return true
	  end

	  local task = Config and Config.Tasks and Config.Tasks[taskId]
	  
	  if not task then
		 return true
	  end
	  
	  if task then
		local party = player:getParty()
		if party and Config.Party.Enabled then
		  local members = party:getMembers()
		  table.insert(members, party:getLeader())

		  local killerPos = player:getPosition()
		  for _, member in ipairs(members) do
			if Config.Party.Range > 0 then
			  if member:getPosition():getDistance(killerPos) <= Config.Party.Range then
				member:taskProcessKill(member, taskId)
			  end
			else
			  member:taskProcessKill(member, taskId)
			end
		  end
		else
		  player:taskProcessKill(player, taskId)
		end
	  end
	end
  return true
end



function Player:taskProcessKill(player, taskId)
  local slot = player:getSlotByTaskId(taskId)
  if slot then
    player:addTaskKill(slot)

    local requiredKills = player:getTaskRequiredKills(slot)
    local kills = player:getTaskKills(slot)
    if kills >= requiredKills then
      player:setStorageValue(Config.StorageSlot + slot, -1)
      player:setStorageValue(Config.StorageKillsCurrent + slot, -1)
      player:setStorageValue(Config.StorageKillsSelected + slot, -1)

      local task = Config.Tasks[taskId]
      for _, reward in ipairs(task.Rewards) do
        player:addTaskReward(player, reward, requiredKills)
      end
      player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[Task Status] You have finished " .. task.RaceName .. " task!")  -- Aqui também
    end
    player:sendTaskUpdate(taskId)
  end
end



function Player:addTaskReward(player, reward, requiredKills)
  local bonus = math.floor((math.max(0, requiredKills - Config.KillsForBonus) / Config.KillsForBonus) + 0.5)

  -- Pontos de tarefa
  if reward.Type == RewardType.Points then
    bonus = bonus * Config.PointsIncrease
    local value = reward.BaseValue + math.floor((reward.BaseValue * bonus / 100) + 0.5)
    player:addTasksPoints(value)
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[Task Reward] Tasks Points +" .. value .. ", you have now " .. player:getTasksPoints() .. " tasks points.")

  -- Experiência
  elseif reward.Type == RewardType.Experience then
    bonus = bonus * Config.ExperienceIncrease
    local value = reward.BaseValue + math.floor((reward.BaseValue * bonus / 100) + 0.5)
    player:addExperience(value, true)
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[Task Reward] Experience +" .. value .. ".")

  -- Ouro
  elseif reward.Type == RewardType.Gold then
    bonus = bonus * Config.GoldIncrease
    local value = reward.BaseValue + math.floor((reward.BaseValue * bonus / 100) + 0.5)
    player:setBankBalance(player:getBankBalance() + value)
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[Task Reward] " .. value .. " gold added to your bank.")

  -- Itens
  elseif reward.Type == RewardType.Item then
    local itemType = ItemType(reward.Id)
    if not itemType then
      player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[Task Reward] Failed to give item reward.")
      return
    end

    local itemWeight = itemType:getWeight(reward.Amount)
    local playerCap = player:getFreeCapacity()
    if playerCap >= itemWeight then
      player:addItem(reward.Id, reward.Amount)
      player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[Task Reward] " .. reward.Amount .. "x " .. itemType:getName() .. ".")
    else
      player:getStoreInbox():addItem(reward.Id, reward.Amount)
      player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[Task Reward] Low on capacity, sending " .. reward.Amount .. "x " .. itemType:getName() .. " to your Purse.")
    end

  -- Storage
  elseif reward.Type == RewardType.Storage then
    if player:getStorageValue(reward.Key) ~= reward.Value then
      player:setStorageValue(reward.Key, reward.Value)
      player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, '[Task Reward] You have been granted "' .. reward.Description .. '".')
    end

  else
    player:sendTextMessage(MESSAGE_INFO_DESCR, "[Task Reward] Invalid reward type.")
  end
end



function Player:getTaskIdBySlot(slot)
  return math.max(0, self:getStorageValue(Config.StorageSlot + slot))
end

function Player:getSlotByTaskId(taskId)
  for i = 1, Config.ActiveTasksLimit do
    local slotTask = self:getTaskIdBySlot(i)
    if taskId == slotTask then
      return i
    end
  end

  return nil
end

function Player:getTaskKills(slot)
  return math.max(0, self:getStorageValue(Config.StorageKillsCurrent + slot))
end

function Player:getTaskRequiredKills(slot)
  return math.max(0, self:getStorageValue(Config.StorageKillsSelected + slot))
end

function Player:addTaskKill(slot)
  self:setStorageValue(Config.StorageKillsCurrent + slot, self:getTaskKills(slot) + 1)
end

function Player:addTasksPoints(points)
  self:setStorageValue(Config.StoragePoints, self:getTasksPoints() + points)
  self:sendTasksPointsUpdate()
end

function Player:getTasksPoints()
  return math.max(0, self:getStorageValue(Config.StoragePoints))
end

function Player:getTasksRank()
  local rank = self:getTasksPoints()
  if rank >= Cache.LastRank then
    return Cache.Ranks[Cache.LastRank]
  end

  return Cache.Ranks[rank]
end

function Player:getFreeTaskSlot()
  for i = 1, Config.ActiveTasksLimit do
    if self:getTaskIdBySlot(i) == 0 then
      return i
    end
  end

  return nil
end

function MonsterType:getOutfitOTC()
  local outfit = self:outfit()
  return {
    type = outfit.lookType,
    auxType = outfit.lookTypeEx,
    head = outfit.lookHead,
    body = outfit.lookBody,
    legs = outfit.lookLegs,
    feet = outfit.lookFeet,
    addons = outfit.lookAddons,
    mount = outfit.lookMount
  }
end

LoginEvent:type("login")
LoginEvent:register()
ExtendedEvent:type("extendedopcode")
ExtendedEvent:register()
KillEvent:type("kill")
KillEvent:register()
StartupEvent:type("startup")
StartupEvent:register()
