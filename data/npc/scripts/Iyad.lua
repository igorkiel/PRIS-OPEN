 local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{ text = 'A... aargh. I wish I had some e... earmuffs to put over this useless t... turban.' },
	{ text = 'Oh p.. please. P... lease let me fly us out of this c... cold.' }
}

npcHandler:addModule(VoiceModule:new(voices))

-- Travel
local function addTravelKeyword(keyword, text, cost, destination)
	--if keyword == 'farmine' then
		--keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'Never heard about a place like this.'}, function(player) return player:getStorageValue(Storage.TheNewFrontier.Mission10) ~= 1 end)
	--end

	local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'Do you seek a ride to ' .. text .. ' for ' .. cost .. '?', cost = cost, discount = 'postman'})
		travelKeyword:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = false, text = 'Hold on!', cost = cost, discount = 'postman', destination = destination})
		travelKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'You shouldn\'t miss the experience.', reset = true})
end

addTravelKeyword('darashia', 'Darashia on Darama', 60, Position(33270, 32441, 6))
addTravelKeyword('edron', 'Edron', 60, Position(33193, 31784, 3))
addTravelKeyword('femor hills', 'the Femor Hills', 60, Position(32536, 31837, 4))
addTravelKeyword('kazordoon', 'Kazordoon', 70, Position(32588, 31942, 0))

npcHandler:setMessage(MESSAGE_GREET, "Greetings, traveller |PLAYERNAME|. Where do you want me to {fly} you?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye!")

npcHandler:addModule(FocusModule:new())
