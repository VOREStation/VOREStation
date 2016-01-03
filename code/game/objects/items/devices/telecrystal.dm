/obj/item/device/telecrystal
	name = "Red crystal"
	desc = "A strange, red, glowing crystal."
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "telecrystal"
	item_state = "telecrystal"
	force = 5
	
/obj/item/device/telecrystal/attack_self(mob/user as mob)
	if(user.mind.accept_tcrystals)
		user.mind.tcrystals += 1
		qdel(src)
	return
	