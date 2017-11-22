//
// Creation subsystem, which is responsible for initializing newly created objects.
//
SUBSYSTEM_DEF(creation)
	name = "Creation"
	priority = 14
	wait = 5
//	flags = SS_POST_FIRE_TIMING|SS_BACKGROUND|SS_NO_INIT
	flags = SS_NO_FIRE|SS_NO_INIT
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

	var/list/atoms_needing_initialize = list()

	var/map_loading = FALSE

/datum/controller/subsystem/creation/StartLoadingMap(var/quiet)
	map_loading = TRUE

/datum/controller/subsystem/creation/StopLoadingMap(var/quiet)
	map_loading = FALSE

/datum/controller/subsystem/creation/proc/initialize_late_atoms()
	admin_notice("<span class='danger'>Initializing atoms in submap.</span>", R_DEBUG)
	var/total_atoms = atoms_needing_initialize.len
	for(var/atom/movable/A in atoms_needing_initialize)
		if(!QDELETED(A))
			A.initialize()
		atoms_needing_initialize -= A
	admin_notice("<span class='danger'>Initalized [total_atoms] atoms in submap.</span>", R_DEBUG)