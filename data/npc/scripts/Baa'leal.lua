local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local condition = Condition(CONDITION_FIRE)
condition:setParameter(CONDITION_PARAM_DELAYED, 1)
condition:addDamage(150, 2000, -10)

local function greetCallback(cid, message)
    local player = Player(cid)
    if not message then
        return false
    end

    if not player:getCondition(CONDITION_FIRE) and not msgcontains(message:lower(), 'djanni\'hah') then
        player:getPosition():sendMagicEffect(CONST_ME_EXPLOSIONAREA)
        player:addCondition(condition)
        npcHandler:say('Take this!', cid)
        return false
    end

    if player:getStorageValue(Storage.DjinnWar.EfreetFaction.Mission01) < 1 then
        npcHandler:setMessage(MESSAGE_GREET, 'You know the code human! Very well then... What do you want, |PLAYERNAME|?')
    else
        npcHandler:setMessage(MESSAGE_GREET, 'You are still alive, |PLAYERNAME|? Well, what do you want?')
    end
    return true
end

local function creatureSayCallback(cid, type, msg)
    local player = Player(cid)

    if msgcontains(msg:lower(), 'djanni\'hah') then
        if player:getStorageValue(Storage.DjinnWar.EfreetFaction.Mission01) < 1 then
            npcHandler:addFocus(cid)
            npcHandler:say('You know the code human! Very well then... What do you want, |PLAYERNAME|?', cid)
        else
            npcHandler:addFocus(cid)
            npcHandler:say('You are still alive, |PLAYERNAME|? Well, what do you want?', cid)
        end
        return true
    end

    if not npcHandler:isFocused(cid) then
        return false
    end

    local missionProgress = player:getStorageValue(Storage.DjinnWar.EfreetFaction.Mission01)
    if msgcontains(msg:lower(), 'mission') then
        if missionProgress < 1 then
            npcHandler:say("Each mission and operation is a crucial step towards our victory! ...", cid)
            npcHandler:say("Now that we speak of it ...", cid)
            npcHandler:say("Since you are no djinn, there is something you could help us with. Are you interested, human?", cid)
            npcHandler.topic[cid] = 1

        elseif isInArray({1, 2}, missionProgress) then
            npcHandler:say('Did you find the thief of our supplies?', cid)
            npcHandler.topic[cid] = 2
        else
            npcHandler:say('Did you already talk to Alesar? He has another mission for you!', cid)
        end

    elseif npcHandler.topic[cid] == 1 then
        if msgcontains(msg:lower(), 'yes') then
            npcHandler:say("Well ... All right. You may only be a human, but you do seem to have the right spirit. ...", cid)
            npcHandler:say("Listen! Since our base of operations is set in this isolated spot we depend on supplies from outside. These supplies are crucial for us to win the war. ...", cid)
            npcHandler:say("Unfortunately, it has happened that some of our supplies have disappeared on their way to this fortress. At first we thought it was the Marid, but intelligence reports suggest a different explanation. ...", cid)
            npcHandler:say("We now believe that a human was behind the theft! ...", cid)
            npcHandler:say("His identity is still unknown but we have been told that the thief fled to the human settlement called Carlin. I want you to find him and report back to me. Nobody messes with the Efreet and lives to tell the tale! ...", cid)
            npcHandler:say("Now go! Travel to the northern city Carlin! Keep your eyes open and look around for something that might give you a clue!", cid)
            player:setStorageValue(Storage.DjinnWar.EfreetFaction.Start, 1)
            player:setStorageValue(Storage.DjinnWar.EfreetFaction.Mission01, 1)

        elseif msgcontains(msg:lower(), "no") then
            npcHandler:say('After all, you\'re just a human.', cid)
        end
        npcHandler.topic[cid] = 0

    elseif npcHandler.topic[cid] == 2 then
        if msgcontains(msg:lower(), "yes") then
            npcHandler:say("Finally! What is his name then?", cid)
            npcHandler.topic[cid] = 3

        elseif msgcontains(msg:lower(), "no") then
            npcHandler:say('Then go to Carlin and search for him! Look for something that might give you a clue!', cid)
            npcHandler.topic[cid] = 0
        end

    elseif npcHandler.topic[cid] == 3 then
        if msgcontains(msg:lower(), "partos") then
            if missionProgress ~= 2 then
                npcHandler:say('Hmmm... I don\'t think so. Return to Thais and continue your search!', cid)
            else
                npcHandler:say("You found the thief! Excellent work, soldier! You are doing well - for a human, that is. Here - take this as a reward. ...", cid)
                npcHandler:say('Since you have proven to be a capable soldier, we have another mission for you. ...', cid)
                npcHandler:say('If you are interested go to Alesar and ask him about it.', cid)
                player:addMoney(600)
                player:setStorageValue(Storage.DjinnWar.EfreetFaction.Mission01, 3)
            end

        else
            npcHandler:say("Hmmm... I don't think so. Return to Thais and continue your search!", cid)
        end
        npcHandler.topic[cid] = 0
    end
    return true
end

npcHandler:setMessage(MESSAGE_FAREWELL, 'Stand down, soldier!')

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

local focusModule = FocusModule:new()
focusModule:addGreetMessage('hi')
focusModule:addGreetMessage('hello')
focusModule:addGreetMessage('djanni\'hah')
npcHandler:addModule(focusModule)
