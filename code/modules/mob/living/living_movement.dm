/mob/CanPass(atom/movable/mover, turf/target)
	if(ismob(mover))
		var/mob/moving_mob = mover
		if ((other_mobs && moving_mob.other_mobs))
			return TRUE
	if(istype(mover, /obj/item/projectile))
		var/obj/item/projectile/P = mover
		return !P.can_hit_target(src, P.permutated, src == P.original, TRUE)
	return (!mover.density || !density || lying)

/mob/CanZASPass(turf/T, is_zone)
	return ATMOS_PASS_YES