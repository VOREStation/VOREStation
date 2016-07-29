/datum/technomancer/spell/phase_shift
	name = "Phase Shift"
	desc = "Hides you in the safest possible place, where no harm can come to you.  Unfortunately you can only stay inside for a few moments before \
	draining your powercell."
	cost = 80
	obj_path = /obj/item/weapon/spell/phase_shift

/obj/item/weapon/spell/phase_shift
	name = "phase shift"
	desc = "Allows you to dodge your untimely fate by shifting your location somewhere else, so long as you can sustain the energy to do so."
	cast_methods = CAST_USE
	aspect = ASPECT_TELE

/obj/item/weapon/spell/phase_shift/New()
	..()
	set_light(3, 2, l_color = "#FA58F4")

/obj/effect/phase_shift
	name = "rift"
	desc = "There was a maniac here a moment ago..."
	icon = 'icons/effects/effects.dmi'
	icon_state = "rift"

/obj/effect/phase_shift/ex_act()
	return

/obj/effect/phase_shift/New()
	..()
	set_light(3, 5, l_color = "#FA58F4")

/obj/effect/phase_shift/Destroy()
	for(var/atom/movable/AM in contents) //Eject everything out.
		AM.forceMove(get_turf(src))
	..()

/obj/item/weapon/spell/phase_shift/on_use_cast(mob/user)
	if(isturf(user.loc)) //Check if we're not already in a rift.
		var/obj/effect/phase_shift/PS = new(get_turf(user))
		visible_message("<span class='warning'>[user] vanishes into a pink rift!</span>")
		user << "<span class='info'>You create an unstable rift, and go through it.  Be sure to not stay too long.</span>"
		user.forceMove(PS)
	else //We're already in a rift, time to get out.
		if(istype(loc, /obj/effect/phase_shift))
			var/obj/effect/phase_shift/PS = user.loc
			qdel(PS) //Ejecting is handled in Destory()
			visible_message("<span class='warning'>[user] reappears from the rift as it collapses.</span>")
			qdel(src)
