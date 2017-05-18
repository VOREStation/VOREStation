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

	if(!job_master)
		job_master = new /datum/controller/occupations()
		job_master.SetupOccupations()
		job_master.LoadJobs("config/jobs.txt")
		admin_notice("<span class='danger'>Job setup complete</span>", R_DEBUG)

	if(!syndicate_code_phrase)		syndicate_code_phrase	= generate_code_phrase()
	if(!syndicate_code_response)	syndicate_code_response	= generate_code_phrase()

datum/controller/game_controller/proc/setup()
	world.tick_lag = config.Ticklag

	setup_objects()
	setupgenetics()
	SetupXenoarch()

	transfer_controller = new
	admin_notice("<span class='danger'>Initializations complete.</span>", R_DEBUG)

#if UNIT_TEST
#define CHECK_SLEEP_MASTER // For unit tests we don't care about a smooth lobby screen experience. We care about speed.
#else
#define CHECK_SLEEP_MASTER if(++initialized_objects > 500) { initialized_objects=0;sleep(world.tick_lag); }
#endif

datum/controller/game_controller/proc/setup_objects()
	#if !UNIT_TEST
	var/initialized_objects = 0
	#endif

	// Set up antagonists.
	populate_antag_type_list()

	//Set up spawn points.
	populate_spawn_points()

	admin_notice("<span class='danger'>Initializing Floor Decals</span>", R_DEBUG)
	var/list/turfs_with_decals = list()
	for(var/obj/effect/floor_decal/D in world)
		var/T = D.add_to_turf_decals()
		if(T) turfs_with_decals |= T
		CHECK_SLEEP_MASTER
	for(var/item in turfs_with_decals)
		var/turf/T = item
		if(T.decals) T.apply_decals()
		CHECK_SLEEP_MASTER
	floor_decals_initialized = TRUE
	sleep(1)

	admin_notice("<span class='danger'>Initializing objects</span>", R_DEBUG)
	for(var/obj/object in world)
		if(isnull(object.gcDestroyed))
			object.initialize()
			CHECK_SLEEP_MASTER
	sleep(1)

	admin_notice("<span class='danger'>Initializing areas</span>", R_DEBUG)
	for(var/area/area in all_areas)
		area.initialize()
		CHECK_SLEEP_MASTER
	sleep(1)

	admin_notice("<span class='danger'>Initializing pipe networks</span>", R_DEBUG)
	for(var/obj/machinery/atmospherics/machine in machines)
		machine.build_network()
		CHECK_SLEEP_MASTER

	admin_notice("<span class='danger'>Initializing atmos machinery.</span>", R_DEBUG)
	for(var/obj/machinery/atmospherics/unary/U in machines)
		if(istype(U, /obj/machinery/atmospherics/unary/vent_pump))
			var/obj/machinery/atmospherics/unary/vent_pump/T = U
			T.broadcast_status()
		else if(istype(U, /obj/machinery/atmospherics/unary/vent_scrubber))
			var/obj/machinery/atmospherics/unary/vent_scrubber/T = U
			T.broadcast_status()
		CHECK_SLEEP_MASTER

	admin_notice("<span class='danger'>Initializing turbolifts</span>", R_DEBUG)
	for(var/thing in turbolifts)
		if(!deleted(thing))
			var/obj/turbolift_map_holder/lift = thing
			lift.initialize()
			CHECK_SLEEP_MASTER
