local textFloat = GlobalEvent("textFloat")

local effects = {
    -- {position = Position(32097, 32219, 7), text = 'Welcome to OLD Project!', effect = 317},


    -- {position = Position(31648, 32230, 7), text = 'Ateliers', effect = 179}
    
}

function textFloat.onThink(interval)
    for i = 1, #effects do
        local settings = effects[i]
        local spectators = Game.getSpectators(settings.position, false, true, 7, 7, 5, 5)
        if #spectators > 0 then
            if settings.text then
                for i = 1, #spectators do
                    spectators[i]:say(settings.text, TALKTYPE_MONSTER_SAY, false, spectators[i], settings.position)
                end
            end
            if settings.effect then
                settings.position:sendMagicEffect(settings.effect)
            end
        end
    end
   return true
end

textFloat:interval(4000)
textFloat:register()