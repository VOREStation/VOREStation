/mob/CanPass(atom/movable/mover, turf/target)
	if(ismob(mover))
		var/mob/moving_mob = mover
		if ((other_mobs && moving_mob.other_mobs))
			return TRUE
	if(istype(mover, /obj/item/projectile))
		var/obj/item/projectile/P = mover
		return !P.can_hit_target(src, P.permutated, src == P.original, TRUE)
	return (!mover.density || !density || lying)

// There is no need to override this if you're just going to unconditionally return TRUE.  Set can_atmos_pass instead.
///mob/CanZASPass(turf/T, is_zone)
//	return TRUE

/mob/living/SelfMove(turf/n, direct)
	// If on walk intent, don't willingly step into hazardous tiles.
	// Unless the walker is confused.
	if(m_intent == "walk" && confused <= 0)
		if(!n.is_safe_to_enter(src))
			to_chat(src, span("warning", "\The [n] is dangerous to move into."))
			return FALSE // In case any code wants to know if movement happened.
	return ..() // Parent call should make the mob move.