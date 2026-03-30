//For spooky, ghost related experiments.
/datum/experiment/ghost_capture
	name = "Spectral Capture"
	description = "There's supposed 'ghosts' and 'specters' roaming around this section of space! Let's capture one of these entities for science!"
	exp_tag = "Spectral"
	allowed_experimentors = list(/obj/machinery/rnd/server)

/datum/experiment/ghost_capture/is_complete()
	return completed

/datum/experiment/ghost_capture/New()
	..()
	RegisterSignal(SSdcs, COMSIG_GLOB_GHOST_CAPTURED, PROC_REF(ghost_captured))
	return TRUE

/datum/experiment/ghost_capture/proc/ghost_captured(datum/source, mob/captured_entity)
	SIGNAL_HANDLER
	// We don't actually care about the mob that's captured, just that something was captured.
	completed = TRUE
	UnregisterSignal(SSdcs, COMSIG_GLOB_GHOST_CAPTURED)
