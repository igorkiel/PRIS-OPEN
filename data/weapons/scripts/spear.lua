local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_SPEAR)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
combat:setFormula(COMBAT_FORMULA_SKILL, 0, 0, 1, 0)

function onUseWeapon(player, variant)

    local weapons = {2389, 3965, 7367}
	local boolean = combat:execute(player, variant)
    local targetCreature = player:getTarget()
    
    if targetCreature then
        local targetPosition = targetCreature:getPosition()
        local item = player:getSlotItem(CONST_SLOT_LEFT) ==2389 or player:getSlotItem(CONST_SLOT_RIGHT) == 2389

        if isInArray(weapons, player:getSlotItem(CONST_SLOT_LEFT):getId()) then
            item = player:getSlotItem(CONST_SLOT_LEFT)
        elseif isInArray(weapons, player:getSlotItem(CONST_SLOT_RIGHT):getId()) then
            item = player:getSlotItem(CONST_SLOT_RIGHT)
        end

        if item then
            local itemType = ItemType(item:getId())
            if itemType:isStackable() and item:getCount() > 1 then
                item:remove(1)
                Game.createItem(item:getId(), 1, targetPosition)
            else
                item:moveTo(targetPosition)
            end
        end
    end

	if not boolean then
		return false
	end

	local target = variant:getNumber()
	if target ~= 0 then
	end
	return boolean
end





