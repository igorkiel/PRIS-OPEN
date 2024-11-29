local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onThink()		npcHandler:onThink()		end

--postman
--addTravelKeyword('carlin', 110, Position(32387, 31820, 6), function(player) if player:getStorageValue(Storage.postman.Mission01) == 1 then player:setStorageValue(Storage.postman.Mission01, 2) end end)

local cities = {
    ["carlin"] = {cost = 110},
    ["ab'dendriel"] = {cost = 130},
    ["edron"] = {cost = 160},
    ["liberty bay"] = {cost = 180},
    ["venore"] = {cost = 170},
    ["port hope"] = {cost = 160},
    ["svargrond"] = {cost = 180},
    ["yalahar"] = {cost = 200}

}
local kick_position = Position(32320, 32219, 6)
keywordHandler:addKeyword({'kick'}, StdModule.kick, {npcHandler = npcHandler, destination = {Position(32320, 32219, 6), Position(32321, 32210, 6)}})


local voices = { {text = 'Passages to Carlin, Ab\'Dendriel, Edron, Venore, Port Hope, Liberty Bay and Svargrond.'} }
npcHandler:addModule(VoiceModule:new(voices))


function onCreatureSay(cid, type, msg)	
    npcHandler:onCreatureSay(cid, type, msg)
    local player = Player(cid)
    local city = msg:match("bring me to%s+(.+)")
    local kick = msg:match("kick")

    if kick then
        player:teleportTo(kick_position)
    end

    if city then
        if os.time() - 3 >= player:getStorageValue(194678) then
            if cities[city] then
                if city == "carlin" and player:getStorageValue(Storage.postman.Mission01) == 1 then
                    player:setStorageValue(Storage.postman.Mission01, 2)
                    player:setStorageValue(194678, os.time())
                    local destination = randomPos(city)
                    player:teleportTo(destination)
                elseif not player:removeTotalMoney(cities[city].cost * 3) then
                    player:sendTextMessage(MESSAGE_INFO_DESCR, "Sorry, you don't have enough gold to travel to " .. city:titleCase() .. ".")
                    return true
                else
                    player:setStorageValue(194678, os.time())
                    local destination = randomPos(city)
                    player:teleportTo(destination)
                end
            end   
        else
            player:sendTextMessage(MESSAGE_INFO_DESCR, "You can't travel that fast")
            return true
        end    
    end 
end
 

local function creatureSayCallback(cid, type, msg)
    if not npcHandler:isFocused(cid) then
		return false
	end
    local player = Player(cid)
    local city = msg:lower()
    if cities[city] then
        npcHandler:say("Do you want to travel to " .. city:titleCase() .. " for " .. cities[city].cost .. " gold?", cid)
        npcHandler.topic[cid] = city
    elseif msg == "yes" and npcHandler.topic[cid] then
        local chosenCity = npcHandler.topic[cid]
        local destination = randomPos(chosenCity)
        if (chosenCity == "carlin" and player:getStorageValue(Storage.postman.Mission01) == 1) then
            player:setStorageValue(Storage.postman.Mission01, 2)
            player:setStorageValue(194678, os.time())
            player:teleportTo(destination)
            player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
            npcHandler:say("Good travel to " .. chosenCity:titleCase() .. "!", cid)
        
        elseif os.time() - 3 >= player:getStorageValue(194678) then
            if player:removeTotalMoney(cities[chosenCity].cost) then
                player:teleportTo(destination)
                player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
                npcHandler:say("Good travel to " .. chosenCity:titleCase() .. "!", cid)
                player:setStorageValue(194678, os.time())
            else
                npcHandler:say("Sorry, you don't have enough gold to travel to " .. chosenCity:titleCase() .. ".", cid)
            end
            npcHandler.topic[cid] = nil
        else
            npcHandler:say("Sorry, you can't travel that fast.", cid)
        end

    elseif msg == "no" then
        npcHandler:say("Maybe next time.", cid)
        npcHandler.topic[cid] = nil
    else
        npcHandler:say("Sorry, you can't travel to this city.", cid)
    end
    
	return true
end

-- Basic
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'My name is Captain Bluebear from the Royal Tibia Line.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I am the captain of this sailing-ship.'})
keywordHandler:addKeyword({'captain'}, StdModule.say, {npcHandler = npcHandler, text = 'I am the captain of this sailing-ship.'})
keywordHandler:addKeyword({'ship'}, StdModule.say, {npcHandler = npcHandler, text = 'The Royal Tibia Line connects all seaside towns of Tibia.'})
keywordHandler:addKeyword({'line'}, StdModule.say, {npcHandler = npcHandler, text = 'The Royal Tibia Line connects all seaside towns of Tibia.'})
keywordHandler:addKeyword({'company'}, StdModule.say, {npcHandler = npcHandler, text = 'The Royal Tibia Line connects all seaside towns of Tibia.'})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, text = 'The Royal Tibia Line connects all seaside towns of Tibia.'})
keywordHandler:addKeyword({'good'}, StdModule.say, {npcHandler = npcHandler, text = 'We can transport everything you want.'})
keywordHandler:addKeyword({'passenger'}, StdModule.say, {npcHandler = npcHandler, text = 'We would like to welcome you on board.'})
keywordHandler:addKeyword({'trip'}, StdModule.say, {npcHandler = npcHandler, text = 'Where do you want to go? To {Carlin}, {Ab\'Dendriel}, {Venore}, {Port Hope}, {Liberty Bay}, {Svargrond} or {Edron}?'})
keywordHandler:addKeyword({'route'}, StdModule.say, {npcHandler = npcHandler, text = 'Where do you want to go? To {Carlin}, {Ab\'Dendriel}, {Venore}, {Port Hope}, {Liberty Bay}, {Svargrond} or {Edron}?'})
keywordHandler:addKeyword({'passage'}, StdModule.say, {npcHandler = npcHandler, text = 'Where do you want to go? To {Carlin}, {Ab\'Dendriel}, {Venore}, {Port Hope}, {Liberty Bay}, {Svargrond} or {Edron}?'})
keywordHandler:addKeyword({'town'}, StdModule.say, {npcHandler = npcHandler, text = 'Where do you want to go? To {Carlin}, {Ab\'Dendriel}, {Venore}, {Port Hope}, {Liberty Bay}, {Svargrond} or {Edron}?'})
keywordHandler:addKeyword({'destination'}, StdModule.say, {npcHandler = npcHandler, text = 'Where do you want to go? To {Carlin}, {Ab\'Dendriel}, {Venore}, {Port Hope}, {Liberty Bay}, {Svargrond} or {Edron}?'})
keywordHandler:addKeyword({'sail'}, StdModule.say, {npcHandler = npcHandler, text = 'Where do you want to go? To {Carlin}, {Ab\'Dendriel}, {Venore}, {Port Hope}, {Liberty Bay}, {Svargrond} or {Edron}?'})
keywordHandler:addKeyword({'go'}, StdModule.say, {npcHandler = npcHandler, text = 'Where do you want to go? To {Carlin}, {Ab\'Dendriel}, {Venore}, {Port Hope}, {Liberty Bay}, {Svargrond} or {Edron}?'})
keywordHandler:addKeyword({'ice'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m sorry, but we don\'t serve the routes to the Ice Islands.'})
keywordHandler:addKeyword({'senja'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m sorry, but we don\'t serve the routes to the Ice Islands.'})
keywordHandler:addKeyword({'folda'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m sorry, but we don\'t serve the routes to the Ice Islands.'})
keywordHandler:addKeyword({'vega'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m sorry, but we don\'t serve the routes to the Ice Islands.'})
keywordHandler:addKeyword({'darashia'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m not sailing there. This route is afflicted by a ghostship! However I\'ve heard that Captain Fearless from Venore sails there.'})
keywordHandler:addKeyword({'darama'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m not sailing there. This route is afflicted by a ghostship! However I\'ve heard that Captain Fearless from Venore sails there.'})
keywordHandler:addKeyword({'ghost'}, StdModule.say, {npcHandler = npcHandler, text = 'Many people who sailed to Darashia never returned because they were attacked by a ghostship! I\'ll never sail there!'})
keywordHandler:addKeyword({'thais'}, StdModule.say, {npcHandler = npcHandler, text = 'This is Thais. Where do you want to go?'})

npcHandler:setMessage(MESSAGE_GREET, 'Welcome on board, |PLAYERNAME|. Where can I {sail} you today?')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Good bye. Recommend us if you were satisfied with our service.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Good bye then.')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
