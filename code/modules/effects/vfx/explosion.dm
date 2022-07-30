/obj/effect/vfx/explosion
	name = "explosive particles"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "explosion"
	opacity = 1
	anchored = 1
	mouse_opacity = 0
	pixel_x = -32
	pixel_y = -32

/obj/effect/vfx/explosion/Initialize()
	. = ..()
	QDEL_IN(src, 1 SECONDS)

/datum/effect_system/explosion/set_up(n = 0, c = 0, turf/loc)
	location = get_turf(loc)

/datum/effect_system/explosion/start()
	new/obj/effect/vfx/explosion( location )
	var/datum/effect_system/expl_particles/P = new/datum/effect_system/expl_particles()
	P.set_up(10,0,location)
	P.start()
	spawn(5)
		var/datum/effect_system/smoke_spread/S = new/datum/effect_system/smoke_spread()
		S.set_up(5,0,location,null)
		S.start()

/datum/effect_system/explosion/smokeless/start()
	new/obj/effect/vfx/explosion(location)
	var/datum/effect_system/expl_particles/P = new/datum/effect_system/expl_particles()
	P.set_up(10,0,location)
	P.start()

/datum/effect_system/reagents_explosion
	var/amount 						// TNT equivalent
	var/flashing = 0			// does explosion creates flash effect?
	var/flashing_factor = 0		// factor of how powerful the flash effect relatively to the explosion

/datum/effect_system/reagents_explosion/set_up(amt, loc, flash = 0, flash_fact = 0)
	amount = amt
	if(istype(loc, /turf/))
		location = loc
	else
		location = get_turf(loc)

	flashing = flash
	flashing_factor = flash_fact

	return

/datum/effect_system/reagents_explosion/start()
	if (amount <= 2)
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread()
		s.set_up(2, 1, location)
		s.start()

		for(var/mob/M in viewers(5, location))
			to_chat(M, "<span class='warning'>The solution violently explodes.</span>")
		for(var/mob/M in viewers(1, location))
			if (prob (50 * amount))
				to_chat(M, "<span class='warning'>The explosion knocks you down.</span>")
				M.Weaken(rand(1,5))
		return
	else
		var/devst = -1
		var/heavy = -1
		var/light = -1
		var/flash = -1

		// Clamp all values to fractions of max_explosion_range, following the same pattern as for tank transfer bombs
		if (round(amount/12) > 0)
			devst = devst + amount/12

		if (round(amount/6) > 0)
			heavy = heavy + amount/6

		if (round(amount/3) > 0)
			light = light + amount/3

		if (flashing && flashing_factor)
			flash = (amount/4) * flashing_factor

		for(var/mob/M in viewers(8, location))
			to_chat(M, "<span class='warning'>The solution violently explodes.</span>")

		explosion(
			location,
			round(min(devst, BOMBCAP_DVSTN_RADIUS)),
			round(min(heavy, BOMBCAP_HEAVY_RADIUS)),
			round(min(light, BOMBCAP_LIGHT_RADIUS)),
			round(min(flash, BOMBCAP_FLASH_RADIUS))
			)
