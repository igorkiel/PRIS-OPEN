#include "otpch.h"
#include "iocreateaccountdata.h"
#include "configmanager.h"
#include "game.h"
#include <random>
#include <algorithm>
#include <curl/curl.h>

// Função para gerar uma chave de recuperação aleatória
std::string IOCreateAccountData::generateRecoveryKey() {
    const char charset[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    const size_t maxIndex = (sizeof(charset) - 1);
    std::string key;
    std::generate_n(std::back_inserter(key), 10, [&]() { 
        return charset[rand() % maxIndex];
    });
    return key;
}

// Função de leitura do corpo do e-mail
size_t payloadSource(void* ptr, size_t size, size_t nmemb, void* userp) {
    std::string* payload = static_cast<std::string*>(userp);
    size_t len = payload->size();

    if (len > size * nmemb) {
        len = size * nmemb;
    }

    memcpy(ptr, payload->c_str(), len);
    payload->erase(0, len);

    return len;
}

bool IOCreateAccountData::sendRecoveryKeyEmail(const std::string& email, const std::string& recoveryKey) {
    CURL* curl;
    CURLcode res = CURLE_OK;
    struct curl_slist* recipients = NULL;
    curl = curl_easy_init();
    if (curl) {
        // Configurar detalhes do servidor SMTP e login
        curl_easy_setopt(curl, CURLOPT_USERNAME, "gameworldofdead@gmail.com");  // Substitua pelo seu e-mail
        curl_easy_setopt(curl, CURLOPT_PASSWORD, "bvnrjukohfsjnlda");         // Substitua pela senha de aplicativo
        curl_easy_setopt(curl, CURLOPT_URL, "smtp://smtp.gmail.com:587");  // Substitua pelo seu servidor SMTP
        curl_easy_setopt(curl, CURLOPT_USE_SSL, CURLUSESSL_ALL);           // Usar SSL/TLS

        // Configurar detalhes do e-mail
        curl_easy_setopt(curl, CURLOPT_MAIL_FROM, "<gameworldofdead@gmail.com>"); // Substitua pelo seu e-mail
        recipients = curl_slist_append(recipients, email.c_str());
        curl_easy_setopt(curl, CURLOPT_MAIL_RCPT, recipients);

        // Configurar corpo do e-mail
        std::string email_body = "To: " + email + "\r\n" +
                                 "From: gameworldofdead@gmail.com\r\n" +           // Substitua pelo seu e-mail
                                 "Subject: Your Recovery Key\r\n" +
                                 "\r\n" +
                                 "Your recovery key is: " + recoveryKey + "\r\n";
        
        // Configure the payload source function and data
        curl_easy_setopt(curl, CURLOPT_READFUNCTION, payloadSource);
        curl_easy_setopt(curl, CURLOPT_READDATA, &email_body);

        // Set the email body type as source
        curl_easy_setopt(curl, CURLOPT_UPLOAD, 1L);

        // Enviar a mensagem
        res = curl_easy_perform(curl);

        // Cleanup
        curl_slist_free_all(recipients);
        curl_easy_cleanup(curl);

        if (res != CURLE_OK) {
            std::cerr << "Failed to send email: " << curl_easy_strerror(res) << std::endl;
            return false;
        }
    }
    return true;
}

bool IOCreateAccountData::isAccountNameValid(const std::string& accountName) {
    return std::regex_match(accountName, std::regex("^[a-zA-Z]{6,}$"));
}

bool IOCreateAccountData::isEmailValid(const std::string& email) {
    return std::regex_match(email, std::regex("(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+$)"));
}

bool IOCreateAccountData::isPasswordValid(const std::string& password) {
    return password.length() > 5 && password.length() < 30;
}

bool IOCreateAccountData::isPasswordConfirmationValid(const std::string& password, const std::string& passwordConfirmation) {
    return password == passwordConfirmation;
}

bool IOCreateAccountData::doesEmailExist(const std::string& email) {
    return doesEntryExist("email", email);
}

bool IOCreateAccountData::doesAccountNameExist(const std::string& accountName) {
    return doesEntryExist("name", accountName);
}

bool IOCreateAccountData::insertAccount(const std::string& accountName, const std::string& email, const std::string& password, const std::string& recoveryKey) {
    Database& db = Database::getInstance();

    std::ostringstream query;
    query << "INSERT INTO `accounts` (`name`, `email`, `password`, `recovery_key`) VALUES ('" << accountName << "', '" << email << "', '" << transformToSHA1(password) << "', '" << recoveryKey << "')";

    if (db.executeQuery(query.str())) {
        return true;
    }

    return false;
}

bool IOCreateAccountData::doesEntryExist(const std::string& fieldName, const std::string& entryValue) {
    Database& db = Database::getInstance();

    std::ostringstream query;
    query << "SELECT `id` FROM `accounts` WHERE `" << fieldName << "` = " << db.escapeString(entryValue);
    DBResult_ptr result = db.storeQuery(query.str());

    if (result) {
        return true;
    }

    return false;
}
