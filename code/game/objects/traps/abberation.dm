#define EFFECT_GLASS "glass"
#define EFFECT_FIRE "glass"

/obj/effect/abstract/abberation
	name = "Abberation"
	desc = "Some sort of weird, pulsating entity."
	icon = 'icons/effects/effects.dmi'
	icon_state = "pre_confuse"
	alpha = 0

	///What type of effect type the abberation has
	var/effect_type = EFFECT_FIRE

	///If the abberation starts active or not.
	var/start_active = TRUE

	///If the abberation has a toggling effect (Turns on-off)
	var/enabled = FALSE

	///If it pulses or not. i.e. has a non-continuous effect
	var/pulses = FALSE

	///How frequently pulses occur
	var/pulse_time = 30 SECONDS

	///The cooldown for our pulse
	COOLDOWN_DECLARE(pulse)

/obj/effect/abstract/abberation/Initialize(mapload)
	. = ..()
	if(start_active)
		START_PROCESSING(SSobj, src)

/obj/effect/abstract/abberation/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/effect/abstract/abberation/process()
	if(COOLDOWN_FINISHED(src, pulse))
		perform_pulse()
		COOLDOWN_START(src, pulse, pulse_time)
	perform_ambient_effects()

/obj/effect/abstract/abberation/proc/perform_pulse()
	return

/obj/effect/abstract/abberation/proc/perform_ambient_effects()
	return


//Fire abberation
/obj/effect/abstract/abberation/fire
	name = "Fire Abberation"
	var/range = 4
	var/random_range = TRUE
	start_active = FALSE
	COOLDOWN_DECLARE(fire_timer)

/obj/effect/abstract/abberation/fire/Initialize(mapload)
	. = ..()
	if(random_range)
		range = rand(3, 5)
	for(var/turf/simulated/turf in range(src, range))
		var/how_far = get_dist(src, turf)
		if(prob(100 - ((how_far - 1) * 15))) //100% at 1 range, 85 at 2 range, 70 at 3, 55 at 4, 40 at 5
			new /obj/effect/abberation_fire(turf)
	qdel(src)
	return

//The things that actually light you on fire.
/obj/effect/abberation_fire
	icon = 'icons/obj/traps/abberations.dmi'
	icon_state = "abb_fire"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	COOLDOWN_DECLARE(fire_timer)

/obj/effect/abberation_fire/Crossed(atom/movable/AM)
	if(AM.is_incorporeal() || isobserver(AM) || istype(AM, /obj/effect/abstract))
		return
	if(isobj)
		var/obj/item/item_check = AM
		if(item_check.item_flags & ABSTRACT)
			continue
	if(COOLDOWN_FINISHED(src, fire_timer))
		ignite_entity(AM)

/obj/effect/abberation_fire/proc/reset_trap()
	for(var/mob/living/living_being in get_turf(src))
		if(living_being.is_incorporeal())
			continue
		ignite_entity(living_being) //Begin anew

/obj/effect/abberation_fire/proc/ignite_entity(atom/movable/AM)
	AM.fire_act(null, 10000, 1000)
	alpha = 125
	animate(src, alpha = 255, time = 2 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(reset_trap)), 2 SECONDS, TIMER_DELETE_ME|TIMER_UNIQUE) //Calling a proc with no arguments
	COOLDOWN_START(src, fire_timer, 2 SECONDS)

#undef EFFECT_GLASS
#undef EFFECT_FIRE


/*
//Useful for later
	var/static/list/connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(ignite_the_unworthy),
	)
	AddComponent(/datum/component/connect_range, src, connections, range)
*/
