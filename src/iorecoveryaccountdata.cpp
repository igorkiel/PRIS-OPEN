#include "otpch.h"
#include "iorecoveryaccountdata.h"
#include "database.h"
#include <regex>

bool IORecoveryAccountData::isAccountNameValid(const std::string& accountName) {
    return std::regex_match(accountName, std::regex("^[a-zA-Z]{6,}$"));
}

bool IORecoveryAccountData::isRecoveryKeyValid(const std::string& recoveryKey) {
    return std::regex_match(recoveryKey, std::regex("^[A-Z0-9]{10}$"));
}

bool IORecoveryAccountData::isPasswordValid(const std::string& password) {
    return password.length() > 5 && password.length() < 30;
}

bool IORecoveryAccountData::isPasswordConfirmationValid(const std::string& password, const std::string& passwordConfirmation) {
    return password == passwordConfirmation;
}

bool IORecoveryAccountData::doesAccountNameExist(const std::string& accountName) {
    return doesEntryExist("name", accountName);
}

bool IORecoveryAccountData::recoverAccount(const std::string& accountName, const std::string& recoveryKey, const std::string& newPassword) {
    Database& db = Database::getInstance();

    std::ostringstream query;
    query << "UPDATE `accounts` SET `password` = '" << transformToSHA1(newPassword) << "' WHERE `name` = '" << accountName << "' AND `recovery_key` = '" << recoveryKey << "'";

    if (db.executeQuery(query.str())) {
        return true;
    }

    return false;
}

bool IORecoveryAccountData::doesEntryExist(const std::string& fieldName, const std::string& entryValue) {
    Database& db = Database::getInstance();

    std::ostringstream query;
    query << "SELECT `id` FROM `accounts` WHERE `" << fieldName << "` = " << db.escapeString(entryValue);
    DBResult_ptr result = db.storeQuery(query.str());

    if (result) {
        return true;
    }

    return false;
}
