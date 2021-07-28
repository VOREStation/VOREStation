/obj/structure/ledge
	name = "rock ledge"
	desc = "An easily scaleable rocky ledge."
	icon = 'icons/obj/ledges.dmi'
	density = TRUE
	throwpass = 1
	climbable = TRUE
	anchored = TRUE
	var/solidledge = 1
	flags = ON_BORDER
	layer = STAIRS_LAYER
	icon_state = "ledge"

/obj/structure/ledge_corner
	icon_state = "ledge-corner"
	flags = 0
	name = "rock ledge"
	desc = "An easily scaleable rocky ledge."
	icon = 'icons/obj/ledges.dmi'
	density = TRUE
	throwpass = 1
	climbable = TRUE
	anchored = TRUE
	layer = STAIRS_LAYER

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
	if(solidledge && get_dir(mover, target) == reverse_dir[dir]) // From elsewhere to here, can't move against our dir
		return !density
	return TRUE

/obj/structure/ledge/Uncross(atom/movable/mover, turf/target)
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return TRUE
	if(solidledge && get_dir(mover, target) == dir) // From here to elsewhere, can't move in our dir
		return FALSE
	return TRUE

/obj/structure/ledge/do_climb(var/mob/living/user)
	if(!can_climb(user))
		return

	usr.visible_message("<span class='warning'>[user] starts climbing onto \the [src]!</span>")
	LAZYDISTINCTADD(climbers, user)

	if(!do_after(user,(issmall(user) ? 20 : 34)))
		LAZYREMOVE(climbers, user)
		return

	if(!can_climb(user, post_climb_check=1))
		LAZYREMOVE(climbers, user)
		return

	if(get_turf(user) == get_turf(src))
		usr.forceMove(get_step(src, src.dir))
	else
		usr.forceMove(get_turf(src))

	usr.visible_message("<span class='warning'>[user] climbed over \the [src]!</span>")
	LAZYREMOVE(climbers, user)

/obj/structure/ledge/can_climb(var/mob/living/user, post_climb_check=0)
	if(!..())
		return 0

	if(get_turf(user) == get_turf(src))
		var/obj/occupied = neighbor_turf_impassable()
		if(occupied)
			to_chat(user, "<span class='danger'>You can't climb there, there's \a [occupied] in the way.</span>")
			return 0
	return 1