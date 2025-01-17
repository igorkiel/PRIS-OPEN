  local keywordHandler = KeywordHandler:new()
  local npcHandler = NpcHandler:new(keywordHandler)
  NpcSystem.parseParameters(npcHandler)
  
  function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
  function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
  function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
  function onThink()				npcHandler:onThink()					end
  
  local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	local player = Player(cid)

	if msgcontains(msg, "nokmir") then
		if player:getStorageValue(Storage.hiddenCityOfBeregar.JusticeForAll) == 1 then
			npcHandler:say("I always liked him and I still can't believe that he really stole that ring.", cid)	
			npcHandler.topic[cid] = 2
		elseif player:getStorageValue(Storage.hiddenCityOfBeregar.JusticeForAll) == 4 and player:removeItem(14348, 1) then
			player:setStorageValue(Storage.hiddenCityOfBeregar.JusticeForAll, 5)
			npcHandler:say("Interesting. The fact that you have the ring means that Nokmir can't have stolen it. Combined with the information Grombur gave you, the case appears in a completely different light. ...", cid)	
			npcHandler:say("Let there be justice for all. Nokmir is innocent and acquitted from all charges! And Rerun... I want him in prison for this malicious act!", cid)
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, "grombur") then
		if npcHandler.topic[cid] == 2 then
			player:setStorageValue(Storage.hiddenCityOfBeregar.JusticeForAll, 2)
			npcHandler:say("He's very ambitious and always volunteers for the long shifts.", cid)	
			
		end
	elseif msgcontains(msg, "mission") then
		if player:getStorageValue(Storage.hiddenCityOfBeregar.RoyalRescue) < 1 then
			npcHandler.topic[cid] = 1
			npcHandler:say("As you have proven yourself trustworthy I'm going to assign you a special mission. Are you interested?", cid)	
		elseif player:getStorageValue(Storage.hiddenCityOfBeregar.RoyalRescue) == 5 then
			player:setStorageValue(Storage.hiddenCityOfBeregar.RoyalRescue, 6)
			player:addItem(2504)
			npcHandler:say("My son was captured by trolls? Doesn't sound like him, but if you say so. Now you want a reward, huh? ...", cid)	
			npcHandler:say("Look at these dwarven legs. They were forged years ago by a dwarf who was rather tall for our kind. I want you to have them. Thank you for rescuing my son.", cid)
			
		end

	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 1 then
			player:setStorageValue(Storage.hiddenCityOfBeregar.RoyalRescue, 1)
			player:setStorageValue(7645, 1)
			player:addItem(2504,1)

			npcHandler:say("Splendid! My son Rehon set off on an expedition to the deeper mines. He and a group of dwarfs were to search for new veins of crystal. Unfortunately they have been missing for 2 weeks now. What I'd like you to do is to find out what happened. ...", cid)
			npcHandler:say("Find my son and if he's alive bring him back. You will find a reactivated ore wagon tunnel at the entrance of the great citadel which leads to the deeper mines. If you encounter problems within the tunnel go ask Xorlosh, he can help you.", cid)
		
		end
	end
	return true
end
  
  npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
  npcHandler:addModule(FocusModule:new())
  