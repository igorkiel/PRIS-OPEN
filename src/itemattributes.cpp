#include "otpch.h"
#include <set>
#include "itemattributes.h"

static struct I {
    const char* name;
    int type;
}
itemrarityattributes[] = {
    { "id", LUA_TNUMBER },
    { "type", LUA_TTABLE },
    { "min", LUA_TUSERDATA },
    { "max", LUA_TUSERDATA },
    { "chance", LUA_TNUMBER },
    { nullptr, 0 }
};

bool ItemRarityAttributes::loadChances(lua_State* L)
{
    auto getChances = [&](const char* name, bool fromMonster) {
        lua_getfield(L, -1, name);
        if (!lua_istable(L, -1)) {
            return false;
        }

        lua_pushnil(L);
        while (lua_next(L, -2)) {
            lua_getfield(L, -1, "id");
            if (!lua_isnumber(L, -1)) {
                lua_pop(L, 1);
                return false;
            }

            ItemRarity_t rarityId = static_cast<ItemRarity_t>(lua_tointeger(L, -1));
            lua_pop(L, 1);

            lua_getfield(L, -1, "chance");
            if (!lua_isnumber(L, -1)) {
                lua_pop(L, 1);
                return false;
            }

            int32_t chance = static_cast<int32_t>(lua_tointeger(L, -1));
            lua_pop(L, 1);

            m_chances[fromMonster][rarityId] = chance;
            lua_pop(L, 1);
        }

        lua_pop(L, 1);
        return true;
    };

    lua_getglobal(L, "RARITY_CHANCE");

    if (!getChances("fromMonster", true) || !getChances("fromQuest", false)) {
        lua_pop(L, 1);
        return false;
    }

    lua_pop(L, 1);
    return true;
}

bool ItemRarityAttributes::loadModifiers(lua_State* L)
{
    lua_getglobal(L, "RARITY_MODIFIERS");
    for (uint16_t i = 1; ; i++)
    {
        lua_rawgeti(L, -1, i);
        if (lua_isnil(L, -1)) {
            lua_pop(L, 1);
            break;
        }

        lua_getfield(L, -1, "id");
        if (!lua_isnumber(L, -1)) {
            lua_pop(L, 1);
            return false;
        }

        ItemRarity_t rarityId = static_cast<ItemRarity_t>(lua_tointeger(L, -1));
        lua_pop(L, 1);

        lua_getfield(L, -1, "amount");
        if (!lua_isnumber(L, -1)) {
            lua_pop(L, 1);
            return false;
        }

        int32_t amount = lua_tointeger(L, -1);
        lua_pop(L, 1);

        m_modifiers[rarityId] = amount;
        lua_pop(L, 1);
    }

    return true;
}

bool ItemRarityAttributes::loadAttributes(lua_State* L)
{
    lua_getglobal(L, "RARITY_ATTRIBUTES");
    for (uint16_t i = 1; ; i++)
    {
        lua_rawgeti(L, -1, i);
        if (lua_isnil(L, -1)) {
            lua_pop(L, 1);
            break;
        }

        lua_getfield(L, -1, "id");
        if (!lua_isnumber(L, -1)) {
            return false;
        }

        slots_t slotId = static_cast<slots_t>(lua_tonumber(L, -1));
        lua_pop(L, 1);

        lua_getfield(L, -1, "attributes");
        if (!lua_istable(L, -1)) {
            return false;
        }

        lua_pushnil(L);
        while (lua_next(L, -2)) {
            ItemRarityAttributesData data;
            for (uint16_t j = 0; itemrarityattributes[j].name != nullptr; j++) {
                const std::string name = itemrarityattributes[j].name;
                const int type = itemrarityattributes[j].type;

                lua_getfield(L, -1, itemrarityattributes[j].name);

                if (type == LUA_TNUMBER && lua_isnumber(L, -1)) {
                    if (name == "id") {
                        data.id = static_cast<ItemTooltipAttributes_t>(lua_tonumber(L, -1));
                    }
                } else if (type == LUA_TTABLE && lua_istable(L, -1)) {
                    if (name == "type") {
                        lua_pushnil(L);
                        while (lua_next(L, -2)) {
                            data.types.push_back(lua_tonumber(L, -1));
                            lua_pop(L, 1);
                        }
                    }
                } else if (type == LUA_TUSERDATA) {
                    if (lua_istable(L, -1)) {
                        lua_pushnil(L);
                        while (lua_next(L, -2)) {
                            if (name == "min") {
                                data.range.first.push_back(lua_tonumber(L, -1));
                                lua_pop(L, 1);
                            } else if (name == "max") {
                                data.range.second.push_back(lua_tonumber(L, -1));
                                lua_pop(L, 1);
                            }
                        }
                    } else if (lua_isnumber(L, -1)) {
                        if (name == "min") {
                            data.range.first.push_back(lua_tonumber(L, -1));
                        } else if (name == "max") {
                            data.range.second.push_back(lua_tonumber(L, -1));
                        }
                    }
                }

                lua_pop(L, 1);
            }

            m_attributes[slotId].push_back(data);
            lua_pop(L, 1);
        }

        lua_pop(L, 1);
        lua_pop(L, 1);
    }

    return true;
}

bool ItemRarityAttributes::load()
{
    lua_State* L = luaL_newstate();
    if (!L) {
        throw std::runtime_error("Failed to allocate memory in ItemAttributes");
    }

    luaL_openlibs(L);
    LuaScriptInterface::registerEnums(L);

    if (luaL_dofile(L, "data/LUA/rarityAttributes.lua")) {
        lua_close(L);
        return false;
    }

    if (!loadChances(L) || !loadModifiers(L) || !loadAttributes(L)) {
        return false;
    }

    lua_close(L);
    return true;
}

int32_t ItemRarityAttributes::getRarityChance() const
{
    lua_State* L = luaL_newstate();
    if (!L) {
        throw std::runtime_error("Failed to allocate memory in ItemRarityAttributes::getRarityChance");
    }

    luaL_openlibs(L);
    LuaScriptInterface::registerEnums(L);

    if (luaL_dofile(L, "data/LUA/rarityAttributes.lua")) {
        lua_close(L);
        return 0;
    }

    lua_getglobal(L, "RARITY_CHANCE");
    lua_getfield(L, -1, "ondrop");

    int32_t ondropChance = 0;
    if (lua_isnumber(L, -1)) {
        ondropChance = static_cast<int32_t>(lua_tonumber(L, -1));
    }

    lua_pop(L, 2);
    lua_close(L);

    return ondropChance;
}

ItemRarity_t ItemRarityAttributes::getRandomRarityId(bool fromMonster) const
{
    auto itChances = m_chances.find(fromMonster);
    if (itChances == m_chances.end()) {
        return ITEM_RARITY_NONE;
    }

    for (auto& itChance : itChances->second) {
        int32_t rarityChance = itChance.second;
        ItemRarity_t rarityId = itChance.first;

        if (uniform_random(0, 100) <= rarityChance) {
            return rarityId;
        }
    }

    return ITEM_RARITY_COMMON;
}

bool ItemRarityAttributes::setRandomAttributes(ItemRarity_t rarityId, slots_t slotId, std::multimap<ItemTooltipAttributes_t, std::pair<int32_t, IntegerVector>>* itemAttributes)
{
    int32_t ondropChance = getRarityChance();
    bool isRarityDrop = uniform_random(0, 100) <= ondropChance;

    if (!isRarityDrop) {
        return false;
    }

    if (rarityId == ITEM_RARITY_NONE) {
        rarityId = getRandomRarityId(true);
    }

    if (rarityId == ITEM_RARITY_NONE) {
        return false;
    }

    itemAttributes->clear();

    auto itModifiers = m_modifiers.find(rarityId);
    if (itModifiers == m_modifiers.end()) {
        return false;
    }

    int32_t numAttributes = itModifiers->second;

    const auto itAttributes = m_attributes.find(slotId);
    if (itAttributes == m_attributes.end()) {
        return false;
    }

    const auto& attributes = itAttributes->second;
    numAttributes = std::min(static_cast<int32_t>(attributes.size()), numAttributes);

    std::set<ItemTooltipAttributes_t> selectedAttributes;
    int32_t attributesGenerated = 0;

    while (attributesGenerated < numAttributes) {
        ItemTooltipAttributes_t attributeId = TOOLTIP_ATTRIBUTE_NONE;
        ItemRarityAttributesData attributeData;

        bool foundAttribute = false;
        for (size_t attempt = 0; attempt < attributes.size(); ++attempt) {
            const size_t index = uniform_random(0, attributes.size() - 1);
            attributeData = attributes.at(index);

            if (selectedAttributes.find(attributeData.id) == selectedAttributes.end()) {
                attributeId = attributeData.id;
                foundAttribute = true;
                break;
            }
        }

        if (!foundAttribute) {
            break;
        }

        int32_t value = uniform_random(attributeData.range.first.at(0), attributeData.range.second.at(0));

        IntegerVector itemTypes;
        if (attributeId == TOOLTIP_ATTRIBUTE_RESISTANCES || attributeId == TOOLTIP_ATTRIBUTE_INCREMENTS) {
            for (auto& itCombatType : attributeData.types) {
                itemTypes.push_back(combatTypeToIndex(static_cast<CombatType_t>(itCombatType)));
            }
        } else {
            itemTypes = attributeData.types;
        }

        itemAttributes->emplace(attributeId, std::make_pair(value, itemTypes));
        selectedAttributes.insert(attributeId);
        attributesGenerated++;
    }

    return attributesGenerated == numAttributes;
}
