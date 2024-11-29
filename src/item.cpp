// Copyright 2022 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "item.h"
#include "container.h"
#include "teleport.h"
#include "trashholder.h"
#include "mailbox.h"
#include "house.h"
#include "game.h"
#include "bed.h"
#include "combat.h"

#include "actions.h"
#include "spells.h"
#include "itemattributes.h"

extern Game g_game;
extern Spells* g_spells;
extern Vocations g_vocations;

Items Item::items;

Item* Item::CreateItem(const uint16_t type, uint16_t count /*= 0*/)
{
	Item* newItem = nullptr;

	const ItemType& it = Item::items[type];
	if (it.group == ITEM_GROUP_DEPRECATED) {
		return nullptr;
	}

	if (it.stackable && count == 0) {
		count = 1;
	}

	if (it.id != 0) {
		if (it.isDepot()) {
			newItem = new DepotLocker(type);
		} else if (it.isContainer()) {
			newItem = new Container(type);
		} else if (it.isTeleport()) {
			newItem = new Teleport(type);
		} else if (it.isMagicField()) {
			newItem = new MagicField(type);
		} else if (it.isDoor()) {
			newItem = new Door(type);
		} else if (it.isTrashHolder()) {
			newItem = new TrashHolder(type);
		} else if (it.isMailbox()) {
			newItem = new Mailbox(type);
		} else if (it.isBed()) {
			newItem = new BedItem(type);
		} else if (it.id >= 2210 && it.id <= 2212) { // magic rings
			newItem = new Item(type - 3, count);
		} else if (it.id == 2215 || it.id == 2216) { // magic rings
			newItem = new Item(type - 2, count);
		} else if (it.id >= 2202 && it.id <= 2206) { // magic rings
			newItem = new Item(type - 37, count);
		} else if (it.id == 2640) { // soft boots
			newItem = new Item(6132, count);
		} else if (it.id == 6301) { // death ring
			newItem = new Item(6300, count);
		} else if (it.id == 18528) { // prismatic ring
			newItem = new Item(18408, count);
		} else {
			newItem = new Item(type, count);
		}
		if (it.pickupable) {
			newItem->setRealUID(g_game.nextItemUID());
		}

		newItem->incrementReferenceCounter();
	}

	return newItem;
}

Container* Item::CreateItemAsContainer(const uint16_t type, uint16_t size)
{
	const ItemType& it = Item::items[type];
	if (it.id == 0 || it.group == ITEM_GROUP_DEPRECATED || it.stackable || it.useable || it.moveable || it.pickupable || it.isDepot() || it.isSplash() || it.isDoor()) {
		return nullptr;
	}

	Container* newItem = new Container(type, size);
	newItem->incrementReferenceCounter();
	return newItem;
}

Item* Item::CreateItem(PropStream& propStream)
{
	uint16_t id;
	if (!propStream.read<uint16_t>(id)) {
		return nullptr;
	}

	switch (id) {
		case ITEM_FIREFIELD_PVP_FULL:
			id = ITEM_FIREFIELD_PERSISTENT_FULL;
			break;

		case ITEM_FIREFIELD_PVP_MEDIUM:
			id = ITEM_FIREFIELD_PERSISTENT_MEDIUM;
			break;

		case ITEM_FIREFIELD_PVP_SMALL:
			id = ITEM_FIREFIELD_PERSISTENT_SMALL;
			break;

		case ITEM_ENERGYFIELD_PVP:
			id = ITEM_ENERGYFIELD_PERSISTENT;
			break;

		case ITEM_POISONFIELD_PVP:
			id = ITEM_POISONFIELD_PERSISTENT;
			break;

		case ITEM_MAGICWALL:
			id = ITEM_MAGICWALL_PERSISTENT;
			break;

		case ITEM_WILDGROWTH:
			id = ITEM_WILDGROWTH_PERSISTENT;
			break;

		default:
			break;
	}

	return Item::CreateItem(id, 0);
}

Item::Item(const uint16_t type, uint16_t count /*= 0*/) :
	id(type)
{
	const ItemType& it = items[id];

	if (it.isFluidContainer() || it.isSplash()) {
		setFluidType(count);
	} else if (it.stackable) {
		if (count != 0) {
			setItemCount(count);
		} else if (it.charges != 0) {
			setItemCount(it.charges);
		}
	} else if (it.charges != 0) {
		if (count != 0) {
			setCharges(count);
		} else {
			setCharges(it.charges);
		}
	}

	setDefaultDuration();
}

Item::Item(const Item& i) :
	Thing(), id(i.id), count(i.count), loadedFromMap(i.loadedFromMap)
{
	if (i.attributes) {
		attributes.reset(new ItemAttributes(*i.attributes));
	}
}

Item* Item::clone() const
{
	Item* item = Item::CreateItem(id, count);
	if (attributes) {
		item->attributes.reset(new ItemAttributes(*attributes));
		if (item->getDuration() > 0) {
			item->incrementReferenceCounter();
			item->setDecaying(DECAYING_TRUE);
			g_game.toDecayItems.push_front(item);
		}
	}
	return item;
}

bool Item::equals(const Item* otherItem) const
{
	if (!otherItem || id != otherItem->id) {
		return false;
	}

	const auto& otherAttributes = otherItem->attributes;
	if (!attributes) {
		return !otherAttributes || (otherAttributes->attributeBits == 0);
	} else if (!otherAttributes) {
		return (attributes->attributeBits == 0);
	}

	if (attributes->attributeBits != otherAttributes->attributeBits) {
		return false;
	}

	const auto& attributeList = attributes->attributes;
	const auto& otherAttributeList = otherAttributes->attributes;
	for (const auto& attribute : attributeList) {
		if (ItemAttributes::isIntAttrType(attribute.type)) {
			for (const auto& otherAttribute : otherAttributeList) {
				if (attribute.type == otherAttribute.type && attribute.value.integer != otherAttribute.value.integer) {
					return false;
				}
			}
		} else if (ItemAttributes::isStrAttrType(attribute.type)) {
			for (const auto& otherAttribute : otherAttributeList) {
				if (attribute.type == otherAttribute.type && *attribute.value.string != *otherAttribute.value.string) {
					return false;
				}
			}
		} else {
			for (const auto& otherAttribute : otherAttributeList) {
				if (attribute.type == otherAttribute.type && *attribute.value.custom != *otherAttribute.value.custom) {
					return false;
				}
			}
		}
	}
	return true;
}

void Item::setDefaultSubtype()
{
	const ItemType& it = items[id];

	setItemCount(1);

	if (it.charges != 0) {
		if (it.stackable) {
			setItemCount(it.charges);
		} else {
			setCharges(it.charges);
		}
	}
}

void Item::onRemoved()
{
	ScriptEnvironment::removeTempItem(this);

	if (hasAttribute(ITEM_ATTRIBUTE_UNIQUEID)) {
		g_game.removeUniqueItem(getUniqueId());
	}
}

void Item::setID(uint16_t newid)
{
	const ItemType& prevIt = Item::items[id];
	id = newid;

	const ItemType& it = Item::items[newid];
	uint32_t newDuration = it.decayTime * 1000;

	if (newDuration == 0 && !it.stopTime && it.decayTo < 0) {
		removeAttribute(ITEM_ATTRIBUTE_DECAYSTATE);
		removeAttribute(ITEM_ATTRIBUTE_DURATION);
	}

	removeAttribute(ITEM_ATTRIBUTE_CORPSEOWNER);

	if (newDuration > 0 && (!prevIt.stopTime || !hasAttribute(ITEM_ATTRIBUTE_DURATION))) {
		setDecaying(DECAYING_FALSE);
		setDuration(newDuration);
	}
}

Cylinder* Item::getTopParent()
{
	Cylinder* aux = getParent();
	Cylinder* prevaux = dynamic_cast<Cylinder*>(this);
	if (!aux) {
		return prevaux;
	}

	while (aux->getParent() != nullptr) {
		prevaux = aux;
		aux = aux->getParent();
	}

	if (prevaux) {
		return prevaux;
	}
	return aux;
}

const Cylinder* Item::getTopParent() const
{
	const Cylinder* aux = getParent();
	const Cylinder* prevaux = dynamic_cast<const Cylinder*>(this);
	if (!aux) {
		return prevaux;
	}

	while (aux->getParent() != nullptr) {
		prevaux = aux;
		aux = aux->getParent();
	}

	if (prevaux) {
		return prevaux;
	}
	return aux;
}

Tile* Item::getTile()
{
	Cylinder* cylinder = getTopParent();
	//get root cylinder
	if (cylinder && cylinder->getParent()) {
		cylinder = cylinder->getParent();
	}
	return dynamic_cast<Tile*>(cylinder);
}

const Tile* Item::getTile() const
{
	const Cylinder* cylinder = getTopParent();
	//get root cylinder
	if (cylinder && cylinder->getParent()) {
		cylinder = cylinder->getParent();
	}
	return dynamic_cast<const Tile*>(cylinder);
}

uint16_t Item::getSubType() const
{
	const ItemType& it = items[id];
	if (it.isFluidContainer() || it.isSplash()) {
		return getFluidType();
	} else if (it.stackable) {
		return count;
	} else if (it.charges != 0) {
		return getCharges();
	}
	return count;
}

Player* Item::getHoldingPlayer() const
{
	Cylinder* p = getParent();
	while (p) {
		if (p->getCreature()) {
			return p->getCreature()->getPlayer();
		}

		p = p->getParent();
	}
	return nullptr;
}

void Item::setSubType(uint16_t n)
{
	const ItemType& it = items[id];
	if (it.isFluidContainer() || it.isSplash()) {
		setFluidType(n);
	} else if (it.stackable) {
		setItemCount(n);
	} else if (it.charges != 0) {
		setCharges(n);
	} else {
		setItemCount(n);
	}
}

Attr_ReadValue Item::readAttr(AttrTypes_t attr, PropStream& propStream)
{
	switch (attr) {
		case ATTR_COUNT:
		case ATTR_RUNE_CHARGES: {
			uint8_t count;
			if (!propStream.read<uint8_t>(count)) {
				return ATTR_READ_ERROR;
			}

			setSubType(count);
			break;
		}

		case ATTR_ACTION_ID: {
			uint16_t actionId;
			if (!propStream.read<uint16_t>(actionId)) {
				return ATTR_READ_ERROR;
			}

			setActionId(actionId);
			break;
		}

		case ATTR_UNIQUE_ID: {
			uint16_t uniqueId;
			if (!propStream.read<uint16_t>(uniqueId)) {
				return ATTR_READ_ERROR;
			}

			setUniqueId(uniqueId);
			break;
		}

		case ATTR_TEXT: {
			std::string text;
			if (!propStream.readString(text)) {
				return ATTR_READ_ERROR;
			}

			setText(text);
			break;
		}

		case ATTR_WRITTENDATE: {
			uint32_t writtenDate;
			if (!propStream.read<uint32_t>(writtenDate)) {
				return ATTR_READ_ERROR;
			}

			setDate(writtenDate);
			break;
		}

		case ATTR_WRITTENBY: {
			std::string writer;
			if (!propStream.readString(writer)) {
				return ATTR_READ_ERROR;
			}

			setWriter(writer);
			break;
		}

		case ATTR_DESC: {
			std::string text;
			if (!propStream.readString(text)) {
				return ATTR_READ_ERROR;
			}

			setSpecialDescription(text);
			break;
		}

		case ATTR_CHARGES: {
			uint16_t charges;
			if (!propStream.read<uint16_t>(charges)) {
				return ATTR_READ_ERROR;
			}

			setSubType(charges);
			break;
		}

		case ATTR_DURATION: {
			int32_t duration;
			if (!propStream.read<int32_t>(duration)) {
				return ATTR_READ_ERROR;
			}

			setDuration(std::max<int32_t>(0, duration));
			break;
		}

		case ATTR_DECAYING_STATE: {
			uint8_t state;
			if (!propStream.read<uint8_t>(state)) {
				return ATTR_READ_ERROR;
			}

			if (state != DECAYING_FALSE) {
				setDecaying(DECAYING_PENDING);
			}
			break;
		}

		case ATTR_NAME: {
			std::string name;
			if (!propStream.readString(name)) {
				return ATTR_READ_ERROR;
			}

			setStrAttr(ITEM_ATTRIBUTE_NAME, name);
			break;
		}

		case ATTR_ARTICLE: {
			std::string article;
			if (!propStream.readString(article)) {
				return ATTR_READ_ERROR;
			}

			setStrAttr(ITEM_ATTRIBUTE_ARTICLE, article);
			break;
		}

		case ATTR_PLURALNAME: {
			std::string pluralName;
			if (!propStream.readString(pluralName)) {
				return ATTR_READ_ERROR;
			}

			setStrAttr(ITEM_ATTRIBUTE_PLURALNAME, pluralName);
			break;
		}

		case ATTR_WEIGHT: {
			uint32_t weight;
			if (!propStream.read<uint32_t>(weight)) {
				return ATTR_READ_ERROR;
			}

			setIntAttr(ITEM_ATTRIBUTE_WEIGHT, weight);
			break;
		}

		case ATTR_ATTACK: {
			int32_t attack;
			if (!propStream.read<int32_t>(attack)) {
				return ATTR_READ_ERROR;
			}

			setIntAttr(ITEM_ATTRIBUTE_ATTACK, attack);
			break;
		}

		case ATTR_ATTACK_SPEED: {
			uint32_t attackSpeed;
			if (!propStream.read<uint32_t>(attackSpeed)) {
				return ATTR_READ_ERROR;
			}

			setIntAttr(ITEM_ATTRIBUTE_ATTACK_SPEED, attackSpeed);
			break;
		}

		case ATTR_DEFENSE: {
			int32_t defense;
			if (!propStream.read<int32_t>(defense)) {
				return ATTR_READ_ERROR;
			}

			setIntAttr(ITEM_ATTRIBUTE_DEFENSE, defense);
			break;
		}

		case ATTR_EXTRADEFENSE: {
			int32_t extraDefense;
			if (!propStream.read<int32_t>(extraDefense)) {
				return ATTR_READ_ERROR;
			}

			setIntAttr(ITEM_ATTRIBUTE_EXTRADEFENSE, extraDefense);
			break;
		}

		case ATTR_ARMOR: {
			int32_t armor;
			if (!propStream.read<int32_t>(armor)) {
				return ATTR_READ_ERROR;
			}

			setIntAttr(ITEM_ATTRIBUTE_ARMOR, armor);
			break;
		}

		case ATTR_HITCHANCE: {
			int8_t hitChance;
			if (!propStream.read<int8_t>(hitChance)) {
				return ATTR_READ_ERROR;
			}

			setIntAttr(ITEM_ATTRIBUTE_HITCHANCE, hitChance);
			break;
		}

		case ATTR_SHOOTRANGE: {
			uint8_t shootRange;
			if (!propStream.read<uint8_t>(shootRange)) {
				return ATTR_READ_ERROR;
			}

			setIntAttr(ITEM_ATTRIBUTE_SHOOTRANGE, shootRange);
			break;
		}

		case ATTR_DECAYTO: {
			int32_t decayTo;
			if (!propStream.read<int32_t>(decayTo)) {
				return ATTR_READ_ERROR;
			}

			setIntAttr(ITEM_ATTRIBUTE_DECAYTO, decayTo);
			break;
		}

		case ATTR_WRAPID:
		{
			uint16_t wrapId;
			if (!propStream.read<uint16_t>(wrapId)) {
				return ATTR_READ_ERROR;
			}

			setIntAttr(ITEM_ATTRIBUTE_WRAPID, wrapId);
			break;
		}

		case ATTR_AUTOOPEN:
		{
			int8_t autoOpen;
			if (!propStream.read<int8_t>(autoOpen)) {
				return ATTR_READ_ERROR;
			}

			setIntAttr(ITEM_ATTRIBUTE_AUTOOPEN, autoOpen);
			break;
		}

		case ATTR_STOREITEM: {
			uint8_t storeItem;
			if (!propStream.read<uint8_t>(storeItem)) {
				return ATTR_READ_ERROR;
			}

			setIntAttr(ITEM_ATTRIBUTE_STOREITEM, storeItem);
			break;
		}

		case ATTR_LOOT_CATEGORY: {
			uint32_t lootCategory;
			if (!propStream.read<uint32_t>(lootCategory)) {
				return ATTR_READ_ERROR;
			}

			setIntAttr(ITEM_ATTRIBUTE_LOOTCATEGORY, lootCategory);
			break;
		}

		//12+ compatibility
		case ATTR_OPENCONTAINER:
		case ATTR_TIER: {
			if (!propStream.skip(1)) {
				return ATTR_READ_ERROR;
			}
			break;
		}

		case ATTR_PODIUMOUTFIT: {
			if (!propStream.skip(15)) {
				return ATTR_READ_ERROR;
			}
			break;
		}

		//these should be handled through derived classes
		//If these are called then something has changed in the items.xml since the map was saved
		//just read the values

		//Depot class
		case ATTR_DEPOT_ID: {
			if (!propStream.skip(2)) {
				return ATTR_READ_ERROR;
			}
			break;
		}

		//Door class
		case ATTR_HOUSEDOORID: {
			if (!propStream.skip(1)) {
				return ATTR_READ_ERROR;
			}
			break;
		}

		//Bed class
		case ATTR_SLEEPERGUID: {
			if (!propStream.skip(4)) {
				return ATTR_READ_ERROR;
			}
			break;
		}

		case ATTR_SLEEPSTART: {
			if (!propStream.skip(4)) {
				return ATTR_READ_ERROR;
			}
			break;
		}

		//Teleport class
		case ATTR_TELE_DEST: {
			if (!propStream.skip(5)) {
				return ATTR_READ_ERROR;
			}
			break;
		}

		//Container class
		case ATTR_CONTAINER_ITEMS: {
			return ATTR_READ_ERROR;
		}

		case ATTR_CUSTOM_ATTRIBUTES: {
			uint64_t size;
			if (!propStream.read<uint64_t>(size)) {
				return ATTR_READ_ERROR;
			}

			for (uint64_t i = 0; i < size; i++) {
				// Unserialize key type and value
				std::string key;
				if (!propStream.readString(key)) {
					return ATTR_READ_ERROR;
				};

				// Unserialize value type and value
				ItemAttributes::CustomAttribute val;
				if (!val.unserialize(propStream)) {
					return ATTR_READ_ERROR;
				}

				setCustomAttribute(key, val);
			}
			break;
		}

		case ATTR_RARITY_ATTRIBUTES: {
			uint8_t rarity;
			if (!propStream.read<uint8_t>(rarity)) {
				return ATTR_READ_ERROR;
			}

			rarityId = static_cast<ItemRarity_t>(rarity);

			uint64_t size;
			if (!propStream.read<uint64_t>(size)) {
				return ATTR_READ_ERROR;
			}

			for (uint64_t i = 0; i < size; i++) {
				uint8_t attributeId;
				if (!propStream.read<uint8_t>(attributeId)) {
					return ATTR_READ_ERROR;
				}

				int32_t value;
				if (!propStream.read<int32_t>(value)) {
					return ATTR_READ_ERROR;
				}

				uint64_t attributesSize;
				if (!propStream.read<uint64_t>(attributesSize)) {
					return ATTR_READ_ERROR;
				}

				IntegerVector itemTypes;
				for (uint64_t j = 0; j < attributesSize; j++) {
					int32_t type;
					if (!propStream.read<int32_t>(type)) {
						return ATTR_READ_ERROR;
					}
					itemTypes.push_back(type);
				}

				const std::pair<int32_t, IntegerVector> types = { value, itemTypes };
				rarityAttributes.emplace(static_cast<ItemTooltipAttributes_t>(attributeId), types);
			}
			break;
		}

		default:
			return ATTR_READ_ERROR;
	}

	return ATTR_READ_CONTINUE;
}

bool Item::unserializeAttr(PropStream& propStream)
{
	uint8_t attr_type;
	while (propStream.read<uint8_t>(attr_type) && attr_type != 0) {
		Attr_ReadValue ret = readAttr(static_cast<AttrTypes_t>(attr_type), propStream);
		if (ret == ATTR_READ_ERROR) {
			return false;
		} else if (ret == ATTR_READ_END) {
			return true;
		}
	}
	return true;
}

bool Item::unserializeItemNode(OTB::Loader&, const OTB::Node&, PropStream& propStream)
{
	return unserializeAttr(propStream);
}

void Item::serializeAttr(PropWriteStream& propWriteStream) const
{
	const ItemType& it = items[id];
	if (it.stackable || it.isFluidContainer() || it.isSplash()) {
		propWriteStream.write<uint8_t>(ATTR_COUNT);
		propWriteStream.write<uint8_t>(getSubType());
	}

	uint16_t charges = getCharges();
	if (charges != 0) {
		propWriteStream.write<uint8_t>(ATTR_CHARGES);
		propWriteStream.write<uint16_t>(charges);
	}

	if (it.moveable) {
		uint16_t actionId = getActionId();
		if (actionId != 0) {
			propWriteStream.write<uint8_t>(ATTR_ACTION_ID);
			propWriteStream.write<uint16_t>(actionId);
		}
	}

	const std::string& text = getText();
	if (!text.empty()) {
		propWriteStream.write<uint8_t>(ATTR_TEXT);
		propWriteStream.writeString(text);
	}

	const time_t writtenDate = getDate();
	if (writtenDate != 0) {
		propWriteStream.write<uint8_t>(ATTR_WRITTENDATE);
		propWriteStream.write<uint32_t>(writtenDate);
	}

	const std::string& writer = getWriter();
	if (!writer.empty()) {
		propWriteStream.write<uint8_t>(ATTR_WRITTENBY);
		propWriteStream.writeString(writer);
	}

	const std::string& specialDesc = getSpecialDescription();
	if (!specialDesc.empty()) {
		propWriteStream.write<uint8_t>(ATTR_DESC);
		propWriteStream.writeString(specialDesc);
	}

	if (hasAttribute(ITEM_ATTRIBUTE_DURATION)) {
		propWriteStream.write<uint8_t>(ATTR_DURATION);
		propWriteStream.write<uint32_t>(getIntAttr(ITEM_ATTRIBUTE_DURATION));
	}

	ItemDecayState_t decayState = getDecaying();
	if (decayState == DECAYING_TRUE || decayState == DECAYING_PENDING) {
		propWriteStream.write<uint8_t>(ATTR_DECAYING_STATE);
		propWriteStream.write<uint8_t>(decayState);
	}

	if (hasAttribute(ITEM_ATTRIBUTE_NAME)) {
		propWriteStream.write<uint8_t>(ATTR_NAME);
		propWriteStream.writeString(getStrAttr(ITEM_ATTRIBUTE_NAME));
	}

	if (hasAttribute(ITEM_ATTRIBUTE_ARTICLE)) {
		propWriteStream.write<uint8_t>(ATTR_ARTICLE);
		propWriteStream.writeString(getStrAttr(ITEM_ATTRIBUTE_ARTICLE));
	}

	if (hasAttribute(ITEM_ATTRIBUTE_PLURALNAME)) {
		propWriteStream.write<uint8_t>(ATTR_PLURALNAME);
		propWriteStream.writeString(getStrAttr(ITEM_ATTRIBUTE_PLURALNAME));
	}

	if (hasAttribute(ITEM_ATTRIBUTE_WEIGHT)) {
		propWriteStream.write<uint8_t>(ATTR_WEIGHT);
		propWriteStream.write<uint32_t>(getIntAttr(ITEM_ATTRIBUTE_WEIGHT));
	}

	if (hasAttribute(ITEM_ATTRIBUTE_ATTACK)) {
		propWriteStream.write<uint8_t>(ATTR_ATTACK);
		propWriteStream.write<int32_t>(getIntAttr(ITEM_ATTRIBUTE_ATTACK));
	}

	if (hasAttribute(ITEM_ATTRIBUTE_ATTACK_SPEED)) {
		propWriteStream.write<uint8_t>(ATTR_ATTACK_SPEED);
		propWriteStream.write<uint32_t>(getIntAttr(ITEM_ATTRIBUTE_ATTACK_SPEED));
	}

	if (hasAttribute(ITEM_ATTRIBUTE_DEFENSE)) {
		propWriteStream.write<uint8_t>(ATTR_DEFENSE);
		propWriteStream.write<int32_t>(getIntAttr(ITEM_ATTRIBUTE_DEFENSE));
	}

	if (hasAttribute(ITEM_ATTRIBUTE_EXTRADEFENSE)) {
		propWriteStream.write<uint8_t>(ATTR_EXTRADEFENSE);
		propWriteStream.write<int32_t>(getIntAttr(ITEM_ATTRIBUTE_EXTRADEFENSE));
	}

	if (hasAttribute(ITEM_ATTRIBUTE_ARMOR)) {
		propWriteStream.write<uint8_t>(ATTR_ARMOR);
		propWriteStream.write<int32_t>(getIntAttr(ITEM_ATTRIBUTE_ARMOR));
	}

	if (hasAttribute(ITEM_ATTRIBUTE_HITCHANCE)) {
		propWriteStream.write<uint8_t>(ATTR_HITCHANCE);
		propWriteStream.write<int8_t>(getIntAttr(ITEM_ATTRIBUTE_HITCHANCE));
	}

	if (hasAttribute(ITEM_ATTRIBUTE_SHOOTRANGE)) {
		propWriteStream.write<uint8_t>(ATTR_SHOOTRANGE);
		propWriteStream.write<uint8_t>(getIntAttr(ITEM_ATTRIBUTE_SHOOTRANGE));
	}

	if (hasAttribute(ITEM_ATTRIBUTE_DECAYTO)) {
		propWriteStream.write<uint8_t>(ATTR_DECAYTO);
		propWriteStream.write<int32_t>(getIntAttr(ITEM_ATTRIBUTE_DECAYTO));
	}

	if (hasAttribute(ITEM_ATTRIBUTE_WRAPID)) {
		propWriteStream.write<uint8_t>(ATTR_WRAPID);
		propWriteStream.write<uint16_t>(getIntAttr(ITEM_ATTRIBUTE_WRAPID));
	}

	if (hasAttribute(ITEM_ATTRIBUTE_AUTOOPEN)) {
		propWriteStream.write<uint8_t>(ATTR_AUTOOPEN);
		propWriteStream.write<int8_t>(getIntAttr(ITEM_ATTRIBUTE_AUTOOPEN));
	}

	if (hasAttribute(ITEM_ATTRIBUTE_STOREITEM)) {
		propWriteStream.write<uint8_t>(ATTR_STOREITEM);
		propWriteStream.write<uint8_t>(getIntAttr(ITEM_ATTRIBUTE_STOREITEM));
	}

	if (hasAttribute(ITEM_ATTRIBUTE_LOOTCATEGORY)) {
		propWriteStream.write<uint8_t>(ATTR_LOOT_CATEGORY);
		propWriteStream.write<uint32_t>(getIntAttr(ITEM_ATTRIBUTE_LOOTCATEGORY));
	}

	if (hasAttribute(ITEM_ATTRIBUTE_CUSTOM)) {
		const ItemAttributes::CustomAttributeMap* customAttrMap = attributes->getCustomAttributeMap();
		propWriteStream.write<uint8_t>(ATTR_CUSTOM_ATTRIBUTES);
		propWriteStream.write<uint64_t>(static_cast<uint64_t>(customAttrMap->size()));
		for (const auto &entry : *customAttrMap) {
			// Serializing key type and value
			propWriteStream.writeString(entry.first);

			// Serializing value type and value
			entry.second.serialize(propWriteStream);
		}
	}

	if (rarityId != ITEM_RARITY_NONE) {
		propWriteStream.write<uint8_t>(ATTR_RARITY_ATTRIBUTES);
		propWriteStream.write<uint8_t>(rarityId);
		propWriteStream.write<uint64_t>(static_cast<uint64_t>(rarityAttributes.size()));
		for (auto& itAttribute : rarityAttributes) {
			propWriteStream.write<uint8_t>(itAttribute.first);
			propWriteStream.write<int32_t>(itAttribute.second.first);
			propWriteStream.write<uint64_t>(static_cast<uint64_t>(itAttribute.second.second.size()));
			for (auto& itType : itAttribute.second.second) {
				propWriteStream.write<int32_t>(itType);
			}
		}
	}
}

bool Item::hasProperty(ITEMPROPERTY prop) const
{
	const ItemType& it = items[id];
	switch (prop) {
		case CONST_PROP_BLOCKSOLID: return it.blockSolid;
		case CONST_PROP_MOVEABLE: return it.moveable && !hasAttribute(ITEM_ATTRIBUTE_UNIQUEID);
		case CONST_PROP_HASHEIGHT: return it.hasHeight;
		case CONST_PROP_BLOCKPROJECTILE: return it.blockProjectile;
		case CONST_PROP_BLOCKPATH: return it.blockPathFind;
		case CONST_PROP_ISVERTICAL: return it.isVertical;
		case CONST_PROP_ISHORIZONTAL: return it.isHorizontal;
		case CONST_PROP_IMMOVABLEBLOCKSOLID: return it.blockSolid && (!it.moveable || hasAttribute(ITEM_ATTRIBUTE_UNIQUEID));
		case CONST_PROP_IMMOVABLEBLOCKPATH: return it.blockPathFind && (!it.moveable || hasAttribute(ITEM_ATTRIBUTE_UNIQUEID));
		case CONST_PROP_IMMOVABLENOFIELDBLOCKPATH: return !it.isMagicField() && it.blockPathFind && (!it.moveable || hasAttribute(ITEM_ATTRIBUTE_UNIQUEID));
		case CONST_PROP_NOFIELDBLOCKPATH: return !it.isMagicField() && it.blockPathFind;
		case CONST_PROP_SUPPORTHANGABLE: return it.isHorizontal || it.isVertical;
		default: return false;
	}
}

uint32_t Item::getWeight() const
{
	uint32_t weight = getBaseWeight();
	if (isStackable()) {
		return weight * std::max<uint32_t>(1, getItemCount());
	}
	return weight;
}

std::string Item::getDescription(const ItemType& it, int32_t lookDistance,
                                 const Item* item /*= nullptr*/, int32_t subType /*= -1*/, bool addArticle /*= true*/)
{
	const std::string* text = nullptr;

	std::ostringstream s;
	s << getNameDescription(it, item, subType, addArticle);

	if (item) {
		subType = item->getSubType();
	}

	if (it.isRune()) {
		if (it.runeLevel > 0 || it.runeMagLevel > 0) {
			if (RuneSpell* rune = g_spells->getRuneSpell(it.id)) {
				int32_t tmpSubType = subType;
				if (item) {
					tmpSubType = item->getSubType();
				}
				s << " (\"" << it.runeSpellName << "\"). " << (it.stackable && tmpSubType > 1 ? "They" : "It") << " can only be used by ";

				const VocSpellMap& vocMap = rune->getVocMap();
				std::vector<Vocation*> showVocMap;

				// vocations are usually listed with the unpromoted and promoted version, the latter being
				// hidden from description, so `total / 2` is most likely the amount of vocations to be shown.
				showVocMap.reserve(vocMap.size() / 2);
				for (const auto& voc : vocMap) {
					if (voc.second) {
						showVocMap.push_back(g_vocations.getVocation(voc.first));
					}
				}

				if (!showVocMap.empty()) {
					auto vocIt = showVocMap.begin(), vocLast = (showVocMap.end() - 1);
					while (vocIt != vocLast) {
						s << asLowerCaseString((*vocIt)->getVocName()) << "s";
						if (++vocIt == vocLast) {
							s << " and ";
						} else {
							s << ", ";
						}
					}
					s << asLowerCaseString((*vocLast)->getVocName()) << "s";
				} else {
					s << "players";
				}

				s << " with";

				if (it.runeLevel > 0) {
					s << " level " << it.runeLevel;
				}

				if (it.runeMagLevel > 0) {
					if (it.runeLevel > 0) {
						s << " and";
					}

					s << " magic level " << it.runeMagLevel;
				}

				s << " or higher";
			}
		}
	} else if (it.weaponType != WEAPON_NONE) {
		bool begin = true;
		if (it.weaponType == WEAPON_DISTANCE && it.ammoType != AMMO_NONE) {
			s << " (Range:" << static_cast<uint16_t>(item ? item->getShootRange() : it.shootRange);

			int32_t attack;
			int8_t hitChance;
			if (item) {
				attack = item->getAttack();
				hitChance = item->getHitChance();
			} else {
				attack = it.attack;
				hitChance = it.hitChance;
			}

			if (attack != 0) {
				s << ", Atk" << std::showpos << attack << std::noshowpos;
			}

			if (hitChance != 0) {
				s << ", Hit%" << std::showpos << static_cast<int16_t>(hitChance) << std::noshowpos;
			}

			begin = false;
		} else if (it.weaponType != WEAPON_AMMO) {
			int32_t attack, defense, extraDefense;
			if (item) {
				attack = item->getAttack();
				defense = item->getDefense();
				extraDefense = item->getExtraDefense();
			} else {
				attack = it.attack;
				defense = it.defense;
				extraDefense = it.extraDefense;
			}

			if (attack != 0) {
				begin = false;
				s << " (Atk:" << attack;

				if (it.abilities && it.abilities->elementType != COMBAT_NONE && it.abilities->elementDamage != 0) {
					s << " physical + " << it.abilities->elementDamage << ' ' << getCombatName(it.abilities->elementType);
				}
			}

			uint32_t attackSpeed = item ? item->getAttackSpeed() : it.attackSpeed;
			if (attackSpeed) {
				if (begin) {
					begin = false;
					s << " (";
				} else {
					s << ", ";
				}

				s << "Atk Spd:" << (attackSpeed / 1000.) << "s";
			}

			if (defense != 0 || extraDefense != 0) {
				if (begin) {
					begin = false;
					s << " (";
				} else {
					s << ", ";
				}

				s << "Def:" << defense;
				if (extraDefense != 0) {
					s << ' ' << std::showpos << extraDefense << std::noshowpos;
				}
			}
		}

		if (it.abilities) {
			for (uint8_t i = SKILL_FIRST; i <= SKILL_LAST; i++) {
				if (!it.abilities->skills[i]) {
					continue;
				}

				if (begin) {
					begin = false;
					s << " (";
				} else {
					s << ", ";
				}

				s << getSkillName(i) << ' ' << std::showpos << it.abilities->skills[i] << std::noshowpos;
			}

			for (uint8_t i = SPECIALSKILL_FIRST; i <= SPECIALSKILL_LAST; i++) {
				if (!it.abilities->specialSkills[i]) {
					continue;
				}

				if (begin) {
					begin = false;
					s << " (";
				} else {
					s << ", ";
				}

				s << getSpecialSkillName(i) << ' ' << std::showpos << it.abilities->specialSkills[i] << '%' << std::noshowpos;
			}

			if (it.abilities->stats[STAT_MAGICPOINTS]) {
				if (begin) {
					begin = false;
					s << " (";
				} else {
					s << ", ";
				}

				s << "magic level " << std::showpos << it.abilities->stats[STAT_MAGICPOINTS] << std::noshowpos;
			}

			int16_t show = it.abilities->absorbPercent[0];
			if (show != 0) {
				for (size_t i = 1; i < COMBAT_COUNT; ++i) {
					if (it.abilities->absorbPercent[i] != show) {
						show = 0;
						break;
					}
				}
			}

			if (show == 0) {
				bool tmp = true;

				for (size_t i = 0; i < COMBAT_COUNT; ++i) {
					if (it.abilities->absorbPercent[i] == 0) {
						continue;
					}

					if (tmp) {
						tmp = false;

						if (begin) {
							begin = false;
							s << " (";
						} else {
							s << ", ";
						}

						s << "protection ";
					} else {
						s << ", ";
					}

					s << getCombatName(indexToCombatType(i)) << ' ' << std::showpos << it.abilities->absorbPercent[i] << std::noshowpos << '%';
				}
			} else {
				if (begin) {
					begin = false;
					s << " (";
				} else {
					s << ", ";
				}

				s << "protection all " << std::showpos << show << std::noshowpos << '%';
			}

			show = it.abilities->fieldAbsorbPercent[0];
			if (show != 0) {
				for (size_t i = 1; i < COMBAT_COUNT; ++i) {
					if (it.abilities->absorbPercent[i] != show) {
						show = 0;
						break;
					}
				}
			}

			if (show == 0) {
				bool tmp = true;

				for (size_t i = 0; i < COMBAT_COUNT; ++i) {
					if (it.abilities->fieldAbsorbPercent[i] == 0) {
						continue;
					}

					if (tmp) {
						tmp = false;

						if (begin) {
							begin = false;
							s << " (";
						} else {
							s << ", ";
						}

						s << "protection ";
					} else {
						s << ", ";
					}

					s << getCombatName(indexToCombatType(i)) << " field " << std::showpos << it.abilities->fieldAbsorbPercent[i] << std::noshowpos << '%';
				}
			} else {
				if (begin) {
					begin = false;
					s << " (";
				} else {
					s << ", ";
				}

				s << "protection all fields " << std::showpos << show << std::noshowpos << '%';
			}

			if (it.abilities->speed) {
				if (begin) {
					begin = false;
					s << " (";
				} else {
					s << ", ";
				}

				s << "speed " << std::showpos << (it.abilities->speed >> 1) << std::noshowpos;
			}
		}

		if (!begin) {
			s << ')';
		}
	} else if (it.armor != 0 || (item && item->getArmor() != 0) || it.showAttributes) {
		bool begin = true;

		int32_t armor = (item ? item->getArmor() : it.armor);
		if (armor != 0) {
			s << " (Arm:" << armor;
			begin = false;
		}

		if (it.abilities) {
			for (uint8_t i = SKILL_FIRST; i <= SKILL_LAST; i++) {
				if (!it.abilities->skills[i]) {
					continue;
				}

				if (begin) {
					begin = false;
					s << " (";
				} else {
					s << ", ";
				}

				s << getSkillName(i) << ' ' << std::showpos << it.abilities->skills[i] << std::noshowpos;
			}

			if (it.abilities->stats[STAT_MAGICPOINTS]) {
				if (begin) {
					begin = false;
					s << " (";
				} else {
					s << ", ";
				}

				s << "magic level " << std::showpos << it.abilities->stats[STAT_MAGICPOINTS] << std::noshowpos;
			}

			int16_t show = it.abilities->absorbPercent[0];
			if (show != 0) {
				for (size_t i = 1; i < COMBAT_COUNT; ++i) {
					if (it.abilities->absorbPercent[i] != show) {
						show = 0;
						break;
					}
				}
			}

			if (!show) {
				bool protectionBegin = true;
				for (size_t i = 0; i < COMBAT_COUNT; ++i) {
					if (it.abilities->absorbPercent[i] == 0) {
						continue;
					}

					if (protectionBegin) {
						protectionBegin = false;

						if (begin) {
							begin = false;
							s << " (";
						} else {
							s << ", ";
						}

						s << "protection ";
					} else {
						s << ", ";
					}

					s << getCombatName(indexToCombatType(i)) << ' ' << std::showpos << it.abilities->absorbPercent[i] << std::noshowpos << '%';
				}
			} else {
				if (begin) {
					begin = false;
					s << " (";
				} else {
					s << ", ";
				}

				s << "protection all " << std::showpos << show << std::noshowpos << '%';
			}

			show = it.abilities->fieldAbsorbPercent[0];
			if (show != 0) {
				for (size_t i = 1; i < COMBAT_COUNT; ++i) {
					if (it.abilities->absorbPercent[i] != show) {
						show = 0;
						break;
					}
				}
			}

			if (!show) {
				bool tmp = true;

				for (size_t i = 0; i < COMBAT_COUNT; ++i) {
					if (it.abilities->fieldAbsorbPercent[i] == 0) {
						continue;
					}

					if (tmp) {
						tmp = false;

						if (begin) {
							begin = false;
							s << " (";
						} else {
							s << ", ";
						}

						s << "protection ";
					} else {
						s << ", ";
					}

					s << getCombatName(indexToCombatType(i)) << " field " << std::showpos << it.abilities->fieldAbsorbPercent[i] << std::noshowpos << '%';
				}
			} else {
				if (begin) {
					begin = false;
					s << " (";
				} else {
					s << ", ";
				}

				s << "protection all fields " << std::showpos << show << std::noshowpos << '%';
			}

			if (it.abilities->speed) {
				if (begin) {
					begin = false;
					s << " (";
				} else {
					s << ", ";
				}

				 s << "speed " << std::showpos << it.abilities->speed << std::noshowpos;
			}
		}

		if (!begin) {
			s << ')';
		}
	} else if (it.isContainer() || (item && item->getContainer())) {
		uint32_t volume = 0;
		if (!item || !item->hasAttribute(ITEM_ATTRIBUTE_UNIQUEID)) {
			if (it.isContainer()) {
				volume = item->getName() == "Quiver" ? 4 : it.maxItems;
			} else {
				volume = item->getContainer()->capacity();
			}
		}

		if (volume != 0) {
			s << " (Vol:" << volume << ')';
		}
	} else {
		bool found = true;

		if (it.abilities) {
			if (it.abilities->speed > 0) {
				s << " (speed " << std::showpos << (it.abilities->speed / 2) << std::noshowpos << ')';
			} else if (hasBitSet(CONDITION_DRUNK, it.abilities->conditionSuppressions)) {
				s << " (hard drinking)";
			} else if (it.abilities->invisible) {
				s << " (invisibility)";
			} else if (it.abilities->regeneration) {
				s << " (faster regeneration)";
			} else if (it.abilities->manaShield) {
				s << " (mana shield)";
			} else {
				found = false;
			}
		} else {
			found = false;
		}

		if (!found) {
			if (it.isKey()) {
				int32_t keyNumber = (item ? item->getActionId() : 0);
				if (keyNumber != 0) {
					s << " (Key:" << std::setfill('0') << std::setw(4) << keyNumber << ')';
				}
			} else if (it.isFluidContainer()) {
				if (subType > 0) {
					const std::string& itemName = items[subType].name;
					s << " of " << (!itemName.empty() ? itemName : "unknown");
				} else {
					s << ". It is empty";
				}
			} else if (it.isSplash()) {
				s << " of ";

				if (subType > 0 && !items[subType].name.empty()) {
					s << items[subType].name;
				} else {
					s << "unknown";
				}
			} else if (it.allowDistRead && (it.id < 7369 || it.id > 7371)) {
				s << ".\n";

				if (lookDistance <= 4) {
					if (item) {
						text = &item->getText();
						if (!text->empty()) {
							const std::string& writer = item->getWriter();
							if (!writer.empty()) {
								s << writer << " wrote";
								time_t date = item->getDate();
								if (date != 0) {
									s << " on " << formatDateShort(date);
								}
								s << ": ";
							} else {
								s << "You read: ";
							}
							s << *text;
						} else {
							s << "Nothing is written on it";
						}
					} else {
						s << "Nothing is written on it";
					}
				} else {
					s << "You are too far away to read it";
				}
			} else if (it.levelDoor != 0 && item) {
				uint16_t actionId = item->getActionId();
				if (actionId >= it.levelDoor) {
					s << " for level " << (actionId - it.levelDoor);
				}
			}
		}
	}

	if (it.showCharges) {
		s << " that has " << subType << " charge" << (subType != 1 ? "s" : "") << " left";
	}

	if (it.showDuration) {
		if (item && item->hasAttribute(ITEM_ATTRIBUTE_DURATION)) {
			uint32_t duration = item->getDuration() / 1000;
			s << " that will expire in ";

			if (duration >= 86400) {
				uint16_t days = duration / 86400;
				uint16_t hours = (duration % 86400) / 3600;
				s << days << " day" << (days != 1 ? "s" : "");

				if (hours > 0) {
					s << " and " << hours << " hour" << (hours != 1 ? "s" : "");
				}
			} else if (duration >= 3600) {
				uint16_t hours = duration / 3600;
				uint16_t minutes = (duration % 3600) / 60;
				s << hours << " hour" << (hours != 1 ? "s" : "");

				if (minutes > 0) {
					s << " and " << minutes << " minute" << (minutes != 1 ? "s" : "");
				}
			} else if (duration >= 60) {
				uint16_t minutes = duration / 60;
				s << minutes << " minute" << (minutes != 1 ? "s" : "");
				uint16_t seconds = duration % 60;

				if (seconds > 0) {
					s << " and " << seconds << " second" << (seconds != 1 ? "s" : "");
				}
			} else {
				s << duration << " second" << (duration != 1 ? "s" : "");
			}
		} else {
			s << " that is brand-new";
		}
	}

	if (!it.allowDistRead || (it.id >= 7369 && it.id <= 7371)) {
		s << '.';
	} else {
		if (!text && item) {
			text = &item->getText();
		}

		if (!text || text->empty()) {
			s << '.';
		}
	}

	if (it.wieldInfo != 0) {
		s << "\nIt can only be wielded properly by ";

		if (it.wieldInfo & WIELDINFO_PREMIUM) {
			s << "premium ";
		}

		if (!it.vocationString.empty()) {
			s << it.vocationString;
		} else {
			s << "players";
		}

//		if (it.wieldInfo & WIELDINFO_LEVEL) {
//			s << " of level " << it.minReqLevel << " or higher";
//		}

		if (it.wieldInfo & WIELDINFO_MAGLV) {
			if (it.wieldInfo & WIELDINFO_LEVEL) {
				s << " and";
			} else {
				s << " of";
			}

			s << " magic level " << it.minReqMagicLevel << " or higher";
		}

		s << '.';
	}

    if (item) {
        s << item->getRarityDescription();
    }

	if (lookDistance <= 1) {
		if (item) {
			const uint32_t weight = item->getWeight();
			if (weight != 0 && it.pickupable) {
				s << '\n' << getWeightDescription(it, weight, item->getItemCount());
			}
		} else if (it.weight != 0 && it.pickupable) {
			s << '\n' << getWeightDescription(it, it.weight);
		}
	}

	if (item) {
		const std::string& specialDescription = item->getSpecialDescription();
		if (!specialDescription.empty()) {
			s << '\n' << specialDescription;
		} else if (lookDistance <= 1 && !it.description.empty()) {
			s << '\n' << it.description;
		}
	} else if (lookDistance <= 1 && !it.description.empty()) {
		s << '\n' << it.description;
	}

	if (it.allowDistRead && it.id >= 7369 && it.id <= 7371) {
		if (!text && item) {
			text = &item->getText();
		}

		if (text && !text->empty()) {
			s << '\n' << *text;
		}
	}
	return s.str();
}

std::string Item::getDescription(int32_t lookDistance) const
{
	const ItemType& it = items[id];
	return getDescription(it, lookDistance, this);
}

std::string Item::getNameDescription(const ItemType& it, const Item* item /*= nullptr*/, int32_t subType /*= -1*/, bool addArticle /*= true*/)
{
	if (item) {
		subType = item->getSubType();
	}

	std::ostringstream s;

	const std::string& name = (item ? item->getName() : it.name);
	if (!name.empty()) {
		if (it.stackable && subType > 1) {
			if (it.showCount) {
				s << subType << ' ';
			}

			s << (item ? item->getPluralName() : it.getPluralName());
		} else {
			if (addArticle) {
				const std::string& article = (item ? item->getArticle() : it.article);
				if (!article.empty()) {
					s << article << ' ';
				}
			}

			s << name;
		}
	} else {
		if (addArticle) {
			s << "an ";
		}
		s << "item of type " << it.id;
	}
	return s.str();
}

std::string Item::getNameDescription() const
{
	const ItemType& it = items[id];
	return getNameDescription(it, this);
}

std::string Item::getWeightDescription(const ItemType& it, uint32_t weight, uint32_t count /*= 1*/)
{
	std::ostringstream ss;
	if (it.stackable && count > 1 && it.showCount != 0) {
		ss << "They weigh ";
	} else {
		ss << "It weighs ";
	}

	if (weight < 10) {
		ss << "0.0" << weight;
	} else if (weight < 100) {
		ss << "0." << weight;
	} else {
		std::string weightString = std::to_string(weight);
		weightString.insert(weightString.end() - 2, '.');
		ss << weightString;
	}

	ss << " oz.";
	return ss.str();
}

std::string Item::getWeightDescription(uint32_t weight) const
{
	const ItemType& it = Item::items[id];
	return getWeightDescription(it, weight, getItemCount());
}

std::string Item::getWeightDescription() const
{
	uint32_t weight = getWeight();
	if (weight == 0) {
		return std::string();
	}
	return getWeightDescription(weight);
}

std::string Item::getRarityDescription() const
{
    if (rarityId == ITEM_RARITY_NONE) {
        return "";
    }

    std::ostringstream rarityStream;

    switch (rarityId) {
        case ITEM_RARITY_COMMON:
            rarityStream << "\nCommon\n";
            break;
        case ITEM_RARITY_RARE:
            rarityStream << "\nRare\n";
            break;
        case ITEM_RARITY_EPIC:
            rarityStream << "\nEpic\n";
            break;
        case ITEM_RARITY_LEGENDARY:
            rarityStream << "\nLegendary\n";
            break;
        case ITEM_RARITY_BRUTAL:
            rarityStream << "\nBrutal\n";
            break;
        default:
            rarityStream << "\nUnknown Rarity\n";
            break;
    }

    auto it = rarityAttributes.begin();
    while (it != rarityAttributes.end()) {
        const auto& itAttribute = *it;
        const int32_t value = itAttribute.second.first;
        const IntegerVector& types = itAttribute.second.second;

        if (itAttribute.first == TOOLTIP_ATTRIBUTE_RESISTANCES) {
            std::set<int32_t> processedResistances;
            for (int32_t type : types) {
                if (processedResistances.find(type) == processedResistances.end()) {
                    rarityStream << "[+" << value << "] " << getResistanceDescription(type);
                    processedResistances.insert(type);
                }
            }
        } else if (itAttribute.first == TOOLTIP_ATTRIBUTE_INCREMENTS) {
            for (int32_t type : types) {
                std::string incrementDesc = getIncrementDescription(type);
                if (incrementDesc != "Unknown Increment") {
                    rarityStream << "[+" << value << "] " << incrementDesc;
                }
            }
        } else {
            if (types.empty()) {
                rarityStream << "[+" << value << "] " << getTooltipAttributeName(itAttribute.first);
            } else {
                for (int32_t type : types) {
                    rarityStream << "[+" << value << "] " << getTooltipAttributeName(itAttribute.first, type);
                }
            }
        }

        if (std::next(it) != rarityAttributes.end()) {
            rarityStream << '\n';
        }

        ++it;
    }

    return rarityStream.str();
}




std::string Item::getTooltipAttributeName(ItemTooltipAttributes_t attributeId, int32_t type) const
{

    switch (attributeId) {
        case TOOLTIP_ATTRIBUTE_ATTACK:
            return "Attack";
        case TOOLTIP_ATTRIBUTE_DEFENSE:
            return "Defense";
        case TOOLTIP_ATTRIBUTE_NAME:
            return "Name";
        case TOOLTIP_ATTRIBUTE_WEIGHT:
            return "Weight";
        case TOOLTIP_ATTRIBUTE_ARMOR:
            return "Armor";
        case TOOLTIP_ATTRIBUTE_HITCHANCE:
            return "Hit Chance";
        case TOOLTIP_ATTRIBUTE_SHOOTRANGE:
            return "Shoot Range";
        case TOOLTIP_ATTRIBUTE_DURATION:
            return "Duration";
        case TOOLTIP_ATTRIBUTE_CHARGES:
            return "Charges";
        case TOOLTIP_ATTRIBUTE_FLUIDTYPE:
            return "Fluid Type";
        case TOOLTIP_ATTRIBUTE_ATTACK_SPEED:
            return "Attack Speed";
        case TOOLTIP_ATTRIBUTE_SPEED:
            return "Speed";

        case TOOLTIP_ATTRIBUTE_CRITICALHIT_CHANCE:
            return "Critical Hit Chance";
        case TOOLTIP_ATTRIBUTE_CRITICALHIT_AMOUNT:
            return "Critical Hit Amount";
        case TOOLTIP_ATTRIBUTE_MANA_LEECH_CHANCE:
            return "Mana Leech Chance";
        case TOOLTIP_ATTRIBUTE_MANA_LEECH_AMOUNT:
            return "Mana Leech Amount";
        case TOOLTIP_ATTRIBUTE_LIFE_LEECH_CHANCE:
            return "Life Leech Chance";
        case TOOLTIP_ATTRIBUTE_LIFE_LEECH_AMOUNT:
            return "Life Leech Amount";

        case TOOLTIP_ATTRIBUTE_STATS:
            switch (type) {
                case STAT_MAGICPOINTS:
                    return "Magic Level";
                case STAT_MAXHITPOINTS:
                    return "Max Hitpoints";
                case STAT_MAXMANAPOINTS:
                    return "Max Mana Points";
                default:
                    return "Unknown Stat";
            }

        case TOOLTIP_ATTRIBUTE_SKILL:
            switch (type) {
                case SKILL_CLUB:
                    return "Club Fighting";
                case SKILL_SWORD:
                    return "Sword Fighting";
                case SKILL_AXE:
                    return "Axe Fighting";
                case SKILL_SHIELD:
                    return "Shielding";
                case SKILL_DISTANCE:
                    return "Distance Fighting";
                case SKILL_FISHING:
                    return "Fishing";
                case SKILL_FIST:
                    return "Fist Fighting";
                default:
                    return "Unknown Skill";
            }

        case TOOLTIP_ATTRIBUTE_RESISTANCES:
            return getResistanceDescription(type);

        case TOOLTIP_ATTRIBUTE_INCREMENTS:
            return getIncrementDescription(type);

        case TOOLTIP_ATTRIBUTE_INCREMENT_COINS:
            return "Extra Gold Coins";

        case TOOLTIP_ATTRIBUTE_EXPERIENCE:
            return "Experience Bonus";

        case TOOLTIP_ATTRIBUTE_EXTRADEFENSE:
            return "Extra Defense";

        case TOOLTIP_ATTRIBUTE_FIRE_ATTACK:
            return "Fire Attack";

        case TOOLTIP_ATTRIBUTE_ENERGY_ATTACK:
            return "Energy Attack";

        case TOOLTIP_ATTRIBUTE_ICE_ATTACK:
            return "Ice Attack";

        case TOOLTIP_ATTRIBUTE_DEATH_ATTACK:
            return "Death Attack";

        case TOOLTIP_ATTRIBUTE_EARTH_ATTACK:
            return "Earth Attack";

        case TOOLTIP_ATTRIBUTE_HOLY_ATTACK:
            return "Holy Attack";

        default:
            if (type == -1) {
                return "Unknown Attribute";
            } else {
                return "Unknown Subtype";
            }
    }
}

std::string Item::getResistanceDescription(int32_t type) const
{
    switch (type) {
        case 0:
            return "Physical Resistance";
        case 1:
            return "Energy Resistance";
        case 2:
            return "Poison (Earth) Resistance";
        case 3:
            return "Fire Resistance";
        case 4:
            return "Drown Resistance";
        case 5:
            return "Ice Resistance";
        case 6:
            return "Holy Resistance";
        case 11:
            return "Death Resistance";
        case 8:
            return "Lifedrain Resistance";
        case 9:
            return "Manadrain Resistance";
        default:
            return "Unknown Resistance";
    }
}

std::string Item::getIncrementDescription(int32_t type) const
{
    switch (type) {
        case 0:
            return "Increase Physical Damage";
        case 1:
            return "Increase Energy Damage";
        case 2:
            return "Increase Earth Damage";
        case 3:
            return "Increase Fire Damage";
        case 4:
            return "Increase Death Increment";
        case 5:
            return "Increase Extra Healing";
        case 6:
            return "Increase Mana Drain";
        case 7:
            return "Increase Healing";
        default:
            return "Unknown Increment";
    }
}


void Item::setUniqueId(uint16_t n)
{
	if (hasAttribute(ITEM_ATTRIBUTE_UNIQUEID)) {
		return;
	}

	if (g_game.addUniqueItem(n, this)) {
		getAttributes()->setUniqueId(n);
	}
}

bool Item::canDecay() const
{
	if (isRemoved()) {
		return false;
	}

	const ItemType& it = Item::items[id];
	if (getDecayTo() < 0 || it.decayTime == 0) {
		return false;
	}

	if (hasAttribute(ITEM_ATTRIBUTE_UNIQUEID)) {
		return false;
	}

	return true;
}

uint32_t Item::getWorth() const
{
	switch (id) {
		case ITEM_GOLD_COIN:
			return count;

		case ITEM_PLATINUM_COIN:
			return count * 100;

		case ITEM_CRYSTAL_COIN:
			return count * 10000;

		default:
			return 0;
	}
}

LightInfo Item::getLightInfo() const
{
	const ItemType& it = items[id];
	return {it.lightLevel, it.lightColor};
}

std::string ItemAttributes::emptyString;
int64_t ItemAttributes::emptyInt;
double ItemAttributes::emptyDouble;
bool ItemAttributes::emptyBool;

const std::string& ItemAttributes::getStrAttr(itemAttrTypes type) const
{
	if (!isStrAttrType(type)) {
		return emptyString;
	}

	const Attribute* attr = getExistingAttr(type);
	if (!attr) {
		return emptyString;
	}
	return *attr->value.string;
}

void ItemAttributes::setStrAttr(itemAttrTypes type, const std::string& value)
{
	if (!isStrAttrType(type)) {
		return;
	}

	if (value.empty()) {
		return;
	}

	Attribute& attr = getAttr(type);
	delete attr.value.string;
	attr.value.string = new std::string(value);
}

void ItemAttributes::removeAttribute(itemAttrTypes type)
{
	if (!hasAttribute(type)) {
		return;
	}

	auto prev_it = attributes.rbegin();
	if ((*prev_it).type == type) {
		attributes.pop_back();
	} else {
		auto it = prev_it, end = attributes.rend();
		while (++it != end) {
			if ((*it).type == type) {
				(*it) = attributes.back();
				attributes.pop_back();
				break;
			}
		}
	}
	attributeBits &= ~type;
}

int64_t ItemAttributes::getIntAttr(itemAttrTypes type) const
{
	if (!isIntAttrType(type)) {
		return 0;
	}

	const Attribute* attr = getExistingAttr(type);
	if (!attr) {
		return 0;
	}
	return attr->value.integer;
}

void ItemAttributes::setIntAttr(itemAttrTypes type, int64_t value)
{
	if (!isIntAttrType(type)) {
		return;
	}

	if (type == ITEM_ATTRIBUTE_ATTACK_SPEED && value < 100) {
		value = 100;
	}

	getAttr(type).value.integer = value;
}

void ItemAttributes::increaseIntAttr(itemAttrTypes type, int64_t value)
{
	setIntAttr(type, getIntAttr(type) + value);
}

const ItemAttributes::Attribute* ItemAttributes::getExistingAttr(itemAttrTypes type) const
{
	if (hasAttribute(type)) {
		for (const Attribute& attribute : attributes) {
			if (attribute.type == type) {
				return &attribute;
			}
		}
	}
	return nullptr;
}

ItemAttributes::Attribute& ItemAttributes::getAttr(itemAttrTypes type)
{
	if (hasAttribute(type)) {
		for (Attribute& attribute : attributes) {
			if (attribute.type == type) {
				return attribute;
			}
		}
	}

	attributeBits |= type;
	attributes.emplace_back(type);
	return attributes.back();
}

void Item::startDecaying()
{
	g_game.startDecay(this);
}

bool Item::hasMarketAttributes() const
{
	if (attributes == nullptr) {
		return true;
	}

	for (const auto& attr : attributes->getList()) {
		if (attr.type == ITEM_ATTRIBUTE_CHARGES) {
			uint16_t charges = static_cast<uint16_t>(attr.value.integer);
			if (charges != items[id].charges) {
				return false;
			}
		} else if (attr.type == ITEM_ATTRIBUTE_DURATION) {
			uint32_t duration = static_cast<uint32_t>(attr.value.integer);
			if (duration != getDefaultDuration()) {
				return false;
			}
		} else {
			return false;
		}
	}
	return true;
}

void Item::getTooltipCombats(const ItemType& it, CombatType_t combatType, TooltipDataContainer& tooltipData)
{
	if (!it.abilities) {
		return;
	}

	const int32_t combatId = combatTypeToIndex(combatType);
	int32_t absorbPercent = it.abilities->absorbPercent.at(combatId);
	if (absorbPercent != 0) {
		tooltipData.push_back(TooltipData(TOOLTIP_ATTRIBUTE_RESISTANCES, absorbPercent, combatId));
	}
	int32_t fieldAbsorbPercent = it.abilities->fieldAbsorbPercent.at(combatId);
	if (fieldAbsorbPercent != 0) {
		tooltipData.push_back(TooltipData(TOOLTIP_ATTRIBUTE_FIELD_ABSORB, fieldAbsorbPercent, combatId));
	}
}

void Item::getTooltipOther(const ItemType& it, TooltipDataContainer& tooltipData) {
    if (!it.abilities) {
        return;
    }
    if (it.attackSpeed != 0) {
        addTooltipData(it, tooltipData, TOOLTIP_ATTRIBUTE_ATTACK_SPEED, it.attackSpeed, -1);
    }

    if (it.abilities->attackSpeedBonus != 0) {
        addTooltipData(it, tooltipData, TOOLTIP_ATTRIBUTE_ATTACK_SPEED, it.abilities->attackSpeedBonus, 1);
    }
    if (it.speed != 0) {
        addTooltipData(it, tooltipData, TOOLTIP_ATTRIBUTE_SPEED, it.speed, 1);
    }

    if (it.abilities->speed != 0) {
        addTooltipData(it, tooltipData, TOOLTIP_ATTRIBUTE_SPEED, it.abilities->speed, -1);
    }

    if (it.armor != 0) {
        addTooltipData(it, tooltipData, TOOLTIP_ATTRIBUTE_ARMOR, it.armor, -1);
    }

    if (it.abilities->armorBonus != 0) {
        addTooltipData(it, tooltipData, TOOLTIP_ATTRIBUTE_ARMOR, it.abilities->armorBonus, 1);
    }

    if (it.attack != 0) {
        addTooltipData(it, tooltipData, TOOLTIP_ATTRIBUTE_ATTACK, it.attack, -1);
    }
    if (it.abilities->attackBonus != 0) {
        addTooltipData(it, tooltipData, TOOLTIP_ATTRIBUTE_ATTACK, it.abilities->attackBonus, 1);
    }

    if (it.defense != 0) {
        addTooltipData(it, tooltipData, TOOLTIP_ATTRIBUTE_DEFENSE, it.defense, -1);
    }
    if (it.abilities->defenseBonus != 0) {
        addTooltipData(it, tooltipData, TOOLTIP_ATTRIBUTE_DEFENSE, it.abilities->defenseBonus, 1);
    }

    for (int32_t skillId = SKILL_FIRST; skillId <= SKILL_LAST; ++skillId) {
        int baseValue = it.abilities->skills[skillId];
        int bonusValue = it.abilities->skillBonus[skillId];

        if (baseValue != 0) {
            std::string skillName;
            switch (skillId) {
                case SKILL_CLUB:
                    skillName = "Club Fighting";
                    break;
                case SKILL_SWORD:
                    skillName = "Sword Fighting";
                    break;
                case SKILL_AXE:
                    skillName = "Axe Fighting";
                    break;
                case SKILL_SHIELD:
                    skillName = "Shielding";
                    break;
                case SKILL_DISTANCE:
                    skillName = "Distance Fighting";
                    break;
                case SKILL_FISHING:
                    skillName = "Fishing";
                    break;
                case SKILL_FIST:
                    skillName = "Fist Fighting";
                    break;
                default:
                    skillName = "Unknown Skill";
            }

            addTooltipData(it, tooltipData, TOOLTIP_ATTRIBUTE_SKILL, baseValue, skillId);
        }
        if (bonusValue != 0) {
            addTooltipData(it, tooltipData, TOOLTIP_ATTRIBUTE_SKILL, bonusValue, skillId);
        }
    }

    for (int32_t statId = STAT_FIRST; statId <= STAT_LAST; ++statId) {
        int baseValue = it.abilities->stats[statId];
        int bonusValue = it.abilities->statsBonus[statId];

        if (baseValue == 0 && bonusValue == 0) {
            continue;
        }

        std::string statName;
        switch (statId) {
            case STAT_MAXHITPOINTS:
                statName = "Max Hitpoints";
                break;
            case STAT_MAXMANAPOINTS:
                statName = "Max Mana";
                break;
            case STAT_MAGICPOINTS:
                statName = "Magic Points";
                break;
            default:
                statName = "Unknown Stat";
                continue;
        }

        if (baseValue != 0) {
            addTooltipData(it, tooltipData, TOOLTIP_ATTRIBUTE_STATS, baseValue, statId);
        }

        if (bonusValue != 0) {
            addTooltipData(it, tooltipData, TOOLTIP_ATTRIBUTE_STATS, bonusValue, statId);
        }
    }

    if (it.hitChance != 0) {
        addTooltipData(it, tooltipData, TOOLTIP_ATTRIBUTE_HITCHANCE, it.hitChance, 0);
    }

    if (it.abilities->specialSkills[SPECIALSKILL_MANALEECHAMOUNT] != 0) {
        addTooltipData(it, tooltipData, TOOLTIP_ATTRIBUTE_MANA_LEECH_AMOUNT, it.abilities->specialSkills[SPECIALSKILL_MANALEECHAMOUNT], 0);
    }

    if (it.abilities->specialSkills[SPECIALSKILL_MANALEECHCHANCE] != 0) {
        addTooltipData(it, tooltipData, TOOLTIP_ATTRIBUTE_MANA_LEECH_CHANCE, it.abilities->specialSkills[SPECIALSKILL_MANALEECHCHANCE], 0);
    }


    if (it.abilities->specialSkills[SPECIALSKILL_LIFELEECHAMOUNT] != 0) {
        addTooltipData(it, tooltipData, TOOLTIP_ATTRIBUTE_LIFE_LEECH_AMOUNT, it.abilities->specialSkills[SPECIALSKILL_LIFELEECHAMOUNT], 0);
    }

    if (it.abilities->specialSkills[SPECIALSKILL_LIFELEECHCHANCE] != 0) {
        addTooltipData(it, tooltipData, TOOLTIP_ATTRIBUTE_LIFE_LEECH_CHANCE, it.abilities->specialSkills[SPECIALSKILL_LIFELEECHCHANCE], 0);
    }

    if (it.abilities->specialSkills[SPECIALSKILL_CRITICALHITAMOUNT] != 0) {
        addTooltipData(it, tooltipData, TOOLTIP_ATTRIBUTE_CRITICALHIT_AMOUNT, it.abilities->specialSkills[SPECIALSKILL_CRITICALHITAMOUNT], 0);
    }

    if (it.abilities->specialSkills[SPECIALSKILL_CRITICALHITCHANCE] != 0) {
        addTooltipData(it, tooltipData, TOOLTIP_ATTRIBUTE_CRITICALHIT_CHANCE, it.abilities->specialSkills[SPECIALSKILL_CRITICALHITCHANCE], 0);
    }

    if (it.abilities->elementDamage != 0) {
        addTooltipData(it, tooltipData, static_cast<ItemTooltipAttributes_t>(TOOLTIP_ATTRIBUTE_FIRE_ATTACK + it.abilities->elementType - COMBAT_FIREDAMAGE), it.abilities->elementDamage, -1);
    }

    if (it.abilities->elementDamageBonus != 0) {
        addTooltipData(it, tooltipData, static_cast<ItemTooltipAttributes_t>(TOOLTIP_ATTRIBUTE_FIRE_ATTACK + it.abilities->elementType - COMBAT_FIREDAMAGE), it.abilities->elementDamageBonus, 1);
    }
}


void Item::addTooltipData(const ItemType& it, TooltipDataContainer& tooltipData, ItemTooltipAttributes_t id, int32_t baseValue, int32_t type) {

    if (id == TOOLTIP_ATTRIBUTE_STATS && baseValue == it.abilities->speed && type == 1) {
        return;
    }

    bool isStatAttribute = (id == TOOLTIP_ATTRIBUTE_STATS);
    bool isSkillAttribute = (id == TOOLTIP_ATTRIBUTE_SKILL); 
    bool isAttackSpeed = (id == TOOLTIP_ATTRIBUTE_ATTACK_SPEED); 
    bool isArmor = (id == TOOLTIP_ATTRIBUTE_ARMOR);

    if (isStatAttribute || isSkillAttribute || isArmor || isAttackSpeed) {
        for (auto& itData : tooltipData) {
            if (itData.attributeId != id || !itData.isNumber()) {
                continue;
            }

            if (itData.attributeType == -1 && type == 1) {  
                std::ostringstream newValue;
                newValue << itData.getNumber();
                newValue << " [+ " << baseValue << " bonus]";
                itData.attributeValue = newValue.str();
                return;
            }

            if (itData.attributeType == 1 && type == -1) {  
                std::ostringstream newValue;
                newValue << baseValue;  // Novo valor base
                newValue << " [+ " << itData.getNumber() << " bonus]";
                itData.attributeValue = newValue.str();
                return;
            }
        }
    }

    tooltipData.push_back(TooltipData(id, baseValue, type));
}

void Item::getTooltipData(Item* item, uint16_t spriteId, uint16_t count, TooltipDataContainer& tooltipData) {
    const ItemType& it = item ? items[item->getID()] : Item::items.getItemIdByClientId(spriteId);
    
    tooltipData.push_back(TooltipData(TOOLTIP_ATTRIBUTE_NAME, (item ? item->getName() : it.name)));
    tooltipData.push_back(TooltipData(TOOLTIP_ATTRIBUTE_COUNT, (item ? item->getSubType() : count)));
	
    if (!it.description.empty()) {
        tooltipData.push_back(TooltipData(TOOLTIP_ATTRIBUTE_DESCRIPTION, it.description));
    } else {
    }
    
    if (it.pickupable) {
        double weight = (item ? item->getWeight() : it.weight);
        if (weight > 0) {
            tooltipData.push_back(TooltipData(TOOLTIP_ATTRIBUTE_WEIGHT, getWeightDescription(it, weight)));
        }
    }

    if (it.isRune()) {
        tooltipData.push_back(TooltipData(TOOLTIP_ATTRIBUTE_CHARGES, std::max<uint32_t>(1, (item ? item->getSubType() : it.charges))));

        if (!it.runeSpellName.empty()) {
            tooltipData.push_back(TooltipData(TOOLTIP_ATTRIBUTE_RUNE_NAME, it.runeSpellName));
        }
        if (it.runeLevel > 0) {
            tooltipData.push_back(TooltipData(TOOLTIP_ATTRIBUTE_RUNE_LEVEL, it.runeLevel));
        }
        if (it.runeMagLevel > 0) {
            tooltipData.push_back(TooltipData(TOOLTIP_ATTRIBUTE_RUNE_MAGIC_LEVEL, it.runeMagLevel));
        }
    } else if (it.weaponType != WEAPON_NONE) {
        if (it.weaponType == WEAPON_DISTANCE && it.ammoType != AMMO_NONE) {
            if (it.shootRange != 0) {
                tooltipData.push_back(TooltipData(TOOLTIP_ATTRIBUTE_SHOOTRANGE, it.shootRange));
            }
        }
    }

    if (it.isFluidContainer()) {
        if (item && item->getFluidType() != 0) {
            tooltipData.push_back(TooltipData(TOOLTIP_ATTRIBUTE_FLUIDTYPE, items[item->getFluidType()].name));
        } else {
            tooltipData.push_back(TooltipData(TOOLTIP_ATTRIBUTE_FLUIDTYPE, "It is empty."));
        }
    }

    if (it.isContainer()) {
        tooltipData.push_back(TooltipData(TOOLTIP_ATTRIBUTE_CONTAINER_SIZE, it.maxItems));
    }

    if (it.isKey() && item) {
        tooltipData.push_back(TooltipData(TOOLTIP_ATTRIBUTE_KEY, item->getActionId()));
    }

    if (it.charges > 0) {
        tooltipData.push_back(TooltipData(TOOLTIP_ATTRIBUTE_CHARGES, std::max<uint32_t>(1, (item ? item->getSubType() : it.charges))));
    }

    if (it.showDuration) {
        std::ostringstream s;
        if (item && item->hasAttribute(ITEM_ATTRIBUTE_DURATION)) {
            int32_t duration = item->getDuration() / 1000;
            s << "That has energy for ";
            if (duration >= 120) {
                s << duration / 60 << " minutes left";
            } else if (duration > 60) {
                s << "1 minute left";
            } else {
                s << "less than a minute left";
            }
        } else {
            s << "That is brand-new.";
        }
        tooltipData.push_back(TooltipData(TOOLTIP_ATTRIBUTE_DURATION, s.str()));
    }

    if (it.wieldInfo != 0) {
        std::ostringstream s;
        s << "It can only be wielded properly by ";
        if (it.wieldInfo & WIELDINFO_PREMIUM) {
            s << "premium ";
        }
        if (it.wieldInfo & WIELDINFO_VOCREQ) {
            s << it.vocationString;
        } else {
            s << "players";
        }
        if (it.wieldInfo & WIELDINFO_LEVEL) {
            s << " of level " << static_cast<int>(it.minReqLevel) << " or higher";
        }
        if (it.wieldInfo & WIELDINFO_MAGLV) {
            if (it.wieldInfo & WIELDINFO_LEVEL) {
                s << " and";
            } else {
                s << " of";
            }
            s << " magic level " << static_cast<int>(it.minReqMagicLevel) << " or higher";
        }
        tooltipData.push_back(TooltipData(TOOLTIP_ATTRIBUTE_WIELDINFO, s.str()));
    }

    if (item) {
        item->getRarityLevel(tooltipData);
    }

    getTooltipCombats(it, COMBAT_PHYSICALDAMAGE, tooltipData);
    getTooltipCombats(it, COMBAT_ENERGYDAMAGE, tooltipData);
    getTooltipCombats(it, COMBAT_EARTHDAMAGE, tooltipData);
    getTooltipCombats(it, COMBAT_FIREDAMAGE, tooltipData);
    getTooltipCombats(it, COMBAT_LIFEDRAIN, tooltipData);
    getTooltipCombats(it, COMBAT_MANADRAIN, tooltipData);
    getTooltipCombats(it, COMBAT_HEALING, tooltipData);
    getTooltipCombats(it, COMBAT_DROWNDAMAGE, tooltipData);
    getTooltipCombats(it, COMBAT_ICEDAMAGE, tooltipData);
    getTooltipCombats(it, COMBAT_HOLYDAMAGE, tooltipData);
    getTooltipCombats(it, COMBAT_DEATHDAMAGE, tooltipData);

    getTooltipOther(it, tooltipData);

    if (item) {
        item->getTooltipData(it, tooltipData);
    }
}

int32_t Item::getAttributeValue(ItemTooltipAttributes_t id, int32_t type) const {
    int32_t value = 0;
    for (const auto& itData : rarityAttributes) {
        if (itData.first != id) {
            continue;
        }

        if (type != -1 && std::find(itData.second.second.begin(), itData.second.second.end(), type) == itData.second.second.end()) {
            continue;
        }

        value += itData.second.first;
    }

    return value;
}


void Item::getTooltipData(const ItemType& it, TooltipDataContainer& tooltipData)
{
    if (rarityId == ITEM_RARITY_NONE) {
        return;
    }

    for (auto& itAttribute : rarityAttributes) {
        if (itAttribute.second.second.empty()) {
            // Não há subtipos
            addTooltipData(it, tooltipData, itAttribute.first, itAttribute.second.first, -1);
        } else {
            // Existem mais subtipos, como resistências ou habilidades
            for (auto& itType : itAttribute.second.second) {
                addTooltipData(it, tooltipData, itAttribute.first, itAttribute.second.first, itType);
            }
        }
    }
}


void Item::getRarityLevel(TooltipDataContainer& tooltipData)
{
	if (rarityId == ITEM_RARITY_NONE) {
		return;
	}

	tooltipData.push_back(TooltipData(TOOLTIP_ATTRIBUTE_RARITY, rarityId));
}

void Item::setRarityLevel(const Position& pos, bool fromMonster)
{
    (void)pos; // Supressão do aviso de parâmetro não utilizado

    if (isStackable()) {
        return;
    }

    const slots_t slotId = getRaritySlot();
    if (slotId == CONST_SLOT_WHEREEVER) {
        return;
    }

    if (!canHoldRarityLevel(slotId)) {
        return;
    }

    ItemRarity_t id = ItemRarityAttributes::getInstance()->getRandomRarityId(fromMonster);
    if (id == ITEM_RARITY_NONE) {
        return;
    }

    if (ItemRarityAttributes::getInstance()->setRandomAttributes(id, slotId, &rarityAttributes)) {
        // Set the rarity id only if the attributes have been set correctly
        rarityId = id;

        TextColor_t color = TEXTCOLOR_NONE;
        std::string text;
        switch (rarityId) {
            case ITEM_RARITY_RARE: {
                color = TEXTCOLOR_BLUE;
                text = "Rare";
                break;
            }
            case ITEM_RARITY_EPIC: {
                color = TEXTCOLOR_ELECTRICPURPLE;
                text = "Epic";
                break;
            }
            case ITEM_RARITY_LEGENDARY: {
                color = TEXTCOLOR_YELLOW;
                text = "Legendary";
                break;
            }
            case ITEM_RARITY_BRUTAL: {
                color = TEXTCOLOR_RED;
                text = "Brutal";
                break;
            }
            default:
                break;
        }

        // if (color != TEXTCOLOR_NONE) {
        //     g_game.addAnimatedText(pos, TEXTCOLOR_BLUE, text);
        // }
    }
}


bool Item::canHoldRarityLevel(slots_t slotId) const
{
	switch (slotId)
	{
		case CONST_SLOT_WHEREEVER:
		case CONST_SLOT_AMMO:
		{
			return false;
		}
	}

	return true;
}

slots_t Item::getRaritySlot() const
{
	const ItemType& it = items[id];
	const slots_t slotId = getSlotType(it);
	switch (slotId)
	{
		case CONST_SLOT_RIGHT:
		{
			if (it.weaponType == WEAPON_SHIELD)
			{
				return CONST_SLOT_SHIELD;
			}
			else if (it.weaponType == WEAPON_SPELLBOOK)
			{
				return CONST_SLOT_SPELLBOOK;
			}
			return CONST_SLOT_WHEREEVER;
		}
		case CONST_SLOT_LEFT:
		{
			if (it.weaponType == WEAPON_WAND)
			{
				return CONST_SLOT_WAND;
			}
			else if (it.weaponType == WEAPON_SWORD || it.weaponType == WEAPON_CLUB || it.weaponType == WEAPON_AXE || it.weaponType == WEAPON_DISTANCE)
			{
				return CONST_SLOT_WEAPON;
			}
			return CONST_SLOT_WHEREEVER;
		}
		default:
			break;
	}
	return slotId;
}

template<>
const std::string& ItemAttributes::CustomAttribute::get<std::string>() {
	if (value.type() == typeid(std::string)) {
		return boost::get<std::string>(value);
	}

	return emptyString;
}

template<>
const int64_t& ItemAttributes::CustomAttribute::get<int64_t>() {
	if (value.type() == typeid(int64_t)) {
		return boost::get<int64_t>(value);
	}

	return emptyInt;
}

template<>
const double& ItemAttributes::CustomAttribute::get<double>() {
	if (value.type() == typeid(double)) {
		return boost::get<double>(value);
	}

	return emptyDouble;
}

template<>
const bool& ItemAttributes::CustomAttribute::get<bool>() {
	if (value.type() == typeid(bool)) {
		return boost::get<bool>(value);
	}

	return emptyBool;
}

uint8_t Item::getRarity() {
    return rarityId;
}

LootCategory_t Item::getLootCategoryId() const
{
	return items[id].lootType;
}