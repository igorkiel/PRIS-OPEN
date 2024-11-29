#ifndef PROTOCOLDELETECHARACTER_H
#define PROTOCOLDELETECHARACTER_H

#include "protocol.h"

class NetworkMessage;
class OutputMessage;

class ProtocolDeleteCharacter : public Protocol
{
    public:
        // static protocol information
        enum { server_sends_first = false };
        enum { protocol_identifier = 0x4 };
        enum { use_checksum = true };
        static const char* protocol_name() {
            return "delete character protocol";
        }

        explicit ProtocolDeleteCharacter(Connection_ptr connection) : Protocol(connection) {}

        void onRecvFirstMessage(NetworkMessage& msg) override;

    private:
        void disconnectClient(const std::string& message, uint16_t version);
        void doDeleteCharacter(const std::string& characterName, const std::string& recoveryKey, uint16_t version);
};

#endif
