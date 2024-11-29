#include "otpch.h"
#include "protocoldeletecharacter.h"
#include "outputmessage.h"
#include "tasks.h"
#include "configmanager.h"
#include "iodeletecharacterdata.h"
#include "iologindata.h"
#include "ban.h"
#include "game.h"
#include <fmt/format.h>

extern ConfigManager g_config;
extern Game g_game;

void ProtocolDeleteCharacter::disconnectClient(const std::string& message, uint16_t version)
{
    auto output = OutputMessagePool::getOutputMessage();
    output->addByte(version >= 1076 ? 0x0B : 0x0A);
    output->addString(message);
    send(output);
    disconnect();
}

void ProtocolDeleteCharacter::doDeleteCharacter(const std::string& characterName, const std::string& recoveryKey, uint16_t version)
{
    // std::cout << "Received request to delete character: " << characterName << std::endl;

    // Obter o ID da conta
    uint32_t accountId = IOLoginData::getAccountIdByCharacterName(characterName);
    if (accountId == 0) {
        // std::cout << "Failed to get account ID for character: " << characterName << std::endl;
        disconnectClient("Failed to get account ID for character.", version);
        return;
    }

    if (!IODeleteCharacterData::isRecoveryKeyValid(characterName, recoveryKey)) {
        // std::cout << "Invalid recovery key for character: " << characterName << std::endl;
        disconnectClient("Invalid recovery key.", version);
        return;
    }

    if (!IODeleteCharacterData::doesCharacterExist(characterName)) {
        // std::cout << "Character does not exist: " << characterName << std::endl;
        disconnectClient("Character does not exist.", version);
        return;
    }

    if (!IODeleteCharacterData::scheduleCharacterDeletion(characterName)) {
        // std::cout << "Failed to schedule deletion for character: " << characterName << std::endl;
        disconnectClient("Something went wrong, please contact administrator!", version);
        return;
    }

    auto output = OutputMessagePool::getOutputMessage();
    output->addByte(0xFF);
    output->addString("Character deletion has been scheduled. It will be deleted in 2 days.");
    send(output);
    disconnect();
}

void ProtocolDeleteCharacter::onRecvFirstMessage(NetworkMessage& msg)
{
    // std::cout << "onRecvFirstMessage called for delete character" << std::endl;

    if (g_game.getGameState() == GAME_STATE_SHUTDOWN) {
        disconnect();
        return;
    }

    msg.skipBytes(2); // client OS

    uint16_t version = msg.get<uint16_t>();
    if (version >= 971) {
        msg.skipBytes(17);
    } else {
        msg.skipBytes(12);
    }

    if (version <= 760) {
        disconnectClient(fmt::format("Only clients with protocol {:s} allowed!", CLIENT_VERSION_STR), version);
        return;
    }

    if (!Protocol::RSA_decrypt(msg)) {
        disconnect();
        return;
    }

    xtea::key key;
    key[0] = msg.get<uint32_t>();
    key[1] = msg.get<uint32_t>();
    key[2] = msg.get<uint32_t>();
    key[3] = msg.get<uint32_t>();
    enableXTEAEncryption();
    setXTEAKey(std::move(key));

    if (version < CLIENT_VERSION_MIN || version > CLIENT_VERSION_MAX) {
        disconnectClient(fmt::format("Only clients with protocol {:s} allowed!", CLIENT_VERSION_STR), version);
        return;
    }

    if (g_game.getGameState() == GAME_STATE_STARTUP) {
        disconnectClient("Gameworld is starting up. Please wait.", version);
        return;
    }

    if (g_game.getGameState() == GAME_STATE_MAINTAIN) {
        disconnectClient("Gameworld is under maintenance.\nPlease re-connect in a while.", version);
        return;
    }

    BanInfo banInfo;
    auto connection = getConnection();
    if (!connection) {
        return;
    }

    if (IOBan::isIpBanned(connection->getIP(), banInfo)) {
        if (banInfo.reason.empty()) {
            banInfo.reason = "(none)";
        }
        disconnectClient(fmt::format("Your IP has been banned until {:s} by {:s}.\n\nReason specified:\n{:s}", formatDateShort(banInfo.expiresAt), banInfo.bannedBy, banInfo.reason), version);
        return;
    }

    std::string characterName = msg.getString();
    if (characterName.empty()) {
        disconnectClient("Invalid character name.", version);
        return;
    }

    std::string recoveryKey = msg.getString();
    if (recoveryKey.empty()) {
        disconnectClient("Invalid recovery key.", version);
        return;
    }

    auto thisPtr = std::static_pointer_cast<ProtocolDeleteCharacter>(shared_from_this());
    g_dispatcher.addTask(createTask(std::bind(&ProtocolDeleteCharacter::doDeleteCharacter, thisPtr, characterName, recoveryKey, version)));
}
