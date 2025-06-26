/obj/structure/fitness/boxing_ropes
	name = "ropes"
	desc = "Firm yet springy, perhaps this could be useful!"
	icon = 'icons/obj/fitness_vr.dmi'
	icon_state = "ropes"
	density = TRUE
	throwpass = TRUE
	layer = WINDOW_LAYER
	anchored = TRUE
	flags = ON_BORDER

/obj/structure/fitness/boxing_ropes/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/climbable, vaulting = TRUE)

/obj/structure/fitness/boxing_ropes/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return TRUE
	if(get_dir(mover, target) == GLOB.reverse_dir[dir]) // From elsewhere to here, can't move against our dir
		return !density
	return TRUE

/obj/structure/fitness/boxing_ropes/Uncross(atom/movable/mover, turf/target)
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return TRUE
	if(get_dir(mover, target) == dir) // From here to elsewhere, can't move in our dir
		return !density
	return TRUE

/obj/structure/fitness/boxing_ropes/bottom
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER

/obj/structure/fitness/boxing_ropes/turnbuckle
	name = "turnbuckle"
	desc = "A sturdy post that looks like it could support even the most heaviest of heavy weights!"
	icon = 'icons/obj/fitness_vr.dmi'
	icon_state = "turnbuckle"
	layer = WINDOW_LAYER

/turf/simulated/fitness
	name = "Mat"
	icon = 'icons/turf/floors_vr.dmi'
	icon_state = "fit_mat"
