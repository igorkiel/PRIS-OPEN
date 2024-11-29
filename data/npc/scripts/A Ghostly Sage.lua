local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

-- Defina o custo da viagem
local travelCost = 1000 -- custo em moedas

local travelNode = keywordHandler:addKeyword({'exit'}, StdModule.say, {
    npcHandler = npcHandler,
    text = 'You will now be travelled out of here. Are you sure that you want to face that teleport?'
})

-- Modifique o comportamento quando o jogador confirmar a viagem
travelNode:addChildKeyword({'yes'}, function(player, npc, msg, handler) -- Corrige os parâmetros passados
    local player = Player(player) -- Converte cid para o objeto Player
    if not player then
        handler:say('Sorry, there was an error.', player)
        return false
    end

    if player:removeTotalMoney(travelCost) then
        player:teleportTo(Position(32834, 32275, 9)) -- Teleporta o jogador
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT) -- Adiciona efeito de teletransporte
        handler:say('You have been teleported.', player)
    else
        handler:say('Sorry, you do not have enough money.', player)
    end
    return true
end, {npcHandler = npcHandler})

-- Se o jogador disser 'no', ele permanecerá no local
travelNode:addChildKeyword({'no'}, StdModule.say, {
    npcHandler = npcHandler,
    reset = true,
    text = 'Then stay here in these ghostly halls.'
})

keywordHandler:addKeyword({'passage'}, StdModule.say, {
    npcHandler = npcHandler,
    text = 'I can offer you a {teleport}.'
})

keywordHandler:addKeyword({'job'}, StdModule.say, {
    npcHandler = npcHandler,
    text = 'Dont mind me.'
})

npcHandler:setMessage(MESSAGE_GREET, "Ah, I feel a mortal walks these ancient halls again. Pardon me, I barely notice you. I am so lost in my thoughts.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Farewell then.")

npcHandler:addModule(FocusModule:new())
