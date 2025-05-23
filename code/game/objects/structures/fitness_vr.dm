/obj/structure/fitness/boxing_ropes
	name = "ropes"
	desc = "Firm yet springy, perhaps this could be useful!"
	icon = 'icons/obj/fitness_vr.dmi'
	icon_state = "ropes"
	density = TRUE
	throwpass = TRUE
	climbable = TRUE
	layer = WINDOW_LAYER
	anchored = TRUE
	flags = ON_BORDER

/obj/structure/fitness/boxing_ropes/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return TRUE
	if(get_dir(mover, target) == reverse_dir[dir]) // From elsewhere to here, can't move against our dir
		return !density
	return TRUE

/obj/structure/fitness/boxing_ropes/Uncross(atom/movable/mover, turf/target)
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return TRUE
	if(get_dir(mover, target) == dir) // From here to elsewhere, can't move in our dir
		return !density
	return TRUE
/obj/structure/fitness/boxing_ropes/do_climb(var/mob/living/user) //Sets it so that players can climb *over* the turf and will enter the the turf **this** turf is facing.
	if(!can_climb(user))
		return

	user.visible_message(span_warning("[user] starts climbing onto \the [src]!"))
	LAZYDISTINCTADD(climbers, user)

	if(!do_after(user,(issmall(user) ? 20 : 34)))
		LAZYREMOVE(climbers, user)
		return

	if(!can_climb(user, post_climb_check=1))
		LAZYREMOVE(climbers, user)
		return

	if(get_turf(user) == get_turf(src))
		user.forceMove(get_step(src, src.dir))
	else
		user.forceMove(get_turf(src))

	user.visible_message(span_warning("[user] climbed over \the [src]!"))
	LAZYREMOVE(climbers, user)

/obj/structure/fitness/boxing_ropes/can_climb(var/mob/living/user, post_climb_check=0) //Sets it to keep people from climbing over into the next turf if it is occupied.
	if(!..())
		return 0

	if(get_turf(user) == get_turf(src))
		var/obj/occupied = neighbor_turf_impassable()
		if(occupied)
			to_chat(user, span_danger("You can't climb there, there's \a [occupied] in the way."))
			return 0
	return 1

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
