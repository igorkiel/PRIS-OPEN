local OPCODE_LANGUAGE = 1
local OPCODE_DONATIONGOALS = 2 -- Supondo que esse seja o valor correto, ajuste conforme necessário

function onExtendedOpcode(player, opcode, buffer)
    if opcode == OPCODE_LANGUAGE then
        -- otclient language
        if buffer == 'en' or buffer == 'pt' then
            -- exemplo de definição de idioma do jogador, porque otclient é multi-idioma...
            -- player:setStorageValue(SOME_STORAGE_ID, SOME_VALUE)
        end
        
    elseif opcode == 215 then
        TaskSystem.onAction(player, json.decode(buffer))
    
    elseif opcode == OPCODE_DONATIONGOALS then
        if buffer == "doCollectPersonalReward1" then
            doCollectGoalReward(player, 1)
        elseif buffer == "doCollectPersonalReward2" then
            doCollectGoalReward(player, 2)
        elseif buffer == "doCollectPersonalReward3" then
            doCollectGoalReward(player, 3)
        elseif buffer == "doCollectGlobalReward" then
            doCollectGlobalReward(player)
        end
    end
end
