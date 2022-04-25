
/*
 MODULAR ANTAGONIST SYSTEM

 Attempts to move all the bullshit snowflake antag tracking code into its own system, which
 has the added bonus of making the display procs consistent. Still needs work/adjustment/cleanup
 but should be fairly self-explanatory with a review of the procs. Will supply a few examples
 of common tasks that the system will be expected to perform below. ~Z

 To use:
   - Get the appropriate datum via get_antag_data("antagonist id")
	 using the id var of the desired /datum/antagonist ie. var/datum/antagonist/A = get_antag_data("traitor")
   - Call add_antagonist() on the desired target mind ie. A.add_antagonist(mob.mind)
   - To ignore protected roles, supply a positive second argument.
   - To skip equipping with appropriate gear, supply a positive third argument.
*/

SUBSYSTEM_DEF(antags)
	name = "Antags"
	init_order = INIT_ORDER_ANTAG
	flags = SS_NO_FIRE
	var/list/antag_datums = list()
	var/list/antag_spawnpoints = list()

/datum/controller/subsystem/antags/Initialize(timeofday)
	for(var/antag_type in subtypesof(/datum/antagonist))
		var/datum/antagonist/A = new antag_type
		antag_datums[A.id] = A

/datum/controller/subsystem/antags/Shutdown()
	for(var/thing in antag_datums)
		qdel(thing)
	. = ..()


/datum/controller/subsystem/antags/proc/get_antag_id_from_name(var/role_text)
	for(var/datum/antagonist/A as anything in antag_datums)
		if(A.role_text == role_text)
			return A.id
	return ""

// Global procs. TODO: Convert these to be called on SSantags
/proc/get_antag_data(var/antag_type)
	if(SSantags.antag_datums[antag_type])
		return SSantags.antag_datums[antag_type]
	for(var/cur_antag_type in SSantags.antag_datums)
		var/datum/antagonist/antag = SSantags.antag_datums[cur_antag_type]
		if(antag && antag.is_type(antag_type))
			return antag

/proc/clear_antag_roles(var/datum/mind/player, var/implanted)
	for(var/antag_type in SSantags.antag_datums)
		var/datum/antagonist/antag = SSantags.antag_datums[antag_type]
		if(!implanted || !(antag.flags & ANTAG_IMPLANT_IMMUNE))
			antag.remove_antagonist(player, 1, implanted)

/proc/update_antag_icons(var/datum/mind/player)
	for(var/antag_type in SSantags.antag_datums)
		var/datum/antagonist/antag = SSantags.antag_datums[antag_type]
		if(player)
			antag.update_icons_removed(player)
			if(antag.is_antagonist(player))
				antag.update_icons_added(player)
		else
			antag.update_all_icons()

/proc/get_antags(var/atype)
	var/datum/antagonist/antag = SSantags.antag_datums[atype]
	return (antag && islist(antag.current_antagonists)) ? \
		antag.current_antagonists : list()

/proc/player_is_antag(var/datum/mind/player, var/only_offstation_roles = 0)
	for(var/antag_type in SSantags.antag_datums)
		var/datum/antagonist/antag = SSantags.antag_datums[antag_type]
		if(only_offstation_roles && !(antag.flags & ANTAG_OVERRIDE_JOB))
			continue
		if(player in antag.current_antagonists)
			return TRUE
		if(player in antag.pending_antagonists)
			return TRUE
	return FALSE
