//i'd move movement_delay() here but it's out of scope atm.

/mob/living/carbon/slip(weaken_amount, obj/slipped_on, lube, slip_dist, stun_amount, force_drop)
	if(!can_slip(lube))
		return FALSE
	if(!slip_timer) //Prevent log spam from recursive slips
		log_combat(src, (slipped_on ? slipped_on : get_turf(src)), "slipped on the", null, ((lube & GALOSHES_DONT_HELP) ? "(LUBE)" : null))
	. = ..()

	loc.handle_slip(src, weaken_amount, slipped_on, lube, slip_dist, stun_amount, force_drop)
	return TRUE
