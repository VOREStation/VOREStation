SUBSYSTEM_DEF(ai)
	name = "AI"
<<<<<<< HEAD
	init_order = INIT_ORDER_AI
=======
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
>>>>>>> f7d6a66ebc3... Merge pull request #8542 from Spookerton/spkrtn/sys/mercenary-behavior
	priority = FIRE_PRIORITY_AI
	wait = 2 SECONDS
	flags = SS_NO_INIT
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/list/processing = list()
	var/list/currentrun = list()

	var/slept_mobs = 0
	var/list/process_z = list()

/datum/controller/subsystem/ai/stat_entry(msg_prefix)
	..("P: [processing.len] | S: [slept_mobs]")

/datum/controller/subsystem/ai/fire(resumed = 0)
	if (!resumed)
		src.currentrun = processing.Copy()
		process_z.Cut()
		slept_mobs = 0
		var/level = 1
		while(process_z.len < GLOB.living_players_by_zlevel.len)
			process_z.len++
			process_z[level] = GLOB.living_players_by_zlevel[level].len
			level++

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(currentrun.len)
		var/datum/ai_holder/A = currentrun[currentrun.len]
		--currentrun.len
		if(!A || QDELETED(A) || A.busy) // Doesn't exist or won't exist soon or not doing it this tick
			continue

		var/mob/living/L = A.holder	//VOREStation Edit Start
		if(!L?.loc)
			continue

		if(process_z[get_z(L)] || !L.low_priority) //VOREStation Edit End
			A.handle_strategicals()
		else
			slept_mobs++
			A.set_stance(STANCE_IDLE)

<<<<<<< HEAD
		if(MC_TICK_CHECK)
			return
=======
/// Convenience define for safely dequeueing an AI datum from slow processing.
#define STOP_AIPROCESSING(DATUM) \
DATUM.process_flags &= ~AI_PROCESSING; \
SSai.queue -= DATUM;


// Prevent AI running during CI to avoid some irrelevant runtimes
#ifdef UNIT_TEST
/datum/controller/subsystem/ai/flags = SS_NO_INIT | SS_NO_FIRE
#else
/datum/controller/subsystem/ai/flags = SS_NO_INIT
#endif
>>>>>>> f7d6a66ebc3... Merge pull request #8542 from Spookerton/spkrtn/sys/mercenary-behavior
