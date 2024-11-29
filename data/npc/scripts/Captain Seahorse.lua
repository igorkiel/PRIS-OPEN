local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onThink()				npcHandler:onThink()					end

--postman
--addTravelKeyword('venore', 40, Position(32954, 32022, 6), function(player) if player:getStorageValue(Storage.postman.Mission01) == 3 then player:setStorageValue(Storage.postman.Mission01, 4) end end)
local cities = {
    ["venore"] = {cost = 40},
    ["thais"] = {cost = 160},
    ["carlin"] = {cost = 110},
    ["ab'dendriel"] = {cost = 70},
    ["port hope"] = {cost = 150},
    ["ankrahmun"] = {cost = 160},
    ["liberty bay"] = {cost = 170}
}
local kick_position = Position(33176, 31772, 6)
keywordHandler:addKeyword({'kick'}, StdModule.kick, {npcHandler = npcHandler, destination = {Position(33176, 31772, 6)}})

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
                if city == "venore" and player:getStorageValue(Storage.postman.Mission01) == 3 then
                    player:setStorageValue(Storage.postman.Mission01, 4)
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
        if (chosenCity == "venore" and player:getStorageValue(Storage.postman.Mission01) == 3) then
            player:setStorageValue(Storage.postman.Mission01, 4)
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
keywordHandler:addKeyword({'sail'}, StdModule.say, {npcHandler = npcHandler, text = 'Where do you want to go? To {Thais}, {Carlin}, {Ab\'Dendriel}, {Mistrock}, {Venore}, {Port Hope}, {Ankrahmun} or {Liberty Bay}?'})
keywordHandler:addKeyword({'passage'}, StdModule.say, {npcHandler = npcHandler, text = 'Where do you want to go? To {Thais}, {Carlin}, {Ab\'Dendriel}, {Mistrock}, {Venore}, {Port Hope}, {Ankrahmun} or {Liberty Bay}?'})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'My name is Captain Seahorse from the Royal Tibia Line.'})
keywordHandler:addKeyword({'edron'}, StdModule.say, {npcHandler = npcHandler, text = 'This is Edron. Where do you want to go?'})
keywordHandler:addKeyword({'yalahar'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m sorry, but we don\'t serve this route. However, I heard that Wyrdin here in Edron is looking for adventurers to go on a trip to Yalahar for him.'})

npcHandler:setMessage(MESSAGE_GREET, 'Welcome on board, |PLAYERNAME|. Where may I {sail} you today?')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Good bye. Recommend us if you were satisfied with our service.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Good bye then.')
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
