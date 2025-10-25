// Grew a little tired of having to juggle with preference checks
// So instead of having multiple checks all over the code
// Let's get some helper procs so that we don't have to do it ALL OVER

/// Most basic check of them all.
/// Checks if PRED can eat PREY.
/proc/CanVore(mob/living/pred, mob/living/prey)
	if(!istype(pred) || !istype(prey))
		return FALSE
	if(!prey.devourable)
		return FALSE
	if(!is_vore_predator(pred))
		return FALSE
	if(prey.is_incorporeal() || pred.is_incorporeal())
		return FALSE
	if(!pred.vore_selected)
		return FALSE
	return TRUE

/// Basic spont vore check.
/// Checks if both have spont vore enable
/proc/CanSpontaneousVore(mob/living/pred, mob/living/prey)
	if(!CanVore(pred, prey))
		return FALSE
	if(!pred.can_be_drop_pred || !prey.can_be_drop_prey)
		return FALSE
	return TRUE

/proc/CanStumbleVore(mob/living/pred, mob/living/prey)
	if(!CanSpontaneousVore(pred, prey))
		return FALSE
	if(!pred.stumble_vore || !prey.stumble_vore)
		return FALSE
	return TRUE

/proc/CanDropVore(mob/living/pred, mob/living/prey)
	if(!CanSpontaneousVore(pred, prey))
		return FALSE
	if(!pred.drop_vore || !prey.stumble_vore)
		return FALSE
	return TRUE

/proc/CanThrowVore(mob/living/pred, mob/living/prey)
	if(!CanSpontaneousVore(pred, prey))
		return FALSE
	if(!pred.throw_vore || !prey.throw_vore)
		return FALSE
	return TRUE

/proc/CanFoodVore(mob/living/pred, mob/living/prey)
	if(!CanSpontaneousVore(pred, prey))
		return FALSE
	if(!pred.food_vore || !prey.food_vore)
		return FALSE
	return TRUE

/proc/CanPhaseVore(mob/living/pred, mob/living/prey)
	if(!CanSpontaneousVore(pred, prey))
		return FALSE
	if(!pred.phase_vore || !prey.phase_vore)
		return FALSE
	return TRUE

/proc/CanSlipVore(mob/living/pred, mob/living/prey)
	if(!CanSpontaneousVore(pred, prey))
		return FALSE
	if(!pred.slip_vore && !prey.slip_vore)
		return FALSE
	if(!pred.is_slipping || !prey.is_slipping)
		return FALSE
	if(world.time <= prey.slip_protect)
		return FALSE
	return TRUE

/proc/CanAnimalVore(mob/living/pred, mob/living/prey)
	if(!CanVore(pred, prey))
		return FALSE
	if(!prey.allowmobvore && isanimal(pred) && !pred.ckey || (!pred.allowmobvore && isanimal(prey) && !prey.ckey))
		return FALSE
	return TRUE
