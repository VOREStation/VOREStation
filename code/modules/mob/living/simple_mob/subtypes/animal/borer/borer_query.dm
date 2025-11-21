/mob/living/simple_mob/animal/borer
	var/datum/ghost_query/ghost_check // Used to unregister our signal

/mob/living/simple_mob/animal/borer/proc/request_player()
	ghost_check = new /datum/ghost_query/borer()
	RegisterSignal(ghost_check, COMSIG_GHOST_QUERY_COMPLETE, PROC_REF(get_winner))
	ghost_check.query() // This will sleep the proc for awhile.

/mob/living/simple_mob/animal/borer/proc/get_winner()
	SIGNAL_HANDLER
	if(ghost_check && ghost_check.candidates.len) //ghost_check should NEVER get deleted but...whatever, sanity.
		var/mob/observer/dead/D = ghost_check.candidates[1]
		transfer_personality(D)
	UnregisterSignal(ghost_check, COMSIG_GHOST_QUERY_COMPLETE)
	QDEL_NULL(ghost_check) //get rid of the query
