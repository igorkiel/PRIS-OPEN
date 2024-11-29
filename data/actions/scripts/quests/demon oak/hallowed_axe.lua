-- Function to handle the onUse event for the hallowed axe
function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local tile = toPosition:getTile()
    if not tile then
        print("Error in actions/quests/demon oak/hallowed_axe.lua: Could not get tile at position " .. toPosition:toString())
        return true
    end

    local itemActions = {
        [8288] = {
            storage_round = player:getStorageValue(DemonOak.AxeBlowsBird),
            rounds = {
                {"Rotworm", "Seagull", "Tortoise", "Fire Elemental"},
                {"Goblin", "Orc", "Troll", "Gargoyle"},
                {"Rotworm", "Seagull", "Tortoise", "Fire Elemental"},
                {"Goblin", "Orc", "Troll", "Gargoyle"}
            }
            
        },
        [8289] = {
            storage_round = player:getStorageValue(DemonOak.AxeBlowsLeft),
            rounds = {
                {"Goblin", "Orc", "Troll", "Gargoyle"},
                {"Skeleton", "Ghoul", "Juggernaut", "Ghoul"},
                {"Goblin", "Orc", "Troll", "Gargoyle"},
                {"Skeleton", "Ghoul", "Juggernaut", "Ghoul"}
            }
        },
        [8290] = {
            storage_round = player:getStorageValue(DemonOak.AxeBlowsRight),
            rounds = {
                {"Dragon", "Hydra", "Behemoth", "Demon"},
                {"Goblin", "Orc", "Troll", "Gargoyle"},
                {"Dragon", "Hydra", "Behemoth", "Demon"},
                {"Goblin", "Orc", "Troll", "Gargoyle"}
            }
        },
        [8291] = {
            storage_round = player:getStorageValue(DemonOak.AxeBlowsFace),
            rounds = {
                {"Demon Skeleton", "Rat", "Bug", "Ghost"},
                {"Goblin", "Orc", "Troll", "Gargoyle"},
                {"Demon Skeleton", "Rat", "Bug", "Ghost"},
                {"Goblin", "Orc", "Troll", "Gargoyle"}
            }
        }
    }

    if player:getStorageValue(Storage.DemonOak.Progress) == 2 then
        for itemId, actionData in pairs(itemActions) do
            local itemOnTile = tile:getItemById(itemId)
            if itemOnTile then
                local rounds = actionData.rounds
                local damagePerRound = 300

                if math.random(1,100) > 75 then
                    for _, round in ipairs(rounds[itemActions[actionData].storage_round]) do
                        for _, monsterName in ipairs(round) do
                            Game.createMonster(monsterName, toPosition)
                        end

                        player:addHealth(-damagePerRound)

                    end
                else
                    player:addHealth(-damagePerRound)
                end

                break
            end
        end
    end

    return true
end
