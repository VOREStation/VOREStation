/*
	The initialization of the game happens roughly like this:

	1. All global variables are initialized (including the global_init instance).
	2. The map is initialized, and map objects are created.
	3. world/New() runs, creating the process scheduler (and the old master controller) and spawning their setup.
	4. processScheduler/setup() runs, creating all the processes. game_controller/setup() runs, calling initialize() on all movable atoms in the world.
	5. The gameticker is created.

*/
var/global/datum/global_init/init = new ()

/*
	Pre-map initialization stuff should go here.
*/
/datum/global_init/New()

	makeDatumRefLists()
	load_configuration()

	initialize_integrated_circuits_list()

	qdel(src) //we're done

/datum/global_init/Destroy()
	global.init = null
	return 2 // QDEL_HINT_IWILLGC
