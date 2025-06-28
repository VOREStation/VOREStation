/mob/living/simple_mob/clowns/big/c_shift
	var/datum/component/shadekin/comp = /datum/component/shadekin/phase_only //Component that holds all the shadekin vars.

/mob/living/simple_mob/clowns/big/c_shift/UnarmedAttack()
	if(comp.in_phase)
		return FALSE //Nope.

	. = ..()

/mob/living/simple_mob/clowns/big/c_shift/can_fall()
	if(comp.in_phase)
		return FALSE //Nope!

	return ..()

/mob/living/simple_mob/clowns/big/c_shift/zMove(direction)
	if(comp.in_phase)
		var/turf/destination = (direction == UP) ? GetAbove(src) : GetBelow(src)
		if(destination)
			forceMove(destination)
		return TRUE

	return ..()
