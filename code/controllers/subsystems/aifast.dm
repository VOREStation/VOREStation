SUBSYSTEM_DEF(aifast)
<<<<<<< HEAD
	name = "AI (Fast)"
	init_order = INIT_ORDER_AI_FAST
=======
	name = "AI Fast"
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	flags = SS_NO_INIT | (UNIT_TEST ? SS_NO_FIRE : 0) // Prevent AI running during CI to avoid some irrelevant runtimes
>>>>>>> e1b7704dd00... Merge pull request #8591 from Atermonera/fix_ai_NOFIRE
	priority = FIRE_PRIORITY_AI
	wait = 0.25 SECONDS // Every quarter second
	flags = SS_NO_INIT
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/list/processing = list()
	var/list/currentrun = list()

/datum/controller/subsystem/aifast/stat_entry(msg_prefix)
	var/list/msg = list(msg_prefix)
	msg += "P:[processing.len]"
	..(msg.Join())

/datum/controller/subsystem/aifast/fire(resumed = 0)
	if (!resumed)
		src.currentrun = processing.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

<<<<<<< HEAD
	while(currentrun.len)
		var/datum/ai_holder/A = currentrun[currentrun.len]
		--currentrun.len
		if(!A || QDELETED(A) || A.busy) // Doesn't exist or won't exist soon or not doing it this tick
			continue
		A.handle_tactics()

		if(MC_TICK_CHECK)
			return
=======
/// Convenience define for safely dequeueing an AI datum from fast processing.
#define STOP_AIFASTPROCESSING(DATUM) \
DATUM.process_flags &= ~AI_FASTPROCESSING; \
SSaifast.queue -= DATUM;
>>>>>>> e1b7704dd00... Merge pull request #8591 from Atermonera/fix_ai_NOFIRE
