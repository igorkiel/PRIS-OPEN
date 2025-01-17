local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

keywordHandler:addKeyword({'hi'}, StdModule.say, {npcHandler = npcHandler, onlyUnfocus = true, text = "MIND YOUR MANNERS COMMONER! To address the king, greet with his title!"})
keywordHandler:addKeyword({'hello'}, StdModule.say, {npcHandler = npcHandler, onlyUnfocus = true, text = "MIND YOUR MANNERS COMMONER! To address the king, greet with his title!"})

local function creatureSayCallback(cid, type, msg)
    local player = Player(cid)
    
    if msgcontains(msg:lower(), "hail king") or msgcontains(msg:lower(), "salutations king") then
        npcHandler:addFocus(cid)
        npcHandler:say('HAIL TO THE KING, ' .. player:getName() .. '!', cid)
        return true
    end

    if not npcHandler:isFocused(cid) then
        return false
    end

    if isInArray({'fuck', 'idiot', 'asshole', 'ass', 'fag', 'stupid', 'tyrant', 'shit', 'lunatic'}, msg) then
        local conditions = { CONDITION_POISON, CONDITION_FIRE, CONDITION_ENERGY, CONDITION_BLEEDING, CONDITION_PARALYZE, CONDITION_DROWN, CONDITION_FREEZING, CONDITION_DAZZLED, CONDITION_CURSED }
        for i = 1, #conditions do
            if player:getCondition(conditions[i]) then
                player:removeCondition(conditions[i])
            end
        end
        player:getPosition():sendMagicEffect(CONST_ME_EXPLOSIONAREA)
        player:addHealth(1 - player:getHealth())
        npcHandler:say('Take this!', cid)
        Npc():getPosition():sendMagicEffect(CONST_ME_YELLOW_RINGS)
    end

    return true
end

local function greetCallback(cid)
    return false
end

npcHandler:setMessage(MESSAGE_FAREWELL, 'LONG LIVE THE KING! You may leave now!')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'LONG LIVE THE KING!')
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

local focusModule = FocusModule:new()
focusModule:addGreetMessage('hail king')
focusModule:addGreetMessage('salutations king')
npcHandler:addModule(focusModule)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
