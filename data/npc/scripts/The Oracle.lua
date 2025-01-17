local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

local vocation = {}
local town = {}

local config = {
    towns = {
	    ["ab'dendriel"] = 1,
	    ["kazordoon"] = 2,
	    ["thais"] = 3,
        ["venore"] = 4,
        ["carlin"] = 5
    },

    vocations = {
        ["sorcerer"] = {
            text = "A SORCERER! ARE YOU SURE? THIS DECISION IS IRREVERSIBLE!",
            vocationId = 1,
        },

        ["druid"] = {
            text = "A DRUID! ARE YOU SURE? THIS DECISION IS IRREVERSIBLE!",
            vocationId = 2,
        },

        ["paladin"] = {
            text = "A PALADIN! ARE YOU SURE? THIS DECISION IS IRREVERSIBLE!",
            vocationId = 3,
        },

        ["knight"] = {
            text = "A KNIGHT! ARE YOU SURE? THIS DECISION IS IRREVERSIBLE!",
            vocationId = 4,
        }
    }
}

local itemsToRemove = {
}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local function greetCallback(cid)
    local player = Player(cid)
    local level = player:getLevel()
    if level < 8 then
        npcHandler:say("CHILD! COME BACK WHEN YOU HAVE GROWN UP!", cid)
        npcHandler:resetNpc(cid)
        return false
    elseif level > 20 then
        npcHandler:say(player:getName() ..", I CAN'T LET YOU LEAVE - YOU ARE TOO STRONG ALREADY! YOU CAN ONLY LEAVE WITH LEVEL 20 OR LOWER.", cid)
        npcHandler:resetNpc(cid)
        return false
    elseif player:getVocation():getId() > 0 then
        npcHandler:say("YOU ALREADY HAVE A VOCATION!", cid)
        npcHandler:resetNpc(cid)
        return false
    else
        npcHandler:setMessage(MESSAGE_GREET, player:getName() ..", ARE YOU PREPARED TO FACE YOUR DESTINY?")
    end
    return true
end

local function creatureSayCallback(cid, type, msg)
    if not npcHandler:isFocused(cid) then
        return false
    end

    local player = Player(cid)
    if npcHandler.topic[cid] == 0 then
        if msgcontains(msg, "yes") then
            npcHandler:say("IN WHICH TOWN DO YOU WANT TO LIVE: {CARLIN}, {THAIS}, {VENORE}, {KAZORDOON}, OR {AB'DENDRIEL}?", cid) 
            npcHandler.topic[cid] = 1                                                                 
        end
    elseif npcHandler.topic[cid] == 1 then
        local cityTable = config.towns[msg:lower()]
        if cityTable then
            town[cid] = cityTable
            npcHandler:say("IN ".. string.upper(msg) .."! AND WHAT PROFESSION HAVE YOU CHOSEN: {KNIGHT}, {PALADIN}, {SORCERER}, OR {DRUID}?", cid)
            npcHandler.topic[cid] = 2
        else
            npcHandler:say("IN WHICH TOWN DO YOU WANT TO LIVE: {CARLIN}, {THAIS}, OR {VENORE}?", cid)
        end
    elseif npcHandler.topic[cid] == 2 then
        local vocationTable = config.vocations[msg:lower()]
        if vocationTable then
            npcHandler:say(vocationTable.text, cid)
            npcHandler.topic[cid] = 3
            vocation[cid] = vocationTable.vocationId
        else
            npcHandler:say("{KNIGHT}, {PALADIN}, {SORCERER}, OR {DRUID}?", cid)
        end
    elseif npcHandler.topic[cid] == 3 then
        if msgcontains(msg, "yes") then
            npcHandler:say("SO BE IT!", cid)
            player:setVocation(Vocation(vocation[cid]))
            player:setTown(Town(town[cid]))
            player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
            player:teleportTo(Town(town[cid]):getTemplePosition())
            player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
            local targetVocation = config.vocations[Vocation(vocation[cid]):getName():lower()]
        else
            npcHandler:say("THEN WHAT? {KNIGHT}, {PALADIN}, {SORCERER}, OR {DRUID}?", cid)
            npcHandler.topic[cid] = 2
        end
    end
    return true
end

local function onAddFocus(cid)
    town[cid] = 0
    vocation[cid] = 0
end

local function onReleaseFocus(cid)
    town[cid] = nil
    vocation[cid] = nil
end

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setMessage(MESSAGE_FAREWELL, "COME BACK WHEN YOU ARE PREPARED TO FACE YOUR DESTINY!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "COME BACK WHEN YOU ARE PREPARED TO FACE YOUR DESTINY!")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
