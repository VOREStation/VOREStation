//simplified MC that is designed to fail when procs 'break'. When it fails it's just replaced with a new one.
//It ensures master_controller.process() is never doubled up by killing the MC (hence terminating any of its sleeping procs)
//WIP, needs lots of work still

//
// TODO - This will be completely replaced by master.dm in time.
//
GLOBAL_DATUM(master_controller, /datum/controller/game_controller) //Set in world.New()

/datum/controller/game_controller
	var/list/shuttle_list	                    // For debugging and VV

/datum/controller/game_controller/New()
	//There can be only one master_controller. Out with the old and in with the new.
	if(GLOB.master_controller != src)
		log_world("Rebuilding Master Controller")
		if(istype(GLOB.master_controller))
			qdel(GLOB.master_controller)
		GLOB.master_controller = src

	if(!GLOB.job_master)
		GLOB.job_master = new /datum/controller/occupations()
		GLOB.job_master.SetupOccupations()
		GLOB.job_master.LoadJobs("config/jobs.txt")
		admin_notice(span_danger("Job setup complete"), R_DEBUG)

	if(!GLOB.syndicate_code_phrase)
		GLOB.syndicate_code_phrase = generate_code_phrase()

	if(!GLOB.syndicate_code_response)
		GLOB.syndicate_code_response = generate_code_phrase()

/datum/controller/game_controller/proc/setup()

	setup_objects()
	// setupgenetics() Moved to SSatoms
	// SetupXenoarch() - Moved to SSxenoarch

	GLOB.transfer_controller = new
	admin_notice(span_danger("Initializations complete."), R_DEBUG)

// #if UNIT_TESTS
// # define CHECK_SLEEP_MASTER // For unit tests we don't care about a smooth lobby screen experience. We care about speed.
// #else
// # define CHECK_SLEEP_MASTER if(++initialized_objects > 500) { initialized_objects=0;sleep(world.tick_lag); }
// #endif

/datum/controller/game_controller/proc/setup_objects()
	// Set up antagonists.
	populate_antag_type_list()

	//Set up spawn points.
	populate_spawn_points()
