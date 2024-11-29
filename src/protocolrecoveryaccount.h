#ifndef PROTOCOLRECOVERYACCOUNT_H
#define PROTOCOLRECOVERYACCOUNT_H

#include "protocol.h"

class NetworkMessage;
class OutputMessage;

class ProtocolRecoveryAccount : public Protocol
{
    public:
        // static protocol information
        enum { server_sends_first = false };
        enum { protocol_identifier = 0x5 }; // Atualize com o identificador correto
        enum { use_checksum = true };
        static const char* protocol_name() {
            return "recovery account protocol";
        }

        explicit ProtocolRecoveryAccount(Connection_ptr connection) : Protocol(connection) {}

        void onRecvFirstMessage(NetworkMessage& msg) override;

    private:
        void disconnectClient(const std::string& message, uint16_t version);
        void doRecoverAccount(const std::string& accountName, const std::string& recoveryKey, const std::string& newPassword, const std::string& newPasswordConfirmation, uint16_t version);
};

#endif
