
/obj/effect/temporary_effect/eruption
	name = "eruption"
	desc = "Oh shit!"
	icon_state = "pool"
	icon = 'icons/effects/64x64.dmi'
	time_to_die = 0.7 SECONDS

	pixel_x = -16

/obj/effect/temporary_effect/eruption/Initialize(mapload, var/ttd = 10 SECONDS, var/newcolor)
	if(ttd)
		time_to_die += ttd
	addtimer(CALLBACK(src, PROC_REF(on_eruption), get_turf(src)), time_to_die - 0.2 SECONDS, TIMER_DELETE_ME)

	if(newcolor)
		color = newcolor

	. = ..()
	flick("[icon_state]_create",src)

/obj/effect/temporary_effect/eruption/proc/on_eruption(var/turf/Target)	// Override for specific functions, as below.
	flick("[icon_state]_erupt",src)
	return TRUE

/obj/effect/temporary_effect/eruption/testing/on_eruption(var/turf/Target)
	flick("[icon_state]_erupt",src)
	if(Target)
		new /obj/effect/explosion(Target)
	return TRUE

/*
 * Subtypes
 */

/obj/effect/temporary_effect/eruption/flamestrike
	desc = "A bubbling pool of fire!"

/obj/effect/temporary_effect/eruption/flamestrike/on_eruption(var/turf/Target)
	flick("[icon_state]_erupt",src)
	if(Target)
		Target.hotspot_expose(1000, 50, 1)

		for(var/mob/living/L in Target)
			L.fire_stacks += 2
			L.add_modifier(/datum/modifier/fire/stack_managed/intense, 30 SECONDS)

	return TRUE
