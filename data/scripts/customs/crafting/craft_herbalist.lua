
local craftMining = Action()

function capAll(str)
    return str:gsub("^(%a)", string.upper):gsub("([^%a]%a)", string.upper)
end

local config = {
	mainTitleMsg = "Herbalist Craft", 
	mainMsg = "Welcome to the Herbalist Craft.\nPlease choose a category:", 
 
	craftTitle = "Herbalist Craft: ",
	craftMsg = "Click on Recipe to see the necessary resources needed to craft a new one.\n\nHere is a list of all resources that can be crafted from Mining craft: ", 
	needItems = "You do not have all the required items to make ",
	system = {
	[1] = {tiers = "Nimble Potions", 
			items = {
				[1] = {item = "Nimble Life Potion", 
						itemID = 26733, 
						reqItems = {
							[1] = {item = 26731, count = 3}, -- 3 Scilla Siberica
							[2] = {item = 26729, count = 1}, -- 1 Delphinium
							},
							description = "Drinking this potions give's 515-685 HP's.",
							skill_required = 0,
							storage = Jobs.Herbalist.NimbleLifePotion, 
						},
						[2] = {item = "Nimble Mana Potion", 
						itemID = 26736, 
						reqItems = {
							[1] = {item = 26730, count = 3}, -- 3 Gilia
							[2] = {item = 26732, count = 1}, -- 1 Bluebell
							},
							description = "Drinking this potions give's 160-235 Mana.",
							skill_required = 0,
							storage = Jobs.Herbalist.NimbleManaPotion, 
						},
 
				},
			},
	[2] = {tiers = "Hazel Potions", 
			items = {
				[1] = {item = "Hazel Life Potion", 
						itemID = 26734, 
						reqItems = {
							[1] = {item = 26725, count = 3}, -- 3 Scarlet Seeds
							[2] = {item = 26726, count = 1}, -- 1 Scarlet Flower
							},
							description = "Drinking this potions give's 750-920 HP's.",
							skill_required = 10,
							storage = Jobs.Herbalist.HazelLifePotion, 
						},
				[2] = {item = "Hazel Mana Potion", 
						itemID = 26737, 
						reqItems = {
							[1] = {item = 26727, count = 3}, -- 3 Red Lilly
							[2] = {item = 26726, count = 1}, -- 1 Scarlet Flower
							},
							description = "Drinking this potions give's 280-425 Mana.",
							skill_required = 10,
							storage = Jobs.Herbalist.HazelManaPotion, 
						},
 
				},
			},
		[3] = {tiers = "Tumble Potions", 
			items = {
				[1] = {item = "Tumble Life Potion", 
						itemID = 26735, 
						reqItems = {
								[1] = {item = 26723, count = 3}, -- 3 Russula Emetica
								[2] = {item = 26724, count = 1}, -- 1 Cantharellus
							},
							description = "Drinking this potions give's 890-1050 HP's.",
							skill_required = 20,
							storage = 0, 
						},
				[2] = {item = "Tumble Mana Potion", 
						itemID = 26738, 
						reqItems = {
							[1] = {item = 26728, count = 3}, -- 3 Anemone
							[2] = {item = 26724, count = 1}, -- 1 Cantharellus
							},
							description = "Drinking this potions give's 500-795 Mana.",
							skill_required = 20,
							storage = 0, 
						},
 
				},
			},
		[4] = {tiers = "Scissor's", 
			items = {
				[1] = {item = "Apprentice's Scissor", 
						itemID = 26713, 
						reqItems = {
								[1] = {item = 26712, count = 1}, -- Beginner's Scissor
								[2] = {item = 26729, count = 5}, -- 5 Delphinium
							},
							description = "This Scissor's are used to harvest on Canterbury Bells and Gentiana.",
							skill_required = 5,
							storage = 0, 
						},
						[2] = {item = "Herbalist's Scissor", 
						itemID = 26714, 
						reqItems = {
							[1] = {item = 26413, count = 1}, -- Apprentice's Scissor
							[2] = {item = 26732, count = 5}, -- 5 Bluebell
							},
							description = "This Scissor's are used to harvest on Canterbury Bells, Gentiana and Scarlet Sage.",
							skill_required = 10,
							storage = 0, 
						},
						[3] = {item = "Expert's Scissor", 
						itemID = 26715, 
						reqItems = {
							[1] = {item = 26714, count = 1}, -- Herbalist's Scissor
							[2] = {item = 26726, count = 5}, -- 5 Scarlet Flower
							},
							description = "This Scissor's are used to harvest on Canterbury Bells, Gentiana, Scarlet Sage and Camellia.",
							skill_required = 20,
							storage = 0, 
						},
						[4] = {item = "Master's Scissor", 
						itemID = 26716, 
						reqItems = {
							[1] = {item = 26715, count = 1}, -- Expert's Scissor
							[2] = {item = 26727, count = 5}, -- 5 Red Lilly
							},
							description = "This Scissor's are used to harvest on Canterbury Bells, Gentiana, Scarlet Sage, Camellia, Russula Emetica and Anemone.",
							skill_required = 30,
							storage = 0, 
						},
 
				},
			},
		},
	}
 
function craftMining.onUse(player, item, fromPosition, itemEx, toPosition, isHotkey)
	
    player:sendMainCraftWindow(config)
    return true
end
craftMining:aid(36457)
craftMining:register()