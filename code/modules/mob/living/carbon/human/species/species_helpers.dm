GLOBAL_LIST_EMPTY(stored_shock_by_ref)

/mob/living/proc/apply_stored_shock_to(mob/living/target)
	if(GLOB.stored_shock_by_ref["\ref[src]"])
		if(GLOB.stored_shock_by_ref["\ref[src]"] > 200)
			GLOB.stored_shock_by_ref["\ref[src]"] = 200
		target.stun_effect_act(agony_amount = GLOB.stored_shock_by_ref["\ref[src]"]*0.40,  electric = TRUE)
		GLOB.stored_shock_by_ref["\ref[src]"] = 0
		/* //TODO: Clean up spark system and make it so colors can be set on sparks.
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, target)
		s.start()
		*/
