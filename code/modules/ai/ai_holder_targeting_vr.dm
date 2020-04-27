/datum/ai_holder/can_see_target(atom/movable/the_target, view_range = vision_range)
	if(the_target && isbelly(the_target.loc))
		return FALSE

	return ..()
