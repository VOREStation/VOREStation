// Slipnoms from chompstation downstream, credit to cadyn for the original PR.

/mob/living
	var/is_slipping = FALSE
	var/slip_vore_in_progress = FALSE

/mob/living/proc/can_slip_vore(var/mob/living/target)
	if(!target.is_slipping)	//Obviously they have to be slipping to get slip vored
		return FALSE
	if(!(src.can_be_drop_pred && target.devourable && target.can_be_drop_prey))	//Make sure both of their prefs align with what we're gonna do.
		return FALSE
	if(!is_vore_predator(src))	//Check their bellies and stuff
		return FALSE
	if(!src.vore_selected)	//Gotta have one selected as well.
		return FALSE
	return TRUE

/mob/living/proc/can_be_slip_vored_by(var/mob/living/target)
	if(!target.is_slipping)	//Obviously they have to be slipping to get slip vored
		return FALSE
	if(!(target.can_be_drop_pred && src.devourable && src.can_be_drop_prey))	//Make sure both of their prefs align with what we're gonna do.
		return FALSE
	if(!is_vore_predator(target))	//Check their bellies and stuff
		return FALSE
	if(!target.vore_selected)	//Gotta have one selected as well.
		return FALSE
	return TRUE

/mob/living/Crossed(var/atom/movable/AM)
	if(AM == src || AM.is_incorporeal()) // We're not going to run over ourselves or ghosts
		return

	if(istype(AM, /mob/living/bot/mulebot))
		var/mob/living/bot/mulebot/MB = AM
		MB.runOver(src)

	if(istype(AM, /obj/vehicle))
		var/obj/vehicle/V = AM
		V.RunOver(src)

	var/mob/living/target = AM
	if(istype(target) && !target.incorporeal_move && !src.incorporeal_move)	//The slip vore begins
		if(can_slip_vore(target) && !src.slip_vore_in_progress && !target.slip_vore_in_progress)	//If we can vore them go for it
			target.slip_vore_in_progress = TRUE //Make them stop slipping
			perform_the_nom(src,target,src,src.vore_selected,1)
			target.slip_vore_in_progress = FALSE
			target.is_slipping = FALSE
		else if(can_be_slip_vored_by(target) && !src.slip_vore_in_progress && !target.slip_vore_in_progress) //Otherwise, if they can vore us, make it happen.
			target.slip_vore_in_progress = TRUE //Make them stop slipping
			perform_the_nom(target,src,target,target.vore_selected,1)
			target.slip_vore_in_progress = FALSE
			target.is_slipping = FALSE

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