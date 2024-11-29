#ifndef IORECOVERYACCOUNTDATA_H
#define IORECOVERYACCOUNTDATA_H

#include "account.h"
#include "player.h"
#include "database.h"
#include <regex>

class IORecoveryAccountData
{
    public:
        static bool isAccountNameValid(const std::string& accountName);
        static bool isRecoveryKeyValid(const std::string& recoveryKey);
        static bool isPasswordValid(const std::string& password);
        static bool isPasswordConfirmationValid(const std::string& password, const std::string& passwordConfirmation);
        static bool doesAccountNameExist(const std::string& accountName);
        static bool recoverAccount(const std::string& accountName, const std::string& recoveryKey, const std::string& newPassword);

    private:
        static bool doesEntryExist(const std::string& fieldName, const std::string& entryValue);
};

#endif
