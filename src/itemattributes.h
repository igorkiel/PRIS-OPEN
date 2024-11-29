#pragma once

#include "luascript.h"
#include "tools.h"
#include <string>
#include <map>

struct ItemRarityAttributesData
{
	ItemTooltipAttributes_t id;
	IntegerVector types;
	std::pair<IntegerVector, IntegerVector> range; // First list holds min range, the second list the max range
	uint16_t chance;
};

typedef std::map<slots_t, std::vector<ItemRarityAttributesData>> ItemRarityAttributesDataMap;
typedef std::map<ItemRarity_t, int32_t> ItemRarityModifiers;
typedef std::map<bool, std::map<ItemRarity_t, int32_t>> ItemRarityChances;

class ItemRarityAttributes
{
	public:
		static ItemRarityAttributes* getInstance()
		{
			static ItemRarityAttributes instance;
			return &instance;
		}

		bool load();
		ItemRarity_t getRandomRarityId(bool fromMonster) const;
		bool setRandomAttributes(ItemRarity_t rarityId, slots_t slotId, std::multimap<ItemTooltipAttributes_t, std::pair<int32_t, IntegerVector>>* attributes);

		// Adicionando a nova função para obter a chance de 'ondrop'
		int32_t getRarityChance() const;

	private:
		bool loadChances(lua_State* L);
		bool loadModifiers(lua_State* L);
		bool loadAttributes(lua_State* L);

		ItemRarityAttributesDataMap m_attributes;
		ItemRarityModifiers m_modifiers;
		ItemRarityChances m_chances;
};
