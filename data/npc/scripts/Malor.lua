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

    if not msgcontains(message:lower(), 'djanni\'hah') then
        return false
    end

    if player:getStorageValue(Storage.DjinnWar.EfreetFaction.Mission03) < 1 then
        npcHandler:setMessage(MESSAGE_GREET, 'Whoa! A human! This is no place for you. Go and play somewhere else.?')
    else
    npcHandler:setMessage(MESSAGE_GREET, 'Greetings, human. My patience with your kind is limited, so speak quickly and choose your words well.')
    end
    return true
end

local function creatureSayCallback(cid, type, msg)
    local player = Player(cid)

    if msgcontains(msg:lower(), 'djanni\'hah') then
        if player:getStorageValue(Storage.DjinnWar.EfreetFaction.Mission03) >= 1 then
            npcHandler:addFocus(cid)
            npcHandler:say('Greetings, human. My patience with your kind is limited, so speak quickly and choose your words well.', cid)
        else
            npcHandler:addFocus(cid)
            npcHandler:say('Whoa! A human! This is no place for you. Go and play somewhere else.', cid)
        end
        return true
    end

    if not npcHandler:isFocused(cid) then
        return false
    end

    local missionProgress = player:getStorageValue(Storage.DjinnWar.EfreetFaction.Mission03)
    if msgcontains(msg:lower(), 'mission') then
        if player:getStorageValue(Storage.DjinnWar.EfreetFaction.Mission02) == 3 then
            if missionProgress < 1 then
                npcHandler:say("I guess this is the first time I entrust a human with a mission. And such an important mission, too. But well, we live in hard times, and I am a bit short of adequate staff. ...", cid)
                npcHandler:say("Besides, Baa\'leal told me you have distinguished yourself well in previous missions, so I think you might be the right person for the job. ...", cid)
                npcHandler:say("But think carefully, human, for this mission will bring you close to certain death. Are you prepared to embark on this mission?", cid)
                npcHandler.topic[cid] = 1

            elseif missionProgress == 1 then
                npcHandler:say('You haven\'t finished your final mission yet. Shall I explain it again to you?', cid)
                npcHandler.topic[cid] = 1

            elseif missionProgress == 2 then
                npcHandler:say('Have you found Fa\'hradin\'s lamp and placed it in Malor\'s personal chambers?', cid)
                npcHandler.topic[cid] = 2
            else
                npcHandler:say('There\'s no mission left for you, friend of the Efreet. However, I have a {task} for you.', cid)
            end
        else
            npcHandler:say("So you would like to fight for us. Hmm. ...", cid)
            npcHandler:say("You show true courage, human, but I will not accept your offer at this point of time", cid)
        end

    elseif npcHandler.topic[cid] == 1 then
        if msgcontains(msg:lower(), 'yes') then
            npcHandler:say("Well, listen. We are trying to acquire the ultimate weapon to defeat Gabel: Fa\'hradin\'s lamp! ...", cid)
            npcHandler:say("At the moment it is still in the possession of that good old friend of mine, the Orc King, who kindly released me from it. ...", cid)
            npcHandler:say("However, for some reason he is not as friendly as he used to be. You better watch out, human, because I don\'t think you will get the lamp without a fight. ...", cid)
            npcHandler:say("Once you have found the lamp you must enter Ashta\'daramai again. Sneak into Gabel\'s personal chambers and exchange his sleeping lamp with Fa\'hradin\'s lamp! ...", cid)
            npcHandler:say("If you succeed, the war could be over one night later!", cid)
            player:setStorageValue(Storage.DjinnWar.EfreetFaction.Mission03, 1)

        elseif msgcontains(msg:lower(), 'no') then
            npcHandler:say('Your choice.', cid)
            npcHandler.topic[cid] = 0
        end

    elseif npcHandler.topic[cid] == 2 then
        if msgcontains(msg:lower(), 'yes') then
            npcHandler:say("Well well, human. So you really have made it - you have smuggled the modified lamp into Gabel's bedroom! ...", cid)
            npcHandler:say("I never thought I would say this to a human, but I must confess I am impressed. ...", cid)
            npcHandler:say("Perhaps I have underestimated you and your kind after all. ...", cid)
            npcHandler:say("I guess I will take this as a lesson to keep in mind when I meet you on the battlefield. ...", cid)
            npcHandler:say("But that\'s in the future. For now, I will confine myself to give you the permission to trade with my people whenever you want to. ...", cid)
            npcHandler:say("Farewell, human!", cid)
            player:setStorageValue(Storage.DjinnWar.EfreetFaction.Mission03, 3)
            player:setStorageValue(Storage.DjinnWar.EfreetFaction.DoorToMaridTerritory, 1)

        elseif msgcontains(msg:lower(), 'no') then
            npcHandler:say('Just do it!', cid)
        end
        npcHandler.topic[cid] = 0
    end
    return true
end

npcHandler:setMessage(MESSAGE_FAREWELL, 'Farewell, human. When I have taken my rightful place I shall remember those who served me well. Even if they are only humans.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Farewell, human.')

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

local focusModule = FocusModule:new()
focusModule:addGreetMessage('hi')
focusModule:addGreetMessage('hello')
focusModule:addGreetMessage('djanni\'hah')
focusModule:addGreetMessage('DJANNI\'HAH')
npcHandler:addModule(focusModule)
