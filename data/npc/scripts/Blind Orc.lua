local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local function addBuyableKeyword(keywords, itemid, amount, price, text)
    local keyword
    if type(keywords) == 'table' then
        keyword = keywordHandler:addKeyword({keywords[1], keywords[2]}, StdModule.say, {npcHandler = npcHandler, text = text})
    else
        keyword = keywordHandler:addKeyword({keywords}, StdModule.say, {npcHandler = npcHandler, text = text})
    end

    keyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'Here is your item.', reset = true},
        function(player)
            if player:getMoney() >= price then
                player:removeMoney(price)
                player:addItem(itemid, amount)
                return true
            else
                npcHandler:say('You do not have enough money.', player)
                return false
            end
        end
    )
    keyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'Maybe next time.', reset = true})
end

-- Greeting and Farewell
keywordHandler:addGreetKeyword({'charach'}, {npcHandler = npcHandler, text = 'Ikem Charach maruk.'})
keywordHandler:addFarewellKeyword({'futchi'}, {npcHandler = npcHandler, text = 'Futchi!'})

-- Keywords for buying items
addBuyableKeyword('bow', 2456, 1, 400, 'Ahhhh, maruk, goshak bow? The price is 400 gold coins and you will receive 1 bow.')
addBuyableKeyword('arrow', 2544, 10, 30, 'Maruk goshak tefar arrow ul bow? The price is 30 gold coins and you will receive 10 arrow.')
addBuyableKeyword('brass shield', 2511, 1, 65, 'Maruk goshak ta? The price is 65 gold coins and you will receive 1 brass shield.')
addBuyableKeyword('leather armor', 2467, 1, 25, 'Maruk goshak ta? The price is 25 gold coins and you will receive 1 leather armor.')
addBuyableKeyword('studded armor', 2484, 1, 90, 'Maruk goshak ta? The price is 90 gold coins and you will receive 1 studded armor leather armor.')
addBuyableKeyword('studded helmet', 2482, 1, 60, 'Maruk goshak ta? The price is 60 gold coins and you will receive 1 studded helmet.')
addBuyableKeyword('sabre', 2385, 1, 25, 'Maruk goshak ta? The price is 25 gold coins and you will receive 1 sabre.')
addBuyableKeyword('sword', 2376, 1, 85, 'Maruk goshak ta? The price is 85 gold coins and you will receive 1 sword.')
addBuyableKeyword('short sword', 2406, 1, 30, 'Maruk goshak ta? The price is 30 gold coins and you will receive 1 short sword.')
addBuyableKeyword('hatchet', 2388, 1, 85, 'Maruk goshak ta? The price is 85 gold coins and you will receive 1 hatchet.')

npcHandler:setMessage(MESSAGE_WALKAWAY, 'Futchi.')
npcHandler:addModule(FocusModule:new())
