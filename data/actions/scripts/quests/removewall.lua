local REMOVE_WALLS = {
    Position(32596, 32103, 14),
    Position(32597, 32103, 14),
    Position(32598, 32103, 14),
    Position(32599, 32103, 14),
    Position(32600, 32103, 14)
}

local CREATE_WALLS = {
    Position(32592, 32104, 14),
    Position(32592, 32106, 14),
    Position(32592, 32105, 14)
}



local REMOVE_WALL_ID = 1026 -- ID da parede a ser removida
local CREATE_WALL_ID = 1025 -- ID da parede a ser criada
local STORAGE_KEY = 12345 -- Substitua por um ID de storage único

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if player:getLevel() < 20 then
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "You need to be level 20 or higher to use this lever.")
        return true
    end

    if Game.getStorageValue(STORAGE_KEY) == 1 then
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "You can only use this lever once until the next global save.")
        return true
    end

    local function toggleWalls()
        for i = 1, #REMOVE_WALLS do
            local wall = Tile(REMOVE_WALLS[i]):getItemById(REMOVE_WALL_ID)
            if wall then
                wall:remove()
            else
                Game.createItem(REMOVE_WALL_ID, 1, REMOVE_WALLS[i])
            end
        end
        for i = 1, #CREATE_WALLS do
            local wall = Tile(CREATE_WALLS[i]):getItemById(CREATE_WALL_ID)
            if wall then
                wall:remove()
            else
                Game.createItem(CREATE_WALL_ID, 1, CREATE_WALLS[i])
            end
        end
    end

    toggleWalls()

    Game.setStorageValue(STORAGE_KEY, 1)
    player:sendTextMessage(MESSAGE_STATUS_SMALL, "The walls have been toggled. You can use this lever again after the next global save.")

    return true
end
