#include "otpch.h"
#include "storeinbox.h"
#include "player.h"
#include "game.h"
#include "creature.h"
#include "auras.h"
#include <unordered_set>
#include <vector>
#include <algorithm>
#include <unordered_map>
#include <functional>

class Item;
class Creature;
class Player;
class Aura;

struct ItemFamilies {
    static const std::unordered_set<int> reliques;
    static const std::unordered_set<int> light_family;
    static const std::unordered_set<int> hp_family;
    static const std::unordered_set<int> speed_family;
    static const std::unordered_set<int> exp_night_family;
    static const std::unordered_set<int> fire_protection;
    static const std::unordered_set<int> death_protection;
    static const std::unordered_set<int> earth_protection;
    static const std::unordered_set<int> energy_protection;
    static const std::unordered_set<int> ice_protection;
    static const std::unordered_set<int> holy_protection;
    static const std::unordered_set<int> physical_protection;
};

    const std::unordered_set<int> ItemFamilies::reliques = {2430, 2361, 2413, 2493, 2494, 2495, 2496, 2497, 2498, 2499, 2553, 5791, 16111};
    const std::unordered_set<int> ItemFamilies::light_family = {2413, 5791, 2361};
    const std::unordered_set<int> ItemFamilies::hp_family = {2430};
    const std::unordered_set<int> ItemFamilies::speed_family = {16111};
    const std::unordered_set<int> ItemFamilies::exp_night_family = {2553};
    const std::unordered_set<int> ItemFamilies::fire_protection = {2493};
    const std::unordered_set<int> ItemFamilies::death_protection = {2494};
    const std::unordered_set<int> ItemFamilies::earth_protection = {2495};
    const std::unordered_set<int> ItemFamilies::energy_protection = {2496};
    const std::unordered_set<int> ItemFamilies::ice_protection = {2497};
    const std::unordered_set<int> ItemFamilies::holy_protection = {2498};
    const std::unordered_set<int> ItemFamilies::physical_protection = {2499};

StoreInbox::StoreInbox(uint16_t type) : Container(type, 20, true, true) {}

void StoreInbox::addEffects(const Item* item, Player* player) const {
    if (!item || !player) {
        return;
    }
    int bonus = 0;
    using EffectFunction = std::function<void(Player*)>;
    static const std::unordered_map<int, EffectFunction> effects = {
        {2430, [](Player* p) { p->setMaxHealth(40); }}, // HP Buff
        {16111, [](Player* p) { 
            int bonus = p->getBaseSpeed() + 10;
            p->setBaseSpeed(bonus);
            g_game.changeSpeed(p, 0);
        }},
        {2553, [](Player* p) { 
            p->addStorageValue(8379, 5);
            p->addStorageValue(8380, 5); 
        }},
        {2413, [](Player* p) { // Utevo Lux
            LightInfo light = p->getCreatureLight();
            if (light.level < 6) {
                light.level = 6;
                p->setCreatureLight(light);
                g_game.changeLight(p);
                p->addStorageValue(8381, 6);
            }
        }},
        {5791, [](Player* p) { // Utevo Gran Lux
            LightInfo light = p->getCreatureLight();
            if (light.level < 8) {
                light.level = 8;
                p->setCreatureLight(light);
                g_game.changeLight(p);
                p->addStorageValue(8381, 8);
            }
        }},
        {2361, [](Player* p) { // Utevo Vis Lux
            LightInfo light = p->getCreatureLight();
            if (light.level < 9) {
                light.level = 9;
                p->setCreatureLight(light);
                g_game.changeLight(p);
                p->addStorageValue(8381, 9);
            }
        }},
        {2493, [](Player* p) { p->addStorageValue(8372, 5); }}, // Fire Protection
        {2494, [](Player* p) { p->addStorageValue(8373, 5); }}, // Death Protection
        {2495, [](Player* p) { p->addStorageValue(8374, 5); }}, // Earth Protection
        {2496, [](Player* p) { p->addStorageValue(8375, 5); }}, // Energy Protection
        {2497, [](Player* p) { p->addStorageValue(8376, 5); }}, // Ice Protection
        {2498, [](Player* p) { p->addStorageValue(8377, 5); }}, // Holy Protection
        {2499, [](Player* p) { p->addStorageValue(8378, 5); }}, // Physical Protection
    };

    int itemID = item->getID();
    auto it = effects.find(itemID);
    if (it != effects.end()) {
        it->second(player);
    }
}

void StoreInbox::removeEffects(const Item* item, Player* player) {
    if (!item || !player) {
        return;
    }

    using EffectFunction = std::function<void(Player*)>;
    static const std::unordered_map<int, EffectFunction> effects = {
        {2430, [](Player* p) { // Remove HP Buff
            p->setMaxHealth(-40);
            if (p->getHealth() > p->getMaxHealth()) {
                int bonus = p->getMaxHealth() - p->getHealth();
                p->changeHealth(bonus);
            }
        }},
        {16111, [](Player* p) { // Remove Speed Buff
            int bonus = p->getBaseSpeed() - 10;
            p->setBaseSpeed(bonus);
            g_game.changeSpeed(p, 0);
        }},
        {2553, [](Player* p) { // Remove Exp Bonus
            p->addStorageValue(8379, 0);
        }},
        {2413, [](Player* p) { // Remove Utevo Lux
            LightInfo light = p->getCreatureLight();
            light.level = std::max(0, light.level - 6); // Evita nível de luz negativo
            p->setCreatureLight(light);
            g_game.changeLight(p);
            p->addStorageValue(8381, 0);
        }},
        {5791, [](Player* p) { // Remove Utevo Gran Lux
            LightInfo light = p->getCreatureLight();
            light.level = std::max(0, light.level - 8);
            p->setCreatureLight(light);
            g_game.changeLight(p);
            p->addStorageValue(8381, 0);
        }},
        {2361, [](Player* p) { // Remove Utevo Vis Lux
            LightInfo light = p->getCreatureLight();
            light.level = std::max(0, light.level - 9);
            p->setCreatureLight(light);
            g_game.changeLight(p);
            p->addStorageValue(8381, 0);
        }},
        {2493, [](Player* p) { p->addStorageValue(8372, 0); }}, // Remove Fire Protection
        {2494, [](Player* p) { p->addStorageValue(8373, 0); }}, // Remove Death Protection
        {2495, [](Player* p) { p->addStorageValue(8374, 0); }}, // Remove Earth Protection
        {2496, [](Player* p) { p->addStorageValue(8375, 0); }}, // Remove Energy Protection
        {2497, [](Player* p) { p->addStorageValue(8376, 0); }}, // Remove Ice Protection
        {2498, [](Player* p) { p->addStorageValue(8377, 0); }}, // Remove Holy Protection
        {2499, [](Player* p) { p->addStorageValue(8378, 0); }}  // Remove Physical Protection
    };

    int itemID = item->getID();
    auto it = effects.find(itemID);
    if (it != effects.end()) {
        it->second(player);
    }
}

ReturnValue StoreInbox::queryAdd(int32_t index, const Thing& thing, uint32_t count, uint32_t flags, Creature* actor) const {
    const Item* item = thing.getItem();
    if (!item) {
        return RETURNVALUE_NOTPOSSIBLE;
    }

    if (item == this) {
        return RETURNVALUE_THISISIMPOSSIBLE;
    }

    if (!item->isPickupable()) {
        return RETURNVALUE_CANNOTPICKUP;
    }

    if (!hasBitSet(FLAG_NOLIMIT, flags)) {
        if (ItemFamilies::reliques.find(item->getID()) == ItemFamilies::reliques.end()) {
            return RETURNVALUE_CANNOTMOVEITEMISNOTSTOREITEM;
        }

        for (const Item* existingItem : itemlist) {
            if (conflictsWithFamily(item->getID(), existingItem->getID())) {
                return RETURNVALUE_CANNOTMOVEITEMOFSAMEFAMILY;
            }
        }

        const Container* container = item->getContainer();
        if (container && !container->empty()) {
            return RETURNVALUE_ITEMCANNOTBEMOVEDTHERE;
        }

        if (Player* player = dynamic_cast<Player*>(actor)) {
            addEffects(item, player);
        }
    }

    return RETURNVALUE_NOERROR;
}

bool StoreInbox::conflictsWithFamily(int itemId, int existingItemId) const {
    const std::vector<std::unordered_set<int>> families = {
        ItemFamilies::light_family,
        ItemFamilies::hp_family
    };

    for (const auto& family : families) {
        if (family.find(itemId) != family.end() && family.find(existingItemId) != family.end()) {
            return true;
        }
    }

    return false;
}

void StoreInbox::postAddNotification(Thing* thing, const Cylinder* oldParent, int32_t index, cylinderlink_t)
{
	if (parent != nullptr) {
		parent->postAddNotification(thing, oldParent, index, LINK_TOPPARENT);
	}
}

void StoreInbox::postRemoveNotification(Thing* thing, const Cylinder* newParent, int32_t index, cylinderlink_t)
{
    if (parent != nullptr) {
        parent->postRemoveNotification(thing, newParent, index, LINK_TOPPARENT);
    }
}

