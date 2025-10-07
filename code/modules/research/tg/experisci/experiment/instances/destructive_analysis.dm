/datum/experiment/physical/destructive_analysis
	name = "Destructive Analysis"
	description = "Deconstruct an object into it's base components."
	points_reward = 5
	var/obj/item/acceptable_item = null // If this is a list, it will be item_type == type checked, otherwise any item will do
	var/item_count_required = 1

/datum/experiment/physical/destructive_analysis/register_events()
	if(!istype(currently_scanned_atom, /obj/machinery/rnd/destructive_analyzer))
		linked_experiment_handler.announce_message("Incorrect object for experiment.")
		return FALSE

	RegisterSignal(currently_scanned_atom, COMSIG_DESTRUCTIVE_ANALYSIS, PROC_REF(deconstruct_item))
	linked_experiment_handler.announce_message("Awaiting incoming atomic analysis.")
	return TRUE

/datum/experiment/physical/destructive_analysis/unregister_events()
	UnregisterSignal(currently_scanned_atom, COMSIG_DESTRUCTIVE_ANALYSIS)

/datum/experiment/physical/destructive_analysis/check_progress()
	var/itm_str = "an item"
	if(acceptable_item)
		itm_str = "a [acceptable_item::name]"
	. += EXPERIMENT_PROG_BOOL("Process [itm_str] with the destructive analyzer into its component atoms.", is_complete())

/datum/experiment/physical/destructive_analysis/proc/deconstruct_item(datum/source, list/obj/item/deconstructed_items)
	SIGNAL_HANDLER
	if(!deconstructed_items.len)
		return
	if(!acceptable_item)
		finish_experiment(linked_experiment_handler)
		return
	// Check for if our item existed in the scan!
	for(var/obj/item/scanned_thing in deconstructed_items)
		if(scanned_thing.type == acceptable_item)
			finish_experiment(linked_experiment_handler)
			return


///////////////////////////////////////////////////////////////////////////////////////////////////////
// Subtypes for deconstructing more specific items
///////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/experiment/physical/destructive_analysis/banana_test
	name = "Destructive Analysis: Banana peel"
	description = "What makes banana peels so slippery? Deconstruct one to find out."
	acceptable_item = /obj/item/bananapeel
