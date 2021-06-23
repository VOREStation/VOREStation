//simplified MC that is designed to fail when procs 'break'. When it fails it's just replaced with a new one.
//It ensures master_controller.process() is never doubled up by killing the MC (hence terminating any of its sleeping procs)
//WIP, needs lots of work still

//
// TODO - This will be completely replaced by master.dm in time.
//

var/global/datum/controller/game_controller/master_controller //Set in world.New()

var/global/controller_iteration = 0
var/global/last_tick_duration = 0

var/global/pipe_processing_killed = 0

/datum/controller/game_controller
	var/list/shuttle_list	                    // For debugging and VV

/datum/controller/game_controller/New()
	//There can be only one master_controller. Out with the old and in with the new.
	if(master_controller != src)
		log_debug("Rebuilding Master Controller")
		if(istype(master_controller))
			qdel(master_controller)
		master_controller = src

	if(!job_master)
		job_master = new /datum/controller/occupations()
		job_master.SetupOccupations()
		job_master.LoadJobs("config/jobs.txt")
		admin_notice("<span class='danger'>Job setup complete</span>", R_DEBUG)

	if(!syndicate_code_phrase)		syndicate_code_phrase	= generate_code_phrase()
	if(!syndicate_code_response)	syndicate_code_response	= generate_code_phrase()

/datum/controller/game_controller/proc/setup()

	setup_objects()
	// setupgenetics() Moved to SSatoms
	// SetupXenoarch() - Moved to SSxenoarch

	transfer_controller = new
	admin_notice("<span class='danger'>Initializations complete.</span>", R_DEBUG)

// #if UNIT_TEST
// #define CHECK_SLEEP_MASTER // For unit tests we don't care about a smooth lobby screen experience. We care about speed.
// #else
// #define CHECK_SLEEP_MASTER if(++initialized_objects > 500) { initialized_objects=0;sleep(world.tick_lag); }
// #endif

/datum/controller/game_controller/proc/setup_objects()
	// Set up antagonists.
	populate_antag_type_list()

	//Set up spawn points.
	populate_spawn_points()