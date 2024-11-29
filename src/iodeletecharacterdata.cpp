#include "otpch.h"
#include "iodeletecharacterdata.h"
#include "database.h"

bool IODeleteCharacterData::doesCharacterExist(const std::string& characterName)
{
    Database& db = Database::getInstance();
    std::ostringstream query;
    query << "SELECT `id` FROM `players` WHERE `name` = " << db.escapeString(characterName);
    DBResult_ptr result = db.storeQuery(query.str());

    return result != nullptr;
}

bool IODeleteCharacterData::scheduleCharacterDeletion(const std::string& characterName)
{
    Database& db = Database::getInstance();
    std::ostringstream query;
    query << "UPDATE `players` SET `deletion_time` = DATE_ADD(NOW(), INTERVAL 2 DAY) WHERE `name` = " << db.escapeString(characterName);

    return db.executeQuery(query.str());
}

bool IODeleteCharacterData::isRecoveryKeyValid(const std::string& characterName, const std::string& recoveryKey)
{
    Database& db = Database::getInstance();
    std::ostringstream query;
    query << "SELECT a.`id` FROM `accounts` a JOIN `players` p ON a.`id` = p.`account_id` WHERE p.`name` = " << db.escapeString(characterName) << " AND a.`recovery_key` = " << db.escapeString(recoveryKey);
    DBResult_ptr result = db.storeQuery(query.str());

    return result != nullptr;
}

void IODeleteCharacterData::deleteScheduledCharacters()
{
    Database& db = Database::getInstance();
    std::ostringstream query;
    query << "DELETE FROM `players` WHERE `deletion_time` IS NOT NULL AND `deletion_time` <= NOW()";
    db.executeQuery(query.str());
}

void IODeleteCharacterData::updateLastDeletion(uint32_t accountId)
{
    Database& db = Database::getInstance();
    std::ostringstream query;
    query << "UPDATE `accounts` SET `last_deletion` = NOW() WHERE `id` = " << accountId;
    db.executeQuery(query.str());
}
