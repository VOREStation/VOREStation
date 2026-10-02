/mob/living/simple_mob/clowns/big/c_shift
	var/datum/component/shadekin/comp = /datum/component/shadekin/phase_only //Component that holds all the shadekin vars.

/mob/living/simple_mob/clowns/big/c_shift/is_incorporeal()
	if(comp.in_phase)
		return TRUE
	. = ..()
