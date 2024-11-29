local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onThink()				npcHandler:onThink()					end


local cities = {
    ["edron"] = {cost = 160},
    ["venore"] = {cost = 150},
    ["port hope"] = {cost = 70},
    ["liberty bay"] = {cost = 90},
    ["darashia"] = {cost = 100},
    ["yalahar"] = {cost = 230}
}
local kick_position = Position(33082, 32879, 6)
keywordHandler:addKeyword({'kick'}, StdModule.kick, {npcHandler = npcHandler, destination = {Position(33082, 32879, 6), Position(33085, 32879, 6), Position(33085, 32881, 6)}})


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
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "I'm known all over the world as Captain Sinbeard"})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I'm the captain of this sailing ship"})
keywordHandler:addKeyword({'captain'}, StdModule.say, {npcHandler = npcHandler, text = "I'm the captain of this sailing ship"})
keywordHandler:addKeyword({'ship'}, StdModule.say, {npcHandler = npcHandler, text = "My ship is the fastest in the whole world."})
keywordHandler:addKeyword({'line'}, StdModule.say, {npcHandler = npcHandler, text = "My ship is the fastest in the whole world."})
keywordHandler:addKeyword({'company'}, StdModule.say, {npcHandler = npcHandler, text = "My ship is the fastest in the whole world."})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, text = "My ship is the fastest in the whole world."})
keywordHandler:addKeyword({'god'}, StdModule.say, {npcHandler = npcHandler, text = "Where do you want to go? To {Darashia}, {Venore}, {Liberty Bay}, {Port Hope} or {Edron}?"})
keywordHandler:addKeyword({'passanger'}, StdModule.say, {npcHandler = npcHandler, text = "We would like to welcome you on board."})
keywordHandler:addKeyword({'trip'}, StdModule.say, {npcHandler = npcHandler, text = "Where do you want to go? To {Darashia}, {Venore}, {Liberty Bay}, {Port Hope} or {Edron}?"})
keywordHandler:addKeyword({'route'}, StdModule.say, {npcHandler = npcHandler, text = "Where do you want to go? To {Darashia}, {Venore}, {Liberty Bay}, {Port Hope} or {Edron}?"})
keywordHandler:addKeyword({'passage'}, StdModule.say, {npcHandler = npcHandler, text = "Where do you want to go? To {Darashia}, {Venore}, {Liberty Bay}, {Port Hope} or {Edron}?"})
keywordHandler:addKeyword({'town'}, StdModule.say, {npcHandler = npcHandler, text = "Where do you want to go? To {Darashia}, {Venore}, {Liberty Bay}, {Port Hope} or {Edron}?"})
keywordHandler:addKeyword({'destination'}, StdModule.say, {npcHandler = npcHandler, text = "Where do you want to go? To {Darashia}, {Venore}, {Liberty Bay}, {Port Hope} or {Edron}?"})
keywordHandler:addKeyword({'sail'}, StdModule.say, {npcHandler = npcHandler, text = "Where do you want to go? To {Darashia}, {Venore}, {Liberty Bay}, {Port Hope} or {Edron}?"})
keywordHandler:addKeyword({'go'}, StdModule.say, {npcHandler = npcHandler, text = "Where do you want to go? To {Darashia}, {Venore}, {Liberty Bay}, {Port Hope} or {Edron}?"})
keywordHandler:addKeyword({'thais'}, StdModule.say, {npcHandler = npcHandler, text = "I'm sorry but I don't sail there."})
keywordHandler:addKeyword({'carlin'}, StdModule.say, {npcHandler = npcHandler, text = "I'm sorry but I don't sail there."})
keywordHandler:addKeyword({'ab\'dendriel'}, StdModule.say, {npcHandler = npcHandler, text = "I'm sorry but I don't sail there."})
keywordHandler:addKeyword({'ankrahmun'}, StdModule.say, {npcHandler = npcHandler, text = "That's where we are."})

npcHandler:setMessage(MESSAGE_GREET, "Welcome on board, Sir |PLAYERNAME|. Where can I {sail} you today?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye. Recommend us if you were satisfied with our service.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye then.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
