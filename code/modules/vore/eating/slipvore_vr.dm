// Slipnoms from chompstation downstream, credit to cadyn for the original PR.

/mob/living
	var/is_slipping = FALSE
	var/slip_protect = 1

/mob/living/proc/can_slip_vore(var/mob/living/target)
	if(!target.is_slipping)	//Obviously they have to be slipping to get slip vored
		return FALSE
	if(is_incorporeal())
		return FALSE
	if(!target.allowmobvore && isanimal(src) && !ckey)
		return FALSE
	if(world.time <= target.slip_protect)
		return FALSE
	if(!(src.can_be_drop_pred && target.devourable && target.can_be_drop_prey))	//Make sure both of their prefs align with what we're gonna do.
		return FALSE
	if(!is_vore_predator(src))	//Check their bellies and stuff
		return FALSE
	if(!src.vore_selected)	//Gotta have one selected as well.
		return FALSE
	if(!slip_vore || !target.slip_vore)
		return FALSE
	return TRUE

/mob/living/proc/can_be_slip_vored_by(var/mob/living/target)
	if(!target.is_slipping)	//Obviously they have to be slipping to get slip vored
		return FALSE
	if(is_incorporeal())
		return FALSE
	if(!allowmobvore && isanimal(target) && !target.ckey)
		return FALSE
	if(world.time <= target.slip_protect)
		return FALSE
	if(!(target.can_be_drop_pred && src.devourable && src.can_be_drop_prey))	//Make sure both of their prefs align with what we're gonna do.
		return FALSE
	if(!is_vore_predator(target))	//Check their bellies and stuff
		return FALSE
	if(!target.vore_selected)	//Gotta have one selected as well.
		return FALSE
	if(!slip_vore || !target.slip_vore)
		return FALSE
	return TRUE

/*
 * SRC = The thing being crossed (Ex: If someone walks on top of someone resting, the resting person is SRC)
 * AM = The person crossing us (Ex: In above example, the person walking on top of us)
*/
/mob/living/Crossed(var/atom/movable/AM)
	..()
	if(src == AM)
		return
	var/mob/living/target = AM
	if(isliving(AM) && !target.is_incorporeal() && !src.is_incorporeal())

		//Person being slipped into eats the person slipping
		if(can_slip_vore(target))	//If we can vore them go for it
			begin_instant_nom(src, prey = target, pred = src, belly = src.vore_selected)
			target.is_slipping = FALSE
			return
		//The person slipping eats the person being slipped into
		else if(can_be_slip_vored_by(target))
			begin_instant_nom(target, prey = src, pred = target, belly = target.vore_selected)
			is_slipping = FALSE
			return


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
