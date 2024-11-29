#include "otpch.h"
#include "protocolrecoveryaccount.h"
#include "outputmessage.h"
#include "tasks.h"
#include "configmanager.h"
#include "iorecoveryaccountdata.h"
#include "ban.h"
#include "game.h"
#include <fmt/format.h>

extern ConfigManager g_config;
extern Game g_game;

void ProtocolRecoveryAccount::disconnectClient(const std::string& message, uint16_t version)
{
    auto output = OutputMessagePool::getOutputMessage();
    output->addByte(version >= 1076 ? 0x0B : 0x0A);
    output->addString(message);
    send(output);
    disconnect();
}

void ProtocolRecoveryAccount::doRecoverAccount(const std::string& accountName, const std::string& recoveryKey, const std::string& newPassword, const std::string& newPasswordConfirmation, uint16_t version)
{
    std::cout << "doRecoverAccount called with accountName: " << accountName << ", recoveryKey: " << recoveryKey << ", newPassword: " << newPassword << ", newPasswordConfirmation: " << newPasswordConfirmation << std::endl;

    if (accountName.empty()) {
        disconnectClient("Account name is invalid.", version);
        return;
    }

    if (recoveryKey.empty()) {
        disconnectClient("Recovery key is invalid.", version);
        return;
    }

    if (newPassword.empty()) {
        disconnectClient("New password is invalid.", version);
        return;
    }

    if (newPasswordConfirmation.empty()) {
        disconnectClient("New password confirmation is invalid.", version);
        return;
    }

    if (!IORecoveryAccountData::isAccountNameValid(accountName)) {
        disconnectClient("Account name is invalid.", version);
        return;
    }

    if (!IORecoveryAccountData::doesAccountNameExist(accountName)) {
        disconnectClient("Account name does not exist.", version);
        return;
    }

    if (!IORecoveryAccountData::isRecoveryKeyValid(recoveryKey)) {
        disconnectClient("Recovery key is invalid.", version);
        return;
    }

    if (!IORecoveryAccountData::isPasswordValid(newPassword)) {
        disconnectClient("New password is invalid.", version);
        return;
    }

    if (!IORecoveryAccountData::isPasswordConfirmationValid(newPassword, newPasswordConfirmation)) {
        disconnectClient("New password confirmation is invalid.", version);
        return;
    }

    if (!IORecoveryAccountData::recoverAccount(accountName, recoveryKey, newPassword)) {
        disconnectClient("Account recovery failed. Please check your details and try again.", version);
        return;
    }

    auto output = OutputMessagePool::getOutputMessage();
    output->addByte(0xFF);
    output->addString("Your account has been recovered. Please use your new password to log in.");
    send(output);
    disconnect();
}

void ProtocolRecoveryAccount::onRecvFirstMessage(NetworkMessage& msg)
{
    std::cout << "onRecvFirstMessage called" << std::endl;

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

    std::string accountName = msg.getString();
    std::string recoveryKey = msg.getString();
    std::string newPassword = msg.getString();
    std::string newPasswordConfirmation = msg.getString();

    std::cout << "Received data - accountName: " << accountName << ", recoveryKey: " << recoveryKey << ", newPassword: " << newPassword << ", newPasswordConfirmation: " << newPasswordConfirmation << std::endl;

    auto thisPtr = std::static_pointer_cast<ProtocolRecoveryAccount>(shared_from_this());
    g_dispatcher.addTask(createTask(std::bind(&ProtocolRecoveryAccount::doRecoverAccount, thisPtr, accountName, recoveryKey, newPassword, newPasswordConfirmation, version)));
}
