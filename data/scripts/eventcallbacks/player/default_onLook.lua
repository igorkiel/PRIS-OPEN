local ec = EventCallback

local pouchItemId = 28165 -- ID of the pouch item

ec.onLook = function(self, thing, position, distance, description)
    -- Verifica se o item olhado é a gold pouch
    if thing:getId() == pouchItemId then
        local goldCoins = 0
        local platinumCoins = 0
        local crystalCoins = 0

        local items = thing:getItems()
        for _, containedItem in ipairs(items) do
            if containedItem:getId() == 2148 then
                goldCoins = goldCoins + containedItem:getCount()
            elseif containedItem:getId() == 2152 then
                platinumCoins = platinumCoins + containedItem:getCount()
            elseif containedItem:getId() == 2160 then
                crystalCoins = crystalCoins + containedItem:getCount()
            end
        end

        local pouchDescription = "This pouch contains:\n" ..
            goldCoins .. " gold coins,\n" ..
            platinumCoins .. " platinum coins,\n" ..
            crystalCoins .. " crystal coins."
        
        description = pouchDescription
    else
        description = "You see " .. thing:getDescription(distance)
        if self:getGroup():getAccess() then
            if thing:isItem() then
                description = string.format("%s\nItem ID: %d", description, thing:getId())

                local actionId = thing:getActionId()
                if actionId ~= 0 then
                    description = string.format("%s, Action ID: %d", description, actionId)
                end

                local uniqueId = thing:getAttribute(ITEM_ATTRIBUTE_UNIQUEID)
                if uniqueId > 0 and uniqueId < 65536 then
                    description = string.format("%s, Unique ID: %d", description, uniqueId)
                end

                local itemType = thing:getType()

                local transformEquipId = itemType:getTransformEquipId()
                local transformDeEquipId = itemType:getTransformDeEquipId()
                if transformEquipId ~= 0 then
                    description = string.format("%s\nTransforms to: %d (onEquip)", description, transformEquipId)
                elseif transformDeEquipId ~= 0 then
                    description = string.format("%s\nTransforms to: %d (onDeEquip)", description, transformDeEquipId)
                end

                local decayId = itemType:getDecayId()
                if decayId ~= -1 then
                    description = string.format("%s\nDecays to: %d", description, decayId)
                end
            elseif thing:isCreature() then
                local str = "%s\nHealth: %d / %d"
                if thing:isPlayer() and thing:getMaxMana() > 0 then
                    str = string.format("%s, Mana: %d / %d", str, thing:getMana(), thing:getMaxMana())
                end
                description = string.format(str, description, thing:getHealth(), thing:getMaxHealth()) .. "."
            end

            local position = thing:getPosition()
            description = string.format(
                "%s\nPosition: %d, %d, %d",
                description, position.x, position.y, position.z
            )

            if thing:isCreature() then
                if thing:isPlayer() then
                    description = string.format("%s\nIP: %s.", description, Game.convertIpToString(thing:getIp()))
                end
            end
        end
    end
    return description
end

ec:register()
