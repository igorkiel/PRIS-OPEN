local DONATION_URL = "https://tibiapristine.online"

local CODE_GAMESTORE = 102
local GAME_STORE = nil

local LoginEvent = CreatureEvent("GameStoreLogin")

function LoginEvent.onLogin(player)
    player:registerEvent("GameStoreExtended")
    return true
end

function gameStoreInitialize()
    GAME_STORE = {
        categories = {},
        offers = {}
    }

    addCategory("Tools", "Tools, Scripts & Others.", "item", 24774)
    addItem("Tools", "Pristine Tool", "Rope, shovel, pick and a lot of functions tool.", 28309, 1, 40);
	addItem("Tools", "Amulet of Loss", "Do not lose anything at you die!", 2173, 1, 50);
	addItem("Tools", "Cash bag", "100 Slots for your money.", 28165, 1, 40);
	addItem("Tools", "Sparkle Light", "24hrs of Full Light", 28166, 1, 4);
	addItem("Tools", "Key Chain", "Store all your keys.", 28171, 1, 30);
	addItem("Tools", "Shooter's Quiver", "Store all your keys.", 28177, 1, 40);
	addItem("Tools", "Erbalist Quiver", "Store all your keys.", 28178, 1, 40);
	addItem("Tools", "Dark Quiver", "Store all your keys.", 28179, 1, 40);
	addItem("Tools", "Rock bag", "Storage all rocks here to train your distance skill.", 28181, 1, 40);
	
	addCategory("Premium", "Premium Scrolls", "item", 16101)
    addItem("Premium", "Premium (7 days)", "Premium points", 28182, 1, 5);
	addItem("Premium", "Premium (15 days)", "Premium points", 28183, 1, 10);
	addItem("Premium", "Premium (30 days)", "Premium points", 28184, 1, 15);
	--addItem("Premium", "Premium (60 days)", "Premium points", 28185, 1, 60);
	
	addCategory("Boxes", "Boxes", "item", 28319)
    addItem("Boxes", "Bronze Box", "Bronze Box", 28317, 1, 10);
	addItem("Boxes", "Platinum Box", "Platinum Box", 28318, 1, 10);
	addItem("Boxes", "Golden Box", "Golden Box", 28319, 1, 10);
	
	addCategory("Scrolls", "Tools, Scripts & Others.", "item", 16101)
    addItem("Scrolls", "Blue Djinn Quest", "Blue Djinn Quest", 28161, 1, 70);
	addItem("Scrolls", "Green Djinn Quest", "Green Djinn Quest", 28162, 1, 70);
	addItem("Scrolls", "Rashid Quest", "Rashid Quest", 28315, 1, 70);
	addItem("Scrolls", "House Scroll", "House Scroll", 28316, 1, 70);
	addItem("Scrolls", "Postman Quest", "Postman Quest", 28163, 1, 70);
	addItem("Scrolls", "Bless Protection", "Grants all Blessings", 28164, 1, 70);
	addItem("Scrolls", "Bless Checker", "Bless Cheker", 28314, 1, 50);
	addItem("Scrolls", "Gender Change", "Change your characters gender.", 28170, 1, 100);
	
	addCategory("Backpacks", "Backpacks", "item", 27732)
	addItem("Backpacks", "Pristine Backpack", "30 Slots.", 28307, 1, 10);
	addItem("Backpacks", "Pristine Backpack", "30 Slots.", 28308, 1, 10);
	addItem("Backpacks", "Dragon Lord Backpack", "50 Slots & 7.00oz", 28174, 1, 20);
	addItem("Backpacks", "Skull Backpack", "50 Slots & 7.00oz", 28172, 1, 20);
	
	addItem("Backpacks", "Rune Backpack", "20 Slots.", 28303, 1, 5);
	addItem("Backpacks", "Rune Backpack", "20 Slots.", 28297, 1, 5);
	addItem("Backpacks", "Rune Backpack", "20 Slots.", 28298, 1, 5);
	addItem("Backpacks", "Rune Backpack", "20 Slots.", 28299, 1, 5);
	addItem("Backpacks", "Rune Backpack", "20 Slots.", 28300, 1, 5);
	addItem("Backpacks", "Rune Backpack", "20 Slots.", 28301, 1, 5);
	addItem("Backpacks", "Rune Backpack", "20 Slots.", 28302, 1, 5);
	
	addItem("Backpacks", "Crown Backpack", "50 Slots & 7.00oz", 28173, 1, 20);
	
	
	addCategory("Training", "Training Items", "item", 27732)
	addItem("Training", "Skill training ring", "Train your axe, club, sword and shielding skill.", 28175, 1, 4);
	addItem("Training", "Exercise Wand", "test.", 27737, 10000, 1);
	addItem("Training", "Exercise Bow", "test.", 27735, 10000, 1);
	addItem("Training", "Exercise Sword", "test.", 27732, 10000, 1);
	addItem("Training", "Exercise Axe", "test.", 27733, 10000, 1);
	addItem("Training", "Exercise Club", "test.", 27734, 10000, 1);
	addItem("Training", "Exercise Shield", "test.", 27758, 1, 1);
	

	
	addCategory(
        "Outfits",
        "Contains all addons.",
        "outfit",
        {
            mount = 0,
            type = 430,
            addons = 0,
            head = 0,
            body = 114,
            legs = 85,
            feet = 76
        }
    )
		
	addOutfit( "Outfits", "Afflicted", "Afflicted",
        {mount = 0, type = 431, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
        {mount = 0, type = 430, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
        25
    )
	
	addOutfit( "Outfits", "Ancient Aucar", "Afflicted",
		{mount = 0, type = 912, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 911, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
		
	addOutfit( "Outfits", "Arena Champion", "Arena Champion",
		{mount = 0, type = 885, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 884, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Armoured Archer", "Armoured Archer",
		{mount = 0, type = 916, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 915, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Arodis", "Arodis",
		{mount = 0, type = 1229, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 1228, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Assassin", "Assassin",
		{mount = 0, type = 183, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 184, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Astral", "Astral",
		{mount = 0, type = 1219, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 1218, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Astral Earth", "Astral Earth",
		{mount = 0, type = 1215, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 1214, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Astral Electric", "Astral Electric",
		{mount = 0, type = 1217, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 1216, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Astral Ice", "Astral Ice",
		{mount = 0, type = 1211, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 1210, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Astral Fire", "Astral Fire",
		{mount = 0, type = 1213, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 1212, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Astro Skeleton Mage", "Astro Skeleton Mage",
		{mount = 0, type = 1207, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 1207, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Astro Skeleton Warrior", "Astro Skeleton Mage",
		{mount = 0, type = 1208, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 1208, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Battle mage", "Battle mage",
		{mount = 0, type = 998, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 997, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
		addOutfit( "Outfits", "Barbarian", "Barbarian",
		{mount = 0, type = 143, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 147, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Beastmaster", "Beastmaster",
		{mount = 0, type = 636, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 637, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
		
	addOutfit( "Outfits", "Beggar", "Beggar",
		{mount = 0, type = 187, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 188, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)

	addOutfit( "Outfits", "Blade Dancer", "Blade Dancer",
		{mount = 0, type = 1238, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 1237, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Brotherhood", "Brotherhood",
		{mount = 0, type = 278, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 279, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Cave Explorer", "Cave Explorer",
		{mount = 0, type = 575, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 574, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
		
	addOutfit( "Outfits", "Celestial Avenger", "Celestial Avenger",
		{mount = 0, type = 1188, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 1189, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	addOutfit( "Outfits", "Ceremonial Garb", "Ceremonial Garb",
		{mount = 0, type = 694, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 695, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	addOutfit( "Outfits", "Champion", "Champion",
		{mount = 0, type = 632, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 633, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Chaos Acolyte", "Chaos Acolyte",
		{mount = 0, type = 664, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 665, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Conjurer", "Conjurer",
		{mount = 0, type = 634, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 635, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Corruped Mage Man", "Corruped Mage Man",
		{mount = 0, type = 1224, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 1224, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Crystal Warlord", "Crystal Warlord",
		{mount = 0, type = 512, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 513, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Darklight Evoker", "Darklight Evoker",
		{mount = 0, type = 923, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 924, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Death Herald", "Death Herald",
		{mount = 0, type = 667, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 666, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Decaying Defender", "Decaying Defender",
		{mount = 0, type = 921, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 922, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Deepling", "Deepling",
		{mount = 0, type = 463, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 464, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Demon", "Demon",
		{mount = 0, type = 171, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 170, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Demon Hunter", "Demon Hunter",
		{mount = 0, type = 289, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 288, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Demon Outfit", "Demon Outfit",
		{mount = 0, type = 541, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 542, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Discoverer", "Discoverer",
		{mount = 0, type = 999, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 1000, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Doom Knight", "Doom Knight",
		{mount = 0, type = 1016, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 1017, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Dragon Slayer", "Dragon Slayer",
		{mount = 0, type = 259, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 260, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Dream Warden", "Dream Warden",
		{mount = 0, type = 577, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 578, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Druid", "Druid",
		{mount = 0, type = 144, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 144, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Elementalist", "Elementalist",
		{mount = 0, type = 432, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 433, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Embolwed Axe", "Embolwed Axe",
		{mount = 0, type = 1202, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 1202, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Embolwed Club", "Embolwed Club",
		{mount = 0, type = 1203, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 1203, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Embolwed Sword", "Embolwed Sword",
		{mount = 0, type = 1204, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 1204, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Entrepreneur", "Entrepreneur",
		{mount = 0, type = 472, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 471, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Eternal Mage", "Eternal Mage",
		{mount = 0, type = 917, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 918, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Everblight", "Everblight",
		{mount = 0, type = 974, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 973, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Evoker", "Evoker",
		{mount = 0, type = 725, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 724, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
		
	addOutfit( "Outfits", "Expert Archer", "Expert Archer",
		{mount = 0, type = 1200, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 1200, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
		
	addOutfit( "Outfits", "Flamefury Mage", "Flamefury Mage",
		{mount = 0, type = 925, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 926, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Frost Tracer", "Frost Tracer",
		{mount = 0, type = 913, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 914, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Glooth Engineer", "Glooth Engineer",
		{mount = 0, type = 610, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 618, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Golden", "Golden",
		{mount = 0, type = 1064, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 1065, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
		
	addOutfit( "Outfits", "Herald", "Herald",
		{mount = 0, type = 984, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 985, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Hand of Inquisition", "Hand of Inquisition",
		{mount = 0, type = 1014, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 1015, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Insectoid", "Insectoid",
		{mount = 0, type = 465, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 466, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Lupine Warden", "Lupine Warden",
		{mount = 0, type = 899, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 900, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Magical Druid", "Magical Druid",
		{mount = 0, type = 1199, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 1199, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Magical Sorcerer", "Magical Sorcerer",
		{mount = 0, type = 1201, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 1201, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "New Citizen", "New Citizen",
		{mount = 0, type = 162, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 163, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "New Druid", "New Druid",
		{mount = 0, type = 174, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 175, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "New Hunter", "New Hunter",
		{mount = 0, type = 164, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 165, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "New Mage", "New Mage",
		{mount = 0, type = 176, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 138, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "New Knight", "New Knight",
		{mount = 0, type = 181, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 182, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "New Warrior", "New Warrior",
		{mount = 0, type = 166, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 167, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "New Wizard", "New Wizard",
		{mount = 0, type = 178, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 179, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Newly Wed", "Newly Wed",
		{mount = 0, type = 328, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 329, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Nightmare", "Nightmare",
		{mount = 0, type = 268, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 269, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Norseman", "Norseman",
		{mount = 0, type = 185, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 186, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Old Mage", "Old Mage",
		{mount = 0, type = 172, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 172, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Old Man", "Old Man",
		{mount = 0, type = 180, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 180, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Outfit", "Outfit",
		{mount = 0, type = 266, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 265, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Oriental", "Oriental",
		{mount = 0, type = 146, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 150, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Philosopher", "Philosopher",
		{mount = 0, type = 873, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 874, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Pirate", "Pirate",
		{mount = 0, type = 151, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 155, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Poltergeist", "Poltergeist",
		{mount = 0, type = 1037, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 1038, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	addOutfit( "Outfits", "Princess of Lands", "Princess of Lands",
		{mount = 0, type = 1221, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 1220, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Puppeteer", "Puppeteer",
		{mount = 0, type = 697, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 696, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Ranger", "Ranger",
		{mount = 0, type = 684, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 683, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Recruiter", "Recruiter",
		{mount = 0, type = 746, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 745, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Retro Noblewoman", "Retro Noblewoman",
		{mount = 0, type = 132, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 140, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Revenant", "Revenant",
		{mount = 0, type = 1066, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 1067, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Rift Warrior", "Rift Warrior",
		{mount = 0, type = 846, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 845, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Royal Costume", "Royal Costume",
		{mount = 0, type = 263, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 264, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Royal Pumpkin", "Royal Pumpkin",
		{mount = 0, type = 760, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 759, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Seaweaver", "Seaweaver",
		{mount = 0, type = 733, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 732, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Sea Dog", "Sea Dog",
		{mount = 0, type = 750, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 749, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Shadowlotus Disciple", "Shadowlotus Disciple",
		{mount = 0, type = 909, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 910, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Shaman", "Shaman",
		{mount = 0, type = 189, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 190, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Skullhunter", "Skullhunter",
		{mount = 0, type = 1206, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 1205, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Small Angel", "Small Angel",
		{mount = 0, type = 972, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 971, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Soil Guardian", "Soil Guardian",
		{mount = 0, type = 516, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 514, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Spirit Caller", "Spirit Caller",
		{mount = 0, type = 699, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 698, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Summoner", "Summoner",
		{mount = 0, type = 133, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 141, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Warmaster", "Warmaster",
		{mount = 0, type = 335, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 336, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Warrior", "Warrior",
		{mount = 0, type = 134, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 142, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Wayfarer", "Wayfarer",
		{mount = 0, type = 367, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 366, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)
	
	addOutfit( "Outfits", "Winter Warden", "Winter Warden",
		{mount = 0, type = 853, addons = 3, head = 114, body = 114, legs = 114, feet = 114}, 
		{mount = 0, type = 852, addons = 3, head = 114, body = 114, legs = 114, feet = 114},
		25
	)

	
  --  addCategory("Mounts", "All add +10 Speed", "mount", 426)
	addMount("Mounts", "Armoured War Horse", "+10 Speed", 1, 426, 20);
	addMount("Mounts", "Astral Horse", "+10 Speed", 2, 1222, 20);
	addMount("Mounts", "Astro Corbak", "+10 Speed", 3, 1225, 20);
	addMount("Mounts", "Azudocus", "+10 Speed", 4, 621, 20);
	addMount("Mounts", "Batcat", "+10 Speed", 5, 728, 20);
	addMount("Mounts", "Blackpelt", "+10 Speed", 6, 651, 20);
	addMount("Mounts", "Black Sheep", "+10 Speed", 7, 371, 20);
	addMount("Mounts", "Black Stag", "+10 Speed", 8, 686, 20);
	addMount("Mounts", "Blazebringer", "+10 Speed", 9, 376, 20);
	addMount("Mounts", "Bloodcurl", "+10 Speed", 10, 869, 20);
	addMount("Mounts", "Bog Tyrant", "+10 Speed", 11, 1235, 20);
	addMount("Mounts", "Carpacosaurus", "+10 Speed", 12, 622, 20);
	addMount("Mounts", "Cinderhoof", "+10 Speed", 13, 851, 20);
	addMount("Mounts", "Copper Fly", "+10 Speed", 14, 671, 20);
	addMount("Mounts", "Coralripper", "+10 Speed", 15, 735, 20);
	addMount("Mounts", "Corpsefire Skull", "+10 Speed", 16, 931, 20);
	addMount("Mounts", "Crimson Fang", "+10 Speed", 17, 1236, 20);
	addMount("Mounts", "Crimson Ray", "+10 Speed", 18, 521, 20);
	addMount("Mounts", "Crystal Wolf", "+10 Speed", 19, 390, 20);
	addMount("Mounts", "Darklight Devourer", "+10 Speed", 20, 927, 20);
	addMount("Mounts", "Dawnbringer Pegasus", "+10 Speed", 21, 1190, 20);
	addMount("Mounts", "Death Crawler", "+10 Speed", 22, 624, 20);
	addMount("Mounts", "Desert King", "+10 Speed", 23, 572, 20);
	addMount("Mounts", "Doombringer", "+10 Speed", 24, 644, 20);
	addMount("Mounts", "Doom Skull", "+10 Speed", 25, 929, 20);
	addMount("Mounts", "Donkey", "+10 Speed", 26, 387, 20);
	addMount("Mounts", "Dragonling", "+10 Speed", 27, 506, 20);
	addMount("Mounts", "Draptor", "+10 Speed", 28, 373, 20);
	addMount("Mounts", "Dromedary", "+10 Speed", 29, 405, 20);
	addMount("Mounts", "Emerald Waccoon", "+10 Speed", 30, 693, 20);
	addMount("Mounts", "Emperor Deer", "+10 Speed", 31, 687, 20);
	addMount("Mounts", "Flamesteed", "+10 Speed", 32, 626, 20);
	addMount("Mounts", "Fleeting Knowledge", "+10 Speed", 33, 996, 20);
	addMount("Mounts", "Flitterkatzen", "+10 Speed", 34, 726, 20);
	addMount("Mounts", "Floating Kashmir", "+10 Speed", 35, 690, 20);
	addMount("Mounts", "Flying Divan", "+10 Speed", 36, 688, 20);
	addMount("Mounts", "Foxmouse", "+10 Speed", 37, 1076, 20);
	addMount("Mounts", "Frostflare", "+10 Speed", 38, 850, 20);
	addMount("Mounts", "Glacier Vagabond", "+10 Speed", 39, 674, 20);
	addMount("Mounts", "Glacier Wyrm", "+10 Speed", 40, 1234, 20);
	addMount("Mounts", "Glooth Glider", "+10 Speed", 41, 682, 20);
	addMount("Mounts", "Gnarlhound", "+10 Speed", 42, 515, 20);
	addMount("Mounts", "Golden Dragonfly", "+10 Speed", 43, 669, 20);
	addMount("Mounts", "Gorongra", "+10 Speed", 44, 738, 20);
	addMount("Mounts", "Gryphon", "+10 Speed", 45, 1030, 20);
	addMount("Mounts", "Hailstorm Fury", "+10 Speed", 46, 648, 20);
	addMount("Mounts", "Haze", "+10 Speed", 47, 1036, 20);
	addMount("Mounts", "Highland Yak", "+10 Speed", 48, 673, 20);
	addMount("Mounts", "Ironblight", "+10 Speed", 49, 502, 20);
	addMount("Mounts", "Ivory Fang", "+10 Speed", 50, 901, 20);
	addMount("Mounts", "Jade Lion", "+10 Speed", 51, 627, 20);
	addMount("Mounts", "Jade Pincer", "+10 Speed", 52, 628, 20);
	addMount("Mounts", "Kingly Deer", "+10 Speed", 53, 401, 20);
	addMount("Mounts", "Lady Bug", "+10 Speed", 54, 447, 20);
	addMount("Mounts", "Leafscuttler", "+10 Speed", 55, 870, 20);
	addMount("Mounts", "Magic Carpet", "+10 Speed", 56, 689, 20);
	addMount("Mounts", "Magma Crawler", "+10 Speed", 57, 503, 20);
	addMount("Mounts", "Magma Skull", "+10 Speed", 58, 930, 20);
	addMount("Mounts", "Manta Ray", "+10 Speed", 59, 450, 20);
	addMount("Mounts", "Midnight Panther", "+10 Speed", 60, 372, 20);
	addMount("Mounts", "Mouldpincer", "+10 Speed", 61, 868, 20);
	addMount("Mounts", "Mould Shell", "+10 Speed", 62, 887, 20);
	addMount("Mounts", "Nethersteed", "+10 Speed", 63, 629, 20);
	addMount("Mounts", "Neon Sparkid", "+10 Speed", 64, 889, 20);
	addMount("Mounts", "Nightstinger", "+10 Speed", 65, 762, 20);
	addMount("Mounts", "Nightdweller", "+10 Speed", 66, 849, 20);
	addMount("Mounts", "Night Waccoon", "+10 Speed", 67, 692, 20);
	addMount("Mounts", "Noble Lion", "+10 Speed", 68, 571, 20);
	addMount("Mounts", "Noctungra", "+10 Speed", 69, 739, 20);
	addMount("Mounts", "Phantasmal Jade", "+10 Speed", 70, 1063, 20);
	addMount("Mounts", "Platesaurian", "+10 Speed", 71, 547, 20);
	addMount("Mounts", "Plumfish", "+10 Speed", 72, 736, 20);
	addMount("Mounts", "Poisonbane", "+10 Speed", 73, 650, 20);
	addMount("Mounts", "Racing Bird", "+10 Speed", 74, 369, 20);
	addMount("Mounts", "Rapid Boar", "+10 Speed", 75, 377, 20);
	addMount("Mounts", "Razorcreep", "+10 Speed", 76, 763, 20);
	addMount("Mounts", "Reed Lurker", "+10 Speed", 77, 888, 20);
	addMount("Mounts", "Rift Runner", "+10 Speed", 78, 848, 20);
	addMount("Mounts", "Ringtail Waccoon", "+10 Speed", 79, 691, 20);
	addMount("Mounts", "Rented Horse", "+10 Speed", 80, 437, 20);
	addMount("Mounts", "Rented Horse", "+10 Speed", 81, 438, 20);
	addMount("Mounts", "Rented Horse", "+10 Speed", 82, 421, 20);
	addMount("Mounts", "Scorpion King", "+10 Speed", 83, 406, 20);
	addMount("Mounts", "Sea Devil", "+10 Speed", 84, 734, 20);
	addMount("Mounts", "Shadow Claw", "+10 Speed", 85, 902, 20);
	addMount("Mounts", "Shadow Draptor", "+10 Speed", 86, 427, 20);
	addMount("Mounts", "Shadow Hart", "+10 Speed", 87, 685, 20);
	addMount("Mounts", "Shock Head", "+10 Speed", 88, 580, 20);
	addMount("Mounts", "Siegebreaker", "+10 Speed", 89, 649, 20);
	addMount("Mounts", "Silverneck", "+10 Speed", 90, 740, 20);
	addMount("Mounts", "Skybreaker Pegasus", "+10 Speed", 91, 1191, 20);
	addMount("Mounts", "Slagsnare", "+10 Speed", 92, 761, 20);
	addMount("Mounts", "Snow Pelt", "+10 Speed", 93, 903, 20);
	addMount("Mounts", "Sparkion", "+10 Speed", 94, 883, 20);
	addMount("Mounts", "Spirit of Purity", "+10 Speed", 95, 928, 20);
	addMount("Mounts", "Stampor", "+10 Speed", 96, 378, 20);
	addMount("Mounts", "Steel Bee", "+10 Speed", 97, 670, 20);
	addMount("Mounts", "Steelbeak", "+10 Speed", 98, 522, 20);
	addMount("Mounts", "Swamp Snapper", "+10 Speed", 99, 886, 20);
	addMount("Mounts", "Tamed Panda", "+10 Speed", 100, 402, 20);
	addMount("Mounts", "Tempest", "+10 Speed", 101, 630, 20);
	addMount("Mounts", "The Hellgrip", "+10 Speed", 102, 559, 20);
	addMount("Mounts", "Tiger Slug", "+10 Speed", 103, 388, 20);
	addMount("Mounts", "Tin Lizzard", "+10 Speed", 104, 375, 20);
	addMount("Mounts", "Titanica", "+10 Speed", 105, 374, 20);
	addMount("Mounts", "Tundra Rambler", "+10 Speed", 106, 672, 20);
	addMount("Mounts", "Tombstinger", "+10 Speed", 107, 546, 20);
	addMount("Mounts", "Undead Cavebear", "+10 Speed", 108, 379, 20);
	addMount("Mounts", "Uniwheel", "+10 Speed", 109, 389, 20);
	addMount("Mounts", "Ursagrodon", "+10 Speed", 110, 548, 20);
	addMount("Mounts", "Venompaw", "+10 Speed", 111, 727, 20);
	addMount("Mounts", "Vortexion", "+10 Speed", 112, 890, 20);
	addMount("Mounts", "Walker", "+10 Speed", 113, 606, 20);
	addMount("Mounts", "War Bear", "+10 Speed", 114, 370, 20);
	addMount("Mounts", "War Horse", "+10 Speed", 115, 392, 20);
	addMount("Mounts", "Water Buffalo", "+10 Speed", 116, 526, 20);
	addMount("Mounts", "White Lion", "+10 Speed", 117, 1062, 20);
	addMount("Mounts", "Widow Queen", "+10 Speed", 118, 368, 20);
	addMount("Mounts", "Winter King", "+10 Speed", 119, 631, 20);
	addMount("Mounts", "Woodland Prince", "+10 Speed", 120, 647, 20);
	addMount("Mounts", "Wrathfire Pegasus", "+10 Speed", 121, 1192, 20);

    addCategory("Auras", "Shiny and bright", "Shiny and bright", 427)
	addAura("Auras", "Bats", "Bats", 1, 936, 20);
	addAura("Auras", "Electric Shock", "Electric Shock", 2, 933, 20);
	addAura("Auras", "Fireflies", "Fireflies", 3, 935, 20);
    addAura("Auras", "Fire Essence", "Fire Essence", 4, 932, 20);
	addAura("Auras", "Star Shine", "Star Shine", 5, 934, 20);
    
  --  addCategory("Wings", "Fly high with +10 of Speed", "wing", 937)
	addWing("Wings", "Angelic Wings", "a wing with +10 of Speed", 1, 1180, 20);
	addWing("Wings", "Bark Wings", "a wing with +10 of Speed", 2, 941, 20);
	addWing("Wings", "Bride Wings", "a wing with +10 of Speed", 3, 1185, 20);
	addWing("Wings", "Butterfly Wings", "a wing with +10 of Speed", 4, 1182, 20);
	addWing("Wings", "Dreadbone Spectre", "a wing with +10 of Speed", 5, 1183, 20);
	addWing("Wings", "Eletric Rider", "a wing with +10 of Speed", 6, 1177, 20);
	addWing("Wings", "Enslaved Wings", "a wing with +10 of Speed", 7, 1184, 20);
	addWing("Wings", "Falanaar Wings", "a wing with +10 of Speed", 8, 939, 20);
	addWing("Wings", "Fiery Wings", "a wing with +10 of Speed", 9, 937, 20);
	addWing("Wings", "Lullaby Wings", "a wing with +10 of Speed", 10, 938, 20);
	addWing("Wings", "Mortis Mirage", "a wing with +10 of Speed", 11, 1179, 20);
	addWing("Wings", "Nimbus Wings", "a wing with +10 of Speed", 12, 1181, 20);
	addWing("Wings", "Strenght Wings", "a wing with +10 of Speed", 13, 1186, 20);
	addWing("Wings", "Vampire Wings", "a wing with +10 of Speed", 14, 940, 20);
	addWing("Wings", "Voronor Flames", "a wing with +10 of Speed", 15, 1178, 20);
	addWing("Wings", "Cosmic Wings", "a wing with +10 of Speed", 16, 1239, 20);
	addWing("Wings", "Phantasmal Wings", "a wing with +10 of Speed", 17, 1240, 20);
	addWing("Wings", "Red Shard", "a wing with +10 of Speed", 18, 1242, 20);
	addWing("Wings", "Purple Shard", "a wing with +10 of Speed", 19, 1243, 20);
	addWing("Wings", "Green Shard", "a wing with +10 of Speed", 20, 1244, 20);
	addWing("Wings", "Lite Blue Shard", "a wing with +10 of Speed", 21, 1245, 20);
	addWing("Wings", "Whited wings", "a wing with +10 of Speed", 22, 1249, 20);
	addWing("Wings", "27", "a wing with +10 of Speed", 23, 1250, 20);
	addWing("Wings", "Dollar Wings", "a wing with +10 of Speed", 24, 1251, 20);
	addWing("Wings", "29", "a wing with +10 of Speed", 25, 1252, 20);
	addWing("Wings", "30", "a wing with +10 of Speed", 26, 1253, 20);
	addWing("Wings", "31", "a wing with +10 of Speed", 27, 1254, 20);
	addWing("Wings", "34", "a wing with +10 of Speed", 28, 1257, 20);
	addWing("Wings", "37", "a wing with +10 of Speed", 29, 1259, 20);
	addWing("Wings", "36", "a wing with +10 of Speed", 30, 1260, 20);
	addWing("Wings", "Rainbow Wings", "a wing with +10 of Speed", 31, 1261, 20);
	addWing("Wings", "39", "a wing with +10 of Speed", 32, 1262, 20);
	addWing("Wings", "40", "a wing with +10 of Speed", 33, 1263, 20);

    
   -- addCategory("Shaders", "Add magical effects to your outfit", "shader", 937)
    addShader("Shaders", "Rainbow Shader", "Gives a rainbow effect to your outfit.", 1, "outfit_rainbow", 25);
	addShader("Shaders", "Heat Shader", "Shader", 2, "outfit_heat", 25);
	addShader("Shaders", "Party Shader", "Shader", 3, "outfit_party", 25);
	addShader("Shaders", "Light Blue", "Shader", 4, "ShaderLightBlue", 25);
	addShader("Shaders", "Blue", "Shader", 5, "ShaderBlue", 25);
	addShader("Shaders", "Red", "Shader", 6, "ShaderRed", 25);
	addShader("Shaders", "Dark Red", "Shader", 7, "ShaderDarkRed", 25);
	addShader("Shaders", "Purple", "Shader", 8, "ShaderPurple", 25);
	addShader("Shaders", "White", "Shader", 9, "ShaderWhite", 25);
	addShader("Shaders", "Light Blue Static", "Shader", 10, "ShaderLightBlueStatic", 25);
	addShader("Shaders", "Blue Static", "Shader", 11, "ShaderBlueStatic", 25);
	addShader("Shaders", "Red Static", "Shader", 12, "ShaderRedStatic", 25);
	addShader("Shaders", "Dark Red Static", "Shader", 13, "ShaderDarkRedStatic", 25);
	addShader("Shaders", "Purple Static", "Shader", 14, "ShaderPurpleStatic", 25);
	addShader("Shaders", "White Static", "Shader", 15, "ShaderWhiteStatic", 25);
	addShader("Shaders", "Rage", "Shader", 16, "ShaderRage", 25);
	addShader("Shaders", "Freeze", "Shader", 17, "ShaderFreeze", 25);
	addShader("Shaders", "Green", "Shader", 18, "ShaderGreen", 25);
	addShader("Shaders", "Green Static", "Shader", 19, "ShaderGreenStatic", 25);
	addShader("Shaders", "Yellow", "Shader", 20, "ShaderYellow", 25);
	addShader("Shaders", "Yellow Stetic", "Shader", 21, "ShaderYellowStatic", 25);
	addShader("Shaders", "Creature Highlight", "Shader", 22, "ShaderCreatureHighlight", 25);
	addShader("Shaders", "3Line", "Shader", 23, "Outfit_3line", 25);
	addShader("Shaders", "Circle", "Shader", 24, "Outfit_circle", 25);
	addShader("Shaders", "Line", "Shader", 25, "Outfit_Line", 25);
	addShader("Shaders", "Outline", "Shader", 26, "Outfit_Outline", 25);
	addShader("Shaders", "Shimering", "Shader", 27, "Outfit_Shimmering", 25);
	addShader("Shaders", "Shine", "Shader", 28, "Outfit_Shine", 25);
	addShader("Shaders", "Brazil", "Shader", 29, "Outfit_brazil", 25);
	addShader("Shaders", "Gold", "Shader", 30, "Outfit_Gold", 25);
	addShader("Shaders", "Stars", "Shader", 31, "Outfit_Stars", 25);
	addShader("Shaders", "Blood", "Shader", 32, "Outfit_blood", 25);
	addShader("Shaders", "Camouflage", "Shader", 33, "Outfit_camouflage", 25);
	addShader("Shaders", "Flash", "Shader", 34, "Outfit_Flash", 25);
	addShader("Shaders", "Glitch", "Shader", 35, "Outfit_Glitch", 25);
	addShader("Shaders", "Ice", "Shader", 36, "Outfit_Ice", 25);
	addShader("Shaders", "Purpleneon", "Shader", 37, "Outfit_Purpleneon", 25);
	addShader("Shaders", "Cosmos", "Shader", 38, "Outfit_Cosmos", 25);
	addShader("Shaders", "Purplesky", "Shader", 39, "Outfit_Purplesky", 25);
	addShader("Shaders", "Static", "Shader", 40, "Outfit_Static", 25);
	addShader("Shaders", "Sun", "Shader", 41, "Outfit_Sun", 25);
	addShader("Shaders", "Red", "Shader", 42, "outfit_red", 25);
	addShader("Shaders", "Blue", "Shader", 43, "outfit_blue", 25);
	addShader("Shaders", "Green", "Shader", 44, "outfit_green", 25);
	addShader("Shaders", "Purple", "Shader", 45, "outfit_purple", 25);
	addShader("Shaders", "Yellow", "Shader", 46, "outfit_yellow", 25);
	addShader("Shaders", "Gray", "Shader", 47, "outfit_gray", 25);
	addShader("Shaders", "Black", "Shader", 48, "outfit_black", 25);
	addShader("Shaders", "White", "Shader", 49, "outfit_white", 25);
	addShader("Shaders", "Fiends", "Shader", 51, "poke_friends", 25);
	addShader("Shaders", "Circle White", "Shader", 52, "outfit_circle_white", 25);
	addShader("Shaders", "Circle Red", "Shader", 53, "outfit_circle_red", 25);
	
    
    -- addCategory("Withdraw", "Convert your premium points to items.", "item", 2160)
    -- addCustom("Withdraw", "withdraw", "Withdraw Premium Points", "Withdraw premium points and receive crystal coins.", {}, 1, 0, withdrawCallback)
end

local ExtendedEvent = CreatureEvent("GameStoreExtended")

function ExtendedEvent.onExtendedOpcode(player, opcode, buffer)
    if opcode == CODE_GAMESTORE then
        if not GAME_STORE then
            gameStoreInitialize()
            addEvent(refreshPlayersPoints, 10 * 1000)
        end

        local status, json_data = pcall(function() return json.decode(buffer) end)
        if not status then return end

        local action = json_data.action
        local data = json_data.data
        if not action or not data then return end

        if action == "fetch" then
            gameStoreFetch(player)
        elseif action == "purchase" then
            gameStorePurchase(player, data)
        elseif action == "gift" then
            gameStorePurchaseGift(player, data)
        elseif action == "withdraw" then
            handleWithdraw(player, data.amount)
        end
    end
end

function handleWithdraw(player, amount)
    local points = getPoints(player)
    if amount > points then
        return errorMsg(player, "You don't have enough premium points to withdraw that amount.")
    end

    local weight = ItemType(2160):getWeight(amount)
    if player:getFreeCapacity() < weight then
        return errorMsg(player, "This item is too heavy for you!")
    end

    local backpack = player:getSlotItem(CONST_SLOT_BACKPACK)
    if not backpack or backpack:getEmptySlots(true) <= 0 then
        return errorMsg(player, "You don't have enough space in your backpack.")
    end

    if player:addItem(28160, amount, false) then
        db.query("UPDATE accounts SET premium_points = premium_points - " .. amount .. " WHERE id = " .. player:getAccountId())
        gameStoreUpdatePoints(player)
        return infoMsg(player, "You've successfully withdrawn " .. amount .. " premium points!")
    else
        return errorMsg(player, "Something went wrong, items couldn't be added.")
    end
end



function gameStoreFetch(player)
    local sex = player:getSex()

    player:sendExtendedOpcode(CODE_GAMESTORE, json.encode({action = "fetchBase", data = {categories = GAME_STORE.categories, url = DONATION_URL}}))

    for category, offersTable in pairs(GAME_STORE.offers) do
        local offers = {}
        local chunkSize = 20 -- Número de ofertas por pacote
        local totalOffers = #offersTable

        -- Enviar comando para limpar ofertas da categoria no cliente
        player:sendExtendedOpcode(CODE_GAMESTORE, json.encode({action = "clearOffers", data = {category = category}}))

        for i = 1, totalOffers, chunkSize do
            offers = {}
            for j = i, math.min(i + chunkSize - 1, totalOffers) do
                local offer = offersTable[j]
                local data = {
                    type = offer.type,
                    title = offer.title,
                    description = offer.description,
                    price = offer.price
                }

                if offer.count then
                    data.count = offer.count
                end
                if offer.clientId then
                    data.clientId = offer.clientId
                end
                if offer.shaderName then
                    data.shaderName = offer.shaderName
                end
                if sex == PLAYERSEX_MALE then
                    if offer.outfitMale then
                        data.outfit = offer.outfitMale
                    end
                else
                    if offer.outfitFemale then
                        data.outfit = offer.outfitFemale
                    end
                end
                if offer.data then
                    data.data = offer.data
                end
                table.insert(offers, data)
            end
            player:sendExtendedOpcode(CODE_GAMESTORE, json.encode({action = "fetchOffers", data = {category = category, offers = offers}}))
        end
    end

    gameStoreUpdatePoints(player)
    gameStoreUpdateHistory(player)
end




function gameStoreUpdatePoints(player)
    if type(player) == "number" then
        player = Player(player)
    end
    player:sendExtendedOpcode(CODE_GAMESTORE, json.encode({action = "points", data = getPoints(player)}))
end

function gameStoreUpdateHistory(player)
    if type(player) == "number" then
        player = Player(player)
    end
    local history = {}
    local resultId = db.storeQuery("SELECT * FROM shop_history WHERE account = " .. player:getAccountId() .. " order by id DESC")

    if resultId ~= false then
        repeat
            local desc = "Bought " .. result.getDataString(resultId, "title")
            local count = result.getDataInt(resultId, "count")
            if count > 0 then
                desc = desc .. " (x" .. count .. ")"
            end
            local target = result.getDataString(resultId, "target")
            if target ~= "" then
                desc = desc .. " on " .. result.getDataString(resultId, "date") .. " for " .. target .. " for " .. result.getDataInt(resultId, "price") .. " points."
            else
                desc = desc .. " on " .. result.getDataString(resultId, "date") .. " for " .. result.getDataInt(resultId, "price") .. " points."
            end
            table.insert(history, desc)
        until not result.next(resultId)
        result.free(resultId)
    end
    player:sendExtendedOpcode(CODE_GAMESTORE, json.encode({action = "history", data = history}))
end

function gameStorePurchase(player, offer)
    local offers = GAME_STORE.offers[offer.category]
    if not offers then
        return errorMsg(player, "Something went wrong, try again or contact server admin [#1]!")
    end
    for i = 1, #offers do
        if offers[i].title == offer.title and offers[i].price == offer.price then
            local callback = offers[i].callback
            if not callback then
                return errorMsg(player, "Something went wrong, try again or contact server admin [#2]!")
            end

            local points = getPoints(player)
            if offers[i].price > points then
                return errorMsg(player, "You don't have enough points!")
            end

            -- print("Executing callback for player:", player:getName(), "Offer:", offer.title)
            local status = callback(player, offers[i])
            if status ~= true then
                return errorMsg(player, status)
            end

            local aid = player:getAccountId()
            local escapeTitle = db.escapeString(offers[i].title)
            local escapePrice = db.escapeString(offers[i].price)
            local escapeCount = offers[i].count and db.escapeString(offers[i].count) or 0

            db.query("UPDATE accounts set premium_points = premium_points - " .. offers[i].price .. " WHERE id = " .. aid)
            db.asyncQuery(
                "INSERT INTO shop_history VALUES (NULL, '" ..
                    aid .. "', '" .. player:getGuid() .. "', NOW(), " .. escapeTitle .. ", " .. escapePrice .. ", " .. escapeCount .. ", NULL)"
            )
            addEvent(gameStoreUpdateHistory, 1000, player:getId())
            addEvent(gameStoreUpdatePoints, 1000, player:getId())
            return infoMsg(player, "You've bought " .. offers[i].title .. "!", true)
        end
    end
    return errorMsg(player, "Something went wrong, try again or contact server admin [#4]!")
end

function gameStorePurchaseGift(player, offer)
    local offers = GAME_STORE.offers[offer.category]
    if not offers then
        return errorMsg(player, "Something went wrong, try again or contact server admin [#1]!")
    end
    if not offer.target then
        return errorMsg(player, "Target player not found!")
    end
    for i = 1, #offers do
        if offers[i].title == offer.title and offers[i].price == offer.price then
            local callback = offers[i].callback
            if not callback then
                return errorMsg(player, "Something went wrong, try again or contact server admin [#2]!")
            end

            local points = getPoints(player)
            if offers[i].price > points then
                return errorMsg(player, "You don't have enough points!")
            end

            local targetPlayer = Player(offer.target)
            if not targetPlayer then
                return errorMsg(player, "Target player not found!")
            end

            local status = callback(targetPlayer, offers[i])
            if status ~= true then
                return errorMsg(player, status)
            end

            local aid = player:getAccountId()
            local escapeTitle = db.escapeString(offers[i].title)
            local escapePrice = db.escapeString(offers[i].price)
            local escapeCount = offers[i].count and db.escapeString(offers[i].count) or 0
            local escapeTarget = db.escapeString(targetPlayer:getName())
            db.query("UPDATE accounts set premium_points = premium_points - " .. offers[i].price .. " WHERE id = " .. aid)
            db.asyncQuery(
                "INSERT INTO shop_history VALUES (NULL, '" ..
                    aid .. "', '" .. player:getGuid() .. "', NOW(), " .. escapeTitle .. ", " .. escapePrice .. ", " .. escapeCount .. ", " .. escapeTarget .. ")"
            )
            addEvent(gameStoreUpdateHistory, 1000, player:getId())
            addEvent(gameStoreUpdatePoints, 1000, player:getId())
            return infoMsg(player, "You've bought " .. offers[i].title .. " for " .. targetPlayer:getName() .. "!", true)
        end
    end
    return errorMsg(player, "Something went wrong, try again or contact server admin [#4]!")
end

function getPoints(player)
    local points = 0
    local resultId = db.storeQuery("SELECT premium_points FROM accounts WHERE id = " .. player:getAccountId())
    if resultId ~= false then
        points = result.getDataInt(resultId, "premium_points")
        result.free(resultId)
    end
    return points
end

function errorMsg(player, msg)
    player:sendExtendedOpcode(CODE_GAMESTORE, json.encode({action = "msg", data = {type = "error", msg = msg}}))
end

function infoMsg(player, msg, close)
    if not close then
        close = false
    end
    player:sendExtendedOpcode(CODE_GAMESTORE, json.encode({action = "msg", data = {type = "info", msg = msg, close = close}}))
end

function addCategory(title, description, iconType, iconData)
    if iconType == "item" then
        iconData = ItemType(iconData):getClientId()
    end

    table.insert(
        GAME_STORE.categories,
        {
            title = title,
            description = description,
            iconType = iconType,
            iconData = iconData
        }
    )
end

function addItem(category, title, description, itemId, count, price, callback)
    if not GAME_STORE.offers[category] then
        GAME_STORE.offers[category] = {}
    end

    if not callback then
        callback = defaultItemCallback
    end

    table.insert(
        GAME_STORE.offers[category],
        {
            type = "item",
            title = title,
            description = description,
            itemId = itemId,
            count = count,
            price = price,
            clientId = ItemType(itemId):getClientId(),
            callback = callback
        }
    )
end

function addOutfit(category, title, description, outfitMale, outfitFemale, price, callback)
    if not GAME_STORE.offers[category] then
        GAME_STORE.offers[category] = {}
    end

    if not callback then
        callback = defaultOutfitCallback
    end

    table.insert(
        GAME_STORE.offers[category],
        {
            type = "outfit",
            title = title,
            description = description,
            outfitMale = outfitMale,
            outfitFemale = outfitFemale,
            price = price,
            callback = callback
        }
    )
end

function addMount(category, title, description, mountId, clientId, price, callback)
    if not GAME_STORE.offers[category] then
        GAME_STORE.offers[category] = {}
    end

    if not callback then
        callback = defaultMountCallback
    end

    table.insert(
        GAME_STORE.offers[category],
        {
            type = "mount",
            title = title,
            description = description,
            mount = mountId,
            clientId = clientId,
            price = price,
            callback = callback
        }
    )
end

function addWing(category, title, description, wingId, clientId, price, callback)
    if not GAME_STORE.offers[category] then
        GAME_STORE.offers[category] = {}
    end

    if not callback then
        callback = defaultWingsCallback
    end

    table.insert(
        GAME_STORE.offers[category],
            {
            type = "wing",
            title = title,
            description = description,
            wing = wingId,
            clientId = clientId,
            price = price,
            callback = callback
        }
    )
end

function addAura(category, title, description, auraId, clientId, price, callback)
    if not GAME_STORE.offers[category] then
        GAME_STORE.offers[category] = {}
    end

    if not callback then
        callback = defaultAurasCallback
    end

    table.insert(
        GAME_STORE.offers[category],
        {
            type = "aura",
            title = title,
            description = description,
            aura = auraId,
            clientId = clientId,
            price = price,
            callback = callback
        }
    )
end

function addShader(category, title, description, shaderId, shaderName, price, callback)
    if not GAME_STORE.offers[category] then
        GAME_STORE.offers[category] = {}
    end

    if not callback then
        callback = defaultShadersCallback
    end

    table.insert(
        GAME_STORE.offers[category],
        {
            type = "shader",
            title = title,
            description = description,
            shader = shaderId,
            shaderName = shaderName,
            price = price,
            callback = callback
        }
    )
end

function addCustom(category, type, title, description, data, count, price, callback)
    if not GAME_STORE.offers[category] then
        GAME_STORE.offers[category] = {}
    end

    if not callback then
        error("[Game Store] addCustom " .. title .. " without callback")
        return
    end

    table.insert(
        GAME_STORE.offers[category],
        {
            type = type,
            title = title,
            description = description,
            data = data,
            price = price,
            count = count,
            callback = callback
        }
    )
end

function defaultItemCallback(player, offer)
    local weight = ItemType(offer.itemId):getWeight(offer.count)
    if player:getFreeCapacity() < weight then
        return "This item is too heavy for you!"
    end

    local item = player:getSlotItem(CONST_SLOT_BACKPACK)
    if not item then
        return "You don't have enough space in backpack."
    end
    local slots = item:getEmptySlots(true)
    if slots <= 0 then
        return "You don't have enough space in backpack."
    end

    if player:addItem(offer.itemId, offer.count, false) then
        return true
    end

    return "Something went wrong, item couldn't be added."
end

function defaultOutfitCallback(player, offer)
    if offer.outfitMale.addons > 0 then
        if player:hasOutfit(offer.outfitMale.type, offer.outfitMale.addons) then
            return "You already have this outfit with addons."
        end

        player:addOutfitAddon(offer.outfitMale.type, offer.outfitMale.addons)
    else
        if player:hasOutfit(offer.outfitMale.type) then
            return "You already have this outfit."
        end

        player:addOutfit(offer.outfitMale.type)
    end
    if offer.outfitFemale.addons > 0 then
        player:addOutfitAddon(offer.outfitFemale.type, offer.outfitFemale.addons)
    else
        player:addOutfit(offer.outfitFemale.type)
    end
    return true
end

function defaultMountCallback(player, offer)
    if player:hasMount(offer.mount) then
        return "You already have this mount."
    end

    player:addMount(offer.mount)
    return true
end

function defaultWingsCallback(player, offer)
    if player:hasWing(offer.wing) then
        return "You already have this wing."
    end

    player:addWings(offer.wing)
    return true
end

function defaultAurasCallback(player, offer)
    if player:hasAura(offer.aura) then
        return "You already have this aura."
    end

    player:addAura(offer.aura)
    return true
end

function defaultShadersCallback(player, offer)
    if player:hasShader(offer.shaderName) then
        return "You already have this shader."
    end

    local success = player:addShader(offer.shaderName)
    if success then
        return true
    else
        return "Failed to add shader."
    end
end

function withdrawCallback(player, offer)
    local points = getPoints(player)
    if points <= 0 then
        return "You don't have any premium points to withdraw!"
    end

    local itemCount = points
    local weight = ItemType(2160):getWeight(itemCount)
    if player:getFreeCapacity() < weight then
        return "This item is too heavy for you!"
    end

    local item = player:getSlotItem(CONST_SLOT_BACKPACK)
    if not item then
        return "You don't have enough space in backpack."
    end
    local slots = item:getEmptySlots(true)
    if slots <= 0 then
        return "You don't have enough space in backpack."
    end

    if player:addItem(2160, itemCount, false) then
        db.query("UPDATE accounts SET premium_points = 0 WHERE id = " .. player:getAccountId())
        return true
    end

    return "Something went wrong, items couldn't be added."
end

function refreshPlayersPoints()
    for _, p in ipairs(Game.getPlayers()) do
        if p:getIp() > 0 then
            gameStoreUpdatePoints(p)
        end
    end
    addEvent(refreshPlayersPoints, 10 * 1000)
end

LoginEvent:type("login")
LoginEvent:register()
ExtendedEvent:type("extendedopcode")
ExtendedEvent:register()
