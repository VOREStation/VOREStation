////// Spiders that are spawned for the security event now have a specific unique AI that only does warning bites on non-hostiles.

/mob/living/simple_mob/animal/giant_spider/event
	ai_holder_type = /datum/ai_holder/simple_mob/melee/event_spider

/mob/living/simple_mob/animal/giant_spider/hunter/event
	ai_holder_type = /datum/ai_holder/simple_mob/melee/event_spider

/datum/ai_holder/simple_mob/melee/event_spider
	hostile = FALSE
	retaliate = TRUE
	var/next_warning = 0

/datum/ai_holder/simple_mob/melee/event_spider/handle_stance_strategical()
	ai_log("++++++++++ Slow Process Beginning ++++++++++", AI_LOG_TRACE)
	ai_log("handle_stance_strategical() : Called.", AI_LOG_TRACE)

	//We got left around for some reason. Goodbye cruel world.
	if(!holder)
		qdel(src)

	ai_log("handle_stance_strategical() : LTT=[lose_target_time]", AI_LOG_TRACE)
	if(lose_target_time && (lose_target_time + lose_target_timeout < world.time)) // We were tracking an enemy but they are gone.
		ai_log("handle_stance_strategical() : Giving up a chase.", AI_LOG_DEBUG)
		remove_target()

	if(stance in STANCES_COMBAT)
		request_help() // Call our allies.

	switch(stance)
		if(STANCE_IDLE)
			if(istype(holder,/mob/living/simple_mob/animal/giant_spider) && (world.time > next_warning))
				do_warning_bite()

			if(speak_chance) // In the long loop since otherwise it wont shut up.
				handle_idle_speaking()

			if(hostile || vore_hostile)
				ai_log("handle_stance_strategical() : STANCE_IDLE, going to find_target().", AI_LOG_TRACE)
				find_target()

			if(should_go_home())
				ai_log("handle_stance_tactical() : STANCE_IDLE, going to go home.", AI_LOG_TRACE)
				go_home()

			else if(should_follow_leader())
				ai_log("handle_stance_tactical() : STANCE_IDLE, going to follow leader.", AI_LOG_TRACE)
				set_stance(STANCE_FOLLOW)

			else if(should_wander())
				ai_log("handle_stance_tactical() : STANCE_IDLE, going to wander randomly.", AI_LOG_TRACE)
				handle_wander_movement()

		if(STANCE_APPROACH)
			if(target)
				ai_log("handle_stance_strategical() : STANCE_APPROACH, going to calculate_path([target]).", AI_LOG_TRACE)
				calculate_path(target)
				walk_to_target()
		if(STANCE_MOVE)
			if(hostile && find_target()) // This will switch its stance.
				ai_log("handle_stance_strategical() : STANCE_MOVE, found target and was interrupted.", AI_LOG_TRACE)
				return
		if(STANCE_FOLLOW)
			if(hostile && find_target()) // This will switch its stance.
				ai_log("handle_stance_strategical() : STANCE_FOLLOW, found target and was interrupted.", AI_LOG_TRACE)
				return
			else if(leader)
				ai_log("handle_stance_strategical() : STANCE_FOLLOW, going to calculate_path([leader]).", AI_LOG_TRACE)
				calculate_path(leader)
				walk_to_leader()

	ai_log("handle_stance_strategical() : Exiting.", AI_LOG_TRACE)
	ai_log("++++++++++ Slow Process Ending ++++++++++", AI_LOG_TRACE)

/datum/ai_holder/simple_mob/melee/event_spider/proc/do_warning_bite()
	if(!istype(holder,/mob/living/simple_mob/animal/giant_spider))
		return
	var/list/intruders = list()
	var/mob/living/intruder
	var/mob/living/simple_mob/animal/giant_spider/S = holder
	for(var/mob/living/L in oview(S,3))
		if(can_attack(L))
			intruders |= L
	if(intruders.len)
		intruder = pick(intruders)
		next_warning = world.time + 30 SECONDS
		S.warning_bite(intruder)
