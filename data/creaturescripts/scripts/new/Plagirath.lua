local posdotp1 = {x=33172, y=31497, z=13}

function MoveStone1() --creates wall back
local criistal2 = getTileItemById(posdotp1, 1353)
if not criistal2 then 
doCreateItem(1353,1,posdotp1)-- Stone pos
else 
doCreateItem(1353,1,posdotp1)
end 

return true

end

function RemoveStone1()
    local cristal1 = getTileItemById(posdotp1, 1353) -- Id do cristal azul que some para dar lugar ao tp
    if cristal1 then
        doRemoveItem(cristal1.uid, 1)
    end
    return true
end

function onKill(cid, target, damage, flags, corpse)
	if not target or not target:isMonster() then
        return true
    end
	if(isMonster(target)) then
		if(string.lower(getCreatureName(target)) == "plagirath") then
		    addEvent(RemoveStone1, 5 * 1000)
     	    addEvent(MoveStone1, 300 * 1000)
		end
	end
	return true
end


