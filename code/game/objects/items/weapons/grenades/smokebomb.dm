/obj/item/weapon/grenade/smokebomb
	desc = "It is set to detonate in 2 seconds."
	name = "smoke bomb"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "flashbang"
	det_time = 20
	item_state = "flashbang"
	slot_flags = SLOT_BELT
	var/datum/effect/effect/system/smoke_spread/bad/smoke
	var/smoke_color
	var/smoke_strength = 4

/obj/item/weapon/grenade/smokebomb/red
	smoke_color = "#FF0000"

/obj/item/weapon/grenade/smokebomb/blue
	smoke_color = "#0000FF"

/obj/item/weapon/grenade/smokebomb/New()
	..()
	src.smoke = PoolOrNew(/datum/effect/effect/system/smoke_spread/bad)
	src.smoke.attach(src)

/obj/item/weapon/grenade/smokebomb/Destroy()
	qdel(smoke)
	smoke = null
	return ..()

/obj/item/weapon/grenade/smokebomb/prime()
	playsound(src.loc, 'sound/effects/smoke.ogg', 50, 1, -3)
	src.smoke.set_up(10, 0, usr.loc)
	spawn(0)
		for(var/i = 1 to smoke_strength)
			src.smoke.start(smoke_color)
			sleep(10)

	for(var/obj/effect/blob/B in view(8,src))
		var/damage = round(30/(get_dist(B,src)+1))
		B.health -= damage
		B.update_icon()
	sleep(80)
	qdel(src)
	return
