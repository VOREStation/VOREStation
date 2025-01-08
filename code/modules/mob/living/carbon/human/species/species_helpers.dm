GLOBAL_LIST_EMPTY(stored_shock_by_ref)

/mob/living/proc/apply_stored_shock_to(var/mob/living/target)
	if(GLOB.stored_shock_by_ref["\ref[src]"])
		target.electrocute_act(GLOB.stored_shock_by_ref["\ref[src]"]*0.9, src)
		GLOB.stored_shock_by_ref["\ref[src]"] = 0
