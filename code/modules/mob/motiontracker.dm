/mob/proc/has_motiontracking() // USE THIS
	return is_motion_tracking

// Subscribing and unsubscribingto the motion tracker subsystem
/mob/proc/motiontracker_subscribe()
	if(!is_motion_tracking)
		is_motion_tracking = TRUE
		wants_to_see_motion_echos = TRUE
		RegisterSignal(SSmotiontracker, COMSIG_MOVABLE_MOTIONTRACKER, PROC_REF(handle_motion_tracking))
		add_verb(src,/mob/proc/toggle_motion_echo_vis)

/mob/proc/motiontracker_unsubscribe(var/destroying = FALSE)
	if(is_motion_tracking)
		is_motion_tracking = FALSE
		UnregisterSignal(SSmotiontracker, COMSIG_MOVABLE_MOTIONTRACKER)
		remove_verb(src,/mob/proc/toggle_motion_echo_vis)

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
	if(!client || !wants_to_see_motion_echos || stat || is_deaf())
		return
	var/atom/echo_source = RW?.resolve()
	if(!echo_source || get_dist(src,echo_source) > SSmotiontracker.max_range || src.z != echo_source.z)
		return
	// Blind characters see all pings around them. Otherwise remove the closest, or any we can see. Pings behind walls or in the dark are always visible
	if(!is_blind() && (get_dist(src,echo_source) < SSmotiontracker.min_range || (T.get_lumcount() >= 0.20 && can_see(src, T, 7)) ))
		return
	var/echos = 1
	if(prob(30))
		echos = rand(1,3)
	SSmotiontracker.queue_echo(get_turf(src),T,echos,client ? WEAKREF(client) : null)

/mob/proc/toggle_motion_echo_vis()
	set name = "Toggle Vibration Senses"
	set desc = "Toggle the visibility of pings revealed by vibration senses or motion trackers."
	set category = "Abilities.General"

	wants_to_see_motion_echos = !wants_to_see_motion_echos
	to_chat(src,"You will [wants_to_see_motion_echos ? "now" : "no longer"] see echos")
