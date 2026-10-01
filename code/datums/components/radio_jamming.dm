GLOBAL_LIST_EMPTY(active_radio_jammers)


/// Returns a list of radiojammer info for the first jammer affecting a turf. Returns null if nothing affects it.
/proc/is_jammed(atom/movable/check_thing)
	RETURN_TYPE(/list)

	// Allows /obj to be passed, but we always work by turf.
	var/turf/jammed_turf = check_thing
	if(!isturf(check_thing))
		check_thing = get_turf(check_thing)
	//Nullspace radios don't get jammed.
	if(!jammed_turf)
		return null

	var/area/our_area = get_area(jammed_turf)
	if(our_area?.no_comms)
		return TRUE
	if(!length(GLOB.active_radio_jammers))
		return null

	for(var/datum/component/radio_jammer/comp in GLOB.active_radio_jammers)
		var/turf/components_turf = comp.get_host_turf()
		if(!components_turf || !comp.can_jam())
			continue
		if(components_turf.z != jammed_turf.z)
			continue
		var/dist = get_dist(components_turf,jammed_turf)
		if(dist > comp.jamming_range())
			continue
		return list("jammer" = comp, "distance" = dist)

	return null


/// Handles radio jamming with a specified distance, can be toggled on and off.
/datum/component/radio_jammer
	VAR_PRIVATE/jam_range
	VAR_PRIVATE/enabled = TRUE

/datum/component/radio_jammer/Initialize(range = 3)
	GLOB.active_radio_jammers += src
	jam_range = range

/datum/component/radio_jammer/RegisterWithParent()
	. = ..()
	if(istype(parent,/mob))
		RegisterSignal(parent, COMSIG_MOB_SAY_PREPARE, PROC_REF(handle_prepare_say))

/datum/component/radio_jammer/UnregisterFromParent()
	if(istype(parent,/mob))
		UnregisterSignal(parent, COMSIG_MOB_SAY_PREPARE)
	. = ..()

/datum/component/radio_jammer/Destroy(force)
	if(enabled)
		GLOB.active_radio_jammers -= src
	. = ..()

/datum/component/radio_jammer/proc/get_host_turf()
	if(QDELETED(parent))
		return null
	return get_turf(parent)

/datum/component/radio_jammer/proc/handle_prepare_say(atom/source, list/message_pieces, datum/language/speaking, message, whispering, message_mode)
	SIGNAL_HANDLER
	if(!enabled)
		return
	// Lets a single message get past when using radio_creeper
	disable()
	addtimer(CALLBACK(src, PROC_REF(enable)), 1, TIMER_DELETE_ME)

/datum/component/radio_jammer/proc/disable()
	if(!enabled)
		return
	GLOB.active_radio_jammers -= src
	enabled = FALSE
	return enabled

/datum/component/radio_jammer/proc/enable()
	if(enabled)
		return
	GLOB.active_radio_jammers += src
	enabled = TRUE
	return enabled

/datum/component/radio_jammer/proc/can_jam()
	return enabled

/datum/component/radio_jammer/proc/jamming_range()
	return jam_range
