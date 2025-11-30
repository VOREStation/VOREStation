// Grew a little tired of having to juggle with preference checks
// So instead of having multiple checks all over the code
// Let's get some helper procs so that we don't have to do it ALL OVER

/// Most basic check of them all.
/// Checks if PRED can eat PREY.
/proc/can_vore(mob/living/pred, mob/living/prey)
	if(pred == prey)
		return FALSE
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
	if(!pred.can_be_afk_pred && (!pred.client || pred.away_from_keyboard))
		return FALSE
	if(!prey.can_be_afk_prey && (!prey.client || prey.away_from_keyboard))
		return FALSE
	return TRUE

/// Basic spont vore check.
/// Checks if both have spont vore enable
/proc/can_spontaneous_vore(mob/living/pred, mob/living/prey)
	if(!can_vore(pred, prey))
		return FALSE
	if(!pred.can_be_drop_pred || !prey.can_be_drop_prey)
		return FALSE
	return TRUE

/proc/can_stumble_vore(mob/living/pred, mob/living/prey)
	if(!can_spontaneous_vore(pred, prey))
		return FALSE
	if(!pred.stumble_vore || !prey.stumble_vore)
		return FALSE
	return TRUE

/proc/can_drop_vore(mob/living/pred, mob/living/prey)
	if(!can_spontaneous_vore(pred, prey))
		return FALSE
	if(!pred.drop_vore || !prey.drop_vore)
		return FALSE
	return TRUE

/proc/can_throw_vore(mob/living/pred, mob/living/prey)
	if(!can_spontaneous_vore(pred, prey))
		return FALSE
	if(!pred.throw_vore || !prey.throw_vore)
		return FALSE
	return TRUE

/proc/can_food_vore(mob/living/pred, mob/living/prey)
	if(!can_spontaneous_vore(pred, prey))
		return FALSE
	if(!pred.food_vore || !prey.food_vore)
		return FALSE
	return TRUE

/proc/can_phase_vore(mob/living/pred, mob/living/prey)
	if(!can_spontaneous_vore(pred, prey))
		return FALSE
	if(!pred.phase_vore || !prey.phase_vore)
		return FALSE
	return TRUE

/proc/can_slip_vore(mob/living/pred, mob/living/prey)
	if(!can_spontaneous_vore(pred, prey))
		return FALSE
	if(!pred.slip_vore && !prey.slip_vore)
		return FALSE
	if(!pred.is_slipping && !prey.is_slipping)
		return FALSE
	if(world.time <= prey.slip_protect)
		return FALSE
	return TRUE

/proc/can_animal_vore(mob/living/pred, mob/living/prey)
	if(!can_vore(pred, prey))
		return FALSE
	if(!prey.allowmobvore && isanimal(pred) && !pred.ckey || (!pred.allowmobvore && isanimal(prey) && !prey.ckey))
		return FALSE
	return TRUE
