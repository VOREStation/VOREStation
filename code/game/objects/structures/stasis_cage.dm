/obj/structure/stasis_cage
	name = "stasis cage"
	desc = "A high-tech animal cage, designed to keep contained fauna docile and safe."
	icon = 'icons/obj/storage_vr.dmi' //VOREStation Edit
	icon_state = "critteropen"
	density = TRUE
	unacidable = TRUE

	var/mob/living/simple_mob/contained

/obj/structure/stasis_cage/Initialize(mapload)
	. = ..()

	var/mob/living/simple_mob/A = locate() in loc
	if(A)
		contain(A)

/obj/structure/stasis_cage/attack_hand(var/mob/user)
	release()

/obj/structure/stasis_cage/attack_robot(var/mob/user)
	if(Adjacent(user))
		release()

/obj/structure/stasis_cage/proc/contain(var/mob/living/simple_mob/animal)
	if(contained || !istype(animal))
		return

	contained = animal
	animal.forceMove(src)
	animal.in_stasis = 1
	if(animal.buckled && istype(animal.buckled, /obj/effect/energy_net))
		animal.buckled.forceMove(animal.loc)
	icon_state = "critter"
	desc = initial(desc) + " \The [contained] is kept inside."

/obj/structure/stasis_cage/proc/release()
	if(!contained)
		return

	contained.dropInto(src)
	if(contained.buckled && istype(contained.buckled, /obj/effect/energy_net))
		contained.buckled.dropInto(src)
	contained.in_stasis = 0
	contained = null
	icon_state = "critteropen"
	underlays.Cut()
	desc = initial(desc)

/obj/structure/stasis_cage/Destroy()
	release()

	return ..()

/mob/living/simple_mob/MouseDrop(var/obj/structure/stasis_cage/over_object)
	if(istype(over_object) && Adjacent(over_object) && CanMouseDrop(over_object, usr))

		if(!src.buckled || !istype(src.buckled, /obj/effect/energy_net))
			to_chat(usr, "It's going to be difficult to convince \the [src] to move into \the [over_object] without capturing it in a net.")
			return

		usr.visible_message("[usr] begins stuffing \the [src] into \the [over_object].", "You begin stuffing \the [src] into \the [over_object].")
		Bumped(usr)
		if(do_after(usr, 20, over_object))
			usr.visible_message("[usr] has stuffed \the [src] into \the [over_object].", "You have stuffed \the [src] into \the [over_object].")
			over_object.contain(src)
	else
		return ..()
