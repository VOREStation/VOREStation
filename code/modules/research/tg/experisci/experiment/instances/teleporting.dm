/datum/experiment/physical/teleporting
	name = "Teleportation Basics"
	description = "How does bluespace travel affect mundane materials? Teleport an object from another location to the telescience telepad, and record observations."

/datum/experiment/physical/teleporting/register_events()
	if(!istype(currently_scanned_atom, /obj/machinery/computer/telescience) && !istype(currently_scanned_atom, /obj/machinery/telepad))
		linked_experiment_handler.announce_message("Incorrect object for experiment.")
		return FALSE

	RegisterSignal(currently_scanned_atom, COMSIG_TELESCI_TELEPORT, PROC_REF(teleported_items))
	linked_experiment_handler.announce_message("Experiment ready to start.")
	return TRUE

/datum/experiment/physical/teleporting/unregister_events()
	UnregisterSignal(currently_scanned_atom, COMSIG_TELESCI_TELEPORT)

/datum/experiment/physical/teleporting/check_progress()
	. += EXPERIMENT_PROG_BOOL("Teleport an object to the telescience telepad.", is_complete())

/datum/experiment/physical/teleporting/proc/teleported_items(datum/source, list/atom/movable/teleported_things, turf/target_turf, sending)
	SIGNAL_HANDLER
	// we must GET an object, not just send one.
	if(!sending && teleported_things.len)
		finish_experiment(linked_experiment_handler)
