
/mob/living/handle_fall(var/turf/landing)
	var/mob/drop_mob = locate(/mob/living, landing)

	if(locate(/obj/structure/stairs) in landing)
		for(var/atom/A in landing)
			if(!A.CanPass(src, src.loc, 1, 0))
				return FALSE
		Move(landing)
		if(isliving(src))
			var/mob/living/L = src
			if(L.pulling)
				L.pulling.forceMove(landing)
		return 1

	for(var/obj/O in loc)
		if(!O.CanFallThru(src, landing))
			return 1

	if(drop_mob && !(drop_mob == src)) //Shitload of checks. This is because the game finds various ways to screw me over.
		var/mob/living/drop_living = drop_mob
		if(drop_living.dropped_onto(src))
			return

	// Then call parent to have us actually fall
	return ..()
/mob/CheckFall(var/atom/movable/falling_atom)
	return falling_atom.fall_impact(src)

/mob/living/proc/dropped_onto(var/atom/hit_atom)
	if(!isliving(hit_atom))
		return 0

	var/mob/living/pred = hit_atom
	pred.visible_message("<span class='danger'>\The [hit_atom] falls onto \the [src]!</span>")
	pred.Weaken(8)
	var/mob/living/prey = src
	var/fallloc = prey.loc
	if(pred.can_be_drop_pred && prey.can_be_drop_prey)
		pred.feed_grabbed_to_self_falling_nom(pred,prey)
		pred.loc = fallloc
	else if(prey.can_be_drop_pred && pred.can_be_drop_prey)
		prey.feed_grabbed_to_self_falling_nom(prey,pred)
	else
		prey.Weaken(8)
		pred.loc = prey.loc
		playsound(src, "punch", 25, 1, -1)
		var/tdamage
		for(var/i = 1 to 10)
			tdamage = rand(0, 10)/2
			pred.adjustBruteLoss(tdamage)
			prey.adjustBruteLoss(tdamage)
		pred.updatehealth()
		prey.updatehealth()
	return 1

/mob/observer/dead/CheckFall()
	return

/mob/proc/CanZPass(atom/A, direction)
	if(z == A.z) //moving FROM this turf
		return direction == UP //can't go below
	else
		if(direction == UP) //on a turf below, trying to enter
			return 0
		if(direction == DOWN) //on a turf above, trying to enter
			return 1
