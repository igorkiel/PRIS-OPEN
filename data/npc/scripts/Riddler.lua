local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)            npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)         npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)    npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                        npcHandler:onThink()                        end

keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I am known as the riddler. That is all you need to know."})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I am the guardian of the paradox tower."})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "It is the age of the talon."})
keywordHandler:addKeyword({'tower'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "This tower, of course, silly one. It holds my master's treasure."})
keywordHandler:addKeyword({'paradox'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "This tower, of course, silly one. It holds my master's treasure."})
keywordHandler:addKeyword({'master'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "His name is none of your business."})
keywordHandler:addKeyword({'guard'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I am guarding the treasures of the tower. Only those who pass the test of the three sigils may pass."})
keywordHandler:addKeyword({'treasure'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I am guarding the treasures of the tower. Only those who pass the test of the three sigils may pass."})
keywordHandler:addKeyword({'key'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "The key of this tower! You will never find it! A malicious plant spirit is guarding it!"})
keywordHandler:addKeyword({'door'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "The key of this tower! You will never find it! A malicious plant spirit is guarding it!"})

local function creatureSayCallback(cid, type, msg)
    local player = Player(cid)
    if not npcHandler:isFocused(cid) then
        return false
    end

    if not npcHandler.topic[cid] then
        npcHandler.topic[cid] = 0
    end

    -- Initialize quest states if not set
    if player:getStorageValue(6667) < 1 then
        player:setStorageValue(6667, 1)
    end
    if player:getStorageValue(6668) < 1 then
        player:setStorageValue(6668, 1)
    end
    if player:getStorageValue(6669) < 1 then
        player:setStorageValue(6669, 0)
    end

    local queststate1 = player:getStorageValue(6667)
    local queststate2 = player:getStorageValue(6668)
    local stored_number = player:getStorageValue(6669)

    local talkState = npcHandler.topic[cid]

    local response01 = "Death awaits those who fail the test of the three seals! Do you really want me to test you?"
    local response02 = "FOOL! Now you're doomed! But well ... So be it! Let's start out with the Seal of Knowledge and the first question: What name did the necromant king choose for himself?"
    local response03 = "HOHO! You have learned your lesson well. Question number two then: Who or what is the feared Hugo?"
    local response04 = "HOHO! Right again. All right. The final question of the first seal: Who was the first warrior to follow the path of the Mooh'Tah?"
    local response05 = "HOHO! Lucky you. You have passed the first seal! So ... would you like to continue with the Seal of the Mind?"
    local response06 = "As you wish, foolish one! Here is my first question: Its lighter then a feather but no living creature can hold it for ten minutes?"
    local response07 = "That was an easy one. Let's try the second: If you name it, you break it."
    local response08 = "Hm. I bet you think you're smart. All right. How about this: What does everybody want to become but nobody to be?"
    local response09 = "ARGH! You did it again! Well all right. Do you wish to break the Seal of Madness?"
    local response10 = "GOOD! So I will get you at last. Answer this: What is my favourite colour?"
    local response11 = "UHM UH OH ... How could you guess that? Are you mad??? All right. Question number two: What is the opposite?"
    local response12 = "NO! NO! NO! That can't be true. You're not only mad, you are a complete idiot! Ah well. Here is the last question: What is 1 plus 1?"
    local response13 = "WRONG!"
    local response14 = "RIGHT!"

    local wrong = "NO! HAHA! YOU FAILED!"
    local keywordAbadon = "no"
    local abadon = "Better for you..."

    local keyword01 = "test"
    local keyword02 = "yes"
    local keyword03 = "goshnar"
    local keyword04 = "demonbunny"
    local keyword05 = "tha'kull"
    local keyword06 = "yes"
    local keyword07 = "breath"
    local keyword08 = "silence"
    local keyword09 = "old"
    local keyword10 = "yes"
    local keyword11 = "green"
    local keyword12 = "none"
    local keyword14 = "2"

    local posPass = Position(32478, 31905, 1)
    local posFail = Position(32725, 31589, 12)

    -- Debugging print statements
    -- print("Player ID:", cid, "Current Talk State:", talkState, "Message:", msg, "Queststate1:", queststate1, "Queststate2:", queststate2, "Stored Number:", stored_number)

    if msg == keyword01 and queststate2 == 1 then
        npcHandler:say(response01, cid)
        npcHandler.topic[cid] = 13
    elseif msg == keyword02 and talkState == 13 then
        npcHandler:say(response02, cid)
        npcHandler.topic[cid] = 14
    elseif msg == keywordAbadon and talkState == 13 then
        npcHandler:say(abadon, cid)
        npcHandler.topic[cid] = 0
    elseif msg == keyword03 and talkState == 14 then
        npcHandler:say(response03, cid)
        npcHandler.topic[cid] = 15
    elseif msg == keyword04 and talkState == 15 then
        npcHandler:say(response04, cid)
        npcHandler.topic[cid] = 16
    elseif msg == keyword05 and talkState == 16 then
        npcHandler:say(response05, cid)
        npcHandler.topic[cid] = 17
    elseif msg == keyword06 and talkState == 17 then
        npcHandler:say(response06, cid)
        npcHandler.topic[cid] = 18
    elseif msg == keyword07 and talkState == 18 then
        npcHandler:say(response07, cid)
        npcHandler.topic[cid] = 19
    elseif msg == keyword08 and talkState == 19 then
        npcHandler:say(response08, cid)
        npcHandler.topic[cid] = 20
    elseif msg == keyword09 and talkState == 20 then
        npcHandler:say(response09, cid)
        npcHandler.topic[cid] = 21
    elseif msg == keyword10 and talkState == 21 then
        npcHandler:say(response10, cid)
        npcHandler.topic[cid] = 22
    elseif msg == keyword11 and talkState == 22 then
        npcHandler:say(response11, cid)
        npcHandler.topic[cid] = 23
    elseif msg == keyword12 and talkState == 23 then
        npcHandler:say(response12, cid)
        npcHandler.topic[cid] = 24
    elseif tonumber(msg) and talkState == 24 then
        if tonumber(msg) == stored_number then
            npcHandler:say(response14, cid)
            player:teleportTo(posPass)
            posPass:sendMagicEffect(CONST_ME_TELEPORT)
        else
            npcHandler:say(response13, cid)
            player:teleportTo(posFail)
            posFail:sendMagicEffect(CONST_ME_TELEPORT)
        end
    elseif msg == keyword01 and queststate1 == 1 then
        npcHandler:say(response01, cid)
        npcHandler.topic[cid] = 1
    elseif msg == keyword02 and talkState == 1 then
        npcHandler:say(response02, cid)
        npcHandler.topic[cid] = 2

    elseif msg == keywordAbadon and talkState == 1 then
        npcHandler:say(abadon, cid)
        npcHandler.topic[cid] = 0

    elseif msg == keyword03 and talkState == 2 then
        npcHandler:say(response03, cid)
        npcHandler.topic[cid] = 3

    elseif msg == keyword04 and talkState == 3 then
        npcHandler:say(response04, cid)
        npcHandler.topic[cid] = 4

    elseif msg == keyword05 and talkState == 4 then
        npcHandler:say(response05, cid)
        npcHandler.topic[cid] = 5

    elseif msg == keyword06 and talkState == 5 then
        npcHandler:say(response06, cid)
        npcHandler.topic[cid] = 6

    elseif msg == keyword07 and talkState == 6 then
        npcHandler:say(response07, cid)
        npcHandler.topic[cid] = 7

    elseif msg == keyword08 and talkState == 7 then
        npcHandler:say(response08, cid)
        npcHandler.topic[cid] = 8
    elseif msg == keyword09 and talkState == 8 then
        npcHandler:say(response09, cid)
        npcHandler.topic[cid] = 9

    elseif msg == keyword10 and talkState == 9 then
        npcHandler:say(response10, cid)
        npcHandler.topic[cid] = 10

    elseif msg == keyword11 and talkState == 10 then
        npcHandler:say(response11, cid)
        npcHandler.topic[cid] = 11

    elseif msg == keyword12 and talkState == 11 then
        npcHandler:say(response12, cid)
        npcHandler.topic[cid] = 12

    elseif tonumber(msg) and talkState == 12 then
        if tonumber(msg) == stored_number then
            npcHandler:say(response14, cid)
            player:teleportTo(posPass)
            posPass:sendMagicEffect(CONST_ME_TELEPORT)

        else
            npcHandler:say(response13, cid)
            player:teleportTo(posFail)
            posFail:sendMagicEffect(CONST_ME_TELEPORT)

        end
    end

    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
