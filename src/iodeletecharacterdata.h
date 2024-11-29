#ifndef IODELETECHARACTERDATA_H
#define IODELETECHARACTERDATA_H

#include <string>

class IODeleteCharacterData
{
public:
    static bool doesCharacterExist(const std::string& characterName);
    static bool scheduleCharacterDeletion(const std::string& characterName);
    static bool isRecoveryKeyValid(const std::string& characterName, const std::string& recoveryKey);
    static void deleteScheduledCharacters();
    static void updateLastDeletion(uint32_t accountId);
};

#endif
