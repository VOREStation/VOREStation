//Fire aberration
/obj/effect/abstract/aberration/spawner/fire
	name = "Fire aberration"
	effect_to_spawn = /obj/effect/abstract/aberration/fire

/obj/effect/abstract/aberration/spawner/fire/small
	range = 2
	percent_drop = 30

//The things that actually light you on fire.
/obj/effect/abstract/aberration/fire
	icon = 'icons/obj/traps/aberrations.dmi'
	icon_state = "abb_fire"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	COOLDOWN_DECLARE(fire_timer)

/obj/effect/abstract/aberration/fire/Crossed(atom/movable/AM)
	. = ..()
	if(AM.is_incorporeal() || isobserver(AM) || istype(AM, /obj/effect/abstract))
		return
	if(isitem(AM)) // Outpost 21 edit(port) - Crash fix
		var/obj/item/item_check = AM
		if(item_check.item_flags & ABSTRACT)
			return
	if(COOLDOWN_FINISHED(src, fire_timer))
		ignite_entity(AM)

/obj/effect/abstract/aberration/fire/proc/reset_trap()
	for(var/mob/living/living_being in get_turf(src))
		if(living_being.is_incorporeal())
			continue
		ignite_entity(living_being) //Begin anew

/obj/effect/abstract/aberration/fire/proc/ignite_entity(atom/movable/AM)
	AM.fire_act(null, 10000, 1000)
	alpha = 125
	animate(src, alpha = 255, time = 2 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(reset_trap)), 2 SECONDS, TIMER_DELETE_ME|TIMER_UNIQUE) //Calling a proc with no arguments
	COOLDOWN_START(src, fire_timer, 2 SECONDS)
