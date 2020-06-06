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
/obj/structure/fitness/boxing_ropes/CanPass(atom/movable/mover, turf/target) //sets it so that players can enter turf from all directions except the main direction.
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return TRUE
	if(get_dir(mover, target) == turn(dir, 180))
		return !density
	return TRUE
/obj/structure/fitness/boxing_ropes/CheckExit(atom/movable/O as mob|obj, target as turf) // Sets it so that players can't leave the truf from the set direction.
	if(istype(O) && O.checkpass(PASSTABLE))
		return 1
	if(get_dir(O.loc, target) == dir)
		return 0
	return 1
/obj/structure/fitness/boxing_ropes/do_climb(var/mob/living/user) //Sets it so that players can climb *over* the turf and will enter the the turf **this** turf is facing.
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

/obj/structure/fitness/boxing_ropes/can_climb(var/mob/living/user, post_climb_check=0) //Sets it to keep people from climbing over into the next turf if it is occupied.
	if(!..())
		return 0

	if(get_turf(user) == get_turf(src))
		var/obj/occupied = neighbor_turf_impassable()
		if(occupied)
			to_chat(user, "<span class='danger'>You can't climb there, there's \a [occupied] in the way.</span>")
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
/obj/structure/fitness/boxing_ropes_bottom/do_climb(var/mob/living/user)
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

/obj/structure/fitness/boxing_ropes_bottom/can_climb(var/mob/living/user, post_climb_check=0)
	if(!..())
		return 0

	if(get_turf(user) == get_turf(src))
		var/obj/occupied = neighbor_turf_impassable()
		if(occupied)
			to_chat(user, "<span class='danger'>You can't climb there, there's \a [occupied] in the way.</span>")
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
/obj/structure/fitness/boxing_turnbuckle/do_climb(var/mob/living/user)
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

/obj/structure/fitness/boxing_turnbuckle/can_climb(var/mob/living/user, post_climb_check=0)
	if(!..())
		return 0

	if(get_turf(user) == get_turf(src))
		var/obj/occupied = neighbor_turf_impassable()
		if(occupied)
			to_chat(user, "<span class='danger'>You can't climb there, there's \a [occupied] in the way.</span>")
			return 0
	return 1

/turf/simulated/fitness
	name = "Mat"
	icon = 'icons/turf/floors_vr.dmi'
	icon_state = "fit_mat"