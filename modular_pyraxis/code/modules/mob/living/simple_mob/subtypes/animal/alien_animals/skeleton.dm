/mob/living/simple_mob/vore/alienanimals/skeleton/fleeing
	ai_holder_type = /datum/ai_holder/simple_mob/melee/hit_and_run

/datum/ai_holder/simple_mob/melee/hit_and_run/runner
	intelligence_level = AI_SMART
	can_flee = TRUE

/datum/ai_holder/simple_mob/melee/hit_and_run/runner/special_flee_check()
	return TRUE
