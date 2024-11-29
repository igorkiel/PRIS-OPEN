local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onThink()		npcHandler:onThink()		end
 
local voices = { {text = 'Passages to Edron, Thais, Venore, Darashia, Ankrahmun, Yalahar and Port Hope.'} }
npcHandler:addModule(VoiceModule:new(voices))

local cities = {
    ["edron"] = {cost = 170},
    ["venore"] = {cost = 180},
    ["port hope"] = {cost = 50},
    ["darashia"] = {cost = 200},
    ["ankrahmun"] = {cost = 90},
    ["thais"] = {cost = 180},
	["goroma"] = {cost = 150}
   
}
local kick_position = Position(32275, 32892, 6)
keywordHandler:addKeyword({'kick'}, StdModule.kick, {npcHandler = npcHandler, destination = {Position(32275, 32892, 6), Position(32276, 32891, 6), Position(32277, 32895, 6)}})


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
keywordHandler:addKeyword({'sail'}, StdModule.say, {npcHandler = npcHandler, text = 'Where do you want to go? To {Edron}, {Thais}, {Venore}, {Darashia}, {Ankrahmun} or {Port Hope}?'})
keywordHandler:addKeyword({'passage'}, StdModule.say, {npcHandler = npcHandler, text = 'Where do you want to go? To {Edron}, {Thais}, {Venore}, {Darashia}, {Ankrahmun} or {Port Hope}?'})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'My name is Jack Fate from the Royal Tibia Line.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m the captain of this sailing ship.'})
keywordHandler:addKeyword({'captain'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m the captain of this sailing ship.'})
keywordHandler:addKeyword({'liberty bay'}, StdModule.say, {npcHandler = npcHandler, text = 'That\'s where we are.'})

npcHandler:setMessage(MESSAGE_GREET, "Welcome on board, Sir |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye. Recommend us if you were satisfied with our service.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye then.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
