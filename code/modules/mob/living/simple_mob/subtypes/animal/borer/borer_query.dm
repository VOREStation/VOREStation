/mob/living/simple_mob/animal/borer
	var/datum/ghost_query/Q						// Used to unregister our signal

/mob/living/simple_mob/animal/borer/proc/request_player()
	Q = new /datum/ghost_query/borer()
	RegisterSignal(Q, COMSIG_GHOST_QUERY_COMPLETE, PROC_REF(get_winner))
	Q.query() // This will sleep the proc for awhile.

/mob/living/simple_mob/animal/borer/proc/get_winner()
	SIGNAL_HANDLER
	if(Q && Q.candidates.len) //Q should NEVER get deleted but...whatever, sanity.
		var/mob/observer/dead/D = Q.candidates[1]
		transfer_personality(D)
	UnregisterSignal(Q, COMSIG_GHOST_QUERY_COMPLETE)
	QDEL_NULL(Q) //get rid of the query
