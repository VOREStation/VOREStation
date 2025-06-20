/obj/structure/ledge
	name = "rock ledge"
	desc = "An easily scaleable rocky ledge."
	icon = 'icons/obj/ledges.dmi'
	density = TRUE
	throwpass = 1
	anchored = TRUE
	var/solidledge = 1
	flags = ON_BORDER
	layer = STAIRS_LAYER
	icon_state = "ledge"

/obj/structure/ledge/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/climbable, vaulting = TRUE)

/obj/structure/ledge_corner
	icon_state = "ledge-corner"
	flags = 0
	name = "rock ledge"
	desc = "An easily scaleable rocky ledge."
	icon = 'icons/obj/ledges.dmi'
	density = TRUE
	throwpass = 1
	anchored = TRUE
	layer = STAIRS_LAYER

/obj/structure/ledge_corner/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/climbable, vaulting = TRUE)

/obj/structure/ledge/ledge_nub
	desc = "Part of a rocky ledge."
	icon_state = "ledge-nub"
	density = FALSE
	solidledge = 0

/obj/structure/ledge/ledge_stairs
	name = "rock stairs"
	desc = "A colorful set of rocky stairs"
	icon_state = "ledge-stairs"
	density = FALSE
	solidledge = 0

/obj/structure/ledge/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return TRUE
	if(solidledge && get_dir(mover, target) == GLOB.reverse_dir[dir]) // From elsewhere to here, can't move against our dir
		return !density
	return TRUE

/obj/structure/ledge/Uncross(atom/movable/mover, turf/target)
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return TRUE
	if(solidledge && get_dir(mover, target) == dir) // From here to elsewhere, can't move in our dir
		return FALSE
	return TRUE
