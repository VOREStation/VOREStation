/obj/structure/cult/pylon/swarm
	name = "Swarm Construct"
	desc = "A small pod."
	icon = 'icons/mob/swarmbot.dmi'
	icon_state = "pod"
	light_color = "#00B2B2"

	shatter_message = "The energetic field shatters!"
	impact_sound = 'sound/effects/Glasshit.ogg'
	shatter_sound = 'sound/effects/phasein.ogg'

	var/list/active_beams

/obj/structure/cult/pylon/swarm/CanPass(atom/movable/mover, turf/target)
	if(istype(mover, /mob/living))
		var/mob/living/L = mover
		if(L.faction == FACTION_SWARMER)
			return TRUE
	else if(istype(mover, /obj/item/projectile))
		var/obj/item/projectile/P = mover
		if(istype(P.firer) && P.firer.faction == FACTION_SWARMER)
			return TRUE
	return ..()

/obj/structure/cult/pylon/swarm/Initialize()
	. = ..()
	active_beams = list()

/obj/structure/cult/pylon/swarm/Destroy()
	for(var/datum/beam/B in active_beams)
		QDEL_NULL(B)
	active_beams = null
	..()

/obj/structure/cult/pylon/swarm/pylonhit(var/damage)
	if(!isbroken)
		if(prob(1 + damage * 3))
			visible_message("<span class='danger'>[shatter_message]</span>")
			STOP_PROCESSING(SSobj, src)
			playsound(src,shatter_sound, 75, 1)
			isbroken = 1
			density = FALSE
			icon_state = "[initial(icon_state)]-broken"
			set_light(0)

/obj/structure/cult/pylon/swarm/attackpylon(mob/user as mob, var/damage)
	if(!isbroken)
		if(prob(1 + damage * 3))
			user.visible_message(
				"<span class='danger'>[user] smashed \the [src]!</span>",
				"<span class='warning'>You hit \the [src], and its crystal breaks apart!</span>",
				"You hear a tinkle of crystalline shards."
				)
			STOP_PROCESSING(SSobj, src)
			user.do_attack_animation(src)
			playsound(src,shatter_sound, 75, 1)
			isbroken = 1
			density = FALSE
			icon_state = "[initial(icon_state)]-broken"
			set_light(0)
		else
			to_chat(user, "You hit \the [src]!")
			playsound(src,impact_sound, 75, 1)
	else
		if(prob(damage * 2))
			to_chat(user, "You pulverize what was left of \the [src]!")
			qdel(src)
		else
			to_chat(user, "You hit \the [src]!")
		playsound(src,impact_sound, 75, 1)

/obj/structure/cult/pylon/swarm/pylon_unique()
	. = ..()

	return .

/obj/structure/cult/pylon/swarm/zp_well
	name = "Zero Point Well"
	desc = "Infinite cosmic power, itty bitty usability."

	icon_state = "trap"

	description_info = "An infinitely small point in space that may or may not be used to supply power to some form of advanced machine."

	activation_cooldown = 0	// These things run constantly.

/obj/structure/cult/pylon/swarm/zp_well/pylon_unique()
	. = ..()

	for(var/mob/living/silicon/robot/drone/swarm/S in view(3, src))
		var/has_beam = FALSE
		for(var/datum/beam/B in active_beams)
			if(B.target == S)
				has_beam = TRUE
				break

		if(!has_beam)
			active_beams |= Beam(S,icon='icons/effects/beam.dmi',icon_state="holo_beam",time=3 SECONDS,maxdistance=3,beam_type = /obj/effect/ebeam,beam_sleep_time=2)

		if(S.cell)
			S.cell.give(rand(30, 120))

		. = TRUE

	return .

/obj/structure/cult/pylon/swarm/defender
	name = "Zero Point Wall"
	desc = "Infinite cosmic power, itty bitty passability."

	icon_state = "barricade"

	description_info = "An infinitely small point in space spread upon infinitely many finitely-bounded points in space. Nice."

/obj/structure/cult/pylon/swarm/defender/pylonhit(var/damage)
	if(!isbroken)
		if(prob(1 + damage * 3) && damage >= 25)
			visible_message("<span class='danger'>[shatter_message]</span>")
			STOP_PROCESSING(SSobj, src)
			playsound(src,shatter_sound, 75, 1)
			isbroken = 1
			density = FALSE
			icon_state = "[initial(icon_state)]-broken"
			set_light(0)

/obj/structure/cult/pylon/swarm/defender/attackpylon(mob/user as mob, var/damage)
	if(!isbroken)
		if(prob(1 + damage * 2) && damage >= 15)
			user.visible_message(
				"<span class='danger'>[user] smashed \the [src]!</span>",
				"<span class='warning'>You hit \the [src], and its crystal breaks apart!</span>",
				"You hear a tinkle of crystalline shards."
				)
			STOP_PROCESSING(SSobj, src)
			user.do_attack_animation(src)
			playsound(src,shatter_sound, 75, 1)
			isbroken = 1
			density = FALSE
			icon_state = "[initial(icon_state)]-broken"
			set_light(0)
		else
			to_chat(user, "You hit \the [src]!")
			playsound(src,impact_sound, 75, 1)
	else
		if(prob(damage * 3))
			to_chat(user, "You pulverize what was left of \the [src]!")
			qdel(src)
		else
			to_chat(user, "You hit \the [src]!")
		playsound(src,impact_sound, 75, 1)
