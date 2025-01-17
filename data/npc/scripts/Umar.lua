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

    if not msgcontains(message:lower(), 'djanni\'hah') and player:getStorageValue(Storage.DjinnWar.Faction.Marid) ~= 1 then
        npcHandler:say('Whoa! A human! This is no place for you. Go and play somewhere else.', cid)
        return false
    end

    if player:getStorageValue(Storage.DjinnWar.Faction.Greeting) == -1 then
        npcHandler:say("Hahahaha! ...", cid)
        npcHandler:say(player:getName() .. ", that almost sounded like the word of greeting. Humans - cute they are!", cid)
        return false
    end

    if player:getStorageValue(Storage.DjinnWar.Faction.Marid) ~= 1 then
        npcHandler:say("Whoa? You know the word! Amazing! ...", cid)
        npcHandler:say("I should go and tell Fa\'hradin. ...", cid)
        npcHandler:say("Well. Why are you here anyway, " .. player:getName() .. "?", cid)
    else
        npcHandler:setMessage(MESSAGE_GREET, "How's it going these days? What brings you {here}?")
    end
    return true
end

local function creatureSayCallback(cid, type, msg)
    local player = Player(cid)

    if msgcontains(msg:lower(), 'djanni\'hah') then
        if player:getStorageValue(Storage.DjinnWar.Faction.Marid) == 1 or player:getStorageValue(Storage.DjinnWar.Faction.Greeting) ~= -1 then
            npcHandler:addFocus(cid)
            npcHandler:say('Whoa? You know the word! Amazing! ... I should go and tell Fa\'hradin. ... Well. Why are you here anyway, |PLAYERNAME|?', cid)
        else
            npcHandler:say("Hahahaha! ...", cid)
            npcHandler:say("That almost sounded like the word of greeting. Humans - cute they are!", cid)
        end
        return true
    end

    if not npcHandler:isFocused(cid) then
        return false
    end

    if msgcontains(msg:lower(), 'passage') then
        if player:getStorageValue(Storage.DjinnWar.Faction.Marid) ~= 1 then
            npcHandler:say("If you want to enter our fortress you have to become one of us and fight the Efreet. ...", cid)
            npcHandler:say("So, are you willing to do so?", cid)
            npcHandler.topic[cid] = 1
        else
            npcHandler:say('You already have the permission to enter Ashta\'daramai.', cid)
        end

    elseif npcHandler.topic[cid] == 1 then
        if msgcontains(msg:lower(), 'yes') then
            if player:getStorageValue(Storage.DjinnWar.Faction.Efreet) ~= 1 then
                npcHandler:say('Are you sure? You pledge loyalty to king Gabel, who is... you know. And you are willing to never ever set foot on Efreets\' territory, unless you want to kill them? Yes?', cid)
                npcHandler.topic[cid] = 2
            else
                npcHandler:say('I don\'t believe you! You better go now.', cid)
                npcHandler.topic[cid] = 0
            end

        elseif msgcontains(msg:lower(), 'no') then
            npcHandler:say('This isn\'t your war anyway, human.', cid)
            npcHandler.topic[cid] = 0
        end

    elseif npcHandler.topic[cid] == 2 then
        if msgcontains(msg:lower(), 'yes') then
            npcHandler:say("Oh. Ok. Welcome then. You may pass. ...", cid)
            npcHandler:say("And don\'t forget to kill some Efreets, now and then.", cid)
            player:setStorageValue(Storage.DjinnWar.Faction.Marid, 1)
            player:setStorageValue(Storage.DjinnWar.Faction.Greeting, 0)

        elseif msgcontains(msg:lower(), 'no') then
            npcHandler:say('This isn\'t your war anyway, human.', cid)
        end
        npcHandler.topic[cid] = 0
    end
    return true
end

npcHandler:setMessage(MESSAGE_FAREWELL, '<salutes>Aaaa -tention!')
npcHandler:setMessage(MESSAGE_WALKAWAY, '<salutes>Aaaa -tention!')

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

local focusModule = FocusModule:new()
focusModule:addGreetMessage('hi')
focusModule:addGreetMessage('hello')
focusModule:addGreetMessage('djanni\'hah')
focusModule:addGreetMessage('DJANNI\'HAH')
npcHandler:addModule(focusModule)
