/mob/proc/has_motiontracking() // USE THIS
	return is_motion_tracking

// Subscribing and unsubscribingto the motion tracker subsystem
/mob/proc/motiontracker_subscribe()
	if(!is_motion_tracking)
		is_motion_tracking = TRUE
		RegisterSignal(SSmotiontracker, COMSIG_MOVABLE_MOTIONTRACKER, PROC_REF(handle_motion_tracking))
		recalculate_vis()

/mob/proc/motiontracker_unsubscribe(var/destroying = FALSE)
	if(is_motion_tracking)
		is_motion_tracking = FALSE
		UnregisterSignal(SSmotiontracker, COMSIG_MOVABLE_MOTIONTRACKER)
		recalculate_vis()

/mob/living/carbon/human/motiontracker_unsubscribe(destroying = FALSE)
	// Block unsub if our species has vibration senses
	if(!destroying && species?.has_vibration_sense)
		return
	. = ..()

// For COMSIG_MOVABLE_MOTIONTRACKER
/mob/proc/handle_motion_tracking(mob/source, var/datum/weakref/RW, var/turf/T)
	SIGNAL_HANDLER
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	var/atom/echo_source = RW?.resolve()
	if(stat) // Ded
		return
	if(!echo_source || get_dist(src,echo_source) > SSmotiontracker.max_range  || get_dist(src,echo_source) < SSmotiontracker.min_range  || src.z != echo_source.z)
		return
	if(!client || echo_source == src) // Not ours
		return
	if(T.get_lumcount() >= 0.20 && can_see(src, T, 7)) // cheaper than oviewers
		return // we already see it
	var/echos = 1
	if(prob(30))
		echos = rand(1,3)
	SSmotiontracker.queue_echo(get_turf(src),T,echos)
