local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end


keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I am a teacher of the most powerful spells in Tibia."})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I am known in this world as Zoltan."})
keywordHandler:addKeyword({'king'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "King Tibianus III was the founder of our academy."})
keywordHandler:addKeyword({'tibianus'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "King Tibianus III was the founder of our academy."})
keywordHandler:addKeyword({'army'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "They rely too much on their brawn instead of their brain."})
keywordHandler:addKeyword({'ferumbras'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "A fallen sorcerer, indeed. What a shame."})
keywordHandler:addKeyword({'excalibug'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "You will need no weapon if you manipulate the essence of magic."})
keywordHandler:addKeyword({'thais'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Thais is a place of barbary."})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "There is still much left to be explored in this world."})
keywordHandler:addKeyword({'carlin'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Carlin's druids waste the influence they have in enviromentalism."})
keywordHandler:addKeyword({'edron'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Sciences are thriving on this isle."})
keywordHandler:addKeyword({'new'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I have no time for chit chat."})
keywordHandler:addKeyword({'rumo'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I have no time for chit chat."})
keywordHandler:addKeyword({'eremo'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "He is an old and wise man that has seen a lot of Tibia. He is also one of the best magicians. Visit him on his little island."})
keywordHandler:addKeyword({'visit'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "You should visit Eremo on his little island. Just ask Pemaret on Cormaya for passage."})
keywordHandler:addKeyword({'yenne the gentle'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Ah, Yenny the Gentle was one of the founders of the druid order called Crunor's Caress, that has been originated in her hometown Carlin."})
keywordHandler:addKeyword({'crunors caress'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "A quite undruidic order of druids they were, as far as we know. I have no more englightening knowledge about them though."})
keywordHandler:addKeyword({'spellbook'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Don't bother me with that. Ask in the shops for it."})
keywordHandler:addKeyword({'spell'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I have some very powerful spells: 'Energy Bomb', 'Mass Healing', 'Poison Storm', 'Paralyze', 'Ultimate Explosion', 'Great Energyball' and 'Great Magic Missile'."})
keywordHandler:addKeyword({'yenny'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Ah, Yenny the Gentle was one of the founders of the druid order called Crunor's Caress, that has been originated in her hometown Carlin."})

-- Female Summoner and Male Mage Hat Addon (needs to be rewritten)
local hatKeyword = keywordHandler:addKeyword({'proof'}, StdModule.say, {npcHandler = npcHandler, text = '... I cannot believe my eyes. You retrieved this hat from Ferumbras\' remains? That is incredible. If you give it to me, I will grant you the right to wear this hat as addon. What do you say?'},
		function(player) return not player:hasOutfit(player:getSex() == PLAYERSEX_FEMALE and 141 or 130, 2) end
	)
	hatKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'Sorry you don\'t have the Ferumbras\' hat.'}, function(player) return player:getItemCount(5903) == 0 end)
	hatKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'I bow to you, player, and hereby grant you the right to wear Ferumbras\' hat as accessory. Congratulations!'}, nil,
		function(player)
			player:removeItem(5903, 1)
			player:addOutfitAddon(141, 2)
			player:addOutfitAddon(130, 2)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
		end
	)
	-- hatKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = ''})

keywordHandler:addKeyword({'myra'}, StdModule.say, {npcHandler = npcHandler,
	text = {
		'Bah, I know. I received some sort of \'nomination\' from our outpost in Port Hope. ...',
		'Usually it takes a little more than that for an award though. However, I honour Myra\'s word. ...',
		'I hereby grant you the right to wear a special sign of honour, acknowledged by the academy of Edron. Since you are a man, I guess you don\'t want girlish stuff. There you go.'
	}},
	function(player) return player:getStorageValue(Storage.OutfitQuest.MageSummoner.AddonHatCloak) == 10 end,
	function(player)
		player:addOutfitAddon(138, 2)
		player:addOutfitAddon(133, 2)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		player:setStorageValue(Storage.OutfitQuest.MageSummoner.AddonHatCloak, 11)
		player:setStorageValue(Storage.OutfitQuest.MageSummoner.MissionHatCloak, 0)
		player:setStorageValue(Storage.OutfitQuest.Ref, math.min(0, player:getStorageValue(Storage.OutfitQuest.Ref) - 1))
	end
)

keywordHandler:addKeyword({'myra'}, StdModule.say, {npcHandler = npcHandler, text = 'Stop bothering me. I am a far too busy man to be constantly giving out awards.'}, function(player) return player:getStorageValue(Storage.OutfitQuest.MageSummoner.AddonHatCloak) == 11 end)
keywordHandler:addKeyword({'myra'}, StdModule.say, {npcHandler = npcHandler, text = 'What the hell are you talking about?'})

npcHandler:setMessage(MESSAGE_GREET, 'Welcome |PLAYERNAME|, student of the arcane arts.')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Good bye, and don\'t come back too soon.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Good bye, and don\'t come back too soon.')

npcHandler:addModule(FocusModule:new())
