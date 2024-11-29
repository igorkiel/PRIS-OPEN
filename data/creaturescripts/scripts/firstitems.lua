local config = {
    [0] = { -- None
        items = {
			{2650, 1}, -- jacket
			{2649, 1}, -- leather legs
			{2461, 1}, -- leather helmet
			{2643, 1}, -- leather boots
			{2661, 1},  -- scarf
            {2512, 1}, -- wooden shield
        },
        container = {
            {2120, 1},  -- rope
			{2554, 1},  -- shovel
			{2379, 1}, -- dagger
			{2380, 1}, -- hand axe
			{2674, 5}, -- red apple
            {2448, 1}, -- studded club
            
        }
    },
}
function onLogin(player)
    if player:getLastLoginSaved() == 0 then
        local vocationId = player:getVocation():getId()

        if config[vocationId] then
            local vocationConfig = config[vocationId]

            -- Give items
            for _, item in ipairs(vocationConfig.items) do
                player:addItem(item[1], item[2])
            end

            -- Create a container and add items to it
            local container = player:addItem(1988, 1)
            for _, containerItem in ipairs(vocationConfig.container) do
                container:addItem(containerItem[1], containerItem[2])
            end
        end
    end
    return true
end





