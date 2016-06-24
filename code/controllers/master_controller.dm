//simplified MC that is designed to fail when procs 'break'. When it fails it's just replaced with a new one.
//It ensures master_controller.process() is never doubled up by killing the MC (hence terminating any of its sleeping procs)
//WIP, needs lots of work still

var/global/datum/controller/game_controller/master_controller //Set in world.New()

var/global/controller_iteration = 0
var/global/last_tick_duration = 0

var/global/air_processing_killed = 0
var/global/pipe_processing_killed = 0

datum/controller/game_controller
	var/list/shuttle_list	                    // For debugging and VV

datum/controller/game_controller/New()
	//There can be only one master_controller. Out with the old and in with the new.
	if(master_controller != src)
		log_debug("Rebuilding Master Controller")
		if(istype(master_controller))
			qdel(master_controller)
		master_controller = src

	var/watch = 0
	if(!job_master)
		watch = start_watch()
		job_master = new /datum/controller/occupations()
		job_master.SetupOccupations()
		job_master.LoadJobs("config/jobs.txt")
		log_startup_progress("Job setup complete in [stop_watch(watch)]s.")

	if(!syndicate_code_phrase)		syndicate_code_phrase	= generate_code_phrase()
	if(!syndicate_code_response)	syndicate_code_response	= generate_code_phrase()

datum/controller/game_controller/proc/setup()
	world.tick_lag = config.Ticklag

	spawn(20)
		createRandomZlevel()

	setup_objects()
	setupgenetics()
	SetupXenoarch()

	transfer_controller = new


datum/controller/game_controller/proc/setup_objects()
	var/watch = start_watch()
	var/count = 0
	var/overwatch = start_watch() //Overall.

	log_startup_progress("Populating asset cache...")
	populate_asset_cache()
	log_startup_progress("  Populated [asset_cache.len] assets in [stop_watch(watch)]s.")

	watch = start_watch()
	log_startup_progress("Initializing objects")
//	sleep(-1)
	for(var/atom/movable/object in world)
		if(isnull(object.gcDestroyed))
			object.initialize()
			count++
	log_startup_progress("  Initialized [count] objects in [stop_watch(watch)]s.")

	watch = start_watch()
	count = 0
	log_startup_progress("Initializing areas")
//	sleep(-1)
	for(var/area/area in all_areas)
		area.initialize()
		count++
	log_startup_progress("  Initialized [count] areas in [stop_watch(watch)]s.")

	watch = start_watch()
	count = 0
	log_startup_progress("Initializing pipe networks")
//	sleep(-1)
	for(var/obj/machinery/atmospherics/machine in machines)
		machine.build_network()
		count++
	log_startup_progress("  Initialized [count] pipe networks in [stop_watch(watch)]s.")

	watch = start_watch()
	count = 0
	log_startup_progress("Initializing atmos machinery.")
//	sleep(-1)
	for(var/obj/machinery/atmospherics/unary/U in machines)
		if(istype(U, /obj/machinery/atmospherics/unary/vent_pump))
			var/obj/machinery/atmospherics/unary/vent_pump/T = U
			T.broadcast_status()
			count++
		else if(istype(U, /obj/machinery/atmospherics/unary/vent_scrubber))
			var/obj/machinery/atmospherics/unary/vent_scrubber/T = U
			T.broadcast_status()
			count++
	log_startup_progress("  Initialized [count] atmospherics devices in [stop_watch(watch)]s.")
	log_startup_progress("Finished object initializations in [stop_watch(overwatch)]s.")

	// Set up antagonists.
	populate_antag_type_list()

	//Set up spawn points.
	populate_spawn_points()

	log_startup_progress("Initializations complete.")
//	sleep(-1)
