//Fire abberation
/obj/effect/abstract/abberation/spawner/fire
	name = "Fire Abberation"
	effect_to_spawn = /obj/effect/abberation_fire

//The things that actually light you on fire.
/obj/effect/abberation_fire
	icon = 'icons/obj/traps/abberations.dmi'
	icon_state = "abb_fire"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	COOLDOWN_DECLARE(fire_timer)

/obj/effect/abberation_fire/Crossed(atom/movable/AM)
	if(AM.is_incorporeal() || isobserver(AM) || istype(AM, /obj/effect/abstract))
		return
	if(isobj(AM))
		var/obj/item/item_check = AM
		if(item_check.item_flags & ABSTRACT)
			return
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
