function Party:onJoin(player)
	if hasEventCallback(EVENT_CALLBACK_ONJOIN) then
		return EventCallback(EVENT_CALLBACK_ONJOIN, self, player)
	else
		return true
	end
end

function Party:onLeave(player)
	if hasEventCallback(EVENT_CALLBACK_ONLEAVE) then
		return EventCallback(EVENT_CALLBACK_ONLEAVE, self, player)
	else
		return true
	end
end

function Party:onDisband()
	if hasEventCallback(EVENT_CALLBACK_ONDISBAND) then
		return EventCallback(EVENT_CALLBACK_ONDISBAND, self)
	else
		return true
	end
end

function Party:onShareExperience(exp)
	local sharedExperienceMultiplier
	local vocationsIds = {}

	local vocationId = self:getLeader():getVocation():getBase():getId()
	if vocationId ~= VOCATION_NONE then
		table.insert(vocationsIds, vocationId)
	end

	for _, member in ipairs(self:getMembers()) do
		vocationId = member:getVocation():getBase():getId()
		if not table.contains(vocationsIds, vocationId) and vocationId ~= VOCATION_NONE then
			table.insert(vocationsIds, vocationId)
		end
	end

	local size = #vocationsIds

	sharedExperienceMultiplier = 1.05 + (math.min(size, 4) - 1) * 0.05 -- igor: comeca com bonus em *1.05 e soma + 0.05 para cada size a mais
	exp = math.ceil((exp * sharedExperienceMultiplier) / (#self:getMembers() + 1))
	local rawExp = exp

	return hasEventCallback(EVENT_CALLBACK_ONSHAREEXPERIENCE) and EventCallback(EVENT_CALLBACK_ONSHAREEXPERIENCE, self, exp, rawExp) or exp
end