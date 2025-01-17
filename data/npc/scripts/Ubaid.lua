local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local function greetCallback(cid, message)
    local player = Player(cid)

    if not message then
        return false
    end

    if not msgcontains(message:lower(), 'djanni\'hah') and player:getStorageValue(Storage.DjinnWar.Faction.Efreet) ~= 1 then
        npcHandler:say('Shove off, little one! Humans are not welcome here, |PLAYERNAME|!', cid)
        return false
    end

    if player:getStorageValue(Storage.DjinnWar.Faction.Greeting) == -1 then
        npcHandler:say("Hahahaha! ... that almost sounded like the word of greeting. Humans - cute they are!", cid)
        return false
    end

    if player:getStorageValue(Storage.DjinnWar.Faction.Efreet) ~= 1 then
        npcHandler:setMessage(MESSAGE_GREET, 'What? You know the word, |PLAYERNAME|? All right then - I won\'t kill you. At least, not now. What brings you {here}?')
    else
        npcHandler:setMessage(MESSAGE_GREET, 'Still alive, |PLAYERNAME|? What brings you {here}?')
    end
    return true
end

local function creatureSayCallback(cid, type, msg)
    local player = Player(cid)

    if msgcontains(msg:lower(), 'djanni\'hah') then
        if player:getStorageValue(Storage.DjinnWar.Faction.Efreet) == 1 or player:getStorageValue(Storage.DjinnWar.Faction.Greeting) ~= -1 then
            npcHandler:addFocus(cid)
            npcHandler:say('What? You know the word, |PLAYERNAME|? All right then - I won\'t kill you. At least, not now. What brings you {here}?', cid)
        else
            npcHandler:say("Hahahaha! ... that almost sounded like the word of greeting. Humans - cute they are!", cid)
        end
        return true
    end

    if not npcHandler:isFocused(cid) then
        return false
    end

    if msgcontains(msg:lower(), 'passage') then
        if player:getStorageValue(Storage.DjinnWar.Faction.Efreet) ~= 1 then
            npcHandler:say("All Marid and little worms like yourself should leave now or something bad may happen. Am I right?", cid)
            npcHandler.topic[cid] = 1
        else
            npcHandler:say('You already pledged loyalty to king Malor!', cid)
        end

    elseif msgcontains(msg:lower(), 'here') then
        npcHandler:say("All Marid and little worms like yourself should leave now or something bad may happen. Am I right?", cid)
        npcHandler.topic[cid] = 1

    elseif npcHandler.topic[cid] == 1 then
        if msgcontains(msg:lower(), 'yes') then
            npcHandler:say('Of course. Then don\'t waste my time and shove off.', cid)
            npcHandler.topic[cid] = 0

        elseif msgcontains(msg:lower(), 'no') then
            if player:getStorageValue(Storage.DjinnWar.Faction.Marid) == 1 then
                npcHandler:say('Who do you think you are? A Marid? Shove off you worm!', cid)
                npcHandler.topic[cid] = 0
            else
                npcHandler:say("Maybe we have some use for someone like you. Would you be interested in working for us. Helping to fight the Marid?", cid)
                npcHandler.topic[cid] = 2
            end
        end

    elseif npcHandler.topic[cid] == 2 then
        if msgcontains(msg:lower(), 'yes') then
            npcHandler:say('So you pledge loyalty to king Malor and you are willing to never ever set foot on Marid\'s territory, unless you want to kill them? Yes?', cid)
            npcHandler.topic[cid] = 3

        elseif msgcontains(msg:lower(), 'no') then
            npcHandler:say('Of course. Then don\'t waste my time and shove off.', cid)
            npcHandler.topic[cid] = 0
        end

    elseif npcHandler.topic[cid] == 3 then
        if msgcontains(msg:lower(), 'yes') then
            npcHandler:say("And don't touch anything!", cid)
            player:setStorageValue(Storage.DjinnWar.Faction.Efreet, 1)
            player:setStorageValue(Storage.DjinnWar.Faction.Greeting, 0)

        elseif msgcontains(msg:lower(), 'no') then
            npcHandler:say("Of course. Then don't waste my time and shove off.", cid)
        end
        npcHandler.topic[cid] = 0
    end
    return true
end

npcHandler:setMessage(MESSAGE_FAREWELL, 'Farewell human!')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Farewell human!')

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

local focusModule = FocusModule:new()
focusModule:addGreetMessage('hi')
focusModule:addGreetMessage('hello')
focusModule:addGreetMessage('djanni\'hah')
focusModule:addGreetMessage('DJANNI\'HAH')
npcHandler:addModule(focusModule)
