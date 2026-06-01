//For spooky, ghost related experiments.
/datum/experiment/ghost_capture
	name = "Spectral Capture"
	description = "There's supposed 'ghosts' and 'specters' roaming around this section of space! Let's capture one of these entities for science!"
	exp_tag = "Spectral"
	allowed_experimentors = list(/obj/item/ghost_trap)
	var/ghost_captured = FALSE

/datum/experiment/ghost_capture/is_complete()
	return ghost_captured

/datum/experiment/ghost_capture/perform_experiment_actions(datum/source, atom/movable/captured_entity)
	if(isobserver(captured_entity) || isliving(captured_entity) || isliving(/obj/effect/shadow_wight))
		// We don't actually care about the mob that's captured, just that something was captured.
		ghost_captured = TRUE
		return TRUE
	return FALSE
