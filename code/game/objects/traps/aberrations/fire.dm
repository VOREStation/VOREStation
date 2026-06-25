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
