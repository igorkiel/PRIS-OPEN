#include "otpch.h"
#include "iocreatecharacterdata.h"
#include <regex>

bool IOCreateCharacterData::isCharacterNameValid(const std::string& characterName) {
    return std::regex_match(characterName, std::regex("^[a-zA-Z ]{3,}$"));
}

bool IOCreateCharacterData::doesCharacterNameExist(const std::string& characterName) {
    Database& db = Database::getInstance();

    std::ostringstream query;
    query << "SELECT `id` FROM `players` WHERE `name` = " << db.escapeString(characterName);
    DBResult_ptr result = db.storeQuery(query.str());

    if (result) {
        return true;
    }

    return false;
}

bool IOCreateCharacterData::insertCharacter(const Account& account, const std::string& characterName, uint16_t townId, uint8_t sex, uint16_t vocation) {
    // Verifica o número de personagens existentes na conta
    if (getCharacterCount(account.id) >= 6) {
        // std::cout << "A conta já possui o número máximo de 5 personagens." << std::endl;
        return false;
    }

    uint16_t healthMax = 150, capMax = 400;
    uint16_t manaMax = 0;
    uint16_t lookType = (sex == 1) ? 128 : 136; // Male: 128, Female: 136

    uint32_t level = 1;
    uint64_t exp = 0;

    Database& db = Database::getInstance();
    std::ostringstream query;
    query << "INSERT INTO `players` (`name`, `group_id`, `account_id`, `level`, `vocation`, `health`, `healthmax`, `experience`, `lookbody`, `lookfeet`, `lookhead`, `looklegs`, `looktype`, `lookaddons`, `maglevel`, `mana`, `manamax`, `manaspent`, `soul`, `town_id`, `posx`, `posy`, `posz`, `conditions`, `cap`, `sex`, `lastlogin`, `lastip`, `skull`, `skulltime`, `save`) VALUES ("
          << db.escapeString(characterName) << ", 1, " << account.id << ", " << level << ", " << vocation << ", " << healthMax << ", " << healthMax << ", " << exp << ", 68, 76, 78, 39, " << lookType << ", 0, 0, " << manaMax << ", " << manaMax << ", 0, 100, " << townId << ", 1047, 1048, 7, NULL, " << capMax << ", " << static_cast<int>(sex) << ", 0, 0, 0, 0, 1)";
    
    if (db.executeQuery(query.str())) {
        return true;
    }

    return false;
}

// Definição da função getCharacterCount
int IOCreateCharacterData::getCharacterCount(uint32_t accountId) {
    Database& db = Database::getInstance();

    std::ostringstream query;
    query << "SELECT COUNT(*) as `count` FROM `players` WHERE `account_id` = " << accountId;
    DBResult_ptr result = db.storeQuery(query.str());

    if (result) {
        return result->getNumber<int>("count");
    }

    return 0;
}
