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

	if npcHandler.topic[cid] == 0 then
		if msgcontains(msg, 'outfit') then
			npcHandler:say("Well, the helmet is for those who really are tenacious and have hunted down all 6666 demons and finished the demon oak as well. Are you interested?", cid)
			npcHandler.topic[cid] = 1
		elseif msgcontains(msg, 'cookie') then
			if player:getStorageValue(Storage.WhatAFoolishQuest.Questline) == 31 and player:getStorageValue(Storage.WhatAFoolishQuest.CookieDelivery.AvarTar) ~= 1 then
				npcHandler:say('Do you really think you could bribe a hero like me with a meagre cookie?', cid)
				npcHandler.topic[cid] = 3
			end
		end
	elseif msgcontains(msg, 'yes') then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say("So you want to have the demon outfit, hah! Let's have a look first if you really deserve it. Tell me: {base}, {shield} or {helmet}?", cid)
			npcHandler.topic[cid] = 2
		elseif npcHandler.topic[cid] == 3 then
			if not player:removeItem(8111, 1) then
				npcHandler:say('You have no cookie that I\'d like.', cid)
				npcHandler.topic[cid] = 0
				return true
			end

			player:setStorageValue(Storage.WhatAFoolishQuest.CookieDelivery.AvarTar, 1)
			if player:getCookiesDelivered() == 10 then
				player:addAchievement('Allow Cookies?')
			end

			Npc():getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
			npcHandler:say('Well, you won\'t! Though it looks tasty ...What the ... WHAT DO YOU THINK YOU ARE? THIS IS THE ULTIMATE INSULT! GET LOST!', cid)
			npcHandler:releaseFocus(cid)
			npcHandler:resetNpc(cid)
		end
	elseif msgcontains(msg, 'no') then
		if npcHandler.topic[cid] == 3 then
			npcHandler:say('I see.', cid)
			npcHandler.topic[cid] = 0
		end
	elseif npcHandler.topic[cid] == 2 then
		if msgcontains(msg, 'base') then
			if player:getStorageValue(Storage.AnnihilatorDone) == 1 then
				if player:getStorageValue(22155) ~= 1 then
					player:addOutfit(541)
					player:addOutfit(542)
					player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
					player:setStorageValue(22155, 1)
					npcHandler:say('Receive the base outfit, ' .. player:getName() .. '.', cid)
				else
					npcHandler:say("You already have received the shield.")
				end
			else
				npcHandler:say('You didn\'t complete the annihilator quest yet.', cid)
			end
		elseif msgcontains(msg, 'shield') then
			if player:getStorageValue(Storage.AnnihilatorDone) == 2 and player:getStorageValue(Storage.QuestChests.DemonHelmetQuestDemonHelmet) == 1 then
				player:addOutfitAddon(541, 1)
				player:addOutfitAddon(542, 1)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				player:setStorageValue(Storage.QuestChests.DemonHelmetQuestDemonHelmet, 2)
				npcHandler:say("Receive the shield, " .. player:getName() ..  ".", cid)
			else 
				npcHandler:say('You didn\'t complete the demon helmet quest yet.', cid)
			end
		elseif msgcontains(msg, 'helmet') then
			if player:getStorageValue(22155) == 1 then
				if player:getStorageValue(Storage.DemonOak.Done) == 3 then
					player:addOutfitAddon(541, 2)
					player:addOutfitAddon(542, 2)
					player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
					player:setStorageValue(Storage.DemonOak.Done, 4)
					npcHandler:say('Receive the helmet, ' .. player:getName() .. '.', cid)
				else
					npcHandler:say('You didn\'t complete the demon oak quest yet.', cid)
				end
			else
				npcHandler:say("You need to complete the shield part of this outfit before.", cid)
			end
		end
		npcHandler.topic[cid] = 0
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, 'Greetings, traveller |PLAYERNAME|!')
npcHandler:setMessage(MESSAGE_FAREWELL, 'See you later, |PLAYERNAME|.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'See you later, |PLAYERNAME|.')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())