/obj/structure/ledge
	name = "rock ledge"
	desc = "An easily scaleable rocky ledge."
	icon = 'icons/obj/ledges.dmi'
	density = 1
	throwpass = 1
	climbable = 1
	anchored = 1
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
	density = 1
	throwpass = 1
	climbable = 1
	anchored = 1
	layer = STAIRS_LAYER

/obj/structure/ledge/ledge_nub
	desc = "Part of a rocky ledge."
	icon_state = "ledge-nub"
	density = 0
	solidledge = 0

/obj/structure/ledge/ledge_stairs
	name = "rock stairs"
	desc = "A colorful set of rocky stairs"
	icon_state = "ledge-stairs"
	density = 0
	solidledge = 0

/obj/structure/ledge/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return TRUE
	if(solidledge && get_dir(mover, target) == turn(dir, 180))
		return !density
	return TRUE

/obj/structure/ledge/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(istype(O) && O.checkpass(PASSTABLE))
		return 1
	if(solidledge && get_dir(O.loc, target) == dir)
		return 0
	return 1

/obj/structure/ledge/do_climb(var/mob/living/user)
	if(!can_climb(user))
		return

	usr.visible_message("<span class='warning'>[user] starts climbing onto \the [src]!</span>")
	climbers |= user

	if(!do_after(user,(issmall(user) ? 20 : 34)))
		climbers -= user
		return

	if(!can_climb(user, post_climb_check=1))
		climbers -= user
		return

	if(get_turf(user) == get_turf(src))
		usr.forceMove(get_step(src, src.dir))
	else
		usr.forceMove(get_turf(src))

	usr.visible_message("<span class='warning'>[user] climbed over \the [src]!</span>")
	climbers -= user

/obj/structure/ledge/can_climb(var/mob/living/user, post_climb_check=0)
	if(!..())
		return 0

	if(get_turf(user) == get_turf(src))
		var/obj/occupied = neighbor_turf_impassable()
		if(occupied)
			to_chat(user, "<span class='danger'>You can't climb there, there's \a [occupied] in the way.</span>")
			return 0
	return 1