/obj/effect/abstract/aberration/spawner/gravity
	name = "Gravity aberration"
	effect_to_spawn = /obj/effect/abstract/aberration/gravity

/obj/effect/abstract/aberration/spawner/gravity/small
	range = 2
	percent_drop = 30

/obj/effect/abstract/aberration/gravity
	icon = 'icons/obj/traps/aberrations.dmi'
	icon_state = "aberr_grav"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/abstract/aberration/gravity/Crossed(atom/movable/AM)
	. = ..()
	if(AM.is_incorporeal() || (!isliving(AM) && !isobj(AM)))
		return
	ADD_TRAIT(AM, TRAIT_NO_GRAVITY, ABERRATION_TRAIT)
	if(isliving(AM))
		var/mob/living/living_entity = AM
		living_entity.update_floating()

/obj/effect/abstract/aberration/gravity/Uncrossed(atom/movable/gone)
	. = ..()
	if(!isliving(gone) && !isobj(gone))
		return
	REMOVE_TRAIT(gone, TRAIT_NO_GRAVITY, ABERRATION_TRAIT)
