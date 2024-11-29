local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onThink()				npcHandler:onThink()					end

local cities = {
    ["thais"] = {cost = 130},
    ["carlin"] = {cost = 80},
    ["edron"] = {cost = 70},
    ["venore"] = {cost = 90},
    ["yalahar"] = {cost = 160}
}
local kick_position = Position(32724, 31669, 6)
keywordHandler:addKeyword({'kick'}, StdModule.kick, {npcHandler = npcHandler, destination = {Position(32724, 31669, 6), Position(32726, 31665, 6)}})

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
                if not player:removeTotalMoney(cities[city].cost * 3) then
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
        if os.time() - 3 >= player:getStorageValue(194678) then
            local chosenCity = npcHandler.topic[cid]
            local destination = randomPos(chosenCity)
            
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
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "My name is Captain Seagull from the Royal Tibia Line."})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I am the captain of this sailing-ship."})
keywordHandler:addKeyword({'captain'}, StdModule.say, {npcHandler = npcHandler, text = "I am the captain of this sailing-ship."})
keywordHandler:addKeyword({'ship'}, StdModule.say, {npcHandler = npcHandler, text = "The Royal Tibia Line connects all seaside towns of Tibia."})
keywordHandler:addKeyword({'line'}, StdModule.say, {npcHandler = npcHandler, text = "The Royal Tibia Line connects all seaside towns of Tibia."})
keywordHandler:addKeyword({'company'}, StdModule.say, {npcHandler = npcHandler, text = "The Royal Tibia Line connects all seaside towns of Tibia."})
keywordHandler:addKeyword({'route'}, StdModule.say, {npcHandler = npcHandler, text = "The Royal Tibia Line connects all seaside towns of Tibia."})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, text = "The Royal Tibia Line connects all seaside towns of Tibia."})
keywordHandler:addKeyword({'good'}, StdModule.say, {npcHandler = npcHandler, text = "We can transport everything you want."})
keywordHandler:addKeyword({'passanger'}, StdModule.say, {npcHandler = npcHandler, text = "We would like to welcome you on board."})
keywordHandler:addKeyword({'trip'}, StdModule.say, {npcHandler = npcHandler, text = "Where do you want to go? To {Thais}, {Carlin}, {Venore} or {Edron}?"})
keywordHandler:addKeyword({'passage'}, StdModule.say, {npcHandler = npcHandler, text = "WWhere do you want to go? To {Thais}, {Carlin}, {Venore} or {Edron}?"})
keywordHandler:addKeyword({'town'}, StdModule.say, {npcHandler = npcHandler, text = "Where do you want to go? To {Thais}, {Carlin}, {Venore} or {Edron}?"})
keywordHandler:addKeyword({'destination'}, StdModule.say, {npcHandler = npcHandler, text = "Where do you want to go? To {Thais}, {Carlin}, {Venore} or {Edron}?"})
keywordHandler:addKeyword({'sail'}, StdModule.say, {npcHandler = npcHandler, text = "Where do you want to go? To {Thais}, {Carlin}, {Venore} or {Edron}?"})
keywordHandler:addKeyword({'go'}, StdModule.say, {npcHandler = npcHandler, text = "Where do you want to go? To {Thais}, {Carlin}, {Venore} or {Edron}?"})
keywordHandler:addKeyword({'ice'}, StdModule.say, {npcHandler = npcHandler, text = "I'm sorry, but we don't serve the routes to the Ice Islands."})
keywordHandler:addKeyword({'senja'}, StdModule.say, {npcHandler = npcHandler, text = "I'm sorry, but we don't serve the routes to the Ice Islands."})
keywordHandler:addKeyword({'folda'}, StdModule.say, {npcHandler = npcHandler, text = "I'm sorry, but we don't serve the routes to the Ice Islands."})
keywordHandler:addKeyword({'vega'}, StdModule.say, {npcHandler = npcHandler, text = "I'm sorry, but we don't serve the routes to the Ice Islands."})
keywordHandler:addKeyword({'ankrahmun'}, StdModule.say, {npcHandler = npcHandler, text = "I'm sorry, but we don't serve this route."})
keywordHandler:addKeyword({'tiquanda'}, StdModule.say, {npcHandler = npcHandler, text = "I'm sorry, but we don't serve this route."})
keywordHandler:addKeyword({'port hope'}, StdModule.say, {npcHandler = npcHandler, text = "I'm sorry, but we don't serve this route."})
keywordHandler:addKeyword({'darashia'}, StdModule.say, {npcHandler = npcHandler, text = "I'm not sailing there. This route is afflicted by a ghost ship! However I've heard that Captain Fearless from Venore sails there."})
keywordHandler:addKeyword({'darama'}, StdModule.say, {npcHandler = npcHandler, text = "I'm not sailing there. This route is afflicted by a ghost ship! However I've heard that Captain Fearless from Venore sails there."})
keywordHandler:addKeyword({'ghost'}, StdModule.say, {npcHandler = npcHandler, text = "Many people who sailed to Darashia never returned because they were attacked by a ghostship! I'll never sail there!"})
keywordHandler:addKeyword({'ab\'dendriel'}, StdModule.say, {npcHandler = npcHandler, text = "This is Ab\'Dendriel. Where do you want to go?"})

npcHandler:setMessage(MESSAGE_GREET, "Welcome on board, |PLAYERNAME|. Where can I {sail} you today?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye. Recommend us if you were satisfied with our service.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
