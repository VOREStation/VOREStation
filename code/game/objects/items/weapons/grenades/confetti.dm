/obj/item/grenade/confetti
	desc = "It is set to detonate in 2 seconds. These party grenades will make everyone jump with joy (or fright)!"
	name = "grenatti"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "grenade"
	det_time = 20
	item_state = "grenade"
	slot_flags = SLOT_BELT
	var/datum/effect/effect/system/confetti_spread
	var/confetti_strength = 8

/obj/item/grenade/confetti/Initialize(mapload)
	. = ..()
	confetti_spread = new /datum/effect/effect/system/confetti_spread()
	confetti_spread.attach(src)

/obj/item/grenade/confetti/Destroy()
	qdel(confetti_spread)
	confetti_spread = null
	return ..()

/obj/item/grenade/confetti/detonate() //Find a good confetti firework or pop sound effect later
	playsound(src.loc, 'sound/effects/snap.ogg', 50, 1, -3)
	src.confetti_spread.set_up(10, 0, usr.loc)
	spawn(0)
		for(var/i = 1 to confetti_strength)
			src.confetti_spread.start()
			sleep(10)
		qdel(src)

	return

/obj/item/grenade/confetti/party_ball //Intended to be used only with the confetti cannon.
	name = "party ball"
	desc = "Full of !!FUN!!"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "party_ball"
	confetti_strength = 2
	det_time = 1
	throwforce = 0 //Confetti cannon is only fun to shoot at people if it deals no damage.

/obj/item/grenade/confetti/party_ball/detonate() //Could condense this by making the sound a variable in the parent but I'm lazy.
	playsound(src.loc, 'sound/effects/confetti_ball.ogg', 50, 1, -3)
	src.confetti_spread.set_up(10, 0, usr.loc)
	spawn(0)
		for(var/i = 1 to confetti_strength)
			src.confetti_spread.start()
			sleep(10)
		qdel(src)

	return
