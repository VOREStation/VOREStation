/obj/effect/anomaly/ectoplasm
	name = "ectoplasm anomaly"
	desc = "It looks like the souls of the damned are trying to break into the realm of the living again. How upsetting."
	icon_state = "ectoplasm"
	anomaly_core = /obj/item/assembly/signaler/anomaly/ectoplasm
	lifespan = ANOMALY_COUNTDOWN_TIMER + 2 SECONDS

	///Blocks the anomaly from updating ghost count. Used in case an admin wants to rig the anomaly to be a certain size or intensity.
	var/override_ghosts = FALSE
	///The numerical power of the anomaly. Calculated in anomalyEffect. Also used in determining the category of detonation effects.
	var/effect_power = 0
	///The actual number of ghosts orbiting the anomaly.
	var/ghosts_orbiting = 0

/obj/effect/anomaly/ectoplasm/examine(mob/user, infix, suffix)
	. = ..()

	if(isobserver(user))
		. += span_info("Orbiting this anomaly will increase the size and intensity of its effects.")

	switch(effect_power)
		if(0 to 25)
			. += span_notice("The space around the anomaly faintly resonates. It doesn't seem very powerful at the moment.")
		if(26 to 49)
			. += span_notice("The space around the anomaly seems to vibrate, letting out a noise that sounds like ghastly moaning. Someone should probably do something about that.")
		if(50 to 100)
			. += span_alert("The anomaly pulsates heavily, about to burst with unearthly energy. This can't be good.")

/obj/effect/anomaly/ectoplasm/anomalyEffect(seconds_per_tick)
	. = ..()

	if(override_ghosts)
		return

	ghosts_orbiting = get_orbiters_count()

	if(ghosts_orbiting)
		var/total_death = 0
		for(var/mob/mob in GLOB.dead_mob_list)
			if(mob.client)
				total_death++
		effect_power = ghosts_orbiting / total_death * 100
	else
		effect_power = 0

	intesity_update()

/obj/effect/anomaly/ectoplasm/detonate()
	. = ..()

	if(effect_power < 10)
		new /obj/effect/temp_visual/revenant/cracks(get_turf(src))
		return

	if(effect_power >= 10)
		var/effect_range = ghosts_orbiting + 3
		for(var/impacted_thing in range(effect_range, src))
			if(isfloorturf(impacted_thing))
