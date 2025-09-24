// Slipnoms from chompstation downstream, credit to cadyn for the original PR.

/mob/living
	var/is_slipping = FALSE
	var/slip_protect = 1

/mob/living/carbon/slip(var/slipped_on,stun_duration=8)
	. = ..()
	if(.)
		is_slipping = TRUE
	return .

/mob/living/update_canmove()
	. = ..()
	if(is_slipping && !lying)
		is_slipping = FALSE
	return .
