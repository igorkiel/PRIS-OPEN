--[[
Reserved storage ranges:
- 300000 to 301000+ reserved for achievements
- 20000 to 21000+ reserved for achievement progress
- 10000000 to 20000000 reserved for outfits and mounts on source
]]--
PlayerStorageKeys = {
	annihilatorReward = 30015,
	promotion = 30018,
	delayLargeSeaShell = 30019,
	firstRod = 30020,
	delayWallMirror = 30021,
	madSheepSummon = 30023,
	crateUsable = 30024,
	afflictedOutfit = 30026,
	afflictedPlagueMask = 30027,
	afflictedPlagueBell = 30028,
	nailCaseUseCount = 30031,
	swampDigging = 30032,
	insectoidCell = 30033,
	vortexTamer = 30034,
	mutatedPumpkin = 30035,
	achievementsBase = 300000,
	achievementsCounter = 20000,
	bestiaryKillsBase = 400000,
	characterStatsPoints = 803210, 
  	characterStatsLevel = 803211,
	dungeonsDifficulty = 86597,
	challengeComplete = 86641, -- 86641 - 87000 reserved (359 challenges limit)
	challengeProgress = 87001, -- 87001 - 87360 reserved (359)
	challengePoints = 87360,
	
}


GlobalStorageKeys = {
}

Storage = {
	exploringKindernia = 30044,
	exploreAroundKindernia = 30045,
	exploreKinderniaVillage = 30046,
	exploreChainQuestKindernia = 30047,
	AzureGates = 30048,
	NpcSpawn = 30049,
}

Jobs = {
	Mining = {
		SmallBronzeIngot = 73800,
		SmallSilverIngot = 73801,
		SmallSapphireIngot = 73802,
		SmallGoldIngot = 73803,
		SmallAmethystIngot = 73804,
		SmallRubyIngot = 73805,
		SmallEmeraldIngot = 73806,
		BigBronzeIngot = 73807,
		BigSilverIngot = 73808,
		BigSapphireIngot = 73809,
		BigGoldIngot = 73810,
		BigAmethystIngot = 73811,
		BigRubyIngot = 73812,
		BigEmeraldIngot = 73813,
	},
	Woodcutting = {
		BigPieceOfWood = 73814,
		AshPlank = 73815,
		ChestnutPlank = 73816,
		OlivePlank = 73817,
		CherryPlank = 73818
	},
	Herbalist = {
		NimbleLifePotion = 73819,
		HazelLifePotion = 73820,
		TumbleLifePotion = 73821,
		NimbleManaPotion = 73822,
		HazelManaPotion = 73823,
		TumbleManaPotion = 73824
	}
}

DeckSystem = {
	Cards = {
		CommonErasmo = 37000,
		RareErasmo = 37001,
		EpicErasmo = 37002,
		MythicErasmo = 37003,
		CommonDemetar = 37004,
		RareDemetar = 37005,
		EpicDemetar = 37006,
		MythicDemetar = 37007,
		CommonKaishuter = 37008,
		RareKaishuter = 37009,
		EpicKaishuter = 37010,
		MythicKaishuter = 37011,
		CommonEnragedChuo = 37012,
		RareEnragedChuo = 37013,
		EpicEnragedChuo = 37014,
		MythicEnragedChuo = 37015,
		CommonZaika = 37016,
		RareZaika = 37017,
		EpicZaika = 37018,
		MythicZaika = 37019,
		CommonRictus = 37020,
		RareRictus = 37021,
		EpicRictus = 37022,
		MythicRictus = 37023,
		CommonGlobus = 37024,
		RareGlobus = 37025,
		EpicGlobus = 37026,
		MythicGlobus = 37027,
		CommonHidaka = 37028,
		RareHidaka = 37029,
		EpicHidaka = 37030,
		MythicHidaka = 37031,
		CommonBrelshaza = 37032,
		RareBrelshaza = 37033,
		EpicBrelshaza = 37034,
		MythicBrelshaza = 37035,
		CommonVairgrys = 37036,
		RareVairgrys = 37037,
		EpicVairgrys = 37038,
		MythicVairgrys = 37039,
		CommonEnviska = 37040,
		RareEnviska = 37041,
		EpicEnviska = 37042,
		MythicEnviska = 37043,
		CommonHarzal = 37044,
		RareHarzal = 37045,
		EpicHarzal = 37046,
		MythicHarzal = 37047,
		CommonAgaton = 37048,
		RareAgaton = 37049,
		EpicAgaton = 37050,
		MythicAgaton = 37051,
		CommonLumerus = 37052,
		RareLumerus = 37053,
		EpicLumerus = 37054,
		MythicLumerus = 37055,
		CommonVelganos = 37056,
		RareVelganos = 37057,
		EpicVelganos = 37058,
		MythicVelganos = 37059
	},
	Legendary = {
		LegendaryExoticAscalonLv6 = 37065,
		LegendaryChaosAscalonLv6 = 37066,
		LegendaryAbyssalAscalonLv6 = 37067,
		LegendaryAncestralAscalonLv6 = 37068,
		LegendaryExoticSaydonLv6 = 37069,
		LegendaryChaosSaydonLv6 = 37070,
		LegendaryAbyssalSaydonLv6 = 37071,
		LegendaryAncestralSaydonLv6 = 37072,
		LegendaryExoticVercruzeLv6 = 37073,
		LegendaryChaosVercruzeLv6 = 37074,
		LegendaryAbyssalVercruzeLv6 = 37075,
		LegendaryAncestralVercruzeLv6 = 37076,
		LegendaryExoticKaiserLv6 = 37077,
		LegendaryChaosKaiserLv6 = 37078,
		LegendaryAbyssalKaiserLv6 = 37079,
		LegendaryAncestralKaiserLv6 = 37080,
		CanCreateSummon = 37081
	},
}

Exercise_Training = {
	isTraining = 37100
}

Ships = {
	ScarletRaven = 37120,
	TheAwakener = 37121,
	TheCounterspell = 37122,
	TheExplorer = 37123,
	Whisperwind = 37124,
	MenethilMarch = 37125,
	Shadowmeld = 37126
}

BoatMissions = {
	MagnusBlackWaterFirst = 37127,
	MagnusBlackWaterSecond = 37128,
	MagnusBlackWaterThird = 37129,
	MagnusBlackWaterFourth = 37130,
	MagnusBlackWaterFifth = 37131,
	MagnusBlackWaterSixth = 37132,
	ShipWrightTraderOne = 37133
}


Quests = {
	astroClock = 37134,
	astroMount = 37135,
	astroWarriorOutfit = 37136,
	astroMageOutfit = 37137,
	YalahariCrystal1 = 37138,
	YalahariCrystal2 = 37139,
	YalahariCrystal3 = 37140,
	YalahariCrystal4 = 37141,
	YalahariCrystal5 = 37142,
	YalahariCrystal6 = 37143,
	YalahariCrystal7 = 37144,
	YalahariCrystal8 = 37145,
	YalahariCrystal9 = 37146,
	YalahariCrystal10 = 37147,
	YalahariCrystal11 = 37148,
	YalahariCrystal12 = 37149,
	YalahariCrystal13 = 37150,
	YalahariCrystal14 = 37151,
	arodisOutfit = 37152,
}

Battlepass = {
	firePanther = 39055,
	retroBoxOutfitWarrior = 39056,
	retroBoxOutfitSummoner = 39057,
	retroBoxOutfitNobleman = 39058,
	retroBoxOutfitMage = 39059,
	retroBoxOutfitKnight = 39060,
	retroBoxOutfitHunter = 39061,
	retroBoxOutfitCitizen = 39062,
	erectDraptor = 39063
}