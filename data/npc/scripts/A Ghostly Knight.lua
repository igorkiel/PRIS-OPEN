local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)            npcHandler:onCreatureAppear(cid)          end
function onCreatureDisappear(cid)         npcHandler:onCreatureDisappear(cid)       end
function onCreatureSay(cid, type, msg)    npcHandler:onCreatureSay(cid, type, msg)  end
function onThink()                        npcHandler:onThink()                      end

local function greetCallback(cid)
    local player = Player(cid)
    if player then
        npcHandler:say("Failed. I have ... failed.", cid)
    end
    return true
end

local function creatureSayCallback(cid, type, msg)
    local player = Player(cid)
    if not player then
        return false
    end

    msg = msg:lower()

    if msg == "failed" then
        npcHandler:say("The pits. We have sealed the pits. We have concealed the way.", cid)

    elseif msg == "concealed" or msg == "pits of inferno" then
        npcHandler:say("I cannot ... tell you. I died ... long ago ... But I still remember my duties.", cid)

    elseif msg == "duties" then
        npcHandler:say("My duties are the only thing death had left me. I have no remembrance of my mortal days ... perhaps with one exception.", cid)

    elseif msg == "exception" then
        npcHandler:say("I remember there used to be something I liked. Grapes! Delicious juicy grapes! What a joy it is to even remember.", cid)

    elseif msg == "grapes" then
        npcHandler:say("You would not have some grapes for me, would you?", cid)

    elseif msg == "no" then
        npcHandler:say("It does not matter. It is only a faint memory anyway.", cid)

    elseif msg == "yes" then
        if player:getItemCount(2681) > 0 then -- Assuming 2681 is the item ID for grapes
            player:removeItem(2681, 1)
            npcHandler:say({
                "Oh, thank you! Thank you! Why, to know such delight! It is almost as if I could taste them again ... almost ...",
                "Listen, mortal. There is so much I forgot, but I remember that the passage is hidden. It can only be revealed through luck or careful exploration ...",
                "One of you must stay here and watch while the others explore every spot of the caverns ahead ...",
                "There are so many ... hidden switches. I can't remember where. But ... they will open the path."
            }, cid)
        else
            npcHandler:say("No, you don't have any with you. That is a shame...", cid)
        end

    elseif msg == "bye" then
        npcHandler:say("Loneliness ... again.", cid)
        npcHandler:releaseFocus(cid)
        npcHandler:resetNpc(cid)
    end

    return true
end

npcHandler:setMessage(MESSAGE_GREET, "Failed. I have ... failed.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Loneliness ... again.")
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
