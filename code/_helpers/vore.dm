// Grew a little tired of having to juggle with preference checks
// So instead of having multiple checks all over the code
// Let's get some helper procs so that we don't have to do it ALL OVER

/// Most basic check of them all.
/// Checks if PRED can eat PREY.
/proc/can_vore(mob/living/pred, mob/living/prey, allow_incorporeal = FALSE)
	if(pred == prey)
		return FALSE
	if(!istype(pred) || !istype(prey))
		return FALSE
	if(!prey.devourable)
		return FALSE
	if(!is_vore_predator(pred))
		return FALSE
	if(prey.is_incorporeal() || pred.is_incorporeal())
		if(!allow_incorporeal)
			return FALSE
	if(!pred.vore_selected)
		return FALSE
	if(!pred.can_be_afk_pred && (!pred.client || pred.away_from_keyboard))
		return FALSE
	if(!prey.is_dead() && !prey.can_be_afk_prey && (!prey.client || prey.away_from_keyboard))
		return FALSE
	if(!prey.allowmobvore && isanimal(pred) && !pred.ckey)
		return FALSE
	return TRUE

/// Basic spont vore check.
/// Checks if both have spont vore enable
/proc/can_spontaneous_vore(mob/living/pred, mob/living/prey, allow_incorporeal = FALSE)
	if(!can_vore(pred, prey, allow_incorporeal))
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

/proc/can_phase_vore(mob/living/pred, mob/living/prey, allow_incorporeal = FALSE)
	if(!can_spontaneous_vore(pred, prey, allow_incorporeal))
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

//Elevating this to allow utensils the same checks as reagent containers do for vore prefs.
/obj/item/proc/standard_feed_mob(mob/user, mob/target) // This goes into attack
	if(!istype(target) || !target.can_feed())
		to_chat(user, span_vdanger("[user == target ? "you can't" : "\The [target] can't"] consume that!"))
		return FALSE

	//micro in food check if someone couldn't be bothered to examine their food.
	if(!target.food_vore || !target.can_be_drop_pred)
		to_chat(user, span_vdanger("Ewww, [user == target ? "You can't" : "\The [target] can't"] consume that, there's a bug in this!") )
		return FALSE

	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(!H.check_has_mouth())
			balloon_alert(user, "[user == target ? "you don't" : "\the [H] doesn't"] have a mouth!")
			return FALSE
		var/obj/item/blocked = H.check_mouth_coverage()
		if(blocked)
			balloon_alert(user, "\the [blocked] is in the way!")
			return FALSE
	return TRUE
