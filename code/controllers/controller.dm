/// The display name of this controller.
/datum/controller/var/name

/// The atom used to provide a clickable stat line in the MC tab for this controller.
/datum/controller/var/obj/effect/statclick/statclick


// Do not implement any base behaviors here.
/// Called to set up this controller.
/datum/controller/proc/Initialize()
	return


// Do not implement any base behaviors here.
/// Called to clean up / finalize this controller.
/datum/controller/proc/Shutdown()
	return


// Do not implement any base behaviors here.
/// Called when dmm_suite begins loading a map.
/datum/controller/proc/StartLoadingMap()
	return


// Do not implement any base behaviors here.
/// Called when dmm_suite finishes loading a map.
/datum/controller/proc/StopLoadingMap()
	return


// Do not implement any base behaviors here.
/// To be called on the OLD instance if the controller fails in some way that requires it to be replaced.
/datum/controller/proc/Recover()
	return


// Do not implement any base behaviors here.
/// Called when an update to the stat line in the MC tab is requested.
/datum/controller/proc/stat_entry()
	return
