RARITY_CHANCE = {
	ondrop = 25, -- 10% de chance de obter qualquer item raro
	fromMonster = {
		{ id = ITEM_RARITY_COMMON, chance = 20 },
		{ id = ITEM_RARITY_RARE, chance = 80 },
		{ id = ITEM_RARITY_EPIC, chance = 70 },
		{ id = ITEM_RARITY_LEGENDARY, chance = 80 },
		{ id = ITEM_RARITY_BRUTAL, chance = 90 },
	},

	fromQuest = {
		{ id = ITEM_RARITY_COMMON, chance = 20 },
		{ id = ITEM_RARITY_RARE, chance = 30 },
		{ id = ITEM_RARITY_EPIC, chance = 12 },
		{ id = ITEM_RARITY_LEGENDARY, chance = 5 },
		{ id = ITEM_RARITY_BRUTAL, chance = 2 },
	}
}

RARITY_MODIFIERS = {
	{ id = ITEM_RARITY_COMMON, amount = 1 },
	{ id = ITEM_RARITY_RARE, amount = 2 },
	{ id = ITEM_RARITY_EPIC, amount = 3 },
	{ id = ITEM_RARITY_LEGENDARY, amount = 4 },
	{ id = ITEM_RARITY_BRUTAL, amount = 5 },
}

RARITY_ATTRIBUTES = {
	{ id = CONST_SLOT_HEAD, attributes = {
		{ -- Elemental Protection (Death)
			id = TOOLTIP_ATTRIBUTE_RESISTANCES, type = {COMBAT_DEATHDAMAGE}, min = 1, max = 5
		},
		{ -- Elemental Protection (Energy)
			id = TOOLTIP_ATTRIBUTE_RESISTANCES, type = {COMBAT_ENERGYDAMAGE}, min = 1, max = 5
		},
		{ -- Elemental Protection (Fire)
			id = TOOLTIP_ATTRIBUTE_RESISTANCES, type = {COMBAT_FIREDAMAGE}, min = 1, max = 5
		},
		{ -- Elemental Protection (Physical)
			id = TOOLTIP_ATTRIBUTE_RESISTANCES, type = {COMBAT_PHYSICALDAMAGE}, min = 1, max = 5
		},
		{ -- Magic Level
			id = TOOLTIP_ATTRIBUTE_STATS, type = {STAT_MAGICPOINTS}, min = 1, max = 5
		},
		{ -- Melee (Club)
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_CLUB}, min = 1, max = 5
		},
		{ -- Melee (Sword)
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_SWORD}, min = 1, max = 5
		},
		{ -- Melee (Axe)
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_AXE}, min = 1, max = 5
		},
		{ -- Melee (Shield)
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_SHIELD}, min = 1, max = 5
		},
		{ -- Skill Distance
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_DISTANCE}, min = 1, max = 5
		},
		{ -- Extra healing
			id = TOOLTIP_ATTRIBUTE_INCREMENTS, type = {COMBAT_HEALING}, min = 1, max = 10
		},
		{ -- Extra Health
			id = TOOLTIP_ATTRIBUTE_STATS, type = {STAT_MAXHITPOINTS}, min = 10, max = 50
		},
		{ -- Extra Mana
			id = TOOLTIP_ATTRIBUTE_STATS, type = {STAT_MAXMANAPOINTS}, min = 10, max = 50
		},
		{ -- Extra gold 
			id = TOOLTIP_ATTRIBUTE_INCREMENT_COINS, min = 1, max = 5
		},
		{ -- Experience % bonus
			id = TOOLTIP_ATTRIBUTE_EXPERIENCE, min = 1, max = 5
		},
		{ -- Extra Arm
			id = TOOLTIP_ATTRIBUTE_ARMOR, min = 1, max = 5
		},
	}},
	{ id = CONST_SLOT_ARMOR, attributes = {
		{ -- Elemental Protection (Death)
			id = TOOLTIP_ATTRIBUTE_RESISTANCES, type = {COMBAT_DEATHDAMAGE}, min = 1, max = 5
		},
		{ -- Elemental Protection (Energy)
			id = TOOLTIP_ATTRIBUTE_RESISTANCES, type = {COMBAT_ENERGYDAMAGE}, min = 1, max = 5
		},
		{ -- Elemental Protection (Fire)
			id = TOOLTIP_ATTRIBUTE_RESISTANCES, type = {COMBAT_FIREDAMAGE}, min = 1, max = 5
		},
		{ -- Elemental Protection (Physical)
			id = TOOLTIP_ATTRIBUTE_RESISTANCES, type = {COMBAT_PHYSICALDAMAGE}, min = 1, max = 5
		},
		{ -- Magic Level
			id = TOOLTIP_ATTRIBUTE_STATS, type = {STAT_MAGICPOINTS}, min = 1, max = 5
		},
		{ -- Melee (Club)
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_CLUB}, min = 1, max = 5
		},
		{ -- Melee (Sword)
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_SWORD}, min = 1, max = 5
		},
		{ -- Melee (Axe)
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_AXE}, min = 1, max = 5
		},
		{ -- Melee (Shield)
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_SHIELD}, min = 1, max = 5
		},
		{ -- Skill Distance
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_DISTANCE}, min = 1, max = 5
		},
		{ -- Extra healing
			id = TOOLTIP_ATTRIBUTE_INCREMENTS, type = {COMBAT_HEALING}, min = 1, max = 10
		},
		{ -- Extra Health
			id = TOOLTIP_ATTRIBUTE_STATS, type = {STAT_MAXHITPOINTS}, min = 10, max = 50
		},
		{ -- Extra Mana
			id = TOOLTIP_ATTRIBUTE_STATS, type = {STAT_MAXMANAPOINTS}, min = 10, max = 50
		},
		{ -- Extra gold 
			id = TOOLTIP_ATTRIBUTE_INCREMENT_COINS, min = 1, max = 5
		},
		{ -- Experience % bonus
			id = TOOLTIP_ATTRIBUTE_EXPERIENCE, min = 1, max = 5
		},
		{ -- Extra Arm
			id = TOOLTIP_ATTRIBUTE_ARMOR, min = 1, max = 5
		},
	}},
	{ id = CONST_SLOT_LEGS, attributes = {
		{ -- Elemental Protection (Death)
			id = TOOLTIP_ATTRIBUTE_RESISTANCES, type = {COMBAT_DEATHDAMAGE}, min = 1, max = 5
		},
		{ -- Elemental Protection (Energy)
			id = TOOLTIP_ATTRIBUTE_RESISTANCES, type = {COMBAT_ENERGYDAMAGE}, min = 1, max = 5
		},
		{ -- Elemental Protection (Fire)
			id = TOOLTIP_ATTRIBUTE_RESISTANCES, type = {COMBAT_FIREDAMAGE}, min = 1, max = 5
		},
		{ -- Elemental Protection (Physical)
			id = TOOLTIP_ATTRIBUTE_RESISTANCES, type = {COMBAT_PHYSICALDAMAGE}, min = 1, max = 5
		},
		{ -- Magic Level
			id = TOOLTIP_ATTRIBUTE_STATS, type = {STAT_MAGICPOINTS}, min = 1, max = 5
		},
		{ -- Melee (Club)
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_CLUB}, min = 1, max = 5
		},
		{ -- Melee (Sword)
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_SWORD}, min = 1, max = 5
		},
		{ -- Melee (Axe)
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_AXE}, min = 1, max = 5
		},
		{ -- Melee (Shield)
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_SHIELD}, min = 1, max = 5
		},
		{ -- Skill Distance
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_DISTANCE}, min = 1, max = 5
		},
		{ -- Extra healing
			id = TOOLTIP_ATTRIBUTE_INCREMENTS, type = {COMBAT_HEALING}, min = 1, max = 10
		},
		{ -- Extra Health
			id = TOOLTIP_ATTRIBUTE_STATS, type = {STAT_MAXHITPOINTS}, min = 10, max = 50
		},
		{ -- Extra Mana
			id = TOOLTIP_ATTRIBUTE_STATS, type = {STAT_MAXMANAPOINTS}, min = 10, max = 50
		},
		{ -- Extra gold 
			id = TOOLTIP_ATTRIBUTE_INCREMENT_COINS, min = 1, max = 5
		},
		{ -- Experience % bonus
			id = TOOLTIP_ATTRIBUTE_EXPERIENCE, min = 1, max = 5
		},
		{ -- Extra Arm
			id = TOOLTIP_ATTRIBUTE_ARMOR, min = 1, max = 5
		},
	}},
	{ id = CONST_SLOT_SHIELD, attributes = {
		{ -- Elemental Protection (Death)
			id = TOOLTIP_ATTRIBUTE_RESISTANCES, type = {COMBAT_DEATHDAMAGE}, min = 1, max = 5
		},
		{ -- Elemental Protection (Energy)
			id = TOOLTIP_ATTRIBUTE_RESISTANCES, type = {COMBAT_ENERGYDAMAGE}, min = 1, max = 5
		},
		{ -- Elemental Protection (Fire)
			id = TOOLTIP_ATTRIBUTE_RESISTANCES, type = {COMBAT_FIREDAMAGE}, min = 1, max = 5
		},
		{ -- Elemental Protection (Physical)
			id = TOOLTIP_ATTRIBUTE_RESISTANCES, type = {COMBAT_PHYSICALDAMAGE}, min = 1, max = 5
		},
		{ -- Extra Defense
			id = TOOLTIP_ATTRIBUTE_EXTRADEFENSE, min = 1, max = 5
		},
		{ -- Magic Level
			id = TOOLTIP_ATTRIBUTE_STATS, type = {STAT_MAGICPOINTS}, min = 1, max = 5
		},
		{ -- Melee (Club)
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_CLUB}, min = 1, max = 5
		},
		{ -- Melee (Sword)
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_SWORD}, min = 1, max = 5
		},
		{ -- Melee (Axe)
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_AXE}, min = 1, max = 5
		},
		{ -- Melee (Shield)
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_SHIELD}, min = 1, max = 5
		},
		{ -- Skill Distance
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_DISTANCE}, min = 1, max = 5
		},
		{ -- Extra healing
			id = TOOLTIP_ATTRIBUTE_INCREMENTS, type = {COMBAT_HEALING}, min = 1, max = 10
		},
		{ -- Extra Health
			id = TOOLTIP_ATTRIBUTE_STATS, type = {STAT_MAXHITPOINTS}, min = 10, max = 50
		},
		{ -- Extra Mana
			id = TOOLTIP_ATTRIBUTE_STATS, type = {STAT_MAXMANAPOINTS}, min = 10, max = 50
		},
		
	}},
	{ id = CONST_SLOT_FEET, attributes = {
		{ -- Movement Speed
			id = TOOLTIP_ATTRIBUTE_SPEED, min = 1, max = 5
		},
		{ -- Elemental Protection (Death)
			id = TOOLTIP_ATTRIBUTE_RESISTANCES, type = {COMBAT_DEATHDAMAGE}, min = 1, max = 5
		},
		{ -- Elemental Protection (Energy)
			id = TOOLTIP_ATTRIBUTE_RESISTANCES, type = {COMBAT_ENERGYDAMAGE}, min = 1, max = 5
		},
		{ -- Elemental Protection (Fire)
			id = TOOLTIP_ATTRIBUTE_RESISTANCES, type = {COMBAT_FIREDAMAGE}, min = 1, max = 5
		},
		{ -- Elemental Protection (Physical)
			id = TOOLTIP_ATTRIBUTE_RESISTANCES, type = {COMBAT_PHYSICALDAMAGE}, min = 1, max = 5
		},
		{ -- Magic Level
			id = TOOLTIP_ATTRIBUTE_STATS, type = {STAT_MAGICPOINTS}, min = 1, max = 5
		},
		{ -- Melee (Club)
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_CLUB}, min = 1, max = 5
		},
		{ -- Melee (Sword)
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_SWORD}, min = 1, max = 5
		},
		{ -- Melee (Axe)
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_AXE}, min = 1, max = 5
		},
		{ -- Melee (Shield)
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_SHIELD}, min = 1, max = 5
		},
		{ -- Skill Distance
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_DISTANCE}, min = 1, max = 5
		},
		{ -- Extra healing
			id = TOOLTIP_ATTRIBUTE_INCREMENTS, type = {COMBAT_HEALING}, min = 1, max = 10
		},
		{ -- Extra Health
			id = TOOLTIP_ATTRIBUTE_STATS, type = {STAT_MAXHITPOINTS}, min = 10, max = 50
		},
		{ -- Extra Mana
			id = TOOLTIP_ATTRIBUTE_STATS, type = {STAT_MAXMANAPOINTS}, min = 10, max = 50
		},
		{ -- Extra Arm
			id = TOOLTIP_ATTRIBUTE_ARMOR, min = 1, max = 5
		},
	}},
	{ id = CONST_SLOT_WEAPON, attributes = {
		{ -- Critical Hit chance
			id = TOOLTIP_ATTRIBUTE_CRITICALHIT_CHANCE, min = 1, max = 2
		},
		{ -- Elemental Protection (Death)
			id = TOOLTIP_ATTRIBUTE_RESISTANCES, type = {COMBAT_DEATHDAMAGE}, min = 1, max = 5
		},
		{ -- Elemental Protection (Energy)
			id = TOOLTIP_ATTRIBUTE_RESISTANCES, type = {COMBAT_ENERGYDAMAGE}, min = 1, max = 5
		},
		{ -- Elemental Protection (Fire)
			id = TOOLTIP_ATTRIBUTE_RESISTANCES, type = {COMBAT_FIREDAMAGE}, min = 1, max = 5
		},
		{ -- Elemental Protection (Physical)
			id = TOOLTIP_ATTRIBUTE_RESISTANCES, type = {COMBAT_PHYSICALDAMAGE}, min = 1, max = 5
		},
		{ -- Extra Defense
			id = TOOLTIP_ATTRIBUTE_EXTRADEFENSE, min = 1, max = 5
		},
		{ -- Magic Level
			id = TOOLTIP_ATTRIBUTE_STATS, type = {STAT_MAGICPOINTS}, min = 1, max = 5
		},
		{ -- Melee (Club)
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_CLUB}, min = 1, max = 5
		},
		{ -- Melee (Sword)
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_SWORD}, min = 1, max = 5
		},
		{ -- Melee (Axe)
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_AXE}, min = 1, max = 5
		},
		{ -- Melee (Shield)
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_SHIELD}, min = 1, max = 5
		},
		{ -- Skill Distance
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_DISTANCE}, min = 1, max = 5
		},
		{ -- Extra healing
			id = TOOLTIP_ATTRIBUTE_INCREMENTS, type = {COMBAT_HEALING}, min = 1, max = 10
		},
		{ -- Extra Health
			id = TOOLTIP_ATTRIBUTE_STATS, type = {STAT_MAXHITPOINTS}, min = 10, max = 50
		},
		{ -- Extra Mana
			id = TOOLTIP_ATTRIBUTE_STATS, type = {STAT_MAXMANAPOINTS}, min = 10, max = 50
		},
		
	}},
	{ id = CONST_SLOT_WAND, attributes = {
		{ -- Critical Hit chance
			id = TOOLTIP_ATTRIBUTE_CRITICALHIT_CHANCE, min = 1, max = 2
		},
		{ -- Elemental Protection (Death)
			id = TOOLTIP_ATTRIBUTE_RESISTANCES, type = {COMBAT_DEATHDAMAGE}, min = 1, max = 5
		},
		{ -- Elemental Protection (Energy)
			id = TOOLTIP_ATTRIBUTE_RESISTANCES, type = {COMBAT_ENERGYDAMAGE}, min = 1, max = 5
		},
		{ -- Elemental Protection (Fire)
			id = TOOLTIP_ATTRIBUTE_RESISTANCES, type = {COMBAT_FIREDAMAGE}, min = 1, max = 5
		},
		{ -- Elemental Protection (Physical)
			id = TOOLTIP_ATTRIBUTE_RESISTANCES, type = {COMBAT_PHYSICALDAMAGE}, min = 1, max = 5
		},
		{ -- Magic Level
			id = TOOLTIP_ATTRIBUTE_STATS, type = {STAT_MAGICPOINTS}, min = 1, max = 5
		},
		{ -- Melee (Shield)
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_SHIELD}, min = 1, max = 5
		},
		{ -- Extra healing
			id = TOOLTIP_ATTRIBUTE_INCREMENTS, type = {COMBAT_HEALING}, min = 1, max = 10
		},
		{ -- Extra Health
			id = TOOLTIP_ATTRIBUTE_STATS, type = {STAT_MAXHITPOINTS}, min = 10, max = 50
		},
		{ -- Extra Mana
			id = TOOLTIP_ATTRIBUTE_STATS, type = {STAT_MAXMANAPOINTS}, min = 10, max = 50
		},
		
	}},
	{ id = CONST_SLOT_NECKLACE, attributes = {
		{ -- Elemental Protection (Death)
			id = TOOLTIP_ATTRIBUTE_RESISTANCES, type = {COMBAT_DEATHDAMAGE}, min = 1, max = 5
		},
		{ -- Elemental Protection (Energy)
			id = TOOLTIP_ATTRIBUTE_RESISTANCES, type = {COMBAT_ENERGYDAMAGE}, min = 1, max = 5
		},
		{ -- Elemental Protection (Fire)
			id = TOOLTIP_ATTRIBUTE_RESISTANCES, type = {COMBAT_FIREDAMAGE}, min = 1, max = 5
		},
		{ -- Elemental Protection (Physical)
			id = TOOLTIP_ATTRIBUTE_RESISTANCES, type = {COMBAT_PHYSICALDAMAGE}, min = 1, max = 5
		},
		{ -- Magic Level
			id = TOOLTIP_ATTRIBUTE_STATS, type = {STAT_MAGICPOINTS}, min = 1, max = 5
		},
		{ -- Melee (Club)
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_CLUB}, min = 1, max = 5
		},
		{ -- Melee (Sword)
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_SWORD}, min = 1, max = 5
		},
		{ -- Melee (Axe)
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_AXE}, min = 1, max = 5
		},
		{ -- Melee (Shield)
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_SHIELD}, min = 1, max = 5
		},
		{ -- Skill Distance
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_DISTANCE}, min = 1, max = 5
		},
		{ -- Extra healing
			id = TOOLTIP_ATTRIBUTE_INCREMENTS, type = {COMBAT_HEALING}, min = 1, max = 10
		},
		{ -- Extra Health
			id = TOOLTIP_ATTRIBUTE_STATS, type = {STAT_MAXHITPOINTS}, min = 10, max = 50
		},
		{ -- Extra Mana
			id = TOOLTIP_ATTRIBUTE_STATS, type = {STAT_MAXMANAPOINTS}, min = 10, max = 50
		},
		{ -- Extra gold 
			id = TOOLTIP_ATTRIBUTE_INCREMENT_COINS, min = 1, max = 5
		},
		{ -- Experience % bonus
			id = TOOLTIP_ATTRIBUTE_EXPERIENCE, min = 1, max = 5
		},
		{ -- Extra Arm
			id = TOOLTIP_ATTRIBUTE_ARMOR, min = 1, max = 5
		},
	}},
	{ id = CONST_SLOT_RING, attributes = {
		{ -- Elemental Protection (Death)
			id = TOOLTIP_ATTRIBUTE_RESISTANCES, type = {COMBAT_DEATHDAMAGE}, min = 1, max = 5
		},
		{ -- Elemental Protection (Energy)
			id = TOOLTIP_ATTRIBUTE_RESISTANCES, type = {COMBAT_ENERGYDAMAGE}, min = 1, max = 5
		},
		{ -- Elemental Protection (Fire)
			id = TOOLTIP_ATTRIBUTE_RESISTANCES, type = {COMBAT_FIREDAMAGE}, min = 1, max = 5
		},
		{ -- Elemental Protection (Physical)
			id = TOOLTIP_ATTRIBUTE_RESISTANCES, type = {COMBAT_PHYSICALDAMAGE}, min = 1, max = 5
		},
		{ -- Magic Level
			id = TOOLTIP_ATTRIBUTE_STATS, type = {STAT_MAGICPOINTS}, min = 1, max = 5
		},
		{ -- Melee (Club)
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_CLUB}, min = 1, max = 5
		},
		{ -- Melee (Sword)
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_SWORD}, min = 1, max = 5
		},
		{ -- Melee (Axe)
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_AXE}, min = 1, max = 5
		},
		{ -- Melee (Shield)
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_SHIELD}, min = 1, max = 5
		},
		{ -- Skill Distance
			id = TOOLTIP_ATTRIBUTE_SKILL, type = {SKILL_DISTANCE}, min = 1, max = 5
		},
		{ -- Extra healing
			id = TOOLTIP_ATTRIBUTE_INCREMENTS, type = {COMBAT_HEALING}, min = 1, max = 10
		},
		{ -- Extra Health
			id = TOOLTIP_ATTRIBUTE_STATS, type = {STAT_MAXHITPOINTS}, min = 10, max = 50
		},
		{ -- Extra Mana
			id = TOOLTIP_ATTRIBUTE_STATS, type = {STAT_MAXMANAPOINTS}, min = 10, max = 50
		},
		{ -- Extra gold 
			id = TOOLTIP_ATTRIBUTE_INCREMENT_COINS, min = 1, max = 5
		},
		{ -- Experience % bonus
			id = TOOLTIP_ATTRIBUTE_EXPERIENCE, min = 1, max = 5
		},
		{ -- Extra Arm
			id = TOOLTIP_ATTRIBUTE_ARMOR, min = 1, max = 5
		},
	}},
}