#pragma once
#include "database.h"
#include "account.h"
#include <regex>

class IOCreateCharacterData
{
    public:
        static bool isCharacterNameValid(const std::string& characterName);
        static bool doesCharacterNameExist(const std::string& characterName);
        static bool insertCharacter(const Account& account, const std::string& characterName, uint16_t townId, uint8_t sex, uint16_t vocation);
        
        // Adicione a declaração de getCharacterCount aqui
        static int getCharacterCount(uint32_t accountId);
};
