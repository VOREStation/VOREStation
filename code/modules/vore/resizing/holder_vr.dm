/obj/item/weapon/holder/dropped(mob/user)
	if (held_mob?.loc != src || isturf(loc))
		var/held = held_mob
		dump_mob()
		held_mob = held
