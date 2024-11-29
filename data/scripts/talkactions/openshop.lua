local talk = TalkAction("/shop")

function talk.onSay(player, words, param)
	if param == '' then
		player:createShop("Welcome to my shop!")
	else
		local seller = Player(param)
		if seller then
			player:openRemoteShop(seller:getId())
		else
			player:popupFYI("Player not found")
		end
	end
end

talk:separator(" ")
talk:register()
