 local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onThink()		npcHandler:onThink()		end

local voices = { {text = 'Feel the wind in your hair during one of my carpet rides!'} }
npcHandler:addModule(VoiceModule:new(voices))

local cities = {
    ["edron"] = {cost = 60},
    ["svargrond"] = {cost = 60},
    ["darashia"] = {cost = 60},
    ["eclipse"] = {cost = 60}
}
local kick_position = Position(32530, 31838, 4)
keywordHandler:addKeyword({'kick'}, StdModule.kick, {npcHandler = npcHandler, destination = {Position(32530, 31838, 4)}})

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
                if city == "edron" and player:getStorageValue(Storage.postman.Mission01) == 2 then
                    player:setStorageValue(Storage.postman.Mission01, 3)
                    player:setStorageValue(194678, os.time())
                    local destination = randomPosCarpet(city)
                    player:teleportTo(destination)

                elseif not player:removeTotalMoney(cities[city].cost * 3) then
                    player:sendTextMessage(MESSAGE_INFO_DESCR, "Sorry, you don't have enough gold to travel to " .. city:titleCase() .. ".")
                    return true
                else
                    player:setStorageValue(194678, os.time())
                    local destination = randomPosCarpet(city)
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
        local destination = randomPosCarpet(chosenCity)
        if (chosenCity == "edron" and player:getStorageValue(Storage.postman.Mission01) == 2) then
            player:setStorageValue(Storage.postman.Mission01, 3)
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
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "I am known as Uzon Ibn Kalith."})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I am a licensed Darashian carpetpilot. I can bring you to {Darashia}, {Kazordoon}, {Svargrond} or {Edron}."})
keywordHandler:addKeyword({'caliph'}, StdModule.say, {npcHandler = npcHandler, text = "The caliph welcomes travellers to his land."})
keywordHandler:addKeyword({'kazzan'}, StdModule.say, {npcHandler = npcHandler, text = "The caliph welcomes travellers to his land."})
keywordHandler:addKeyword({'daraman'}, StdModule.say, {npcHandler = npcHandler, text = "Oh, there is so much to tell about Daraman. You better travel to Darama to learn about his teachings."})
keywordHandler:addKeyword({'ferumbras'}, StdModule.say, {npcHandler = npcHandler, text = "I would never transport this one."})
keywordHandler:addKeyword({'drefia'}, StdModule.say, {npcHandler = npcHandler, text = "So you heared about haunted Drefia? Many adventures travel there to test their skills against the undead: vampires, mummies, and ghosts."})
keywordHandler:addKeyword({'excalibug'}, StdModule.say, {npcHandler = npcHandler, text = "Some people claim it is hidden somewhere under the endless sands of the devourer desert in Darama."})
keywordHandler:addKeyword({'thais'}, StdModule.say, {npcHandler = npcHandler, text = "Thais is noisy and overcroweded. That's why I like Darashia more."})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, text = "I have seen almost every place on the continent."})
keywordHandler:addKeyword({'continent'}, StdModule.say, {npcHandler = npcHandler, text = "I could retell the tales of my travels for hours. Sadly another flight is scheduled soon."})
keywordHandler:addKeyword({'carlin'}, StdModule.say, {npcHandler = npcHandler, text = "Just another Thais but with women to lead them."})
keywordHandler:addKeyword({'flying'}, StdModule.say, {npcHandler = npcHandler, text = "You can buy flying carpets only in Darashia."})
keywordHandler:addKeyword({'fly'}, StdModule.say, {npcHandler = npcHandler, text = "I transport travellers to the continent of Darama for a small fee. So many want to see the wonders of the desert and learn the secrets of Darama."})
keywordHandler:addKeyword({'new'}, StdModule.say, {npcHandler = npcHandler, text = "I heard too many news to recall them all."})
keywordHandler:addKeyword({'rumors'}, StdModule.say, {npcHandler = npcHandler, text = "I heard too many news to recall them all."})
keywordHandler:addKeyword({'passage'}, StdModule.say, {npcHandler = npcHandler, text = "I can fly you to {Darashia} on Darama, {Kazordoon}, {Svargrond} or {Edron} if you like. Where do you want to go?"})
keywordHandler:addKeyword({'transport'}, StdModule.say, {npcHandler = npcHandler, text = "I can fly you to {Darashia} on Darama, {Kazordoon}, {Svargrond} or {Edron} if you like. Where do you want to go?"})
keywordHandler:addKeyword({'ride'}, StdModule.say, {npcHandler = npcHandler, text = "I can fly you to {Darashia} on Darama, {Kazordoon}, {Svargrond} or {Edron} if you like. Where do you want to go?"})
keywordHandler:addKeyword({'trip'}, StdModule.say, {npcHandler = npcHandler, text = "I can fly you to {Darashia} on Darama, {Kazordoon}, {Svargrond} or {Edron} if you like. Where do you want to go?"})

npcHandler:setMessage(MESSAGE_GREET, "Daraman's blessings, traveller |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Daraman's blessings")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Daraman's blessings")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
