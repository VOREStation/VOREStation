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
/* VOREStation Removal - Ours is even earlier, in world/New()
	//logs
	log_path += time2text(world.realtime, "YYYY/MM-Month/DD-Day/round-hh-mm-ss")
	diary = file("[log_path].log")
	href_logfile = file("[log_path]-hrefs.htm")
	error_log = file("[log_path]-error.log")
	debug_log = file("[log_path]-debug.log")
	debug_log << "[log_end]\n[log_end]\nStarting up. [time_stamp()][log_end]\n---------------------[log_end]"
*/ //VOREStation Removal End
	load_configuration()
	makeDatumRefLists()

	initialize_integrated_circuits_list()

	qdel(src) //we're done

/datum/global_init/Destroy()
	global.init = null
	return 2 // QDEL_HINT_IWILLGC
