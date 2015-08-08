/obj/item/weapon/grenade/explosive
	desc = "A fragmentation grenade, optimized for harming personnel without causing massive structural damage."
	name = "frag grenade"
	icon = 'icons/obj/grenade.dmi'
	det_time = 50
	icon_state = "grenade"
	item_state = "grenade"
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 3)

/obj/item/weapon/grenade/explosive/prime()
	..()
	spawn(0)
		explosion(src.loc,-1,-1,2)	//If you're within two tiles of the grenade, you get hit twice, which tends to do 50+ brute and cause fractures.
		explosion(src.loc,-1,-1,4)	//This is preferable to increasing the severity, so we don't decap with frags.
		qdel(src)
	return