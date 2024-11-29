local eliteMonsters = {
    ["giant spider"] = {
        elites = {
            {skullType = SKULL_WHITE, effect = CONST_ME_MAGIC_RED, percentageIncrease = 0.25, chance = 10, shaderName = "ShaderWhite", effectSpawn = 322},
            {skullType = SKULL_RED, effect = CONST_ME_FIREATTACK, percentageIncrease = 0.5, chance = 8, shaderName = "ShaderRage", effectSpawn = 321}, 
            {skullType = SKULL_BLACK, effect = CONST_ME_ENERGYHIT, percentageIncrease = 1.0, chance = 4, shaderName = "ShaderDarkRed", effectSpawn = 323}
        },
        eliteLoot = {
            {itemId = 2160, count = 1, chance = 10}
        }
    },
    ["cyclops"] = {
        elites = {
            {skullType = SKULL_WHITE, effect = CONST_ME_MAGIC_GREEN, percentageIncrease = 0.25, chance = 10, shaderId = 10, effectSpawn = 3},
            {skullType = SKULL_RED, effect = CONST_ME_FIREATTACK, percentageIncrease = 0.5, chance = 8, shaderId = 12, effectSpawn = 5}, 
            {skullType = SKULL_BLACK, effect = CONST_ME_ENERGYHIT, percentageIncrease = 1.0, chance = 4, shaderId = 13, effectSpawn = 11}
        },
        eliteLoot = {
            {itemId = 2125, count = 1, chance = 100},
            {itemId = 2152, count = 10, chance = 105},
            {itemId = 2160, count = 1, chance = 10}
        }
    },
    ["demon"] = {
        elites = {
            {skullType = SKULL_WHITE, effect = CONST_ME_MAGIC_GREEN, percentageIncrease = 0.25, chance = 10, shaderId = 16, effectSpawn = 3},
            {skullType = SKULL_RED, effect = CONST_ME_FIREATTACK, percentageIncrease = 0.5, chance = 8, shaderId = 17, effectSpawn = 5}, 
            {skullType = SKULL_BLACK, effect = CONST_ME_ENERGYHIT, percentageIncrease = 1.0, chance = 4, shaderId = 48, effectSpawn = 11}
        },
        eliteLoot = {
            {itemId = 2125, count = 1, chance = 100},
            {itemId = 2152, count = 10, chance = 105},
            {itemId = 2160, count = 1, chance = 10}
        }
    },
    ["black knight"] = {
        elites = {
            {skullType = SKULL_WHITE, effect = CONST_ME_MAGIC_GREEN, percentageIncrease = 0.25, chance = 10, shaderId = 18},
            {skullType = SKULL_RED, effect = CONST_ME_FIREATTACK, percentageIncrease = 0.5, chance = 8, shaderId = 20},
            {skullType = SKULL_BLACK, effect = CONST_ME_ENERGYHIT, percentageIncrease = 1.0, chance = 4, shaderId = 22}
        },
        eliteLoot = {
            {itemId = 2125, count = 1, chance = 100},
            {itemId = 2152, count = 10, chance = 105},
            {itemId = 2160, count = 1, chance = 10}
        }
    },
    ["minotaur"] = {
        elites = {
            {skullType = SKULL_WHITE, effect = CONST_ME_MAGIC_GREEN, percentageIncrease = 0.25, chance = 10, shaderId = 23}, -- Outfit_3line
            {skullType = SKULL_RED, effect = CONST_ME_FIREATTACK, percentageIncrease = 0.5, chance = 8, shaderId = 24},      -- Outfit_circle
            {skullType = SKULL_BLACK, effect = CONST_ME_ENERGYHIT, percentageIncrease = 1.0, chance = 4, shaderId = 25}      -- Outfit_Line
        },
        eliteLoot = {
            {itemId = 2125, count = 1, chance = 100},
            {itemId = 2152, count = 10, chance = 105},
            {itemId = 2160, count = 1, chance = 10}
        }
    },
    ["minotaur guard"] = {
        elites = {
            {skullType = SKULL_WHITE, effect = CONST_ME_MAGIC_GREEN, percentageIncrease = 0.25, chance = 10, shaderId = 26}, -- Outfit_Outline
            {skullType = SKULL_RED, effect = CONST_ME_FIREATTACK, percentageIncrease = 0.5, chance = 8, shaderId = 27},      -- Outfit_Shimmering
            {skullType = SKULL_BLACK, effect = CONST_ME_ENERGYHIT, percentageIncrease = 1.0, chance = 4, shaderId = 28}      -- Outfit_Shine
        },
        eliteLoot = {
            {itemId = 2125, count = 1, chance = 100},
            {itemId = 2152, count = 10, chance = 105},
            {itemId = 2160, count = 1, chance = 10}
        }
    },
    ["minotaur archer"] = {
        elites = {
            {skullType = SKULL_WHITE, effect = CONST_ME_MAGIC_GREEN, percentageIncrease = 0.25, chance = 10, shaderId = 29}, -- Outfit_brazil
            {skullType = SKULL_RED, effect = CONST_ME_FIREATTACK, percentageIncrease = 0.5, chance = 8, shaderId = 30},      -- Outfit_Gold
            {skullType = SKULL_BLACK, effect = CONST_ME_ENERGYHIT, percentageIncrease = 1.0, chance = 4, shaderId = 31}      -- Outfit_Stars
        },
        eliteLoot = {
            {itemId = 2125, count = 1, chance = 100},
            {itemId = 2152, count = 10, chance = 105},
            {itemId = 2160, count = 1, chance = 10}
        }
    },
    ["orc"] = {
        elites = {
            {skullType = SKULL_WHITE, effect = CONST_ME_MAGIC_GREEN, percentageIncrease = 0.25, chance = 10, shaderId = 32}, -- Outfit_blood
            {skullType = SKULL_RED, effect = CONST_ME_FIREATTACK, percentageIncrease = 0.5, chance = 8, shaderId = 33},      -- Outfit_camouflage
            {skullType = SKULL_BLACK, effect = CONST_ME_ENERGYHIT, percentageIncrease = 1.0, chance = 4, shaderId = 34}      -- Outfit_Flash
        },
        eliteLoot = {
            {itemId = 2125, count = 1, chance = 100},
            {itemId = 2152, count = 10, chance = 105},
            {itemId = 2160, count = 1, chance = 10}
        }
    },
    ["orc spearman"] = {
        elites = {
            {skullType = SKULL_WHITE, effect = CONST_ME_MAGIC_GREEN, percentageIncrease = 0.25, chance = 10, shaderId = 35}, -- Outfit_Glitch
            {skullType = SKULL_RED, effect = CONST_ME_FIREATTACK, percentageIncrease = 0.5, chance = 8, shaderId = 36},      -- Outfit_Ice
            {skullType = SKULL_BLACK, effect = CONST_ME_ENERGYHIT, percentageIncrease = 1.0, chance = 4, shaderId = 37}      -- Outfit_Purpleneon
        },
        eliteLoot = {
            {itemId = 2125, count = 1, chance = 100},
            {itemId = 2152, count = 10, chance = 105},
            {itemId = 2160, count = 1, chance = 10}
        }
    },
    ["orc warrior"] = {
        elites = {
            {skullType = SKULL_WHITE, effect = CONST_ME_MAGIC_GREEN, percentageIncrease = 0.25, chance = 10, shaderId = 38}, -- Outfit_Cosmos
            {skullType = SKULL_RED, effect = CONST_ME_FIREATTACK, percentageIncrease = 0.5, chance = 8, shaderId = 39},      -- Outfit_Purplesky
            {skullType = SKULL_BLACK, effect = CONST_ME_ENERGYHIT, percentageIncrease = 1.0, chance = 4, shaderId = 40}      -- Outfit_Static
        },
        eliteLoot = {
            {itemId = 2125, count = 1, chance = 100},
            {itemId = 2152, count = 10, chance = 105},
            {itemId = 2160, count = 1, chance = 10}
        }
    }
}

local function applyEliteStats(creature, skullType, percentageIncrease, shaderName)
    creature:setElite(true)
    
    local maxHealth = creature:getMaxHealth() * (1 + percentageIncrease)
    creature:setMaxHealth(maxHealth)
    creature:setHealth(maxHealth)

    local newSpeed = creature:getSpeed() * (1 + percentageIncrease)
    creature:setSpeed(newSpeed)

    local newMinDamage = creature:getMinDamage() * (1 + percentageIncrease)
    local newMaxDamage = creature:getMaxDamage() * (1 + percentageIncrease)
    creature:setDamage(newMinDamage, newMaxDamage)

    local newExperience = creature:getExperience() * (1 + percentageIncrease)
    creature:setExperience(newExperience)

    local lootMultiplier = 1 + percentageIncrease
    creature:setLootMultiplier(lootMultiplier)

    creature:setSkull(skullType)

    if shaderName then
        local success = creature:addShader(shaderName)
        if success then
        else
        end
    else
    end
end


local function applyEliteLoot(monster, eliteLootTable)
    for _, loot in ipairs(eliteLootTable) do
        if math.random(100) <= loot.chance then
            monster:addItem(loot.itemId, loot.count)
        end
    end
end

local function spawnEliteMonster(player, targetName, eliteData, position)
    local eliteCreature = Game.createMonster(targetName, position, true, true)
    if eliteCreature then
        applyEliteStats(eliteCreature, eliteData.skullType, eliteData.percentageIncrease, eliteData.shaderName)

        position:sendMagicEffect(eliteData.effectSpawn)

        eliteCreature:say("An elite " .. eliteCreature:getName() .. " has appeared!", TALKTYPE_MONSTER_SAY)

        local monsterConfig = eliteMonsters[targetName]
        if monsterConfig and monsterConfig.eliteLoot then
            applyEliteLoot(eliteCreature, monsterConfig.eliteLoot)
        end
    end
end


local function repeatEffect(position, effect, count)
    if count > 0 then
        position:sendMagicEffect(effect)
        addEvent(repeatEffect, 2000, position, effect, count - 1)
    end
end

local function onKillEliteChance(player, target, lastHit)
    if not target or not target:isMonster() then
        return true
    end

    if target:getStorageValue("eliteSpawned") == 1 then
        return true
    end
    target:setStorageValue("eliteSpawned", 1)

    if target:getSkull() ~= SKULL_NONE then
        return true
    end

    local targetName = target:getName():lower()
    local targetPos = target:getPosition()
    local monsterConfig = eliteMonsters[targetName]

    if monsterConfig then
        local eliteData = monsterConfig.elites[math.random(#monsterConfig.elites)]

        if math.random(100) <= eliteData.chance then
            repeatEffect(targetPos, eliteData.effectSpawn, 5)

            addEvent(function()
                spawnEliteMonster(player, targetName, eliteData, targetPos)
            end, 8000)
        end
    end

    return true
end


local registeredMonsters = {}

local function registerMonsterEvents()
    for monsterName, _ in pairs(eliteMonsters) do
        if not registeredMonsters[monsterName] then
            local eventName = monsterName:gsub(" ", "") .. "EliteSpawn"
            local creatureEvent = CreatureEvent(eventName)

            function creatureEvent.onKill(player, target, lastHit)
                return onKillEliteChance(player, target, lastHit)
            end

            creatureEvent:register()
            registeredMonsters[monsterName] = true
        end
    end
end

local loginEvent = CreatureEvent("RegisterEliteEventsOnLogin")
function loginEvent.onLogin(player)
    for monsterName, _ in pairs(eliteMonsters) do
        local eventName = monsterName:gsub(" ", "") .. "EliteSpawn"
        player:registerEvent(eventName)
    end
    return true
end

loginEvent:register()
registerMonsterEvents()