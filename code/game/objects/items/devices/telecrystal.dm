/* 
Telecrystal item
Does nothing if not suitable antag type, checks for accept_tcrystals = 1 in a mob's mind.
For new antags, make sure to add "player.mind.accept_tcrystals = 1" if you want tradable tcrystals.
*/
/obj/item/device/telecrystal
	name = "red crystal"
	desc = "A strange, red, glowing crystal."
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "telecrystal"
	item_state = "telecrystal"
	force = 5
	origin_tech = list(TECH_MATERIAL = 2, TECH_BLUESPACE = 1, TECH_ILLEGAL = 1)
	
/obj/item/device/telecrystal/attack_self(mob/user as mob)
	if(user.mind.accept_tcrystals) //Checks to see if antag type allows for tcrystals
		user.mind.tcrystals += 1
		user.drop_from_inventory(src)
		qdel(src)
	return
	