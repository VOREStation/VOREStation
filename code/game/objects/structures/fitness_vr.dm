/obj/structure/fitness/boxing_ropes
	name = "Ropes"
	desc = "Firm yet springy, perhaps this could be useful!"
	icon = 'icons/obj/fitness_vr.dmi'
	icon_state = "ropes"
	density = 1
	throwpass = 1
	climbable = 1
	layer = WINDOW_LAYER
	anchored = 1
	flags = ON_BORDER
/obj/structure/fitness/boxing_ropes/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return TRUE
	if(get_dir(mover, target) == turn(dir, 180))
		return !density
	return TRUE
/obj/structure/fitness/boxing_ropes/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(istype(O) && O.checkpass(PASSTABLE))
		return 1
	if(get_dir(O.loc, target) == dir)
		return 0
	return 1

/obj/structure/fitness/boxing_ropes_bottom
	name = "Ropes"
	desc = "Firm yet springy, perhaps this could be useful!"
	icon = 'icons/obj/fitness_vr.dmi'
	icon_state = "ropes"
	density = 1
	throwpass = 1
	climbable = 1
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER
	anchored = 1
	flags = ON_BORDER
/obj/structure/fitness/boxing_ropes_bottom/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return TRUE
	if(get_dir(mover, target) == turn(dir, 180))
		return !density
	return TRUE
/obj/structure/fitness/boxing_ropes_bottom/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(istype(O) && O.checkpass(PASSTABLE))
		return 1
	if(get_dir(O.loc, target) == dir)
		return 0
	return 1



/obj/structure/fitness/boxing_turnbuckle
	name = "Turnbuckle"
	desc = "A sturdy post that looks like it could support even the most heaviest of heavy weights!"
	icon = 'icons/obj/fitness_vr.dmi'
	icon_state = "turnbuckle"
	density = 1
	throwpass = 1
	climbable = 1
	layer = WINDOW_LAYER
	anchored = 1
	flags = ON_BORDER
/obj/structure/fitness/boxing_turnbuckle/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return TRUE
	if(get_dir(mover, target) == turn(dir, 180))
		return !density
	return TRUE
/obj/structure/fitness/boxing_turnbuckle/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(istype(O) && O.checkpass(PASSTABLE))
		return 1
	if(get_dir(O.loc, target) == dir)
		return 0
	return 1

/turf/simulated/fitness
	name = "Mat"
	icon = 'icons/turf/floors_vr.dmi'
	icon_state = "fit_mat"